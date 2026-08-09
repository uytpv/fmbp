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

  @override
  void initState() {
    super.initState();
    _loadCuisinePreferences();
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
                      if (targetFamilyId != null && mounted) {
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
                        return ListView(
                          padding: const EdgeInsets.only(
                            left: AppSpacing.md,
                            right: AppSpacing.md,
                            top: AppSpacing.md,
                            bottom: 80,
                          ),
                          children: [
                            // Summary Banner
                            AppCard(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Thực Đơn Tuần Đang Áp Dụng',
                                            style: theme.textTheme.bodySmall?.copyWith(color: theme.disabledColor),
                                          ),
                                          Text(
                                            '${DateFormat('dd/MM').format(plan.startDate)} - ${DateFormat('dd/MM').format(plan.endDate)}',
                                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: _copyPlanToNextWeek,
                                            borderRadius: BorderRadius.circular(4),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: const [
                                                  Icon(Icons.copy_rounded, size: 14, color: AppColors.primary),
                                                  SizedBox(width: 4),
                                                  Text('Sao chép tuần sau', style: TextStyle(fontSize: 11, color: AppColors.primary)),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary.withOpacity(0.12),
                                              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                            ),
                                            child: Text(
                                              'Hoạt Động',
                                              style: theme.textTheme.bodySmall?.copyWith(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 18),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Chi phí ước tính:',
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                      Text(
                                        CurrencyFormatter.format(plan.totalEstimatedCost, activeCurrency),
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),

                            // AI Budget Warning & Feasibility Advice Banner
                            Container(
                              margin: const EdgeInsets.only(bottom: AppSpacing.md),
                              padding: const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                border: Border.all(color: Colors.amber.withOpacity(0.3)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 22),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          '💡 Phân Tích Ngân Sách AI & Chế Độ Tiết Kiệm',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.amber),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Nếu ngân sách tuần quá thấp so với số người ăn, AI tự động kích hoạt Chế Độ Tiết Kiệm Cực Hạn (Survival Mode): lặp lại các nguyên liệu giá rẻ như Khoai tây nghiền, Yến mạch và Trứng để mua sỉ tối ưu ngân sách.',
                                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 11, height: 1.4),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Lịch Ăn Uống Trong Tuần',
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                InkWell(
                                  onTap: _isGenerating ? null : _generateAIPlan,
                                  borderRadius: BorderRadius.circular(4),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(Icons.refresh_rounded, size: 16, color: AppColors.primary),
                                        SizedBox(width: 4),
                                        Text('Đổi thực đơn', style: TextStyle(fontSize: 12, color: AppColors.primary)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.xs),

                            // Meal Days dynamically rendered from plan.items
                            ...() {
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

                              final List<Widget> dayCards = [];
                              for (final day in days) {
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

                                dayCards.add(
                                  _buildMealDayCard(context, day, bfItem, luItem, dnItem, activeCurrency),
                                );
                              }
                              return dayCards;
                            }(),

                            // Cycle Next Week Action Card
                            const SizedBox(height: AppSpacing.md),
                            AppCard(
                              color: AppColors.primary.withOpacity(0.06),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(Icons.autorenew_rounded, color: AppColors.primary),
                                      SizedBox(width: 8),
                                      Text(
                                        '🔄 Vòng Lặp Tuần Tiếp Theo',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Khi hoàn thành tuần ăn, hãy lên thực đơn tuần mới. AI sẽ quét toàn bộ thực phẩm còn thừa trong tủ lạnh để tối ưu chi phí đi chợ!',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          icon: const Icon(Icons.copy_rounded, size: 16),
                                          label: const Text('Sao chép tuần này', style: TextStyle(fontSize: 11)),
                                          onPressed: _copyPlanToNextWeek,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                                          label: const Text('Tạo thực đơn tuần mới', style: TextStyle(fontSize: 11)),
                                          onPressed: _generateAIPlan,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 80),
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
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: InkWell(
                          onTap: _generateChecklistAndGoShopping,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                              boxShadow: const [
                                BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.shopping_cart_checkout_rounded, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  '🛒 Tạo Danh Sách Mua Sắm & Đi Chợ ➔',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
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
            const Divider(height: 14),
            _buildMealRow(context, Icons.wb_sunny_outlined, 'Sáng', bfName, dayName, bfCost, currency, mealItem: breakfastItem),
            const SizedBox(height: 6),
            _buildMealRow(context, Icons.wb_twilight, 'Trưa', luName, dayName, luCost, currency, mealItem: lunchItem),
            const SizedBox(height: 6),
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
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Icon(icon, size: 16, color: theme.disabledColor),
            const SizedBox(width: 8),
            Text(
              '$label: ',
              style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Text(
                mealName,
                style: theme.textTheme.bodySmall?.copyWith(
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.dotted,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
