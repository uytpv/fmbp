import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../app/theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_text_field.dart';
import 'budget_provider.dart';

class BudgetTrackingScreen extends ConsumerStatefulWidget {
  const BudgetTrackingScreen({super.key});

  @override
  ConsumerState<BudgetTrackingScreen> createState() => _BudgetTrackingScreenState();
}

class _BudgetTrackingScreenState extends ConsumerState<BudgetTrackingScreen> {
  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedType = 'GROCERY';

  @override
  void dispose() {
    _amountController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _showAddTransactionBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final theme = Theme.of(context);
            final isDark = theme.brightness == Brightness.dark;

            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                top: AppSpacing.lg,
              ),
              decoration: BoxDecoration(
                color: isDark ? AppColors.bgCardDark : AppColors.bgCardLight,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.radiusLg),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Thêm Chi Tiêu Thực Phẩm',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    controller: _amountController,
                    labelText: 'Số tiền (VNĐ)',
                    keyboardType: TextInputType.number,
                    hintText: 'Ví dụ: 150000',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    controller: _descController,
                    labelText: 'Mô tả chi tiêu',
                    hintText: 'Ví dụ: Mua rau siêu thị, Ăn tối ngoài tiệm...',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Phân loại chi tiêu',
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('Đi chợ'),
                          selected: _selectedType == 'GROCERY',
                          onSelected: (selected) {
                            if (selected) setModalState(() => _selectedType = 'GROCERY');
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('Ăn ngoài'),
                          selected: _selectedType == 'DINING_OUT',
                          onSelected: (selected) {
                            if (selected) setModalState(() => _selectedType = 'DINING_OUT');
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    text: 'Ghi Nhận Chi Tiêu',
                    onPressed: () {
                      final amount = int.tryParse(_amountController.text) ?? 0;
                      final desc = _descController.text.trim();
                      if (amount > 0 && desc.isNotEmpty) {
                        ref.read(budgetStateProvider.notifier).recordTransaction(
                              amount,
                              _selectedType,
                              desc,
                            );
                        _amountController.clear();
                        _descController.clear();
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final budgetState = ref.watch(budgetStateProvider);
    final theme = Theme.of(context);
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Ngân Sách'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Mở màn hình cập nhật hạn mức ngân sách
              _showUpdateBudgetDialog(context);
            },
          ),
        ],
      ),
      body: budgetState.when(
        data: (budget) {
          if (budget == null) {
            return const Center(
              child: Text('Không tìm thấy dữ liệu ngân sách. Vui lòng hoàn thành thiết lập onboarding.'),
            );
          }

          final remaining = budget.allocatedAmount - budget.spentAmount;
          final percent = budget.allocatedAmount > 0 ? remaining / budget.allocatedAmount : 0.0;
          final color = percent > 0.3
              ? AppColors.success
              : percent > 0.1
                  ? AppColors.warning
                  : AppColors.error;

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              // Dashboard Budget Card
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Ngân Sách Ăn Uống Tuần Này',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.brightness == Brightness.dark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formatCurrency.format(remaining),
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      child: LinearProgressIndicator(
                        value: percent.clamp(0.0, 1.0),
                        minHeight: 8,
                        backgroundColor: theme.brightness == Brightness.dark
                            ? AppColors.borderDark
                            : AppColors.borderLight,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Đã tiêu: ${formatCurrency.format(budget.spentAmount)}'),
                        Text('Hạn mức: ${formatCurrency.format(budget.allocatedAmount)}'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Lịch Sử Chi Tiêu',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: _showAddTransactionBottomSheet,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Thêm chi tiêu'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              // Placeholder cho danh sách giao dịch
              AppCard(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                  child: Column(
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 48,
                        color: theme.disabledColor,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Chưa có giao dịch chi tiêu nào ghi nhận',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.disabledColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Lỗi tải ngân sách: $err')),
      ),
    );
  }

  void _showUpdateBudgetDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cập Nhật Hạn Mức Tuần'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Nhập hạn mức mới (VNĐ)',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                final amount = int.tryParse(controller.text) ?? 0;
                if (amount > 0) {
                  ref.read(budgetStateProvider.notifier).updateBudgetLimit(amount);
                  Navigator.pop(context);
                }
              },
              child: const Text('Cập Nhật'),
            ),
          ],
        );
      },
    );
  }
}
