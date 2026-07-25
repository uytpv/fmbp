import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fmbp_models/fmbp_models.dart';
import 'package:uuid/uuid.dart';
import '../../../app/theme.dart';
import '../../../core/services/firebase_auth_service.dart';
import '../../../core/services/firestore_service.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/persistent_financial_header.dart';
import '../../budget/presentation/budget_provider.dart';
import '../../meal_plan/presentation/meal_plan_provider.dart';
import '../../pantry/presentation/pantry_provider.dart';
import 'shopping_provider.dart';

class ShoppingListScreen extends ConsumerStatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ConsumerState<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends ConsumerState<ShoppingListScreen> {
  var _isGenerating = false;
  var _isCompleting = false;
  final Map<String, bool> _checkedStatus = {};
  final Map<String, Map<String, dynamic>> _customItemEdits = {};

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

  void _showEditQuantityDialog(Map<String, dynamic> item) {
    final itemId = item['id'];
    final existingCustom = _customItemEdits[itemId];

    final double initialQty = (existingCustom?['quantity'] as num?)?.toDouble() ?? (item['rawQty'] as num).toDouble();
    final String initialUnit = existingCustom?['unit'] as String? ?? (item['unit'] as String);
    final String initialLoc = existingCustom?['storageLocation'] as String? ?? (item['storageLocation'] as String);
    final double initialPrice = (existingCustom?['price'] as num?)?.toDouble() ?? 5.0;

    final qtyCtrl = TextEditingController(
      text: initialQty.truncateToDouble() == initialQty ? initialQty.toInt().toString() : initialQty.toString(),
    );
    final priceCtrl = TextEditingController(
      text: initialPrice > 0 ? (initialPrice.truncateToDouble() == initialPrice ? initialPrice.toInt().toString() : initialPrice.toString()) : '',
    );
    String selectedUnit = initialUnit;
    String selectedLoc = initialLoc;

    final units = ['kg', 'g', 'quả', 'bó', 'củ', 'hộp', 'bịch', 'gói', 'chai', 'l', 'ml', 'con', 'ổ', 'hũ', 'lát'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setBottomSheetState) => Container(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shopping_cart_checkout_rounded, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Gợi ý thực đơn: ${item['qty']} • Quầy: ${item['aisle']}',
                  style: TextStyle(fontSize: 12, color: Theme.of(context).disabledColor),
                ),
                const SizedBox(height: AppSpacing.md),

                // Qty & Unit Input Row
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: qtyCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Số lượng mua thực tế',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        initialValue: units.contains(selectedUnit) ? selectedUnit : units.first,
                        decoration: const InputDecoration(
                          labelText: 'Đơn vị',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        ),
                        items: units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                        onChanged: (val) {
                          if (val != null) setBottomSheetState(() => selectedUnit = val);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                // Price Input Row (Thu thập giá mua thực tế cho ngân sách & AI dataset)
                TextField(
                  controller: priceCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Giá mua thực tế (Tùy chọn - Dùng cập nhật Ngân sách & AI)',
                    hintText: 'VD: 5.0 (hoặc 50000)',
                    prefixIcon: Icon(Icons.payments_outlined, size: 18),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Smart Compartment Selection
                const Text(
                  'Tự động phân chia ngăn tủ lạnh:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildLocationChoiceChip('❄️ Tủ Mát', 'FRIDGE', selectedLoc, (loc) {
                        setBottomSheetState(() => selectedLoc = loc);
                      }),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _buildLocationChoiceChip('🧊 Tủ Đông', 'FREEZER', selectedLoc, (loc) {
                        setBottomSheetState(() => selectedLoc = loc);
                      }),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _buildLocationChoiceChip('🧺 Tủ Khô', 'PANTRY', selectedLoc, (loc) {
                        setBottomSheetState(() => selectedLoc = loc);
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Hủy'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final newQty = double.tryParse(qtyCtrl.text) ?? initialQty;
                          final newPrice = double.tryParse(priceCtrl.text) ?? initialPrice;
                          setState(() {
                            _checkedStatus[itemId] = true;
                            _customItemEdits[itemId] = {
                              'quantity': newQty,
                              'unit': selectedUnit,
                              'storageLocation': selectedLoc,
                              'price': newPrice,
                              'displayQty': '$newQty $selectedUnit ${newPrice > 0 ? "($newPrice)" : ""}',
                            };
                          });
                          Navigator.pop(ctx);
                        },
                        child: const Text('Xác Nhận Đã Mua'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationChoiceChip(String title, String locKey, String currentLoc, Function(String) onSelect) {
    final isSelected = currentLoc == locKey;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () => onSelect(locKey),
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(isDark ? 0.25 : 0.12)
              : (isDark ? Colors.white12 : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.black12,
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isSelected ? AppColors.primary : (isDark ? Colors.white : Colors.black87),
          ),
        ),
      ),
    );
  }

  Future<void> _completeList(List<Map<String, dynamic>> items) async {
    final checkedItems = items.where((i) => _checkedStatus[i['id']] == true).toList();
    if (checkedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng tích chọn các mặt hàng đã mua trước khi hoàn thành!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isCompleting = true);
    try {
      final user = ref.read(firebaseAuthServiceProvider).currentUser;
      final firestore = ref.read(firestoreServiceProvider);
      double totalSpent = 0;

      if (user != null) {
        final userDoc = await firestore.getUser(user.uid);
        if (userDoc?.familyId != null) {
          final familyId = userDoc!.familyId!;

          for (final item in checkedItems) {
            final itemId = item['id'];
            final custom = _customItemEdits[itemId];

            final finalQty = (custom?['quantity'] as num?)?.toDouble() ?? (item['rawQty'] as num).toDouble();
            final finalUnit = custom?['unit'] as String? ?? item['unit'] as String;
            final finalLoc = custom?['storageLocation'] as String? ?? item['storageLocation'] as String;
            final finalPrice = (custom?['price'] as num?)?.toDouble() ?? 5.0;

            totalSpent += finalPrice;

            final pantryItem = PantryItem(
              id: const Uuid().v4(),
              familyId: familyId,
              ingredientId: item['name'],
              quantity: finalQty,
              unit: finalUnit,
              storageLocation: finalLoc,
            );
            await firestore.updatePantryItem(familyId, pantryItem);
          }
        }
      }

      // Tự động hạch toán giao dịch chi tiêu vào Ngân Sách Tuần
      if (totalSpent > 0) {
        await ref.read(budgetStateProvider.notifier).recordTransaction(
              totalSpent.toInt(),
              'GROCERY',
              'Đi chợ tuần (${checkedItems.length} nguyên liệu)',
            );
      }

      await ref.read(shoppingStateProvider.notifier).completeShopping();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã hoàn thành! Đã tự động phân loại ${checkedItems.length} thực phẩm vào Tủ Lạnh và trừ ngân sách đi chợ! 🎉'),
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

  List<Map<String, dynamic>> _compileShoppingItems({
    required List<PantryItem> pantryItems,
    required int memberCount,
  }) {
    final factor = memberCount <= 0 ? 1 : memberCount;

    bool inPantryCheck(String searchKeyword) {
      final key = searchKeyword.toLowerCase();
      return pantryItems.any((p) {
        final name = p.ingredientId.toLowerCase();
        final loc = p.storageLocation.toLowerCase();
        return name.contains(key) || key.contains(name) || loc.contains(key);
      });
    }

    final List<Map<String, dynamic>> allItems = [
      // 🥩 Quầy Thịt & Hải Sản
      {
        'id': 'thit_bo',
        'name': 'Thịt bò tái / phi lê',
        'qty': '${factor * 250} g',
        'aisle': 'Thịt & Hải sản',
        'rawQty': factor * 250.0,
        'unit': 'g',
        'storageLocation': 'FREEZER',
        'inPantry': inPantryCheck('bò') || inPantryCheck('beef'),
      },
      {
        'id': 'suon_heo',
        'name': 'Sườn non heo',
        'qty': '${factor * 300} g',
        'aisle': 'Thịt & Hải sản',
        'rawQty': factor * 300.0,
        'unit': 'g',
        'storageLocation': 'FREEZER',
        'inPantry': inPantryCheck('sườn') || inPantryCheck('pork'),
      },
      {
        'id': 'ca_hoi',
        'name': 'Lườn cá hồi tươi (Lohifilee)',
        'qty': '${factor * 300} g',
        'aisle': 'Thịt & Hải sản',
        'rawQty': factor * 300.0,
        'unit': 'g',
        'storageLocation': 'FRIDGE',
        'inPantry': inPantryCheck('cá hồi') || inPantryCheck('lohi') || inPantryCheck('salmon'),
      },
      {
        'id': 'tom_muc',
        'name': 'Tôm & Mực ống tươi',
        'qty': '${factor * 300} g',
        'aisle': 'Thịt & Hải sản',
        'rawQty': factor * 300.0,
        'unit': 'g',
        'storageLocation': 'FREEZER',
        'inPantry': inPantryCheck('tôm') || inPantryCheck('mực') || inPantryCheck('squid'),
      },
      {
        'id': 'thit_ba_chi',
        'name': 'Thịt ba chỉ heo',
        'qty': '${factor * 300} g',
        'aisle': 'Thịt & Hải sản',
        'rawQty': factor * 300.0,
        'unit': 'g',
        'storageLocation': 'FREEZER',
        'inPantry': inPantryCheck('thịt ba chỉ') || inPantryCheck('thịt heo'),
      },
      {
        'id': 'thit_ga',
        'name': 'Thịt gà đùi / ức tươi',
        'qty': '${factor * 300} g',
        'aisle': 'Thịt & Hải sản',
        'rawQty': factor * 300.0,
        'unit': 'g',
        'storageLocation': 'FREEZER',
        'inPantry': inPantryCheck('gà') || inPantryCheck('chicken'),
      },

      // 🥦 Quầy Rau Củ Quả
      {
        'id': 'rau_muong_spinach',
        'name': 'Rau muống / Cải bina (Spinach)',
        'qty': '2 bó',
        'aisle': 'Rau củ quả',
        'rawQty': 2.0,
        'unit': 'bó',
        'storageLocation': 'FRIDGE',
        'inPantry': inPantryCheck('rau') || inPantryCheck('spinach') || inPantryCheck('cải'),
      },
      {
        'id': 'ca_chua_dua',
        'name': 'Cà chua & Thơm / Dứa',
        'qty': '${factor * 2} quả',
        'aisle': 'Rau củ quả',
        'rawQty': factor * 2.0,
        'unit': 'quả',
        'storageLocation': 'FRIDGE',
        'inPantry': inPantryCheck('cà chua') || inPantryCheck('dứa'),
      },
      {
        'id': 'su_su_khoai',
        'name': 'Su su & Khoai môn/Bí đỏ',
        'qty': '${factor * 2} củ',
        'aisle': 'Rau củ quả',
        'rawQty': factor * 2.0,
        'unit': 'củ',
        'storageLocation': 'FRIDGE',
        'inPantry': inPantryCheck('su su') || inPantryCheck('khoai') || inPantryCheck('bí'),
      },

      // 🥚 Quầy Trứng & Sữa
      {
        'id': 'trung_ga',
        'name': 'Trứng gà tươi',
        'qty': '${factor * 4} quả',
        'aisle': 'Trứng & Sữa',
        'rawQty': factor * 4.0,
        'unit': 'quả',
        'storageLocation': 'FRIDGE',
        'inPantry': inPantryCheck('trứng') || inPantryCheck('egg'),
      },
      {
        'id': 'bo_lat',
        'name': 'Bơ lạt nướng (Unsalted Butter)',
        'qty': '${factor * 30} g',
        'aisle': 'Trứng & Sữa',
        'rawQty': factor * 30.0,
        'unit': 'g',
        'storageLocation': 'FRIDGE',
        'inPantry': inPantryCheck('bơ') || inPantryCheck('butter'),
      },
      {
        'id': 'sua_tuoi',
        'name': 'Sữa tươi nguyên chất',
        'qty': '${factor * 200} ml',
        'aisle': 'Trứng & Sữa',
        'rawQty': factor * 200.0,
        'unit': 'ml',
        'storageLocation': 'FRIDGE',
        'inPantry': inPantryCheck('sữa') || inPantryCheck('milk'),
      },

      // 🍞 Quầy Bánh Mì & Mứt
      {
        'id': 'banh_mi_sandwich',
        'name': 'Bánh mì sandwich mềm (Ruisleipä)',
        'qty': '${factor * 2} lát',
        'aisle': 'Bánh mì & Mứt',
        'rawQty': factor * 2.0,
        'unit': 'lát',
        'storageLocation': 'PANTRY',
        'inPantry': inPantryCheck('bánh mì') || inPantryCheck('sandwich') || inPantryCheck('bread'),
      },
      {
        'id': 'mut_dau',
        'name': 'Mứt dâu tây Lingonberry',
        'qty': '1 hũ',
        'aisle': 'Bánh mì & Mứt',
        'rawQty': 1.0,
        'unit': 'hũ',
        'storageLocation': 'PANTRY',
        'inPantry': inPantryCheck('mứt') || inPantryCheck('dâu') || inPantryCheck('jam'),
      },

      // 🍜 Quầy Bún Phở & Ngũ Cốc
      {
        'id': 'bun_pho',
        'name': 'Bánh phở & Bún tươi/khô',
        'qty': '${factor * 300} g',
        'aisle': 'Bún Phở & Ngũ Cốc',
        'rawQty': factor * 300.0,
        'unit': 'g',
        'storageLocation': 'PANTRY',
        'inPantry': inPantryCheck('phở') || inPantryCheck('bún') || inPantryCheck('noodle'),
      },
      {
        'id': 'gao_jasmine',
        'name': 'Gạo thơm Jasmine',
        'qty': '${factor * 500} g',
        'aisle': 'Bún Phở & Ngũ Cốc',
        'rawQty': factor * 500.0,
        'unit': 'g',
        'storageLocation': 'PANTRY',
        'inPantry': inPantryCheck('gạo') || inPantryCheck('rice'),
      },

      // 🧂 Quầy Gia Vị & Đồ Khô
      {
        'id': 'nuoc_da_sa_te',
        'name': 'Gia vị phở, Sa tế & Nước dừa',
        'qty': '1 bộ',
        'aisle': 'Gia vị & Đồ khô',
        'rawQty': 1.0,
        'unit': 'bộ',
        'storageLocation': 'PANTRY',
        'inPantry': inPantryCheck('gia vị') || inPantryCheck('sa tế') || inPantryCheck('dừa'),
      },
    ];

    // Chỉ giữ lại các món CHƯA CÓ TRONG TỦ LẠNH
    return allItems.where((item) => item['inPantry'] == false).toList();
  }

  @override
  Widget build(BuildContext context) {
    final shoppingListState = ref.watch(shoppingStateProvider);
    final pantryItems = ref.watch(pantryStateProvider).value ?? [];
    final user = ref.watch(firebaseAuthServiceProvider).currentUser;
    final mealPlan = ref.watch(mealPlanStateProvider).value;
    final theme = Theme.of(context);

    return StreamBuilder<User?>(
      stream: user != null ? ref.watch(firestoreServiceProvider).watchUser(user.uid) : null,
      builder: (context, userSnap) {
        final familyId = userSnap.data?.familyId ?? '';

        return StreamBuilder<List<FamilyMember>>(
          stream: familyId.isNotEmpty
              ? ref.watch(firestoreServiceProvider).watchFamilyMembers(familyId)
              : Stream.value([]),
          builder: (context, membersSnap) {
            final members = membersSnap.data ?? [];
            final memberCount = members.isNotEmpty ? members.length : 2;

            final compiledItems = _compileShoppingItems(
              pantryItems: pantryItems,
              memberCount: memberCount,
            );

            return Scaffold(
              appBar: AppBar(
                title: const Text('Danh Sách Đi Chợ Tuần'),
              ),
              body: Column(
                children: [
                  const PersistentFinancialHeader(),
                  Expanded(
                    child: shoppingListState.when(
                      data: (list) {
                        if (list == null && mealPlan == null) {
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
                                    'Chưa có danh sách đi chợ tuần này',
                                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Vui lòng sinh thực đơn tuần ở màn hình Thực Đơn trước.',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.disabledColor),
                                  ),
                                  const SizedBox(height: AppSpacing.lg),
                                  AppButton(
                                    text: 'Tạo Danh Sách Đi Chợ',
                                    icon: Icons.auto_awesome,
                                    isLoading: _isGenerating,
                                    onPressed: _generateList,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        if (compiledItems.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.check_circle_outline_rounded,
                                    size: 64,
                                    color: AppColors.success,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Tủ Lạnh Gia Đình Đã Đầy Đủ!',
                                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Tất cả nguyên liệu cần thiết cho thực đơn tuần này đều đã có sẵn trong kho tủ lạnh của bạn.',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.disabledColor),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        // Display Active Compiled Shopping List
                        return Column(
                          children: [
                            Expanded(
                              child: ListView(
                                padding: const EdgeInsets.all(AppSpacing.md),
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Nguyên liệu cần mua tuần này',
                                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                        ),
                                        child: Text(
                                          '👨‍👩‍👧‍👦 $memberCount người (Đã trừ đồ có sẵn)',
                                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  ...compiledItems.map((item) {
                                    final itemId = item['id'];
                                    final isChecked = _checkedStatus[itemId] ?? false;
                                    final custom = _customItemEdits[itemId];
                                    final displayQty = custom?['displayQty'] as String? ?? (item['qty'] as String);

                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: AppCard(
                                        padding: EdgeInsets.zero,
                                        child: CheckboxListTile(
                                          title: Text(
                                            item['name'],
                                            style: TextStyle(
                                              decoration: isChecked ? TextDecoration.lineThrough : null,
                                              fontWeight: FontWeight.bold,
                                              color: isChecked ? theme.disabledColor : null,
                                            ),
                                          ),
                                          subtitle: Row(
                                            children: [
                                              Text('Quầy: ${item['aisle']}'),
                                              const SizedBox(width: 8),
                                              InkWell(
                                                onTap: () => _showEditQuantityDialog(item),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: const [
                                                    Icon(Icons.edit_note_rounded, size: 16, color: AppColors.primary),
                                                    SizedBox(width: 2),
                                                    Text('Sửa', style: TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          secondary: Text(
                                            displayQty,
                                            style: TextStyle(
                                              color: isChecked ? theme.disabledColor : AppColors.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          value: isChecked,
                                          onChanged: (val) {
                                            if (val == true && custom == null) {
                                              _showEditQuantityDialog(item);
                                            } else {
                                              setState(() {
                                                _checkedStatus[itemId] = val ?? false;
                                              });
                                            }
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
                                text: 'Hoàn Thành Đi Chợ (Nhập Tủ Lạnh)',
                                isLoading: _isCompleting,
                                onPressed: () => _completeList(compiledItems),
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, st) => Center(child: Text('Lỗi tải danh sách đi chợ: $err')),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
