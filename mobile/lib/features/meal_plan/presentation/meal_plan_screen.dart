import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../app/theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import 'meal_plan_provider.dart';

class MealPlanScreen extends ConsumerStatefulWidget {
  const MealPlanScreen({super.key});

  @override
  ConsumerState<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends ConsumerState<MealPlanScreen> {
  var _isGenerating = false;

  Future<void> _generateAIPlan() async {
    setState(() => _isGenerating = true);
    try {
      await ref.read(mealPlanStateProvider.notifier).requestAISuggestions();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã tạo thực đơn tuần bằng AI thành công!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi gợi ý thực đơn: $e'),
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

  @override
  Widget build(BuildContext context) {
    final mealPlanState = ref.watch(mealPlanStateProvider);
    final theme = Theme.of(context);
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kế Hoạch Thực Đơn'),
      ),
      body: mealPlanState.when(
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
                        size: 64,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Lập Thực Đơn Tuần',
                      style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'AI sẽ tự động lập kế hoạch thực đơn chi tiết dựa trên ngân sách tuần và nguyên liệu sẵn có trong tủ lạnh của bạn.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.brightness == Brightness.dark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AppButton(
                      text: 'Tự Động Gợi Ý Thực Đơn Bằng AI',
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
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              // Summary Banner
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Thực Đơn Tuần Hoạt Động',
                              style: theme.textTheme.bodyMedium?.copyWith(color: theme.disabledColor),
                            ),
                            Text(
                              '${DateFormat('dd/MM').format(plan.startDate)} - ${DateFormat('dd/MM').format(plan.endDate)}',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                          child: Text(
                            'Hoạt Động',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Chi phí ước tính:',
                          style: theme.textTheme.bodyLarge,
                        ),
                        Text(
                          formatCurrency.format(plan.totalEstimatedCost),
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              Text(
                'Lịch Ăn Uống Trong Tuần',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Mock Meal list representing suggested structure
              _buildMockMealDayCard(context, 'Thứ Hai', 'Bánh mì sandwich', 'Cơm sườn bì chả', 'Canh chua cá lóc'),
              _buildMockMealDayCard(context, 'Thứ Ba', 'Phở bò', 'Thịt kho trứng', 'Canh cải thịt băm'),
              _buildMockMealDayCard(context, 'Thứ Tư', 'Bún mọc', 'Cá lóc kho tộ', 'Rau muống xào tỏi'),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Lỗi tải thực đơn: $err')),
      ),
    );
  }

  Widget _buildMockMealDayCard(
    BuildContext context,
    String dayName,
    String breakfast,
    String lunch,
    String dinner,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dayName,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const Divider(height: 16),
            _buildMealRow(context, Icons.wb_sunny_outlined, 'Sáng', breakfast),
            const SizedBox(height: 8),
            _buildMealRow(context, Icons.wb_twilight, 'Trưa', lunch),
            const SizedBox(height: 8),
            _buildMealRow(context, Icons.nights_stay_outlined, 'Tối', dinner),
          ],
        ),
      ),
    );
  }

  Widget _buildMealRow(BuildContext context, IconData icon, String label, String mealName) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.disabledColor),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            mealName,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
