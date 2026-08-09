import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fmbp_models/fmbp_models.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/theme.dart';
import '../../../core/services/firebase_auth_service.dart';
import '../../../core/services/firestore_service.dart';
import '../../../shared/utils/currency_formatter.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/persistent_financial_header.dart';
import '../../budget/presentation/budget_provider.dart';
import '../../family/presentation/family_members_sheet.dart';
import '../../shopping/presentation/shopping_provider.dart';
import 'meal_plan_provider.dart';
import 'recipe_detail_bottom_sheet.dart';

class MealPlanScreen extends ConsumerStatefulWidget {
  final void Function(int tabIndex)? onSelectTab;

  const MealPlanScreen({super.key, this.onSelectTab});

  @override
  ConsumerState<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends ConsumerState<MealPlanScreen> {
  var _isGenerating = false;
  String _selectedComplexity = 'BALANCED'; // FAST (<30p), BALANCED (30-60p), ELABORATE (>60p)
  final Set<String> _selectedCuisines = {'VIETNAMESE'};

  late PageController _pageController;
  int _selectedDayIndex = 0;
  bool _hasInitializedPage = false;
  String? _lastPlanId;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadCuisinePreferences();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadCuisinePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCuisines = prefs.getStringList('selected_cuisines');
      if (savedCuisines != null && savedCuisines.isNotEmpty && mounted) {
        setState(() {
          _selectedCuisines.clear();
          _selectedCuisines.addAll(savedCuisines);
        });
      }
    } catch (_) {}
  }

  Future<void> _saveCuisinePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('selected_cuisines', _selectedCuisines.toList());
    } catch (_) {}
  }

  Future<void> _generateAIPlan() async {
    setState(() => _isGenerating = true);
    try {
      await ref.read(mealPlanStateProvider.notifier).requestAISuggestions(
            complexity: _selectedComplexity,
            cuisines: _selectedCuisines.toList(),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã tạo thực đơn tuần thông minh phù hợp ngân sách & tủ lạnh!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tạo thực đơn thất bại: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  void _copyPlanToNextWeek() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã sao chép thực đơn tuần này áp dụng cho Tuần Tiếp Theo!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  Future<void> _generateChecklistAndGoShopping() async {
    try {
      await ref.read(shoppingStateProvider.notifier).generateShoppingList();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã tự động gộp nguyên liệu cần mua vào Danh Sách Đi Chợ!'),
            backgroundColor: AppColors.success,
          ),
        );
        if (widget.onSelectTab != null) {
          widget.onSelectTab!(2); // Switch to Tab 2 (Đi chợ)
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi sinh danh sách đi chợ: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showCuisinePreferencesDialog() {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Tùy Chọn Phong Cách Ẩm Thực'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Chọn một hoặc nhiều phong cách món ăn yêu thích của gia đình:', style: TextStyle(fontSize: 12)),
              const SizedBox(height: 12),
              _buildCuisineCheckbox('🇻🇳 Món Việt Nam', 'VIETNAMESE', setDialogState),
              _buildCuisineCheckbox('🇫🇮 Món Bắc Âu (Phần Lan)', 'FINNISH', setDialogState),
              _buildCuisineCheckbox('🇪🇺 Món Châu Âu (Pasta, Steak)', 'EUROPEAN', setDialogState),
              _buildCuisineCheckbox('🇯🇵 Món Châu Á (Nhật, Hàn)', 'ASIAN', setDialogState),
              _buildCuisineCheckbox('🥗 Món Clean / Healthy', 'HEALTHY', setDialogState),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _saveCuisinePreferences();
                Navigator.pop(ctx);
              },
              child: const Text('Đóng'),
            ),
            ElevatedButton(
              onPressed: () {
                _saveCuisinePreferences();
                Navigator.pop(ctx);
                _generateAIPlan();
              },
              child: const Text('Áp Dụng & Gợi Ý AI'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCuisineCheckbox(String label, String key, StateSetter setDialogState) {
    final isChecked = _selectedCuisines.contains(key);
    return CheckboxListTile(
      value: isChecked,
      title: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      dense: true,
      activeColor: AppColors.primary,
      onChanged: (val) {
        setDialogState(() {
          if (val == true) {
            _selectedCuisines.add(key);
          } else {
            // Đảm bảo phải chọn ít nhất 1 phong cách ẩm thực
            if (_selectedCuisines.length > 1) {
              _selectedCuisines.remove(key);
            }
          }
        });
        _saveCuisinePreferences();
        setState(() {});
      },
    );
  }

  void _openRecipeDetail(
    String recipeTitle,
    String dayName,
    String mealType,
    num estimatedCost,
    String currency, {
    Map<String, dynamic>? mealItem,
  }) {
    List<Map<String, dynamic>>? ings;
    List<String>? steps;
    String? localTip;

    if (mealItem != null) {
      if (mealItem['ingredients'] is List) {
        ings = (mealItem['ingredients'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
      if (mealItem['cooking_steps'] is List) {
        steps = (mealItem['cooking_steps'] as List).map((e) => e.toString()).toList();
      } else if (mealItem['cookingSteps'] is List) {
        steps = (mealItem['cookingSteps'] as List).map((e) => e.toString()).toList();
      }
      localTip = mealItem['local_tip'] ?? mealItem['localTip'];
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RecipeDetailBottomSheet(
        recipeTitle: recipeTitle,
        dayName: dayName,
        mealType: mealType,
        estimatedCost: estimatedCost,
        currency: currency,
        ingredients: ings ?? const [],
        cookingSteps: steps,
        localTip: localTip,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mealPlanState = ref.watch(mealPlanStateProvider);
    final user = ref.watch(firebaseAuthServiceProvider).currentUser;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return StreamBuilder<User?>(
      stream: user != null ? ref.watch(firestoreServiceProvider).watchUser(user.uid) : null,
      builder: (context, userSnap) {
        final familyId = userSnap.data?.familyId;

        return StreamBuilder<FamilyGroup?>(
          stream: familyId != null ? ref.watch(firestoreServiceProvider).watchFamily(familyId) : null,
          builder: (context, familySnap) {
            final activeCurrency = familySnap.data?.currency ?? 'EUR';

            return Scaffold(
              appBar: AppBar(
                title: const Text('Kế Hoạch Thực Đơn'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.people_outline_rounded),
                    tooltip: 'Hồ sơ nhân khẩu học & khẩu vị gia đình',
                    onPressed: () async {
                      var targetFamilyId = familyId;
                      if ((targetFamilyId == null || targetFamilyId.isEmpty) && user != null) {
                        targetFamilyId = await ref.read(firestoreServiceProvider).createFamilyGroup('Gia Đình Tôi', user.uid);
                      }
                      if (targetFamilyId != null && context.mounted) {
                        FamilyMembersSheet.show(context, targetFamilyId);
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.public_rounded),
                    tooltip: 'Tùy chọn phong cách ẩm thực',
                    onPressed: _showCuisinePreferencesDialog,
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded),
                    tooltip: 'Tạo lại thực đơn',
                    onPressed: _isGenerating ? null : _generateAIPlan,
                  ),
                ],
              ),
              body: Column(
                children: [
                  const PersistentFinancialHeader(),

                  Expanded(
                    child: mealPlanState.when(
                      data: (plan) {
                        if (plan == null) {
                          // Empty state - Prompt AI Generation with Input Settings
                          return SingleChildScrollView(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.auto_awesome_outlined,
                                    size: 48,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  'Lập Thực Đơn Tuần Dinh Dưỡng',
                                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Trợ lý AI sẽ gợi ý thực đơn dựa trên ngân sách, đồ trong tủ lạnh và tiêu chí cài đặt bên dưới.',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.lg),

                                // Thẻ Tiêu Chí Đầu Vào Nấu Ăn
                                AppCard(
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: const [
                                          Icon(Icons.tune_rounded, size: 18, color: AppColors.primary),
                                          SizedBox(width: 8),
                                          Text(
                                            'Cấu Hình Tiêu Chí Nấu Ăn Đầu Vào',
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        '1. Chọn cấp độ & thời gian chuẩn bị:',
                                        style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(child: _buildComplexityOptionTile('⚡ Nấu Nhanh', '<30 phút', 'FAST')),
                                          const SizedBox(width: 6),
                                          Expanded(child: _buildComplexityOptionTile('🍲 Cân Bằng', '30-60 phút', 'BALANCED')),
                                          const SizedBox(width: 6),
                                          Expanded(child: _buildComplexityOptionTile('👑 Cầu Kỳ', '>60 phút', 'ELABORATE')),
                                        ],
                                      ),
                                      const SizedBox(height: 14),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '2. Phong cách ẩm thực:',
                                            style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                                          ),
                                          InkWell(
                                            onTap: _showCuisinePreferencesDialog,
                                            child: Text(
                                              'Tùy chỉnh (${_selectedCuisines.length}) ⚙️',
                                              style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: AppSpacing.xl),
                                AppButton(
                                  text: 'Gợi Ý Thực Đơn Bằng AI',
                                  isLoading: _isGenerating,
                                  onPressed: _generateAIPlan,
                                ),
                              ],
                            ),
                          );
                        }

                        // Active Meal Plan UI
                        final days = _extractDaysFromPlan(plan);
                        final todayIndex = _findTodayIndex(days);

                        if ((!_hasInitializedPage || _lastPlanId != plan.id) && days.isNotEmpty) {
                          _lastPlanId = plan.id;
                          _selectedDayIndex = todayIndex;
                          _pageController = PageController(initialPage: _selectedDayIndex);
                          _hasInitializedPage = true;
                        }

                        final budget = ref.watch(budgetStateProvider).value;
                        final isLowBudget = (budget != null && budget.allocatedAmount < 70) ||
                            (budget != null && budget.spentAmount >= budget.allocatedAmount * 0.85);

                        return ListView(
                          padding: const EdgeInsets.only(
                            left: AppSpacing.md,
                            right: AppSpacing.md,
                            top: AppSpacing.sm,
                            bottom: 80,
                          ),
                          children: [
                            // Compact Header
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lịch Ăn Theo Ngày',
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Ước tính: ${CurrencyFormatter.format(plan.totalEstimatedCost, activeCurrency)}',
                                  style: theme.textTheme.bodySmall?.copyWith(color: theme.disabledColor, fontSize: 11),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.xs),

                            // AI Budget Warning (ONLY displayed when budget is low / near limit)
                            if (isLowBudget)
                              Container(
                                margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                  border: Border.all(color: Colors.amber.withOpacity(0.3)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            '💡 Ngân Sách Hạn Chế: Chế Độ Tiết Kiệm Kích Hoạt',
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.amber),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Thực đơn tự động ưu tiên nguyên liệu giá tốt (Khoai tây, Yến mạch, Trứng) để tối ưu chi phí đi chợ.',
                                            style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, height: 1.3),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            // Day Navigation Header
                            _buildDayNavigationHeader(context, days, _selectedDayIndex, todayIndex, theme),
                            const SizedBox(height: AppSpacing.xs),

                            // Swipable Day Card PageView
                            SizedBox(
                              height: 230,
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: days.length,
                                onPageChanged: (index) {
                                  setState(() {
                                    _selectedDayIndex = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  final day = days[index];
                                  final items = plan.items ?? [];
                                  final dayItems = items.where((i) => i['day'] == day).toList();
                                  Map<String, dynamic>? bfItem;
                                  Map<String, dynamic>? luItem;
                                  Map<String, dynamic>? dnItem;

                                  for (final it in dayItems) {
                                    final type = it['meal_type'] ?? it['mealType'];
                                    if (type == 'BREAKFAST') bfItem = Map<String, dynamic>.from(it as Map);
                                    if (type == 'LUNCH') luItem = Map<String, dynamic>.from(it as Map);
                                    if (type == 'DINNER') dnItem = Map<String, dynamic>.from(it as Map);
                                  }

                                  return _buildMealDayCard(context, day, bfItem, luItem, dnItem, activeCurrency);
                                },
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),

                            // Page Indicator Dots
                            _buildDayPageIndicator(days.length, _selectedDayIndex, todayIndex),

                            const SizedBox(height: 120),
                          ],
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, st) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                              const SizedBox(height: 8),
                              const Text('Tạm thời chưa có dữ liệu thực đơn'),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: _generateAIPlan,
                                child: const Text('Tạo Thực Đơn Ngay'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              floatingActionButton: mealPlanState.asData?.value == null
                  ? null
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: isDark
                                        ? AppColors.bgCardDark.withOpacity(0.95)
                                        : Colors.white.withOpacity(0.95),
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                    ),
                                    side: BorderSide(color: AppColors.primary.withOpacity(0.4)),
                                  ),
                                  icon: const Icon(Icons.copy_rounded, size: 14, color: AppColors.primary),
                                  label: const Text('Sao chép tuần sau', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                  onPressed: _copyPlanToNextWeek,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: isDark
                                        ? AppColors.bgCardDark.withOpacity(0.95)
                                        : Colors.white.withOpacity(0.95),
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                    ),
                                    side: BorderSide(color: AppColors.primary.withOpacity(0.4)),
                                  ),
                                  icon: const Icon(Icons.auto_awesome_rounded, size: 14, color: AppColors.primary),
                                  label: const Text('Tạo thực đơn mới', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                  onPressed: _isGenerating ? null : _generateAIPlan,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: double.infinity,
                            height: 46,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                                ),
                                elevation: 4,
                              ),
                              icon: const Icon(Icons.shopping_cart_checkout_rounded, size: 18),
                              label: const Text(
                                'Tạo Danh Sách Mua Sắm & Đi Chợ ➔',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              onPressed: _generateChecklistAndGoShopping,
                            ),
                          ),
                        ],
                      ),
                    ),
            );
          },
        );
      },
    );
  }

  Widget _buildComplexityOptionTile(String title, String subtitle, String key) {
    final isSelected = _selectedComplexity == key;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: () => setState(() => _selectedComplexity = key),
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(isDark ? 0.25 : 0.12)
              : (isDark ? AppColors.bgCardDark : Colors.white),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(
            color: isSelected ? AppColors.primary : (isDark ? Colors.white12 : Colors.black12),
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.primary : (isDark ? Colors.white : Colors.black87),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealDayCard(
    BuildContext context,
    String dayName,
    Map<String, dynamic>? breakfastItem,
    Map<String, dynamic>? lunchItem,
    Map<String, dynamic>? dinnerItem,
    String currency,
  ) {
    final theme = Theme.of(context);
    final bfName = breakfastItem?['recipe_title'] ?? breakfastItem?['recipeTitle'] ?? breakfastItem?['title'] ?? 'Bánh mì sandwich';
    final luName = lunchItem?['recipe_title'] ?? lunchItem?['recipeTitle'] ?? lunchItem?['title'] ?? 'Cơm sườn kho trứng';
    final dnName = dinnerItem?['recipe_title'] ?? dinnerItem?['recipeTitle'] ?? dinnerItem?['title'] ?? 'Canh chua cá hồi';

    final bfCost = (breakfastItem?['estimated_cost'] as num?) ?? 5;
    final luCost = (lunchItem?['estimated_cost'] as num?) ?? 10;
    final dnCost = (dinnerItem?['estimated_cost'] as num?) ?? 12;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dayName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  'Bấm món để xem chi tiết ➔',
                  style: TextStyle(fontSize: 10, color: theme.disabledColor),
                ),
              ],
            ),
            const Divider(height: 16),
            _buildMealRow(context, Icons.wb_sunny_outlined, 'Sáng', bfName, dayName, bfCost, currency, mealItem: breakfastItem),
            const SizedBox(height: 8),
            _buildMealRow(context, Icons.wb_twilight, 'Trưa', luName, dayName, luCost, currency, mealItem: lunchItem),
            const SizedBox(height: 8),
            _buildMealRow(context, Icons.nights_stay_outlined, 'Tối', dnName, dayName, dnCost, currency, mealItem: dinnerItem),
          ],
        ),
      ),
    );
  }

  Widget _buildMealRow(
    BuildContext context,
    IconData icon,
    String label,
    String mealName,
    String dayName,
    num estCost,
    String currency, {
    Map<String, dynamic>? mealItem,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => _openRecipeDetail(mealName, dayName, label, estCost, currency, mealItem: mealItem),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, size: 20, color: theme.disabledColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                mealName,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.dotted,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  List<String> _extractDaysFromPlan(MealPlan plan) {
    final items = plan.items ?? [];
    final List<String> days = [];
    for (final it in items) {
      final d = it['day'] as String?;
      if (d != null && !days.contains(d)) {
        days.add(d);
      }
    }
    if (days.isEmpty) {
      days.addAll(List.generate(7, (index) {
        final targetDate = DateTime.now().add(Duration(days: index));
        final dateStr = DateFormat('dd/MM').format(targetDate);
        if (index == 0) return 'Hôm nay ($dateStr)';
        if (index == 1) return 'Ngày mai ($dateStr)';
        switch (targetDate.weekday) {
          case DateTime.monday: return 'Thứ Hai ($dateStr)';
          case DateTime.tuesday: return 'Thứ Ba ($dateStr)';
          case DateTime.wednesday: return 'Thứ Tư ($dateStr)';
          case DateTime.thursday: return 'Thứ Năm ($dateStr)';
          case DateTime.friday: return 'Thứ Sáu ($dateStr)';
          case DateTime.saturday: return 'Thứ Bảy ($dateStr)';
          case DateTime.sunday: return 'Chủ Nhật ($dateStr)';
          default: return dateStr;
        }
      }));
    }
    return days;
  }

  int _findTodayIndex(List<String> days) {
    final todayStr = DateFormat('dd/MM').format(DateTime.now());
    for (int i = 0; i < days.length; i++) {
      if (days[i].contains('Hôm nay') || days[i].contains(todayStr)) {
        return i;
      }
    }
    return 0;
  }

  Widget _buildDayNavigationHeader(
    BuildContext context,
    List<String> days,
    int currentIndex,
    int todayIndex,
    ThemeData theme,
  ) {
    final isToday = currentIndex == todayIndex;
    final currentDayName = days.isNotEmpty && currentIndex < days.length ? days[currentIndex] : '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 4),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark ? AppColors.bgCardDark : AppColors.bgCardLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: theme.brightness == Brightness.dark ? Colors.white12 : Colors.black12,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded, size: 28),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            tooltip: 'Ngày trước',
            onPressed: currentIndex > 0
                ? () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                    );
                  }
                : null,
          ),
          Expanded(
            child: Text(
              currentDayName,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isToday)
                InkWell(
                  onTap: () {
                    _pageController.animateToPage(
                      todayIndex,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.today_rounded, size: 14, color: AppColors.primary),
                        SizedBox(width: 4),
                        Text(
                          'Hôm nay',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded, size: 28),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                tooltip: 'Ngày tiếp theo',
                onPressed: currentIndex < days.length - 1
                    ? () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDayPageIndicator(int totalDays, int currentIndex, int todayIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalDays, (index) {
        final isSelected = index == currentIndex;
        final isToday = index == todayIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isSelected ? 20 : (isToday ? 10 : 6),
          height: 6,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : (isToday ? AppColors.primary.withOpacity(0.5) : Colors.grey.shade400),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
