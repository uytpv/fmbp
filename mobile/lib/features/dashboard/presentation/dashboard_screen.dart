import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../core/services/firebase_auth_service.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../budget/presentation/budget_provider.dart';
import '../../budget/presentation/budget_tracking_screen.dart';
import '../../meal_plan/presentation/meal_plan_screen.dart';
import '../../pantry/presentation/pantry_screen.dart';
import '../../shopping/presentation/shopping_list_screen.dart';
import '../../recipe/presentation/recipe_library_screen.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const DashboardContent(),
    const MealPlanScreen(),
    const ShoppingListScreen(),
    const PantryScreen(),
    const SettingsContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Tổng quan',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu),
            label: 'Thực đơn',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Đi chợ',
          ),
          NavigationDestination(
            icon: Icon(Icons.kitchen_outlined),
            selectedIcon: Icon(Icons.kitchen),
            label: 'Tủ lạnh',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Cài đặt',
          ),
        ],
      ),
    );
  }
}

// ----------------- TỔNG QUAN CONTENT -----------------

class DashboardContent extends ConsumerWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final budgetState = ref.watch(budgetStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FMBP'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book_rounded),
            onPressed: () {
              // Đi tới thư viện công thức món ăn
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RecipeLibraryScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(budgetStateProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            // Hello Card
            Text(
              'Xin chào gia đình!',
              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Budget summary card
            budgetState.when(
              data: (budget) {
                if (budget == null) return const SizedBox();
                final remaining = budget.allocatedAmount - budget.spentAmount;
                final percent = remaining / budget.allocatedAmount;

                return InkWell(
                  onTap: () {
                    // Navigate to budget tracking details
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BudgetTrackingScreen()),
                    );
                  },
                  child: Card(
                    color: AppColors.primary.withOpacity(0.05),
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ngân sách tuần còn lại',
                                style: theme.textTheme.bodyMedium?.copyWith(color: theme.disabledColor),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(remaining)}',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: percent > 0.2 ? AppColors.primary : AppColors.error,
                                ),
                              ),
                            ],
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                        ],
                      ),
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, st) => const SizedBox(),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Quick actions
            Text(
              'Phím tắt nhanh',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    context,
                    Icons.add_shopping_cart,
                    'Tạo danh sách',
                    'Đi chợ tuần mới',
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _buildQuickActionCard(
                    context,
                    Icons.cookie_outlined,
                    'Thư viện món',
                    'Công thức chuẩn vị',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(BuildContext context, IconData icon, String title, String subtitle) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.disabledColor),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------- CÀI ĐẶT CONTENT -----------------

class SettingsContent extends ConsumerWidget {
  const SettingsContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // User Card
          AppCard(
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, color: Colors.white, size: 30),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ref.read(firebaseAuthServiceProvider).currentUser?.email ?? 'User Email',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text('Thành viên nhóm gia đình'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Logout Button
          AppButton(
            text: 'Đăng xuất',
            isLoading: authState.isLoading,
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
    );
  }
}
