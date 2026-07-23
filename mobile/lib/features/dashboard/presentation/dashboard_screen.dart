import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/persistent_financial_header.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../budget/presentation/budget_provider.dart';
import '../../family/presentation/family_members_sheet.dart';
import '../../meal_plan/presentation/meal_plan_screen.dart';
import '../../pantry/presentation/pantry_screen.dart';
import '../../recipe/presentation/recipe_library_screen.dart';
import '../../shopping/presentation/shopping_list_screen.dart';
import '../../../core/services/firebase_auth_service.dart';
import '../../../core/services/firestore_service.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      DashboardContent(
        onSelectTab: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      MealPlanScreen(
        onSelectTab: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      const ShoppingListScreen(),
      PantryScreen(
        onSelectTab: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      const SettingsContent(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: tabs,
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
  final void Function(int tabIndex)? onSelectTab;

  const DashboardContent({super.key, this.onSelectTab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('FMBP - MealSave'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book_rounded),
            tooltip: 'Thư viện món ăn',
            onPressed: () {
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
          padding: const EdgeInsets.only(bottom: AppSpacing.xl),
          children: [
            const PersistentFinancialHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text(
                'Xin chào gia đình!',
                style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Quy Trình 3 Bước Nội Trợ
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quy Trình Nội Trợ 3 Bước',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Quản lý bữa ăn & ngân sách thông minh mỗi tuần',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Danh sách 3 Bước
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                children: [
                  // Bước 1: Kiểm Tra Tủ Lạnh
                  _buildStepCard(
                    context,
                    stepNumber: '1',
                    icon: Icons.kitchen_outlined,
                    iconColor: Colors.blue,
                    title: 'Xem & Kiểm tra tủ lạnh',
                    subtitle: 'Rà soát đồ sẵn có & cảnh báo món sắp hết hạn',
                    onTap: () {
                      if (onSelectTab != null) onSelectTab!(3); // Tab 3: Tủ lạnh
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Bước 2: Lên Thực Đơn
                  _buildStepCard(
                    context,
                    stepNumber: '2',
                    icon: Icons.restaurant_menu_outlined,
                    iconColor: Colors.orange,
                    title: 'Lên thực đơn tuần mới',
                    subtitle: 'Chọn món ruột & nhờ AI gợi ý thực đơn chuẩn vị',
                    onTap: () {
                      if (onSelectTab != null) onSelectTab!(1); // Tab 1: Thực đơn
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Bước 3: Đi Chợ & Quản Lý Ví
                  _buildStepCard(
                    context,
                    stepNumber: '3',
                    icon: Icons.shopping_cart_outlined,
                    iconColor: AppColors.primary,
                    title: 'Tạo danh sách & Đi chợ',
                    subtitle: 'Tự động gộp nguyên liệu & trừ lùi ngân sách trực tiếp',
                    onTap: () {
                      if (onSelectTab != null) onSelectTab!(2); // Tab 2: Đi chợ
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Banner Thư Viện Món
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RecipeLibraryScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.cookie_outlined, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Thư viện món ngon & Công thức',
                              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Khám phá các món ăn ruột & gợi ý thực đơn Fusion',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.primary),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard(
    BuildContext context, {
    required String stepNumber,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          // Step badge
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Text(
              stepNumber,
              style: TextStyle(
                color: iconColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 18, color: iconColor),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),
          const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
        ],
      ),
    );
  }
}

// ----------------- CÀI ĐẶT CONTENT -----------------

class SettingsContent extends ConsumerWidget {
  const SettingsContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài Đặt'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Thông tin tài khoản'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.group_outlined, color: AppColors.primary),
            title: const Text('Nhóm gia đình & Hồ sơ nhân khẩu học'),
            subtitle: const Text('Độ tuổi, giới tính & khẩu vị của các thành viên'),
            onTap: () async {
              final user = ref.read(firebaseAuthServiceProvider).currentUser;
              if (user == null) return;
              final firestore = ref.read(firestoreServiceProvider);
              final userDoc = await firestore.watchUser(user.uid).first;
              var familyId = userDoc?.familyId;
              if (familyId == null || familyId.isEmpty) {
                familyId = await firestore.createFamilyGroup('Gia Đình Tôi', user.uid);
              }
              if (context.mounted) {
                FamilyMembersSheet.show(context, familyId);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Thông báo'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text('Đăng xuất', style: TextStyle(color: AppColors.error)),
            onTap: () async {
              await ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
    );
  }
}
