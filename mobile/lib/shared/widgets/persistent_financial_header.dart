import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fmbp_models/fmbp_models.dart';
import '../../app/theme.dart';
import '../../core/services/currency_service.dart';
import '../../core/services/firebase_auth_service.dart';
import '../../core/services/firestore_service.dart';
import '../../features/budget/presentation/budget_provider.dart';
import 'adjust_budget_bottom_sheet.dart';

class PersistentFinancialHeader extends ConsumerWidget {
  const PersistentFinancialHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final user = ref.watch(firebaseAuthServiceProvider).currentUser;
    final budgetState = ref.watch(budgetStateProvider);
    final currencySvc = ref.watch(currencyServiceProvider);

    if (user == null) return const SizedBox();

    return StreamBuilder<User?>(
      stream: ref.watch(firestoreServiceProvider).watchUser(user.uid),
      builder: (context, userSnap) {
        final userData = userSnap.data;
        final familyId = userData?.familyId;

        if (familyId == null) return _buildNoBudgetCard(context, null);

        return StreamBuilder<FamilyGroup?>(
          stream: ref.watch(firestoreServiceProvider).watchFamily(familyId),
          builder: (context, familySnap) {
            final family = familySnap.data;
            final currency = family?.currency ?? 'EUR';

            return budgetState.when(
              data: (budget) {
                if (budget == null) return _buildNoBudgetCard(context, family);

                final allocated = budget.allocatedAmount.toDouble();
                final spent = budget.spentAmount.toDouble();
                final remaining = allocated - spent;
                final percentRemaining = allocated > 0 ? (remaining / allocated).clamp(0.0, 1.0) : 0.0;

                // Xác định màu tiến trình
                Color progressColor = AppColors.primary;
                String statusLabel = 'Ngân sách an toàn';

                if (percentRemaining < 0.15) {
                  progressColor = AppColors.error;
                  statusLabel = 'Cảnh báo: Sắp hết ngân sách!';
                } else if (percentRemaining < 0.40) {
                  progressColor = Colors.orange;
                  statusLabel = 'Cần cân đối các bữa ăn';
                }

                return Container(
                  margin: const EdgeInsets.all(AppSpacing.md),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.bgCardDark : Colors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(color: progressColor.withOpacity(0.4), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: progressColor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.account_balance_wallet_rounded,
                                  size: 18,
                                  color: progressColor,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Kế Hoạch Ngân Sách Tuần',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    statusLabel,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: progressColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Nút Điều Chỉnh Ngân Sách
                          InkWell(
                            onTap: () {
                              AdjustBudgetBottomSheet.show(
                                context,
                                family: family,
                                currentBudget: budget,
                              );
                            },
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.tune_rounded, size: 14, color: AppColors.primary),
                                  SizedBox(width: 4),
                                  Text(
                                    'Điều Chỉnh',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // Số dư ngân sách
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Còn lại: ${currencySvc.format(remaining, currency)}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: progressColor,
                            ),
                          ),
                          Text(
                            '/ ${currencySvc.format(allocated, currency)}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Spending Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: percentRemaining,
                          minHeight: 6,
                          backgroundColor: Colors.grey.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const SizedBox(),
              error: (_, __) => _buildNoBudgetCard(context, family),
            );
          },
        );
      },
    );
  }

  Widget _buildNoBudgetCard(BuildContext context, FamilyGroup? family) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgCardDark : Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.account_balance_wallet_rounded, size: 18, color: AppColors.primary),
                    SizedBox(width: 6),
                    Text(
                      'Ngân Sách Ăn Uống Tuần',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Chưa thiết lập kế hoạch ngân sách tuần này',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () {
              AdjustBudgetBottomSheet.show(context, family: family, currentBudget: null);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusSm)),
            ),
            icon: const Icon(Icons.tune_rounded, size: 14),
            label: const Text('Thiết Lập', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
