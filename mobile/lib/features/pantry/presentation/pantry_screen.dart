import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fmbp_models/fmbp_models.dart';
import 'package:uuid/uuid.dart';
import '../../../app/theme.dart';
import '../../../core/services/firebase_auth_service.dart';
import '../../../core/services/firestore_service.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/persistent_financial_header.dart';
import '../../meal_plan/presentation/meal_plan_screen.dart';
import 'pantry_provider.dart';

class PantryScreen extends ConsumerStatefulWidget {
  final void Function(int tabIndex)? onSelectTab;

  const PantryScreen({super.key, this.onSelectTab});

  @override
  ConsumerState<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends ConsumerState<PantryScreen> {
  String _selectedFilter = 'ALL'; // ALL, FRIDGE, FREEZER, PANTRY

  void _navigateToMealPlan() {
    if (widget.onSelectTab != null) {
      widget.onSelectTab!(1); // Switch to Tab 1 (Thực đơn)
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MealPlanScreen()),
      );
    }
  }

  /// Helper chuẩn hóa đơn vị hiển thị thông minh (0.5 kg -> 500 g, 1500 g -> 1.5 kg)
  String _formatPantryQuantity(double quantity, String unit) {
    final u = unit.toLowerCase();
    if (u == 'kg' && quantity < 1.0) {
      final grams = (quantity * 1000).round();
      return '$grams g';
    }
    if (u == 'g' && quantity >= 1000) {
      final kg = quantity / 1000;
      return '${kg.toStringAsFixed(kg.truncateToDouble() == kg ? 0 : 1)} kg';
    }
    if (u == 'l' && quantity < 1.0) {
      final ml = (quantity * 1000).round();
      return '$ml ml';
    }
    if (u == 'ml' && quantity >= 1000) {
      final l = quantity / 1000;
      return '${l.toStringAsFixed(l.truncateToDouble() == l ? 0 : 1)} l';
    }

    if (quantity.truncateToDouble() == quantity) {
      return '${quantity.toInt()} $unit';
    }
    return '${quantity.toStringAsFixed(1)} $unit';
  }

  void _addPantryItemDialog() {
    final nameCtrl = TextEditingController();
    final quantityCtrl = TextEditingController(text: '1');
    final nameFocus = FocusNode();
    final quantityFocus = FocusNode();

    String selectedUnit = 'kg';
    String selectedLocation = (_selectedFilter != 'ALL') ? _selectedFilter : 'FRIDGE';

    final List<String> units = ['kg', 'g', 'quả', 'bắp', 'củ', 'hộp', 'bịch', 'gói', 'chai', 'l', 'ml', 'lon'];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Thêm Nguyên Liệu Vào Tủ Lạnh'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  controller: nameCtrl,
                  focusNode: nameFocus,
                  labelText: 'Tên nguyên liệu / thực phẩm',
                  hintText: 'VD: Cá hồi tươi, Bắp cải, Trứng gà...',
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: AppTextField(
                        controller: quantityCtrl,
                        focusNode: quantityFocus,
                        labelText: 'Số lượng',
                        keyboardType: TextInputType.text,
                        enableMathEvaluation: true,
                        hintText: '1.5 hoặc 500*2',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Đơn vị', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.borderLight),
                              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedUnit,
                                isExpanded: true,
                                items: units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                                onChanged: (val) {
                                  if (val != null) setDialogState(() => selectedUnit = val);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                const Text('Vị trí lưu trữ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildLocationOption(
                        label: '❄️ Tủ mát',
                        locationKey: 'FRIDGE',
                        currentLocation: selectedLocation,
                        onSelect: (loc) => setDialogState(() => selectedLocation = loc),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _buildLocationOption(
                        label: '🧊 Tủ đông',
                        locationKey: 'FREEZER',
                        currentLocation: selectedLocation,
                        onSelect: (loc) => setDialogState(() => selectedLocation = loc),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _buildLocationOption(
                        label: '🧺 Tủ khô',
                        locationKey: 'PANTRY',
                        currentLocation: selectedLocation,
                        onSelect: (loc) => setDialogState(() => selectedLocation = loc),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                nameFocus.dispose();
                quantityFocus.dispose();
                Navigator.pop(ctx);
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameCtrl.text.trim();
                final quantityStr = quantityCtrl.text.replaceAll(RegExp(r'[^0-9.]'), '');
                final quantity = double.tryParse(quantityStr) ?? 0;

                if (name.isEmpty) {
                  nameFocus.requestFocus();
                  return;
                }
                if (quantity <= 0) {
                  quantityFocus.requestFocus();
                  return;
                }

                final user = ref.read(firebaseAuthServiceProvider).currentUser;
                final firestore = ref.read(firestoreServiceProvider);
                if (user == null) return;

                final userDoc = await firestore.watchUser(user.uid).first;
                final familyId = userDoc?.familyId;
                if (familyId == null) return;

                final newItem = PantryItem(
                  id: const Uuid().v4(),
                  familyId: familyId,
                  ingredientId: name,
                  quantity: quantity,
                  unit: selectedUnit,
                  storageLocation: selectedLocation,
                );

                await firestore.updatePantryItem(familyId, newItem);

                nameFocus.dispose();
                quantityFocus.dispose();
                if (mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã thêm "$name" vào tủ !'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              },
              child: const Text('Thêm Mới'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationOption({
    required String label,
    required String locationKey,
    required String currentLocation,
    required ValueChanged<String> onSelect,
  }) {
    final isSelected = currentLocation == locationKey;
    return InkWell(
      onTap: () => onSelect(locationKey),
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTab(String label, String filterKey) {
    final isSelected = _selectedFilter == filterKey;
    return ChoiceChip(
      showCheckmark: false,
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.white : AppColors.primary,
        ),
      ),
      selected: isSelected,
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.primary.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.primary.withOpacity(0.2),
        ),
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedFilter = filterKey;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pantryState = ref.watch(pantryStateProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kho Tủ Lạnh Gia Đình'),
        actions: [
          TextButton.icon(
            onPressed: _navigateToMealPlan,
            icon: const Icon(Icons.restaurant_menu_rounded, size: 18, color: AppColors.primary),
            label: const Text('Lên Món', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            tooltip: 'Thêm nguyên liệu mới',
            onPressed: _addPantryItemDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          const PersistentFinancialHeader(),

          // Thanh phân loại 3 Ngăn Tủ (Tất cả, Tủ mát, Tủ đông, Tủ khô)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterTab('Tất Cả', 'ALL'),
                  const SizedBox(width: 8),
                  _buildFilterTab('❄️ Tủ Mát', 'FRIDGE'),
                  const SizedBox(width: 8),
                  _buildFilterTab('🧊 Tủ Đông', 'FREEZER'),
                  const SizedBox(width: 8),
                  _buildFilterTab('🧺 Tủ Khô', 'PANTRY'),
                ],
              ),
            ),
          ),

          Expanded(
            child: pantryState.when(
              data: (items) {
                final filteredItems = items.where((item) {
                  if (_selectedFilter == 'ALL') return true;
                  return item.storageLocation == _selectedFilter;
                }).toList();

                if (filteredItems.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.kitchen_outlined,
                            size: 56,
                            color: theme.disabledColor,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            items.isEmpty
                                ? 'Tủ lạnh của bạn đang trống'
                                : 'Không có nguyên liệu ở ngăn này',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Nhấn nút bên dưới để thêm thực phẩm hoặc bấm "Lên Món" để AI gợi ý!',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.disabledColor,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: _addPantryItemDialog,
                                icon: const Icon(Icons.add),
                                label: const Text('Thêm Đồ Vào Tủ'),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                onPressed: _navigateToMealPlan,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                ),
                                icon: const Icon(Icons.restaurant_menu_rounded),
                                label: const Text('Lên Món Ngay'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(
                    left: AppSpacing.md,
                    right: AppSpacing.md,
                    top: AppSpacing.md,
                    bottom: 80,
                  ),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];

                    IconData locIcon = Icons.kitchen_outlined;
                    String locText = 'Tủ mát';
                    Color locColor = AppColors.primary;

                    if (item.storageLocation == 'FREEZER') {
                      locIcon = Icons.ac_unit_rounded;
                      locText = 'Tủ đông';
                      locColor = Colors.blue;
                    } else if (item.storageLocation == 'PANTRY') {
                      locIcon = Icons.inventory_2_outlined;
                      locText = 'Tủ đồ khô';
                      locColor = Colors.orange;
                    }

                    final formattedQtyStr = _formatPantryQuantity(item.quantity, item.unit);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: AppCard(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.sm),
                              decoration: BoxDecoration(
                                color: locColor.withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                locIcon,
                                color: locColor,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.ingredientId,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: locColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          locText,
                                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: locColor),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Còn: $formattedQtyStr',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Trừ bớt số lượng
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, size: 20, color: Colors.orange),
                              tooltip: 'Dùng bớt 1 đơn vị',
                              onPressed: () async {
                                if (item.quantity > 1) {
                                  await ref.read(pantryStateProvider.notifier).updateItemQuantity(item, item.quantity - 1);
                                } else {
                                  final firestore = ref.read(firestoreServiceProvider);
                                  await firestore.deletePantryItem(item.familyId, item.id);
                                }
                              },
                            ),

                            // Thêm số lượng
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline, size: 20, color: AppColors.primary),
                              tooltip: 'Thêm 1 đơn vị',
                              onPressed: () async {
                                await ref.read(pantryStateProvider.notifier).updateItemQuantity(item, item.quantity + 1);
                              },
                            ),

                            // Xóa hẳn món
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                              tooltip: 'Xóa khỏi tủ',
                              onPressed: () async {
                                final firestore = ref.read(firestoreServiceProvider);
                                await firestore.deletePantryItem(item.familyId, item.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, st) => Center(
                child: Text('Lỗi tải dữ liệu tủ lạnh: $err'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: FloatingActionButton.extended(
                heroTag: 'cook_now_fab',
                onPressed: _navigateToMealPlan,
                icon: const Icon(Icons.restaurant_menu_rounded),
                label: const Text('🍲 Nấu Món Gì Đây?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: FloatingActionButton.extended(
                heroTag: 'add_pantry_fab',
                onPressed: _addPantryItemDialog,
                icon: const Icon(Icons.add),
                label: const Text('Thêm Đồ Vào Tủ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
