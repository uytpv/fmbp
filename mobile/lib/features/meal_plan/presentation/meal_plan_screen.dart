import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fmbp_models/fmbp_models.dart';
import 'package:intl/intl.dart';
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
  String _selectedComplexity = 'ALL'; // ALL, FAST (<30p), BALANCED (30-60p), ELABORATE (>60p)
  final Set<String> _selectedCuisines = {'VIETNAMESE', 'FINNISH'};

  Future<void> _generateAIPlan() async {
    setState(() => _isGenerating = true);
    try {
      await ref.read(mealPlanStateProvider.notifier).requestAISuggestions();
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
          const SnackBar(
            content: Text('Không thể tạo thực đơn. Vui lòng hoàn tất cài đặt ngân sách!'),
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
              _buildCuisineCheckbox('🇫🇮 Món Phần Lan / Bắc Âu', 'FINNISH', setDialogState),
              _buildCuisineCheckbox('🇪🇺 Món Châu Âu (Pasta, Steak)', 'EUROPEAN', setDialogState),
              _buildCuisineCheckbox('🇯🇵 Món Châu Á (Nhật, Hàn)', 'ASIAN', setDialogState),
              _buildCuisineCheckbox('🥗 Món Clean / Healthy', 'HEALTHY', setDialogState),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Đóng')),
            ElevatedButton(
              onPressed: () {
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
            _selectedCuisines.remove(key);
          }
        });
        setState(() {});
      },
    );
  }

  void _openRecipeDetail(String recipeTitle, String dayName, String mealType, num estimatedCost, String currency) {
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

                  // Bộ Lọc Cấp Độ Nấu Nướng (<30p, 30-60p, >60p)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildComplexityChip('Tất Cả Cấp Độ', 'ALL'),
                          const SizedBox(width: 6),
                          _buildComplexityChip('⚡ Nấu Nhanh (<30p)', 'FAST'),
                          const SizedBox(width: 6),
                          _buildComplexityChip('🍲 Cân Bằng (30-60p)', 'BALANCED'),
                          const SizedBox(width: 6),
                          _buildComplexityChip('👑 Cầu Kỳ (>60p)', 'ELABORATE'),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: mealPlanState.when(
                      data: (plan) {
                        if (plan == null) {
                          // Empty state - Prompt AI Generation
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(AppSpacing.md),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.auto_awesome_outlined,
                                      size: 56,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.lg),
                                  Text(
                                    'Lập Thực Đơn Tuần Dinh Dưỡng',
                                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Trợ lý AI sẽ gợi ý thực đơn quốc tế tối ưu dựa trên ngân sách tuần và thực phẩm trong tủ lạnh của bạn.',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
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
                                          TextButton.icon(
                                            onPressed: _copyPlanToNextWeek,
                                            icon: const Icon(Icons.copy_rounded, size: 14),
                                            label: const Text('Sao chép tuần sau', style: TextStyle(fontSize: 11)),
                                          ),
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

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Lịch Ăn Uống Trong Tuần',
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                TextButton.icon(
                                  onPressed: _isGenerating ? null : _generateAIPlan,
                                  icon: const Icon(Icons.refresh_rounded, size: 16),
                                  label: const Text('Đổi thực đơn', style: TextStyle(fontSize: 12)),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.xs),

                            // Meal Days (Tapping any meal inspects details)
                            _buildMockMealDayCard(context, 'Thứ Hai', 'Bánh mì sandwich mứt dâu', 'Cơm sườn kho trứng', 'Canh chua cá hồi & rau muống xào', activeCurrency),
                            _buildMockMealDayCard(context, 'Thứ Ba', 'Phở bò Hà Nội', 'Thịt heo quay & canh cải băm', 'Cá kho tộ & canh khoai mỡ', activeCurrency),
                            _buildMockMealDayCard(context, 'Thứ Tư', 'Cháo gà hạt sen', 'Bún mọc sườn chua', 'Tôm hấp dừa & su su xào trứng', activeCurrency),
                            _buildMockMealDayCard(context, 'Thứ Năm', 'Bún riêu cua', 'Bò xào thiên lý & canh bí đỏ', 'Cơm cá hồi nướng bơ tỏi', activeCurrency),
                            _buildMockMealDayCard(context, 'Thứ Sáu', 'Hủ tiếu Nam Vang', 'Mực xào sa tế & canh rau ngót', 'Thịt kho tàu & trứng luộc', activeCurrency),
                            _buildMockMealDayCard(context, 'Thứ Bảy', 'Bánh mì ốp la pate', 'Lẩu thái hải sản gia đình', 'Cơm chiên hải sản', activeCurrency),
                            _buildMockMealDayCard(context, 'Chủ Nhật', 'Bún bò Huế', 'Cơm gà Hải Nam', 'Canh sườn hầm củ quả', activeCurrency),
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
              floatingActionButton: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _generateChecklistAndGoShopping,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
                      elevation: 4,
                    ),
                    icon: const Icon(Icons.shopping_cart_checkout_rounded),
                    label: const Text(
                      '🛒 Tạo Danh Sách Mua Sắm & Đi Chợ ➔',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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

  Widget _buildComplexityChip(String label, String key) {
    final isSelected = _selectedComplexity == key;
    return ChoiceChip(
      showCheckmark: false,
      label: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.white : AppColors.primary,
        ),
      ),
      selected: isSelected,
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.primary.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.primary.withOpacity(0.2),
        ),
      ),
      onSelected: (sel) {
        if (sel) setState(() => _selectedComplexity = key);
      },
    );
  }

  Widget _buildMockMealDayCard(
    BuildContext context,
    String dayName,
    String breakfast,
    String lunch,
    String dinner,
    String currency,
  ) {
    final theme = Theme.of(context);
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
            _buildMealRow(context, Icons.wb_sunny_outlined, 'Sáng', breakfast, dayName, 5, currency),
            const SizedBox(height: 6),
            _buildMealRow(context, Icons.wb_twilight, 'Trưa', lunch, dayName, 10, currency),
            const SizedBox(height: 6),
            _buildMealRow(context, Icons.nights_stay_outlined, 'Tối', dinner, dayName, 12, currency),
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
    String currency,
  ) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => _openRecipeDetail(mealName, dayName, label, estCost, currency),
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
