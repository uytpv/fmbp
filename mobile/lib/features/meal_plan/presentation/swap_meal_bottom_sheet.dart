import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fmbp_models/fmbp_models.dart';
import '../../../app/theme.dart';
import '../../../core/constants/default_recipes_seed.dart';
import '../../../core/services/ai_gateway_service.dart';
import '../../../core/services/firestore_service.dart';
import '../../../shared/utils/currency_formatter.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../pantry/presentation/pantry_provider.dart';

class SwapMealBottomSheet extends ConsumerStatefulWidget {
  final String dayName;
  final String mealType;
  final String currentMealTitle;
  final num currentEstimatedCost;
  final String currency;
  final List<String> cuisines;
  final String complexity;
  final Future<void> Function(Map<String, dynamic> newMeal) onMealSwapped;

  const SwapMealBottomSheet({
    super.key,
    required this.dayName,
    required this.mealType,
    required this.currentMealTitle,
    required this.currentEstimatedCost,
    required this.currency,
    required this.cuisines,
    required this.complexity,
    required this.onMealSwapped,
  });

  static Future<void> show(
    BuildContext context, {
    required String dayName,
    required String mealType,
    required String currentMealTitle,
    required num currentEstimatedCost,
    required String currency,
    required List<String> cuisines,
    required String complexity,
    required Future<void> Function(Map<String, dynamic> newMeal) onMealSwapped,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SwapMealBottomSheet(
        dayName: dayName,
        mealType: mealType,
        currentMealTitle: currentMealTitle,
        currentEstimatedCost: currentEstimatedCost,
        currency: currency,
        cuisines: cuisines,
        complexity: complexity,
        onMealSwapped: onMealSwapped,
      ),
    );
  }

  @override
  ConsumerState<SwapMealBottomSheet> createState() => _SwapMealBottomSheetState();
}

class _SwapMealBottomSheetState extends ConsumerState<SwapMealBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<Recipe> _searchResults = [];
  List<Recipe> _suggestedRecipes = [];
  bool _isLoading = false;
  bool _isAIGenerating = false;
  String _selectedCuisineFilter = 'ALL';

  // Preview & Customization State
  Map<String, dynamic>? _previewMeal;
  bool _isCustomizing = false;

  @override
  void initState() {
    super.initState();
    _loadInitialSuggestions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getMealTypeLabel(String type) {
    switch (type.toUpperCase()) {
      case 'BREAKFAST':
        return 'Bữa Sáng';
      case 'LUNCH':
        return 'Bữa Trưa';
      case 'DINNER':
        return 'Bữa Tối';
      default:
        return 'Bữa Ăn';
    }
  }

  Future<void> _loadInitialSuggestions() async {
    setState(() => _isLoading = true);
    try {
      final firestore = ref.read(firestoreServiceProvider);
      // Lấy toàn bộ công thức cộng đồng phổ biến từ Firestore
      final dbRecipes = await firestore.searchRecipes(
        cuisine: _selectedCuisineFilter != 'ALL' ? _selectedCuisineFilter : null,
        limit: 50,
      );

      // Kết hợp với Seed data cục bộ
      final seedList = DefaultRecipesSeed.seedRecipes.where((r) {
        final matchesCuisine = _selectedCuisineFilter == 'ALL' || r.cuisine == _selectedCuisineFilter;
        final notCurrent = r.title.toLowerCase() != widget.currentMealTitle.toLowerCase();
        return matchesCuisine && notCurrent;
      }).toList();

      final combinedMap = <String, Recipe>{};
      for (final r in dbRecipes) {
        if (r.title.toLowerCase() != widget.currentMealTitle.toLowerCase()) {
          combinedMap[r.title.toLowerCase()] = r;
        }
      }
      for (final r in seedList) {
        combinedMap.putIfAbsent(r.title.toLowerCase(), () => r);
      }

      if (mounted) {
        setState(() {
          _suggestedRecipes = combinedMap.values.toList();
          _searchResults = _suggestedRecipes;
        });
      }
    } catch (_) {
      // Fallback cục bộ nếu offline
      final fallback = DefaultRecipesSeed.seedRecipes.where((r) {
        return r.title.toLowerCase() != widget.currentMealTitle.toLowerCase();
      }).toList();
      if (mounted) {
        setState(() {
          _suggestedRecipes = fallback;
          _searchResults = fallback;
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged(String query) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      setState(() => _searchResults = _suggestedRecipes);
      return;
    }

    // 1. Tìm kiếm nhanh trong bộ nhớ đệm
    final allSeeds = DefaultRecipesSeed.seedRecipes;
    final results = _suggestedRecipes.where((r) => r.title.toLowerCase().contains(q)).toList();

    for (final s in allSeeds) {
      if (s.title.toLowerCase().contains(q) && !results.any((r) => r.title.toLowerCase() == s.title.toLowerCase())) {
        results.add(s);
      }
    }

    setState(() => _searchResults = results);

    // 2. Đồng thời tìm kiếm trực tiếp trên Firestore để tìm các món người dùng/cộng đồng vừa tạo
    try {
      final firestore = ref.read(firestoreServiceProvider);
      final remoteResults = await firestore.searchRecipes(query: q, limit: 30);
      if (mounted && _searchController.text.trim().toLowerCase() == q) {
        final currentTitles = results.map((r) => r.title.toLowerCase()).toSet();
        bool hasNew = false;
        for (final r in remoteResults) {
          if (!currentTitles.contains(r.title.toLowerCase())) {
            results.add(r);
            currentTitles.add(r.title.toLowerCase());
            hasNew = true;
          }
        }
        if (hasNew) {
          setState(() => _searchResults = List.from(results));
        }
      }
    } catch (_) {}
  }

  /// Gọi AI để tạo công thức cho món ăn người dùng tự gõ
  Future<void> _generateRecipeForCustomTitle(String title) async {
    if (title.trim().isEmpty) return;

    setState(() => _isAIGenerating = true);
    try {
      final aiService = ref.read(aiGatewayServiceProvider);
      final firestore = ref.read(firestoreServiceProvider);

      final detail = await aiService.getRecipeDetail(
        recipeTitle: title.trim(),
        location: 'FI',
        currency: widget.currency,
      );

      final ingredients = (detail?['ingredients'] as List?)?.map((e) => Map<String, dynamic>.from(e as Map)).toList() ??
          [
            {'name': 'Nguyên liệu chính món $title', 'quantity': 200, 'unit': 'g', 'aisle': 'Thịt & Hải sản'},
            {'name': 'Gia vị tổng hợp', 'quantity': 1, 'unit': 'phần', 'aisle': 'Gia vị'},
          ];
      final cookingSteps = (detail?['cooking_steps'] as List?)?.map((e) => e.toString()).toList() ??
          [
            'Bước 1: Sơ chế các nguyên liệu tươi sạch.',
            'Bước 2: Ướp gia vị vừa ăn theo khẩu vị gia đình.',
            'Bước 3: Chế biến món ăn theo nhiệt độ thích hợp.',
            'Bước 4: Trình bày ra đĩa và thưởng thức nóng.',
          ];
      final localTip = detail?['local_tip'] ?? 'Nên chọn mua nguyên liệu tươi tại chợ/siêu thị địa phương để món ăn ngon nhất.';
      final estCost = (detail?['estimated_cost'] as num?)?.toDouble() ?? widget.currentEstimatedCost.toDouble();

      final newMeal = <String, dynamic>{
        'recipe_title': detail?['recipe_title'] ?? title.trim(),
        'recipeTitle': detail?['recipe_title'] ?? title.trim(),
        'title': detail?['recipe_title'] ?? title.trim(),
        'day': widget.dayName,
        'meal_type': widget.mealType,
        'mealType': widget.mealType,
        'estimated_cost': estCost,
        'ingredients': ingredients,
        'cooking_steps': cookingSteps,
        'local_tip': localTip,
      };

      // Tự động lưu ngay món mới vào Firestore recipes để lần sau tìm là có ngay
      final recipeId = 'rec_${title.trim().toLowerCase().hashCode.abs()}';
      final newRecipeObj = Recipe(
        id: recipeId,
        title: title.trim(),
        mealType: widget.mealType,
        cuisine: 'VIETNAMESE',
        complexity: widget.complexity,
        estimatedCost: estCost,
        currency: widget.currency,
        ingredients: ingredients,
        instructions: cookingSteps,
        localTip: localTip,
        usageCount: 1,
        creatorId: 'COMMUNITY_USER',
      );

      try {
        await firestore.saveRecipe(newRecipeObj);
        // Thêm vào danh sách gợi ý hiện tại
        if (!_suggestedRecipes.any((r) => r.title.toLowerCase() == title.trim().toLowerCase())) {
          _suggestedRecipes.insert(0, newRecipeObj);
        }
      } catch (_) {}

      setState(() {
        _previewMeal = newMeal;
        _isCustomizing = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi gọi AI: $e'), backgroundColor: AppColors.error),
      );
    } finally {
      if (mounted) setState(() => _isAIGenerating = false);
    }
  }

  /// Gọi AI để sinh 1 món ngẫu nhiên phù hợp tiêu chí
  Future<void> _generateRandomAlternativeMeal() async {
    setState(() => _isAIGenerating = true);
    try {
      final aiService = ref.read(aiGatewayServiceProvider);
      final pantry = ref.read(pantryStateProvider).value ?? [];

      final detail = await aiService.suggestSingleMeal(
        mealType: widget.mealType,
        cuisines: widget.cuisines,
        complexity: widget.complexity,
        currency: widget.currency,
        location: 'FI',
        avoidTitle: widget.currentMealTitle,
        pantryItems: pantry,
      );

      if (detail != null) {
        final newMeal = <String, dynamic>{
          'recipe_title': detail['recipe_title'] ?? 'Món ăn mới',
          'recipeTitle': detail['recipe_title'] ?? 'Món ăn mới',
          'title': detail['recipe_title'] ?? 'Món ăn mới',
          'day': widget.dayName,
          'meal_type': widget.mealType,
          'mealType': widget.mealType,
          'estimated_cost': (detail['estimated_cost'] as num?)?.toDouble() ?? 5.0,
          'ingredients': (detail['ingredients'] as List?)?.map((e) => Map<String, dynamic>.from(e as Map)).toList() ?? [],
          'cooking_steps': (detail['cooking_steps'] as List?)?.map((e) => e.toString()).toList() ?? [],
          'local_tip': detail['local_tip'] ?? 'Mẹo nấu ngon từ trợ lý AI.',
        };

        setState(() {
          _previewMeal = newMeal;
          _isCustomizing = true;
        });
      } else {
        // Fallback: chọn ngẫu nhiên 1 món từ seed
        final availableSeeds = DefaultRecipesSeed.seedRecipes.where((r) {
          return (r.mealType == widget.mealType || r.mealType == 'ANY') &&
              r.title.toLowerCase() != widget.currentMealTitle.toLowerCase();
        }).toList();

        if (availableSeeds.isNotEmpty) {
          availableSeeds.shuffle();
          _selectRecipeToPreview(availableSeeds.first);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi gợi ý AI: $e'), backgroundColor: AppColors.error),
      );
    } finally {
      if (mounted) setState(() => _isAIGenerating = false);
    }
  }

  void _selectRecipeToPreview(Recipe recipe) {
    final meal = <String, dynamic>{
      'recipe_title': recipe.title,
      'recipeTitle': recipe.title,
      'title': recipe.title,
      'day': widget.dayName,
      'meal_type': widget.mealType,
      'mealType': widget.mealType,
      'estimated_cost': recipe.estimatedCost,
      'ingredients': recipe.ingredients,
      'cooking_steps': recipe.instructions,
      'local_tip': recipe.localTip ?? 'Món ăn dinh dưỡng chuẩn vị.',
    };

    setState(() {
      _previewMeal = meal;
      _isCustomizing = true;
    });
  }

  Future<void> _confirmSwap() async {
    if (_previewMeal == null) return;
    setState(() => _isLoading = true);
    try {
      await widget.onMealSwapped(_previewMeal!);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 Đã đổi thành công sang món "${_previewMeal!['recipe_title']}"!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi đổi món: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: MediaQuery.of(context).size.height * 0.90,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.bgDark : AppColors.bgLight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
        ),
        padding: EdgeInsets.only(
          top: AppSpacing.md,
          left: AppSpacing.md,
          right: AppSpacing.md,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
        ),
        child: _isCustomizing && _previewMeal != null
            ? _buildPreviewAndCustomizeView(theme, isDark)
            : _buildSearchAndBrowseView(theme, isDark),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // VIEW 1: Tìm kiếm & Duyệt thư viện món ăn cộng đồng
  // --------------------------------------------------------------------------
  Widget _buildSearchAndBrowseView(ThemeData theme, bool isDark) {
    final hasExactMatch = _searchResults.any(
      (r) => r.title.toLowerCase() == _searchController.text.trim().toLowerCase(),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Drag handle
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.disabledColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Header with current meal info
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${widget.dayName} • ${_getMealTypeLabel(widget.mealType)}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Đang chọn: ${widget.currentMealTitle}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        const Divider(height: 16),

        // Search Bar + Custom Title Submit
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? AppColors.bgCardDark : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Nhập tên món muốn đổi (Ví dụ: Bún chả, Pasta...)',
              hintStyle: TextStyle(fontSize: 12.5, color: theme.disabledColor),
              prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.primary),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            ),
          ),
        ),

        // If user typed a custom title not found in list -> AI Generator button
        if (_searchController.text.trim().isNotEmpty && !hasExactMatch) ...[
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Món "${_searchController.text.trim()}" chưa có trong thư viện. AI sẽ tự động tạo công thức & nguyên liệu!',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 38,
                  child: ElevatedButton.icon(
                    onPressed: _isAIGenerating ? null : () => _generateRecipeForCustomTitle(_searchController.text.trim()),
                    icon: _isAIGenerating
                        ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.auto_awesome_rounded, size: 16),
                    label: Text(_isAIGenerating ? 'Đang tạo công thức...' : '✨ Tạo Công Thức Cho Món Này'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 10),

        // Quick AI Random Alternative Button
        InkWell(
          onTap: _isAIGenerating ? null : _generateRandomAlternativeMeal,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.casino_outlined, color: Colors.amber, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    '🎲 Nhờ AI gợi ý 1 món ngẫu nhiên khác cùng tiêu chí',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.amber),
                  ),
                ),
                if (_isAIGenerating)
                  const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.amber))
                else
                  const Icon(Icons.chevron_right_rounded, size: 18, color: Colors.amber),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Section Title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Gợi ý từ Thư viện Công thức (${_searchResults.length}):',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              'Bấm để xem & chỉnh sửa',
              style: TextStyle(fontSize: 11, color: theme.disabledColor),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // Scrollable List of recipes
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _searchResults.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_rounded, size: 40, color: theme.disabledColor),
                          const SizedBox(height: 8),
                          Text(
                            'Không tìm thấy món ăn phù hợp.',
                            style: TextStyle(fontSize: 12.5, color: theme.disabledColor),
                          ),
                          const SizedBox(height: 6),
                          TextButton.icon(
                            icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                            label: Text('Nhờ AI tạo công thức cho "${_searchController.text}"'),
                            onPressed: _searchController.text.isNotEmpty
                                ? () => _generateRecipeForCustomTitle(_searchController.text)
                                : null,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final recipe = _searchResults[index];
                        final estCostStr = CurrencyFormatter.format(recipe.estimatedCost, widget.currency);
                        final prepStr = '${recipe.prepTime + recipe.cookTime}p';

                        return Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.bgCardDark : Colors.white,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                            border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.06)),
                          ),
                          child: ListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            leading: CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.primary.withOpacity(0.12),
                              child: Text(
                                _getCuisineEmoji(recipe.cuisine),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            title: Text(
                              recipe.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            subtitle: Row(
                              children: [
                                Text('💰 $estCostStr', style: const TextStyle(fontSize: 11, color: AppColors.primary)),
                                const SizedBox(width: 10),
                                Text('⏱️ $prepStr', style: TextStyle(fontSize: 11, color: theme.disabledColor)),
                                if (recipe.dietaryTags.isNotEmpty) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: AppColors.success.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: Text(
                                      recipe.dietaryTags.first,
                                      style: const TextStyle(fontSize: 9, color: AppColors.success, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.primary),
                            onTap: () => _selectRecipeToPreview(recipe),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  // --------------------------------------------------------------------------
  // VIEW 2: Xem trước & Chỉnh sửa công thức trước khi xác nhận đổi
  // --------------------------------------------------------------------------
  Widget _buildPreviewAndCustomizeView(ThemeData theme, bool isDark) {
    final meal = _previewMeal!;
    final title = meal['recipe_title'] ?? meal['title'] ?? 'Món ăn mới';
    final estCost = (meal['estimated_cost'] as num?) ?? 5.0;
    final ingredients = (meal['ingredients'] as List?)?.map((e) => Map<String, dynamic>.from(e as Map)).toList() ?? [];
    final cookingSteps = (meal['cooking_steps'] as List?)?.map((e) => e.toString()).toList() ?? [];
    final localTip = meal['local_tip']?.toString();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Back Button & Header
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => setState(() => _isCustomizing = false),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Xem Trước & Tùy Chỉnh Công Thức',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${widget.dayName} • ${_getMealTypeLabel(widget.mealType)}',
                    style: TextStyle(fontSize: 11, color: theme.disabledColor),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        const Divider(height: 12),

        // Scrollable Recipe Details
        Expanded(
          child: ListView(
            children: [
              // Dish Title Box
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                          child: Text(
                            'Ước tính: ${CurrencyFormatter.format(estCost, widget.currency)}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (localTip != null && localTip.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.amber.withOpacity(0.25)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('💡 ', style: TextStyle(fontSize: 13)),
                            Expanded(
                              child: Text(
                                localTip,
                                style: const TextStyle(fontSize: 11, height: 1.3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Section: Ingredients
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nguyên liệu chuẩn bị (${ingredients.length}):',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.add_rounded, size: 16),
                    label: const Text('Thêm nguyên liệu', style: TextStyle(fontSize: 11.5)),
                    onPressed: () => _showAddIngredientDialog(ingredients),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ...List.generate(ingredients.length, (idx) {
                final ing = ingredients[idx];
                final ingName = ing['name'] ?? 'Nguyên liệu';
                final ingQty = ing['quantity']?.toString() ?? '1';
                final ingUnit = ing['unit'] ?? 'phần';
                final ingAisle = ing['aisle'] ?? 'Gian hàng';

                return Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.bgCardDark : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ingName,
                              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              ingAisle,
                              style: TextStyle(fontSize: 10, color: theme.disabledColor),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '$ingQty $ingUnit',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.error),
                        onPressed: () {
                          setState(() {
                            ingredients.removeAt(idx);
                            _previewMeal!['ingredients'] = ingredients;
                          });
                        },
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 12),

              // Section: Cooking steps
              Text(
                'Hướng dẫn 4 bước thực hiện:',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              ...List.generate(cookingSteps.length, (idx) {
                final step = cookingSteps[idx];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: AppColors.primary,
                        child: Text('${idx + 1}', style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          step,
                          style: const TextStyle(fontSize: 12, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),

        // Action Confirm Button
        const SizedBox(height: 12),
        AppButton(
          text: 'Xác Nhận Đổi Sang Món Này',
          isLoading: _isLoading,
          onPressed: _confirmSwap,
        ),
      ],
    );
  }

  void _showAddIngredientDialog(List<Map<String, dynamic>> ingredients) {
    final nameCtrl = TextEditingController();
    final qtyCtrl = TextEditingController(text: '100');
    final unitCtrl = TextEditingController(text: 'g');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Thêm Nguyên Liệu'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Tên nguyên liệu')),
            Row(
              children: [
                Expanded(child: TextField(controller: qtyCtrl, decoration: const InputDecoration(labelText: 'Số lượng'))),
                const SizedBox(width: 10),
                Expanded(child: TextField(controller: unitCtrl, decoration: const InputDecoration(labelText: 'Đơn vị (g, ml, quả)'))),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isNotEmpty) {
                setState(() {
                  ingredients.add({
                    'name': nameCtrl.text.trim(),
                    'quantity': double.tryParse(qtyCtrl.text) ?? 100,
                    'unit': unitCtrl.text.trim(),
                    'aisle': 'Gia vị & Khác',
                  });
                  _previewMeal!['ingredients'] = ingredients;
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }

  String _getCuisineEmoji(String cuisine) {
    switch (cuisine.toUpperCase()) {
      case 'VIETNAMESE':
        return '🇻🇳';
      case 'FINNISH':
        return '🇫🇮';
      case 'EUROPEAN':
        return '🇪🇺';
      case 'ASIAN':
        return '🇯🇵';
      case 'HEALTHY':
        return '🥗';
      default:
        return '🍲';
    }
  }
}
