import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fmbp_models/fmbp_models.dart';
import '../../app/theme.dart';
import '../../core/services/currency_service.dart';
import '../../core/services/firebase_auth_service.dart';
import '../../core/services/firestore_service.dart';
import '../../features/budget/presentation/budget_provider.dart';
import 'adjust_budget_bottom_sheet.dart';

class PersistentFinancialHeader extends ConsumerStatefulWidget {
  const PersistentFinancialHeader({super.key});

  @override
  ConsumerState<PersistentFinancialHeader> createState() => _PersistentFinancialHeaderState();
}

class _PersistentFinancialHeaderState extends ConsumerState<PersistentFinancialHeader> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
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

            final budget = budgetState.value;

            if (budget == null) {
              if (budgetState.isLoading) {
                return const SizedBox(
                  height: 40,
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                );
              }
              return _buildNoBudgetCard(context, family);
            }

            final allocated = budget.allocatedAmount.toDouble();
            final spent = budget.spentAmount.toDouble();
            final remaining = allocated - spent;
            final percentRemaining = allocated > 0 ? (remaining / allocated).clamp(0.0, 1.0) : 0.0;
            final percentSpent = allocated > 0 ? (spent / allocated).clamp(0.0, 1.0) : 0.0;

            // Màu sắc trạng thái tiến trình
            Color progressColor = AppColors.primary;
            String statusLabel = 'Ngân sách an toàn';

            if (percentRemaining < 0.15) {
              progressColor = AppColors.error;
              statusLabel = 'Sắp hết ngân sách!';
            } else if (percentRemaining < 0.40) {
              progressColor = Colors.orange;
              statusLabel = 'Cần cân đối bữa ăn';
            }

            final spentText = currencySvc.format(spent.round(), currency);
            final allocatedText = currencySvc.format(allocated.round(), currency);
            final remainingText = currencySvc.format(remaining.round(), currency);

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
              decoration: BoxDecoration(
                color: isDark ? AppColors.bgCardDark : Colors.white,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: progressColor.withOpacity(0.4), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: _isExpanded
                  ? _buildExpandedContent(
                      context: context,
                      theme: theme,
                      isDark: isDark,
                      family: family,
                      budget: budget,
                      spentText: spentText,
                      allocatedText: allocatedText,
                      remainingText: remainingText,
                      percentRemaining: percentRemaining,
                      progressColor: progressColor,
                      statusLabel: statusLabel,
                      currencySvc: currencySvc,
                    )
                  : _buildFloatingMiniPill(
                      context: context,
                      theme: theme,
                      isDark: isDark,
                      spentText: spentText,
                      allocatedText: allocatedText,
                      remainingText: remainingText,
                      percentSpent: percentSpent,
                      progressColor: progressColor,
                      statusLabel: statusLabel,
                    ),
            );
          },
        );
      },
    );
  }

  // --------------------------------------------------------------------------
  // FLOATING MINI PILL MODE (Compact floating bar)
  // --------------------------------------------------------------------------
  Widget _buildFloatingMiniPill({
    required BuildContext context,
    required ThemeData theme,
    required bool isDark,
    required String spentText,
    required String allocatedText,
    required String remainingText,
    required double percentSpent,
    required Color progressColor,
    required String statusLabel,
  }) {
    return InkWell(
      onTap: () => setState(() => _isExpanded = true),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                // Mini Icon
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: progressColor.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.account_balance_wallet_rounded, size: 16, color: progressColor),
                ),
                const SizedBox(width: 8),

                // Text: Còn €80 / €100
                Expanded(
                  child: Text(
                    'Còn $remainingText / $allocatedText',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: progressColor,
                      fontSize: 13,
                    ),
                  ),
                ),

                // Button Expand (Bấm xem chi tiết)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('Chi tiết', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      SizedBox(width: 2),
                      Icon(Icons.expand_more_rounded, size: 14, color: AppColors.primary),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Mini Progress Indicator
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: percentSpent,
                minHeight: 4,
                backgroundColor: Colors.grey.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // EXPANDED DETAILED MODE (Full View with Collapse Button)
  // --------------------------------------------------------------------------
  Widget _buildExpandedContent({
    required BuildContext context,
    required ThemeData theme,
    required bool isDark,
    required FamilyGroup? family,
    required BudgetPeriod budget,
    required String spentText,
    required String allocatedText,
    required String remainingText,
    required double percentRemaining,
    required Color progressColor,
    required String statusLabel,
    required CurrencyService currencySvc,
  }) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
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

              Row(
                children: [
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.tune_rounded, size: 13, color: AppColors.primary),
                          SizedBox(width: 3),
                          Text('Điều Chỉnh', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 6),

                  // NÚT THU NHỎ (Icon Only Collapse)
                  InkWell(
                    onTap: () => setState(() => _isExpanded = false),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.keyboard_arrow_up_rounded, size: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentRemaining,
              minHeight: 6,
              backgroundColor: Colors.grey.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Chi tiết số tiền
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Còn lại:',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  Text(
                    '$remainingText / $allocatedText',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: progressColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: progressColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Text(
                  'Đã tiêu: $spentText',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: progressColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoBudgetCard(BuildContext context, FamilyGroup? family) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
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
                      'Ngân Sách Tuần',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Chưa thiết lập kế hoạch ngân sách',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              AdjustBudgetBottomSheet.show(context, family: family, currentBudget: null);
            },
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.tune_rounded, size: 14, color: Colors.white),
                  SizedBox(width: 4),
                  Text('Thiết Lập', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
