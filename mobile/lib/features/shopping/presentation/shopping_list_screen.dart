import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import 'shopping_provider.dart';

class ShoppingListScreen extends ConsumerStatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ConsumerState<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends ConsumerState<ShoppingListScreen> {
  var _isGenerating = false;
  var _isCompleting = false;

  // Mock items list for display in MVP Shopping List
  final List<Map<String, dynamic>> _mockItems = [
    {'name': 'Thịt ba chỉ', 'qty': '1.5 kg', 'aisle': 'Thịt & Hải sản', 'checked': false},
    {'name': 'Cá lóc', 'qty': '1 con', 'aisle': 'Thịt & Hải sản', 'checked': false},
    {'name': 'Rau muống', 'qty': '2 bó', 'aisle': 'Rau củ quả', 'checked': false},
    {'name': 'Trứng gà', 'qty': '10 quả', 'aisle': 'Trứng & Sữa', 'checked': false},
    {'name': 'Nước mắm', 'qty': '1 chai', 'aisle': 'Gia vị & Đồ khô', 'checked': false},
  ];

  Future<void> _generateList() async {
    setState(() => _isGenerating = true);
    try {
      await ref.read(shoppingStateProvider.notifier).generateShoppingList();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã tạo danh sách đi chợ từ thực đơn tuần!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi tạo danh sách đi chợ: $e'),
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

  Future<void> _completeList() async {
    setState(() => _isCompleting = true);
    try {
      await ref.read(shoppingStateProvider.notifier).completeShopping();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã hoàn thành đi chợ! Các nguyên liệu đã được nhập kho tủ lạnh.'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi hoàn thành đi chợ: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCompleting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final shoppingListState = ref.watch(shoppingStateProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh Sách Đi Chợ'),
      ),
      body: shoppingListState.when(
        data: (list) {
          if (list == null) {
            // Empty State
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_basket_outlined,
                      size: 64,
                      color: theme.disabledColor,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Không có danh sách đi chợ hoạt động',
                      style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tạo danh sách đi chợ tự động dựa trên thực đơn tuần hoạt động của gia đình bạn.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.brightness == Brightness.dark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AppButton(
                      text: 'Tạo Danh Sách Đi Chợ',
                      isLoading: _isGenerating,
                      onPressed: _generateList,
                    ),
                  ],
                ),
              ),
            );
          }

          // Active Shopping List UI
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: [
                    // Info Header Card
                    AppCard(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: AppColors.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Đồng bộ thời gian thực: Các thành viên khác có thể thấy những gì bạn nhặt vào giỏ.',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    Text(
                      'Các mặt hàng cần mua',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Display mock items list
                    ..._mockItems.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: AppCard(
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              item['name'],
                              style: TextStyle(
                                decoration: item['checked'] ? TextDecoration.lineThrough : null,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text('Quầy: ${item['aisle']}'),
                            secondary: Text(
                              item['qty'],
                              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                            ),
                            value: item['checked'],
                            onChanged: (val) {
                              setState(() {
                                item['checked'] = val ?? false;
                              });
                            },
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              // Bottom Button Container
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: AppButton(
                  text: 'Hoàn Thành Đi Chợ',
                  isLoading: _isCompleting,
                  onPressed: _completeList,
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Lỗi tải danh sách đi chợ: $err')),
      ),
    );
  }
}
