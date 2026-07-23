import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fmbp_models/fmbp_models.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../app/theme.dart';
import '../../../core/services/currency_service.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_text_field.dart';
import 'onboarding_provider.dart';

enum BudgetMode {
  fixedExpenses, // Tính từ Thu nhập - Chi phí cố định
  direct,        // Nhập trực tiếp ngân sách ăn uống
}

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _familyNameController = TextEditingController();
  final _incomeController = TextEditingController(text: '3349.72');
  final _directBudgetController = TextEditingController(text: '478.43');

  final _familyNameFocusNode = FocusNode();
  final _incomeFocusNode = FocusNode();
  final _directBudgetFocusNode = FocusNode();

  BudgetMode _selectedMode = BudgetMode.fixedExpenses;
  String _selectedCurrency = 'EUR';

  // Danh sách các khoản chi cố định
  final List<FixedExpense> _fixedExpenses = [
    const FixedExpense(id: '1', title: 'Thuê nhà / Tiền nhà', amount: 1000.00, category: 'housing'),
    const FixedExpense(id: '2', title: 'Trả góp xe', amount: 170.00, termMonths: 12, category: 'vehicle'),
    const FixedExpense(id: '3', title: 'Trả nợ ngân hàng', amount: 166.00, termMonths: 24, category: 'loan'),
    const FixedExpense(id: '4', title: 'Điện, nước, Internet', amount: 100.00, category: 'utility'),
  ];

  @override
  void dispose() {
    _familyNameController.dispose();
    _incomeController.dispose();
    _directBudgetController.dispose();
    _familyNameFocusNode.dispose();
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

    // 3. Quy đổi Danh Sách Chi Phí Cố Định
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
    if (_selectedMode == BudgetMode.fixedExpenses) {
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
    final titleFocus = FocusNode();
    final amountFocus = FocusNode();

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
                focusNode: titleFocus,
                labelText: 'Tên khoản chi',
                hintText: 'Ví dụ: Học phí, Bảo hiểm...',
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: amountCtrl,
                focusNode: amountFocus,
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
            onPressed: () {
              titleFocus.dispose();
              amountFocus.dispose();
              Navigator.pop(ctx);
            },
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleCtrl.text.trim();
              final amountStr = amountCtrl.text.replaceAll(RegExp(r'[^0-9.]'), '');
              final amount = double.tryParse(amountStr) ?? 0;
              final term = int.tryParse(termCtrl.text.trim());

              if (title.isEmpty) {
                titleFocus.requestFocus();
                return;
              }
              if (amount <= 0) {
                amountFocus.requestFocus();
                return;
              }

              setState(() {
                _fixedExpenses.add(FixedExpense(
                  id: const Uuid().v4(),
                  title: title,
                  amount: amount,
                  termMonths: term,
                ));
              });
              titleFocus.dispose();
              amountFocus.dispose();
              Navigator.pop(ctx);
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
    final titleFocus = FocusNode();
    final amountFocus = FocusNode();

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
                focusNode: titleFocus,
                labelText: 'Tên khoản chi',
                hintText: 'Ví dụ: Học phí, Bảo hiểm...',
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: amountCtrl,
                focusNode: amountFocus,
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
            onPressed: () {
              titleFocus.dispose();
              amountFocus.dispose();
              Navigator.pop(ctx);
            },
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleCtrl.text.trim();
              final amountStr = amountCtrl.text.replaceAll(RegExp(r'[^0-9.]'), '');
              final amount = double.tryParse(amountStr) ?? 0;
              final term = int.tryParse(termCtrl.text.trim());

              if (title.isEmpty) {
                titleFocus.requestFocus();
                return;
              }
              if (amount <= 0) {
                amountFocus.requestFocus();
                return;
              }

              setState(() {
                _fixedExpenses[index] = expense.copyWith(
                  title: title,
                  amount: amount,
                  termMonths: term,
                );
              });
              titleFocus.dispose();
              amountFocus.dispose();
              Navigator.pop(ctx);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    // 1. Kiểm tra Tên nhóm gia đình
    if (_familyNameController.text.trim().isEmpty) {
      _scrollToAndFocus(_familyNameFocusNode);
      _formKey.currentState?.validate();
      return;
    }

    // 2. Kiểm tra thu nhập hoặc ngân sách trực tiếp
    if (_selectedMode == BudgetMode.fixedExpenses) {
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

    final name = _familyNameController.text.trim();
    final weeklyBudget = _finalWeeklyBudgetInt;

    await ref.read(onboardingStateProvider.notifier).setupFamilyAndBudget(
          familyName: name,
          weeklyBudgetAmount: weeklyBudget,
          currency: _selectedCurrency,
          monthlyIncome: _selectedMode == BudgetMode.fixedExpenses ? _totalIncome : null,
          fixedExpenses: _selectedMode == BudgetMode.fixedExpenses ? _fixedExpenses : const [],
        );

    final state = ref.read(onboardingStateProvider);
    if (state.hasError) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Có lỗi xảy ra: ${state.error}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } else {
      if (mounted) {
        context.go('/dashboard');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final state = ref.watch(onboardingStateProvider);
    final currencySvc = ref.watch(currencyServiceProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.darkGradient : null,
          color: isDark ? null : AppColors.bgLight,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Bar: Logo & Currency Selector Combo Box
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.family_restroom_rounded,
                            size: 36,
                            color: AppColors.primary,
                          ),
                        ),
                        // Currency Selector Dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.bgCardDark : Colors.white,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
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
                                      Text(curr.flag, style: const TextStyle(fontSize: 18)),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${curr.code} (${curr.symbol})',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    Text(
                      'Chào Mừng Đến Với MealSave',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),

                    Text(
                      'Lập kế hoạch quản lý bữa ăn & tài chính gia đình thông minh.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Tên Gia Đình
                    AppCard(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: AppTextField(
                        controller: _familyNameController,
                        focusNode: _familyNameFocusNode,
                        labelText: 'Tên nhóm gia đình',
                        hintText: 'Ví dụ: Gia đình Bình An, Bếp Nhà Uy...',
                        prefixIcon: const Icon(Icons.home_outlined, size: 20),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Vui lòng nhập tên gia đình';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Câu hỏi lựa chọn chế độ lập kế hoạch
                    AppCard(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.help_outline_rounded, color: AppColors.primary, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Phương Thức Lập Kế Hoạch Ngân Sách',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Chúng ta cùng lên kế hoạch bằng cách tính từ thu chi cố định hay bạn chỉ cần cung cấp ngân sách cho việc ăn uống?',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Mode Selector Buttons
                          Row(
                            children: [
                              Expanded(
                                child: ChoiceChip(
                                  label: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Column(
                                      children: const [
                                        Icon(Icons.calculate_outlined, size: 22),
                                        SizedBox(height: 4),
                                        Text('Tính từ Thu Chi Cố Định', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  selected: _selectedMode == BudgetMode.fixedExpenses,
                                  selectedColor: AppColors.primary.withOpacity(0.2),
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _selectedMode = BudgetMode.fixedExpenses;
                                      });
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Expanded(
                                child: ChoiceChip(
                                  label: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Column(
                                      children: const [
                                        Icon(Icons.edit_note_rounded, size: 22),
                                        SizedBox(height: 4),
                                        Text('Nhập Ngân Sách Trực Tiếp', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  selected: _selectedMode == BudgetMode.direct,
                                  selectedColor: AppColors.primary.withOpacity(0.2),
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _selectedMode = BudgetMode.direct;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // FORM CHẾ ĐỘ 1: TÍNH TỪ THU CHI CỐ ĐỊNH
                    if (_selectedMode == BudgetMode.fixedExpenses) ...[
                      AppCard(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '1. Tổng Thu Nhập Hàng Tháng',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            AppTextField(
                              controller: _incomeController,
                              focusNode: _incomeFocusNode,
                              labelText: 'Thu nhập hàng tháng ($_selectedCurrency)',
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
                            const SizedBox(height: AppSpacing.lg),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '2. Các Khoản Chi Cố Định',
                                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: _addExpenseDialog,
                                  icon: const Icon(Icons.add_circle_outline, size: 18),
                                  label: const Text('Thêm khoản'),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.xs),

                            // Danh sách khoản chi cố định
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _fixedExpenses.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 8),
                              itemBuilder: (ctx, idx) {
                                final exp = _fixedExpenses[idx];
                                return InkWell(
                                  onTap: () => _editExpenseDialog(exp, idx),
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.bgCardDark : AppColors.bgLight,
                                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                      border: Border.all(color: AppColors.borderLight.withOpacity(0.5)),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          exp.category == 'housing'
                                              ? Icons.home_outlined
                                              : exp.category == 'vehicle'
                                                  ? Icons.directions_car_outlined
                                                  : exp.category == 'loan'
                                                      ? Icons.credit_card_outlined
                                                      : Icons.receipt_long_outlined,
                                          size: 20,
                                          color: AppColors.primary,
                                        ),
                                        const SizedBox(width: AppSpacing.xs),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(exp.title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                                              if (exp.termMonths != null)
                                                Text('Thời hạn: ${exp.termMonths} tháng', style: theme.textTheme.bodySmall?.copyWith(color: theme.disabledColor)),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          currencySvc.format(exp.amount, _selectedCurrency),
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.error,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
                                          tooltip: 'Chỉnh sửa khoản chi',
                                          onPressed: () => _editExpenseDialog(exp, idx),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline, size: 18, color: Colors.grey),
                                          tooltip: 'Xóa khoản chi',
                                          onPressed: () {
                                            setState(() {
                                              _fixedExpenses.removeAt(idx);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // TỰ ĐỘNG TÍNH TOÁN CARD PREVIEW
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Tổng Thu Nhập Tháng:'),
                                Text(currencySvc.format(_totalIncome, _selectedCurrency), style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Tổng Chi Cố Định:'),
                                Text('- ${currencySvc.format(_totalFixedExpenses, _selectedCurrency)}', style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const Divider(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Ngân Sách Ăn Uống Tháng Còn Lại:', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(currencySvc.format(_calculatedMonthlyFoodBudget, _selectedCurrency), style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 16)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('👉 Ngân Sách Ăn Uống Ước Tính Tuần:', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                                Text(
                                  currencySvc.format(_calculatedWeeklyFoodBudget, _selectedCurrency),
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],

                    // FORM CHẾ ĐỘ 2: NHẬP TRỰC TIẾP NGÂN SÁCH
                    if (_selectedMode == BudgetMode.direct) ...[
                      AppCard(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: AppTextField(
                          controller: _directBudgetController,
                          focusNode: _directBudgetFocusNode,
                          labelText: 'Ngân sách ăn uống tuần ($_selectedCurrency)',
                          hintText: 'VD: 1500000 hoặc 500*3',
                          keyboardType: TextInputType.text,
                          enableMathEvaluation: true,
                          prefixIcon: Container(
                            width: 40,
                            alignment: Alignment.center,
                            child: Text(
                              currencySvc.getSymbol(_selectedCurrency),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
                            ),
                          ),
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
                        ),
                      ),
                    ],

                    const SizedBox(height: AppSpacing.lg),

                    // Setup Button
                    AppButton(
                      text: 'Hoàn Tất Thiết Lập (${currencySvc.format(_finalWeeklyBudgetInt, _selectedCurrency)}/tuần)',
                      isLoading: state.isLoading,
                      onPressed: _submit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
