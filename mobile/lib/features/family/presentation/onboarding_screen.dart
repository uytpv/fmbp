import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_text_field.dart';
import 'onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _familyNameController = TextEditingController();
  final _budgetController = TextEditingController(text: '1500000');

  @override
  void dispose() {
    _familyNameController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _familyNameController.text.trim();
    final budgetStr = _budgetController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final budget = int.tryParse(budgetStr) ?? 1500000;

    await ref.read(onboardingStateProvider.notifier).setupFamilyAndBudget(
          familyName: name,
          weeklyBudgetAmount: budget,
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
                    // Brand Icon
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.family_restroom_rounded,
                          size: 64,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    Text(
                      'Chào Mừng Đến Với FMBP',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),

                    Text(
                      'Hãy thiết lập nhóm gia đình và hạn mức ngân sách tuần đầu tiên để bắt đầu hành trình của bạn.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    AppCard(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Khởi Tạo Gia Đình',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),

                          // Family Name
                          AppTextField(
                            controller: _familyNameController,
                            labelText: 'Tên nhóm gia đình',
                            hintText: 'Ví dụ: Gia đình Bình An, Nhà của Uy...',
                            prefixIcon: const Icon(Icons.home_outlined, size: 20),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Vui lòng nhập tên gia đình';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Weekly Food Budget
                          AppTextField(
                            controller: _budgetController,
                            labelText: 'Ngân sách ăn uống tuần (VNĐ)',
                            hintText: '1500000',
                            keyboardType: TextInputType.number,
                            prefixIcon: const Icon(Icons.account_balance_wallet_outlined, size: 20),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Vui lòng nhập ngân sách tuần';
                              }
                              final num = int.tryParse(val);
                              if (num == null || num <= 0) {
                                return 'Ngân sách không hợp lệ';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.lg),

                          // Setup Button
                          AppButton(
                            text: 'Hoàn Tất Thiết Lập',
                            isLoading: state.isLoading,
                            onPressed: _submit,
                          ),
                        ],
                      ),
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
