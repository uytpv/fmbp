import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fmbp_models/fmbp_models.dart';
import 'package:uuid/uuid.dart';
import '../../app/theme.dart';
import '../../core/services/currency_service.dart';
import '../../core/services/firebase_auth_service.dart';
import '../../core/services/firestore_service.dart';
import '../../features/budget/presentation/budget_provider.dart';
import 'app_button.dart';
import 'app_card.dart';
import 'app_text_field.dart';

enum AdjustBudgetMode {
  fixedExpenses,
  direct,
}

class AdjustBudgetBottomSheet extends ConsumerStatefulWidget {
  final FamilyGroup? family;
  final BudgetPeriod? currentBudget;

  const AdjustBudgetBottomSheet({
    super.key,
    required this.family,
    required this.currentBudget,
  });

  static Future<void> show(BuildContext context, {FamilyGroup? family, BudgetPeriod? currentBudget}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AdjustBudgetBottomSheet(family: family, currentBudget: currentBudget),
    );
  }

  @override
  ConsumerState<AdjustBudgetBottomSheet> createState() => _AdjustBudgetBottomSheetState();
}

class _AdjustBudgetBottomSheetState extends ConsumerState<AdjustBudgetBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedCurrency;
  late AdjustBudgetMode _selectedMode;
  late TextEditingController _incomeController;
  late TextEditingController _directBudgetController;
  final _incomeFocusNode = FocusNode();
  final _directBudgetFocusNode = FocusNode();
  late List<FixedExpense> _fixedExpenses;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedCurrency = widget.family?.currency ?? 'EUR';
    _selectedMode = (widget.family?.monthlyIncome != null && widget.family!.monthlyIncome! > 0)
        ? AdjustBudgetMode.fixedExpenses
        : AdjustBudgetMode.direct;

    _incomeController = TextEditingController(
      text: widget.family?.monthlyIncome != null
          ? widget.family!.monthlyIncome!.toStringAsFixed(2)
          : '3349.72',
    );
    _directBudgetController = TextEditingController(
      text: widget.currentBudget?.allocatedAmount != null
          ? widget.currentBudget!.allocatedAmount.toStringAsFixed(2)
          : '478.43',
    );
    _fixedExpenses = List.from(widget.family?.fixedExpenses ?? [
      const FixedExpense(id: '1', title: 'Thuê nhà / Tiền nhà', amount: 1000.00, category: 'housing'),
      const FixedExpense(id: '2', title: 'Trả góp xe', amount: 170.00, termMonths: 12, category: 'vehicle'),
      const FixedExpense(id: '3', title: 'Trả nợ ngân hàng', amount: 166.00, termMonths: 24, category: 'loan'),
      const FixedExpense(id: '4', title: 'Điện, nước, Internet', amount: 100.00, category: 'utility'),
    ]);
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _directBudgetController.dispose();
    _incomeFocusNode.dispose();
    _directBudgetFocusNode.dispose();
    super.dispose();
  }

  void _scrollToAndFocus(FocusNode focusNode) {
    focusNode.requestFocus();
    if (focusNode.context != null) {
      Scrollable.ensureVisible(
        focusNode.context!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.2,
      );
    }
  }

  void _changeCurrency(String newCurrency, CurrencyService currencySvc) {
    if (newCurrency == _selectedCurrency) return;
    final oldCurrency = _selectedCurrency;

    // 1. Quy đổi Thu Nhập
    final currentIncome = _totalIncome;
    if (currentIncome > 0) {
      final convertedIncome = currencySvc.convert(currentIncome, oldCurrency, newCurrency);
      _incomeController.text = (newCurrency == 'VND' || newCurrency == 'JPY' || newCurrency == 'KRW')
          ? convertedIncome.round().toString()
          : convertedIncome.toStringAsFixed(2);
    }

    // 2. Quy đổi Ngân Sách Trực Tiếp
    final cleanDirectStr = _directBudgetController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final currentDirect = double.tryParse(cleanDirectStr) ?? 0;
    if (currentDirect > 0) {
      final convertedDirect = currencySvc.convert(currentDirect, oldCurrency, newCurrency);
      _directBudgetController.text = (newCurrency == 'VND' || newCurrency == 'JPY' || newCurrency == 'KRW')
          ? convertedDirect.round().toString()
          : convertedDirect.toStringAsFixed(2);
    }

    // 3. Quy đổi Chi Phí Cố Định
    final List<FixedExpense> updatedExpenses = [];
    for (final exp in _fixedExpenses) {
      final convertedAmount = currencySvc.convert(exp.amount, oldCurrency, newCurrency);
      updatedExpenses.add(exp.copyWith(amount: convertedAmount));
    }

    setState(() {
      _selectedCurrency = newCurrency;
      _fixedExpenses.clear();
      _fixedExpenses.addAll(updatedExpenses);
    });
  }

  double get _totalIncome {
    final cleanStr = _incomeController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleanStr) ?? 0.0;
  }

  double get _totalFixedExpenses {
    return _fixedExpenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  double get _calculatedMonthlyFoodBudget {
    final remaining = _totalIncome - _totalFixedExpenses;
    return remaining > 0 ? remaining : 0.0;
  }

  double get _calculatedWeeklyFoodBudget {
    return _calculatedMonthlyFoodBudget / 4;
  }

  int get _finalWeeklyBudgetInt {
    if (_selectedMode == AdjustBudgetMode.fixedExpenses) {
      return _calculatedWeeklyFoodBudget.round();
    } else {
      final cleanStr = _directBudgetController.text.replaceAll(RegExp(r'[^0-9.]'), '');
      return (double.tryParse(cleanStr) ?? 1500000).round();
    }
  }

  void _addExpenseDialog() {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final termCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Thêm Khoản Chi Cố Định'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: titleCtrl,
                labelText: 'Tên khoản chi',
                hintText: 'Ví dụ: Học phí, Bảo hiểm...',
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: amountCtrl,
                labelText: 'Số tiền hàng tháng ($_selectedCurrency)',
                keyboardType: TextInputType.text,
                enableMathEvaluation: true,
                hintText: 'VD: 1000000 hoặc 37.5*4*15',
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: termCtrl,
                labelText: 'Thời hạn trả (tháng - tùy chọn)',
                keyboardType: TextInputType.number,
                hintText: 'Để trống nếu cố định lâu dài',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleCtrl.text.trim();
              final amountStr = amountCtrl.text.replaceAll(RegExp(r'[^0-9.]'), '');
              final amount = double.tryParse(amountStr) ?? 0;
              final term = int.tryParse(termCtrl.text.trim());

              if (title.isNotEmpty && amount > 0) {
                setState(() {
                  _fixedExpenses.add(FixedExpense(
                    id: const Uuid().v4(),
                    title: title,
                    amount: amount,
                    termMonths: term,
                  ));
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

  void _editExpenseDialog(FixedExpense expense, int index) {
    final titleCtrl = TextEditingController(text: expense.title);
    final amountCtrl = TextEditingController(
      text: (_selectedCurrency == 'VND' || _selectedCurrency == 'JPY' || _selectedCurrency == 'KRW')
          ? expense.amount.round().toString()
          : expense.amount.toStringAsFixed(2),
    );
    final termCtrl = TextEditingController(text: expense.termMonths?.toString() ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Chỉnh Sửa Khoản Chi Cố Định'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: titleCtrl,
                labelText: 'Tên khoản chi',
                hintText: 'Ví dụ: Học phí, Bảo hiểm...',
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: amountCtrl,
                labelText: 'Số tiền hàng tháng ($_selectedCurrency)',
                keyboardType: TextInputType.text,
                enableMathEvaluation: true,
                hintText: 'VD: 1000000 hoặc 37.5*4*15',
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: termCtrl,
                labelText: 'Thời hạn trả (tháng - tùy chọn)',
                keyboardType: TextInputType.number,
                hintText: 'Để trống nếu cố định lâu dài',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleCtrl.text.trim();
              final amountStr = amountCtrl.text.replaceAll(RegExp(r'[^0-9.]'), '');
              final amount = double.tryParse(amountStr) ?? 0;
              final term = int.tryParse(termCtrl.text.trim());

              if (title.isNotEmpty && amount > 0) {
                setState(() {
                  _fixedExpenses[index] = expense.copyWith(
                    title: title,
                    amount: amount,
                    termMonths: term,
                  );
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (_selectedMode == AdjustBudgetMode.fixedExpenses) {
      if (_incomeController.text.trim().isEmpty || _totalIncome <= 0) {
        _scrollToAndFocus(_incomeFocusNode);
        _formKey.currentState?.validate();
        return;
      }
    } else {
      final cleanDirect = _directBudgetController.text.replaceAll(RegExp(r'[^0-9.]'), '');
      if (cleanDirect.isEmpty || (double.tryParse(cleanDirect) ?? 0) <= 0) {
        _scrollToAndFocus(_directBudgetFocusNode);
        _formKey.currentState?.validate();
        return;
      }
    }

    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final user = ref.read(firebaseAuthServiceProvider).currentUser;
      final firestore = ref.read(firestoreServiceProvider);

      if (user == null || widget.family == null) {
        throw Exception('Chưa xác định nhóm gia đình');
      }

      final familyId = widget.family!.id;
      final newWeeklyBudget = _finalWeeklyBudgetInt;

      // 1. Cập nhật Family Info (currency, income, fixed expenses)
      await firestore.createFamilyGroup(
        widget.family!.name,
        user.uid,
        currency: _selectedCurrency,
        monthlyIncome: _selectedMode == AdjustBudgetMode.fixedExpenses ? _totalIncome : null,
        fixedExpenses: _selectedMode == AdjustBudgetMode.fixedExpenses ? _fixedExpenses : const [],
      );

      // 2. Cập nhật BudgetPeriod hiện tại
      if (widget.currentBudget != null) {
        final updatedBudget = widget.currentBudget!.copyWith(
          allocatedAmount: newWeeklyBudget,
        );
        await firestore.setBudget(familyId, updatedBudget);
      } else {
        final now = DateTime.now();
        final monday = now.subtract(Duration(days: now.weekday - 1));
        final startOfWeek = DateTime(monday.year, monday.month, monday.day);
        final endOfWeek = startOfWeek.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

        final newBudget = BudgetPeriod(
          id: const Uuid().v4(),
          familyId: familyId,
          startDate: startOfWeek,
          endDate: endOfWeek,
          allocatedAmount: newWeeklyBudget,
          spentAmount: 0,
        );
        await firestore.setBudget(familyId, newBudget);
      }

      // làm mới state trên app
      ref.invalidate(budgetStateProvider);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã cập nhật ngân sách & kế hoạch tài chính thành công!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi cập nhật ngân sách: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currencySvc = ref.watch(currencyServiceProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
      ),
      padding: EdgeInsets.only(
        top: AppSpacing.md,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Indicator
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.tune_rounded, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Điều Chỉnh Ngân Sách',
                            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: AppSpacing.sm),

              // Currency Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Đơn vị tiền tệ:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.bgCardDark : AppColors.bgLight,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCurrency,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
                        onChanged: (val) {
                          if (val != null) {
                            _changeCurrency(val, currencySvc);
                          }
                        },
                        items: CurrencyService.supportedCurrencies.map((curr) {
                          return DropdownMenuItem<String>(
                            value: curr.code,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(curr.flag, style: const TextStyle(fontSize: 16)),
                                const SizedBox(width: 6),
                                Text('${curr.code} (${curr.symbol})', style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Mode Selection
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Thu Chi Cố Định', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      selected: _selectedMode == AdjustBudgetMode.fixedExpenses,
                      selectedColor: AppColors.primary.withOpacity(0.2),
                      onSelected: (selected) {
                        if (selected) setState(() => _selectedMode = AdjustBudgetMode.fixedExpenses);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Nhập Trực Tiếp', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      selected: _selectedMode == AdjustBudgetMode.direct,
                      selectedColor: AppColors.primary.withOpacity(0.2),
                      onSelected: (selected) {
                        if (selected) setState(() => _selectedMode = AdjustBudgetMode.direct);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              if (_selectedMode == AdjustBudgetMode.fixedExpenses) ...[
                AppTextField(
                  controller: _incomeController,
                  focusNode: _incomeFocusNode,
                  labelText: 'Tổng thu nhập hàng tháng ($_selectedCurrency)',
                  keyboardType: TextInputType.text,
                  enableMathEvaluation: true,
                  hintText: 'VD: 20000000 hoặc 37.5*4*15',
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Vui lòng nhập thu nhập hàng tháng';
                    }
                    final num = double.tryParse(val.replaceAll(RegExp(r'[^0-9.]'), ''));
                    if (num == null || num <= 0) {
                      return 'Thu nhập không hợp lệ';
                    }
                    return null;
                  },
                  prefixIcon: Container(
                    width: 40,
                    alignment: Alignment.center,
                    child: Text(
                      currencySvc.getSymbol(_selectedCurrency),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: AppSpacing.md),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Các khoản chi cố định:', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextButton.icon(
                      onPressed: _addExpenseDialog,
                      icon: const Icon(Icons.add_circle_outline, size: 16),
                      label: const Text('Thêm khoản'),
                    ),
                  ],
                ),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _fixedExpenses.length,
                  itemBuilder: (ctx, idx) {
                    final exp = _fixedExpenses[idx];
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(exp.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: exp.termMonths != null ? Text('Thời hạn: ${exp.termMonths} tháng') : null,
                      onTap: () => _editExpenseDialog(exp, idx),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(currencySvc.format(exp.amount, _selectedCurrency), style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
                            tooltip: 'Chỉnh sửa khoản chi',
                            onPressed: () => _editExpenseDialog(exp, idx),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18, color: Colors.grey),
                            tooltip: 'Xóa khoản chi',
                            onPressed: () => setState(() => _fixedExpenses.removeAt(idx)),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Ngân sách ăn uống tháng còn lại:'),
                          Text(currencySvc.format(_calculatedMonthlyFoodBudget, _selectedCurrency), style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('👉 Ngân sách ăn uống tuần:'),
                          Text(currencySvc.format(_calculatedWeeklyFoodBudget, _selectedCurrency), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],

              if (_selectedMode == AdjustBudgetMode.direct) ...[
                AppTextField(
                  controller: _directBudgetController,
                  focusNode: _directBudgetFocusNode,
                  labelText: 'Ngân sách ăn uống tuần ($_selectedCurrency)',
                  hintText: 'VD: 1500000 hoặc 500*3',
                  keyboardType: TextInputType.text,
                  enableMathEvaluation: true,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Vui lòng nhập ngân sách tuần';
                    }
                    final num = double.tryParse(val.replaceAll(RegExp(r'[^0-9.]'), ''));
                    if (num == null || num <= 0) {
                      return 'Ngân sách không hợp lệ';
                    }
                    return null;
                  },
                  prefixIcon: Container(
                    width: 40,
                    alignment: Alignment.center,
                    child: Text(
                      currencySvc.getSymbol(_selectedCurrency),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: AppSpacing.lg),

              AppButton(
                text: 'Cập Nhật Ngân Sách (${currencySvc.format(_finalWeeklyBudgetInt, _selectedCurrency)}/tuần)',
                isLoading: _isLoading,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
