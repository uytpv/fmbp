import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fmbp_models/fmbp_models.dart';
import '../../../app/theme.dart';
import '../../../core/services/firebase_auth_service.dart';
import '../../../core/services/firestore_service.dart';
import '../../../shared/utils/currency_formatter.dart';
import '../../../shared/widgets/app_card.dart';
import '../../pantry/presentation/pantry_provider.dart';

class RecipeDetailBottomSheet extends ConsumerStatefulWidget {
  final String recipeTitle;
  final String dayName;
  final String mealType;
  final num estimatedCost;
  final String currency;
  final List<Map<String, dynamic>> ingredients;
  final String prepTime;
  final String complexity;
  final String localTip;

  const RecipeDetailBottomSheet({
    super.key,
    required this.recipeTitle,
    required this.dayName,
    required this.mealType,
    required this.estimatedCost,
    required this.currency,
    this.ingredients = const [],
    this.prepTime = '25 phút',
    this.complexity = '⚡ Nấu nhanh (< 30 phút)',
    this.localTip = 'Mẹo tại Châu Âu/Phần Lan: Có thể thay thế rau củ nhiệt đới bằng rau bina tươi (Spinach) hoặc mứt dâu tây lingonberry tại siêu thị địa phương.',
  });

  @override
  ConsumerState<RecipeDetailBottomSheet> createState() => _RecipeDetailBottomSheetState();
}

class _RecipeDetailBottomSheetState extends ConsumerState<RecipeDetailBottomSheet> {
  final Map<int, bool> _completedSteps = {};
  bool _isCooking = false;

  Future<void> _cookMealAndDeductPantry(
    String familyId,
    List<Map<String, dynamic>> ingredients,
    List<PantryItem> pantryItems,
  ) async {
    if (familyId.isEmpty) return;

    setState(() => _isCooking = true);
    try {
      final firestore = ref.read(firestoreServiceProvider);

      for (final ing in ingredients) {
        final ingName = (ing['name'] as String).toLowerCase();
        final ingQtyStr = ing['quantity'] as String?;
        final ingQty = double.tryParse(ingQtyStr ?? '1') ?? 1.0;

        final matchingPantry = pantryItems.firstWhere(
          (p) => p.ingredientId.toLowerCase().contains(ingName) || ingName.contains(p.ingredientId.toLowerCase()),
          orElse: () => PantryItem(id: '', familyId: '', ingredientId: '', quantity: 0, unit: '', storageLocation: ''),
        );

        if (matchingPantry.id.isNotEmpty && matchingPantry.quantity > 0) {
          final newQty = matchingPantry.quantity - ingQty;
          if (newQty <= 0) {
            await firestore.deletePantryItem(familyId, matchingPantry.id);
          } else {
            final updatedItem = matchingPantry.copyWith(quantity: newQty);
            await firestore.updatePantryItem(familyId, updatedItem);
          }
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 Chúc gia đình ngon miệng! Đã tự động trừ nguyên liệu của món "${widget.recipeTitle}" khỏi tủ lạnh!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi cập nhật tủ lạnh: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isCooking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final user = ref.watch(firebaseAuthServiceProvider).currentUser;
    final pantryItems = ref.watch(pantryStateProvider).value ?? [];

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

            final calculatedIngredients = widget.ingredients.isNotEmpty
                ? widget.ingredients
                : _getIngredientsForRecipe(
                    widget.recipeTitle,
                    memberCount: memberCount,
                    pantryItems: pantryItems,
                  );

            final cookingSteps = _getCookingStepsForRecipe(widget.recipeTitle);

            return Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: isDark ? AppColors.bgCardDark : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drag Indicator
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: theme.disabledColor.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Header info
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.restaurant_rounded, color: AppColors.primary, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.recipeTitle,
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${widget.dayName} • Bữa ${widget.mealType} • 👨‍👩‍👧‍👦 $memberCount thành viên',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Badges Bar (Cost & Prep Time)
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Chi phí ước tính', style: TextStyle(fontSize: 10, color: AppColors.primary)),
                                const SizedBox(height: 2),
                                Text(
                                  CurrencyFormatter.format(widget.estimatedCost, widget.currency),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                              border: Border.all(color: Colors.orange.withOpacity(0.2)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Thời gian & Cấp độ', style: TextStyle(fontSize: 10, color: Colors.orange)),
                                const SizedBox(height: 2),
                                Text(
                                  '${widget.prepTime} • ${widget.complexity}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.orange),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Ingredients Breakdown Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '🥑 Thành Phần & Nguyên Liệu',
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                          child: Text(
                            'Khẩu phần: $memberCount người',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Dynamic Ingredients List
                    Column(
                      children: calculatedIngredients.map((ing) {
                        final isAvailable = ing['inPantry'] == true;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: AppCard(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: Row(
                              children: [
                                Icon(
                                  isAvailable ? Icons.check_circle_rounded : Icons.add_shopping_cart_rounded,
                                  size: 18,
                                  color: isAvailable ? AppColors.success : Colors.orange,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    ing['name'],
                                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Text(
                                  '${ing['quantity']} ${ing['unit']}',
                                  style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: (isAvailable ? AppColors.success : Colors.orange).withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    isAvailable ? 'Có trong tủ' : 'Cần mua',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isAvailable ? AppColors.success : Colors.orange,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // 👨‍🍳 COOKING STEPS INSTRUCTIONS
                    Text(
                      '👨‍🍳 Hướng Dẫn Nấu Ăn Từng Bước',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    Column(
                      children: List.generate(cookingSteps.length, (idx) {
                        final isStepDone = _completedSteps[idx] ?? false;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _completedSteps[idx] = !isStepDone;
                              });
                            },
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isStepDone
                                    ? AppColors.success.withOpacity(0.08)
                                    : (isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100),
                                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                border: Border.all(
                                  color: isStepDone ? AppColors.success : Colors.black12,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    isStepDone ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                                    color: isStepDone ? AppColors.success : theme.disabledColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      cookingSteps[idx],
                                      style: TextStyle(
                                        fontSize: 12,
                                        height: 1.4,
                                        decoration: isStepDone ? TextDecoration.lineThrough : null,
                                        color: isStepDone ? theme.disabledColor : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Local Substitution Tip Card
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        border: Border.all(color: Colors.blue.withOpacity(0.2)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.lightbulb_outline_rounded, color: Colors.blue, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Mẹo Nấu Nướng Quốc Tế & Đi Chợ',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blue),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _getLocalTipForRecipe(widget.recipeTitle),
                                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // COOK MEAL & DEDUCT PANTRY BUTTON
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Đóng'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success,
                              foregroundColor: Colors.white,
                            ),
                            icon: _isCooking
                                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Icon(Icons.soup_kitchen_rounded, size: 18),
                            label: const Text('Xác Nhận Nấu (Trừ Tủ Lạnh)'),
                            onPressed: _isCooking
                                ? null
                                : () => _cookMealAndDeductPantry(familyId, calculatedIngredients, pantryItems),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<Map<String, dynamic>> _getIngredientsForRecipe(
    String title, {
    required int memberCount,
    required List<PantryItem> pantryItems,
  }) {
    final t = title.toLowerCase();
    final factor = memberCount <= 0 ? 1 : memberCount;

    // Helper kiểm tra xem nguyên liệu có trong tủ lạnh hay không
    bool inPantryCheck(String searchKeyword) {
      final key = searchKeyword.toLowerCase();
      return pantryItems.any((p) {
        final name = p.ingredientId.toLowerCase();
        final loc = p.storageLocation.toLowerCase();
        return name.contains(key) || key.contains(name) || loc.contains(key);
      });
    }

    if (t.contains('sandwich') || t.contains('mứt dâu') || t.contains('bánh mì sandwich')) {
      return [
        {
          'name': 'Bánh mì sandwich mềm',
          'quantity': '${factor * 2}',
          'unit': 'lát',
          'inPantry': inPantryCheck('bánh mì') || inPantryCheck('sandwich') || inPantryCheck('bread'),
        },
        {
          'name': 'Mứt dâu tây (Strawberry Jam / Lingonberry)',
          'quantity': '1',
          'unit': 'hũ',
          'inPantry': inPantryCheck('mứt') || inPantryCheck('dâu') || inPantryCheck('jam'),
        },
        {
          'name': 'Bơ lạt nướng (Unsalted Butter)',
          'quantity': '${factor * 15}',
          'unit': 'g',
          'inPantry': inPantryCheck('bơ') || inPantryCheck('butter'),
        },
        {
          'name': 'Sữa tươi nguyên chất',
          'quantity': '${factor * 100}',
          'unit': 'ml',
          'inPantry': inPantryCheck('sữa') || inPantryCheck('milk'),
        },
      ];
    }

    if (t.contains('phở bò')) {
      return [
        {
          'name': 'Thịt bò tái / nạm tươi',
          'quantity': '${factor * 150}',
          'unit': 'g',
          'inPantry': inPantryCheck('bò') || inPantryCheck('beef'),
        },
        {
          'name': 'Bánh phở tươi / khô',
          'quantity': '${factor * 150}',
          'unit': 'g',
          'inPantry': inPantryCheck('phở') || inPantryCheck('noodle'),
        },
        {
          'name': 'Xương ống ninh nước dùng',
          'quantity': '${factor * 200}',
          'unit': 'g',
          'inPantry': inPantryCheck('xương'),
        },
        {
          'name': 'Hành tây, gừng & bộ gia vị phở',
          'quantity': '1',
          'unit': 'bộ',
          'inPantry': inPantryCheck('hành') || inPantryCheck('gừng'),
        },
      ];
    }

    if (t.contains('sườn kho') || t.contains('cơm sườn')) {
      return [
        {
          'name': 'Sườn heo tươi ngon',
          'quantity': '${factor * 150}',
          'unit': 'g',
          'inPantry': inPantryCheck('sườn') || inPantryCheck('pork'),
        },
        {
          'name': 'Trứng gà / Trứng cút',
          'quantity': '${factor * 1}',
          'unit': 'quả',
          'inPantry': inPantryCheck('trứng') || inPantryCheck('egg'),
        },
        {
          'name': 'Gạo thơm Jasmine',
          'quantity': '${factor * 100}',
          'unit': 'g',
          'inPantry': inPantryCheck('gạo') || inPantryCheck('rice'),
        },
        {
          'name': 'Hành tỏi & nước màu kho',
          'quantity': '1',
          'unit': 'ít',
          'inPantry': inPantryCheck('hành') || inPantryCheck('tỏi'),
        },
      ];
    }

    if (t.contains('canh chua cá hồi') || (t.contains('cá hồi') && t.contains('canh'))) {
      return [
        {
          'name': 'Đầu / Lườn cá hồi tươi (Lohifilee)',
          'quantity': '${factor * 150}',
          'unit': 'g',
          'inPantry': inPantryCheck('cá') || inPantryCheck('cá hồi') || inPantryCheck('salmon') || inPantryCheck('lohi'),
        },
        {
          'name': 'Cà chua & thơm/dứa',
          'quantity': '${factor * 1}',
          'unit': 'quả',
          'inPantry': inPantryCheck('cà chua') || inPantryCheck('dứa') || inPantryCheck('thơm'),
        },
        {
          'name': 'Rau muống / Cải bina (Spinach)',
          'quantity': '1',
          'unit': 'bó',
          'inPantry': inPantryCheck('rau') || inPantryCheck('spinach') || inPantryCheck('cải'),
        },
        {
          'name': 'Tỏi, ớt & ngò gai',
          'quantity': '1',
          'unit': 'ít',
          'inPantry': inPantryCheck('tỏi') || inPantryCheck('ớt'),
        },
      ];
    }

    if (t.contains('thịt heo quay') || t.contains('canh cải băm')) {
      return [
        {
          'name': 'Thịt ba chỉ heo quay',
          'quantity': '${factor * 150}',
          'unit': 'g',
          'inPantry': inPantryCheck('thịt') || inPantryCheck('heo') || inPantryCheck('pork'),
        },
        {
          'name': 'Cải bẹ xanh / Cải bina',
          'quantity': '1',
          'unit': 'bó',
          'inPantry': inPantryCheck('cải') || inPantryCheck('rau') || inPantryCheck('spinach'),
        },
        {
          'name': 'Thịt nạc băm nấu canh',
          'quantity': '${factor * 50}',
          'unit': 'g',
          'inPantry': inPantryCheck('thịt băm') || inPantryCheck('thịt'),
        },
        {
          'name': 'Gừng tươi & tỏi',
          'quantity': '1',
          'unit': 'ít',
          'inPantry': inPantryCheck('gừng') || inPantryCheck('tỏi'),
        },
      ];
    }

    if (t.contains('cá kho tộ') || t.contains('khoai mỡ')) {
      return [
        {
          'name': 'Cá tươi kho tộ (Cá lóc / Cá hồi)',
          'quantity': '${factor * 150}',
          'unit': 'g',
          'inPantry': inPantryCheck('cá') || inPantryCheck('lohi') || inPantryCheck('salmon'),
        },
        {
          'name': 'Khoai mỡ / Khoai môn',
          'quantity': '${factor * 100}',
          'unit': 'g',
          'inPantry': inPantryCheck('khoai'),
        },
        {
          'name': 'Thịt nạc băm',
          'quantity': '${factor * 50}',
          'unit': 'g',
          'inPantry': inPantryCheck('thịt') || inPantryCheck('thịt băm'),
        },
        {
          'name': 'Hành lá, ớt & nước mắm',
          'quantity': '1',
          'unit': 'ít',
          'inPantry': inPantryCheck('hành') || inPantryCheck('nước mắm'),
        },
      ];
    }

    if (t.contains('cháo gà') || t.contains('hạt sen')) {
      return [
        {
          'name': 'Thịt gà đùi / ức tươi',
          'quantity': '${factor * 150}',
          'unit': 'g',
          'inPantry': inPantryCheck('gà') || inPantryCheck('chicken'),
        },
        {
          'name': 'Gạo tẻ & gạo nếp',
          'quantity': '${factor * 75}',
          'unit': 'g',
          'inPantry': inPantryCheck('gạo') || inPantryCheck('rice'),
        },
        {
          'name': 'Hạt sen khô / tươi',
          'quantity': '${factor * 25}',
          'unit': 'g',
          'inPantry': inPantryCheck('hạt sen') || inPantryCheck('sen'),
        },
        {
          'name': 'Hành lá, ngò rí & tiêu',
          'quantity': '1',
          'unit': 'ít',
          'inPantry': inPantryCheck('hành') || inPantryCheck('tiêu'),
        },
      ];
    }

    if (t.contains('bún mọc') || t.contains('sườn chua')) {
      return [
        {
          'name': 'Bún tươi / Bún khô',
          'quantity': '${factor * 150}',
          'unit': 'g',
          'inPantry': inPantryCheck('bún') || inPantryCheck('noodle'),
        },
        {
          'name': 'Sườn non heo',
          'quantity': '${factor * 150}',
          'unit': 'g',
          'inPantry': inPantryCheck('sườn') || inPantryCheck('pork'),
        },
        {
          'name': 'Giò sống mọc nấm mèo',
          'quantity': '${factor * 75}',
          'unit': 'g',
          'inPantry': inPantryCheck('giò') || inPantryCheck('mọc') || inPantryCheck('thịt'),
        },
        {
          'name': 'Cà chua & dọc mùng/dứa',
          'quantity': '${factor * 1}',
          'unit': 'quả',
          'inPantry': inPantryCheck('cà chua') || inPantryCheck('dứa'),
        },
      ];
    }

    if (t.contains('tôm hấp') || t.contains('su su')) {
      return [
        {
          'name': 'Tôm tươi ngon',
          'quantity': '${factor * 150}',
          'unit': 'g',
          'inPantry': inPantryCheck('tôm') || inPantryCheck('shrimp'),
        },
        {
          'name': 'Nước dừa tươi',
          'quantity': '1',
          'unit': 'quả',
          'inPantry': inPantryCheck('dừa'),
        },
        {
          'name': 'Su su tươi',
          'quantity': '${factor * 1}',
          'unit': 'quả',
          'inPantry': inPantryCheck('su su') || inPantryCheck('rau'),
        },
        {
          'name': 'Trứng gà',
          'quantity': '${factor * 1}',
          'unit': 'quả',
          'inPantry': inPantryCheck('trứng') || inPantryCheck('egg'),
        },
      ];
    }

    if (t.contains('bún riêu')) {
      return [
        {
          'name': 'Bún tươi / Bún khô',
          'quantity': '${factor * 150}',
          'unit': 'g',
          'inPantry': inPantryCheck('bún') || inPantryCheck('noodle'),
        },
        {
          'name': 'Cua đồng xay / Gạch cua',
          'quantity': '${factor * 100}',
          'unit': 'g',
          'inPantry': inPantryCheck('cua'),
        },
        {
          'name': 'Đậu phụ chiên giòn',
          'quantity': '${factor * 1}',
          'unit': 'miếng',
          'inPantry': inPantryCheck('đậu phụ') || inPantryCheck('tofu'),
        },
        {
          'name': 'Cà chua & rau sống',
          'quantity': '${factor * 1}',
          'unit': 'quả',
          'inPantry': inPantryCheck('cà chua') || inPantryCheck('rau'),
        },
      ];
    }

    if (t.contains('bò xào') || t.contains('thiên lý')) {
      return [
        {
          'name': 'Thịt bò phi lê',
          'quantity': '${factor * 125}',
          'unit': 'g',
          'inPantry': inPantryCheck('bò') || inPantryCheck('beef'),
        },
        {
          'name': 'Bông thiên lý / Bông hẹ',
          'quantity': '${factor * 75}',
          'unit': 'g',
          'inPantry': inPantryCheck('thiên lý') || inPantryCheck('rau'),
        },
        {
          'name': 'Bí đỏ nấu canh',
          'quantity': '${factor * 100}',
          'unit': 'g',
          'inPantry': inPantryCheck('bí') || inPantryCheck('pumpkin'),
        },
        {
          'name': 'Thịt băm & tỏi',
          'quantity': '${factor * 50}',
          'unit': 'g',
          'inPantry': inPantryCheck('thịt') || inPantryCheck('tỏi'),
        },
      ];
    }

    if (t.contains('cá hồi nướng') || t.contains('bơ tỏi')) {
      return [
        {
          'name': 'Lườn cá hồi tươi (Lohifilee)',
          'quantity': '${factor * 150}',
          'unit': 'g',
          'inPantry': inPantryCheck('cá') || inPantryCheck('cá hồi') || inPantryCheck('lohi') || inPantryCheck('salmon'),
        },
        {
          'name': 'Bơ lạt & tỏi băm',
          'quantity': '${factor * 25}',
          'unit': 'g',
          'inPantry': inPantryCheck('bơ') || inPantryCheck('tỏi'),
        },
        {
          'name': 'Gạo thơm Jasmine',
          'quantity': '${factor * 100}',
          'unit': 'g',
          'inPantry': inPantryCheck('gạo') || inPantryCheck('rice'),
        },
        {
          'name': 'Súp lơ xanh (Broccoli)',
          'quantity': '${factor * 75}',
          'unit': 'g',
          'inPantry': inPantryCheck('súp lơ') || inPantryCheck('broccoli') || inPantryCheck('rau'),
        },
      ];
    }

    if (t.contains('hủ tiếu')) {
      return [
        {
          'name': 'Hủ tiếu khô / tươi',
          'quantity': '${factor * 125}',
          'unit': 'g',
          'inPantry': inPantryCheck('hủ tiếu') || inPantryCheck('noodle'),
        },
        {
          'name': 'Thịt heo & tôm tươi',
          'quantity': '${factor * 100}',
          'unit': 'g',
          'inPantry': inPantryCheck('thịt') || inPantryCheck('tôm'),
        },
        {
          'name': 'Trứng cút luộc',
          'quantity': '${factor * 2}',
          'unit': 'quả',
          'inPantry': inPantryCheck('trứng') || inPantryCheck('egg'),
        },
        {
          'name': 'Cần tây & giá đỗ',
          'quantity': '${factor * 50}',
          'unit': 'g',
          'inPantry': inPantryCheck('giá') || inPantryCheck('rau'),
        },
      ];
    }

    if (t.contains('mực xào') || t.contains('sa tế')) {
      return [
        {
          'name': 'Mực ống tươi ngon',
          'quantity': '${factor * 150}',
          'unit': 'g',
          'inPantry': inPantryCheck('mực') || inPantryCheck('squid'),
        },
        {
          'name': 'Sa tế ớt & ớt chuông',
          'quantity': '1',
          'unit': 'hũ',
          'inPantry': inPantryCheck('sa tế') || inPantryCheck('ớt'),
        },
        {
          'name': 'Rau ngót / Cải bina',
          'quantity': '1',
          'unit': 'bó',
          'inPantry': inPantryCheck('rau') || inPantryCheck('spinach'),
        },
        {
          'name': 'Thịt nạc băm nấu canh',
          'quantity': '${factor * 50}',
          'unit': 'g',
          'inPantry': inPantryCheck('thịt') || inPantryCheck('thịt băm'),
        },
      ];
    }

    if (t.contains('thịt kho tàu') || t.contains('thịt kho')) {
      return [
        {
          'name': 'Thịt ba chỉ heo',
          'quantity': '${factor * 150}',
          'unit': 'g',
          'inPantry': inPantryCheck('thịt') || inPantryCheck('heo') || inPantryCheck('pork'),
        },
        {
          'name': 'Trứng gà luộc',
          'quantity': '${factor * 1}',
          'unit': 'quả',
          'inPantry': inPantryCheck('trứng') || inPantryCheck('egg'),
        },
        {
          'name': 'Nước dừa xiêm',
          'quantity': '1',
          'unit': 'quả',
          'inPantry': inPantryCheck('dừa'),
        },
        {
          'name': 'Hành tỏi & ớt',
          'quantity': '1',
          'unit': 'ít',
          'inPantry': inPantryCheck('hành') || inPantryCheck('tỏi'),
        },
      ];
    }

    if (t.contains('ốp la') || t.contains('pate')) {
      return [
        {
          'name': 'Bánh mì baguette',
          'quantity': '${factor * 1}',
          'unit': 'ổ',
          'inPantry': inPantryCheck('bánh mì') || inPantryCheck('bread'),
        },
        {
          'name': 'Trứng gà tươi',
          'quantity': '${factor * 1}',
          'unit': 'quả',
          'inPantry': inPantryCheck('trứng') || inPantryCheck('egg'),
        },
        {
          'name': 'Pate gan heo',
          'quantity': '${factor * 25}',
          'unit': 'g',
          'inPantry': inPantryCheck('pate'),
        },
        {
          'name': 'Dưa leo & ngò rí',
          'quantity': '1',
          'unit': 'quả',
          'inPantry': inPantryCheck('dưa') || inPantryCheck('rau'),
        },
      ];
    }

    if (t.contains('lẩu thái')) {
      return [
        {
          'name': 'Tôm, mực & cá viên',
          'quantity': '${factor * 200}',
          'unit': 'g',
          'inPantry': inPantryCheck('tôm') || inPantryCheck('mực') || inPantryCheck('cá'),
        },
        {
          'name': 'Gói gia vị lẩu Thái',
          'quantity': '1',
          'unit': 'gói',
          'inPantry': inPantryCheck('lẩu') || inPantryCheck('sa tế'),
        },
        {
          'name': 'Nấm kim châm & rau muống',
          'quantity': '${factor * 100}',
          'unit': 'g',
          'inPantry': inPantryCheck('nấm') || inPantryCheck('rau'),
        },
        {
          'name': 'Bún tươi / Mỳ gói',
          'quantity': '${factor * 100}',
          'unit': 'g',
          'inPantry': inPantryCheck('bún') || inPantryCheck('mỳ') || inPantryCheck('noodle'),
        },
      ];
    }

    if (t.contains('cơm chiên')) {
      return [
        {
          'name': 'Cơm nguội dẻo',
          'quantity': '${factor * 150}',
          'unit': 'g',
          'inPantry': inPantryCheck('cơm') || inPantryCheck('gạo') || inPantryCheck('rice'),
        },
        {
          'name': 'Tôm & mực thái hạt lựu',
          'quantity': '${factor * 75}',
          'unit': 'g',
          'inPantry': inPantryCheck('tôm') || inPantryCheck('mực'),
        },
        {
          'name': 'Trứng gà & đậu hà lan',
          'quantity': '${factor * 1}',
          'unit': 'quả',
          'inPantry': inPantryCheck('trứng') || inPantryCheck('egg'),
        },
        {
          'name': 'Cà rốt & hành lá',
          'quantity': '1',
          'unit': 'củ',
          'inPantry': inPantryCheck('cà rốt') || inPantryCheck('hành'),
        },
      ];
    }

    if (t.contains('bún bò')) {
      return [
        {
          'name': 'Bún sợi to',
          'quantity': '${factor * 150}',
          'unit': 'g',
          'inPantry': inPantryCheck('bún') || inPantryCheck('noodle'),
        },
        {
          'name': 'Nạm bò & chả bắp',
          'quantity': '${factor * 150}',
          'unit': 'g',
          'inPantry': inPantryCheck('bò') || inPantryCheck('beef'),
        },
        {
          'name': 'Huyết heo & mắm ruốc Huế',
          'quantity': '${factor * 50}',
          'unit': 'g',
          'inPantry': inPantryCheck('mắm') || inPantryCheck('huyết'),
        },
        {
          'name': 'Sả củ & ớt sa tế',
          'quantity': '2',
          'unit': 'cây',
          'inPantry': inPantryCheck('sả') || inPantryCheck('ớt'),
        },
      ];
    }

    if (t.contains('cơm gà')) {
      return [
        {
          'name': 'Thịt gà luộc / hấp',
          'quantity': '${factor * 150}',
          'unit': 'g',
          'inPantry': inPantryCheck('gà') || inPantryCheck('chicken'),
        },
        {
          'name': 'Gạo nấu nước dùng gà',
          'quantity': '${factor * 100}',
          'unit': 'g',
          'inPantry': inPantryCheck('gạo') || inPantryCheck('rice'),
        },
        {
          'name': 'Nước chấm gừng tỏi',
          'quantity': '1',
          'unit': 'bát',
          'inPantry': inPantryCheck('gừng') || inPantryCheck('tỏi'),
        },
        {
          'name': 'Dưa leo & xà lách',
          'quantity': '1',
          'unit': 'quả',
          'inPantry': inPantryCheck('dưa') || inPantryCheck('xà lách'),
        },
      ];
    }

    // Dynamic Generic Fallback extracted from dish name keywords
    List<Map<String, dynamic>> dynamicIngs = [];

    if (t.contains('cá')) {
      dynamicIngs.add({
        'name': 'Cá tươi ngon (Lohifilee / Cá thu)',
        'quantity': '${factor * 150}',
        'unit': 'g',
        'inPantry': inPantryCheck('cá') || inPantryCheck('lohi') || inPantryCheck('salmon'),
      });
    } else if (t.contains('gà')) {
      dynamicIngs.add({
        'name': 'Thịt gà tươi',
        'quantity': '${factor * 150}',
        'unit': 'g',
        'inPantry': inPantryCheck('gà') || inPantryCheck('chicken'),
      });
    } else if (t.contains('bò')) {
      dynamicIngs.add({
        'name': 'Thịt bò tươi',
        'quantity': '${factor * 150}',
        'unit': 'g',
        'inPantry': inPantryCheck('bò') || inPantryCheck('beef'),
      });
    } else if (t.contains('tôm')) {
      dynamicIngs.add({
        'name': 'Tôm tươi',
        'quantity': '${factor * 150}',
        'unit': 'g',
        'inPantry': inPantryCheck('tôm') || inPantryCheck('shrimp'),
      });
    } else if (t.contains('bánh mì')) {
      dynamicIngs.add({
        'name': 'Bánh mì tươi',
        'quantity': '${factor * 1}',
        'unit': 'ổ',
        'inPantry': inPantryCheck('bánh mì') || inPantryCheck('bread'),
      });
    } else {
      dynamicIngs.add({
        'name': 'Thịt ba chỉ / Nguyên liệu chính',
        'quantity': '${factor * 150}',
        'unit': 'g',
        'inPantry': inPantryCheck('thịt') || inPantryCheck('pork'),
      });
    }

    dynamicIngs.addAll([
      {
        'name': 'Rau xanh kèm theo (Spinach / Cải)',
        'quantity': '1',
        'unit': 'bó',
        'inPantry': inPantryCheck('rau') || inPantryCheck('cải') || inPantryCheck('spinach'),
      },
      {
        'name': 'Gia vị hành tỏi',
        'quantity': '1',
        'unit': 'ít',
        'inPantry': inPantryCheck('hành') || inPantryCheck('tỏi'),
      },
    ]);

    return dynamicIngs;
  }

  List<String> _getCookingStepsForRecipe(String title) {
    final t = title.toLowerCase();
    if (t.contains('phở bò')) {
      return [
        'Bước 1: Ninh xương ống lấy nước dùng trong 45 phút cùng gừng nướng, hành khô và bộ gia vị phở (hoa hồi, quế, thảo quả).',
        'Bước 2: Sơ chế thịt bò tái thành từng lát mỏng. Chần sơ bánh phở qua nước sôi rồi xếp vào tô.',
        'Bước 3: Xếp thịt bò tái, hành lá, ngò rí lên mặt bánh phở.',
        'Bước 4: Chan nước dùng phở thật sôi vào tô cho thịt bò chín tái vừa tới. Dùng nóng kèm chanh, ớt.',
      ];
    }
    if (t.contains('sandwich') || t.contains('mứt dâu')) {
      return [
        'Bước 1: Áo một lớp bơ lạt (Unsalted Butter) lên 2 mặt bánh mì sandwich.',
        'Bước 2: Cho bánh mì vào chảo nướng nhẹ 1-2 phút cho vàng giòn thơm phức.',
        'Bước 3: Phết đều mứt dâu tây (Lingonberry/Strawberry Jam) lên mặt bánh.',
        'Bước 4: Kẹp bánh lại, cắt đôi hình tam giác và thưởng thức kèm 1 ly sữa tươi mát lạnh.',
      ];
    }
    if (t.contains('canh chua cá hồi')) {
      return [
        'Bước 1: Rửa sạch lườn/đầu cá hồi với nước muối và gừng để khử mùi hôi.',
        'Bước 2: Đun sôi nước, cho cà chua, dứa (thơm) cắt lát và gia vị canh chua vào nấu 5 phút.',
        'Bước 3: Cho cá hồi vào nấu chín tới trong 7-10 phút (không đảo mạnh tránh nát cá).',
        'Bước 4: Cho rau muống/cải bina, su su vào đun sôi bùng, nêm nước mắm thơm và ngò gai.',
      ];
    }
    if (t.contains('sườn kho') || t.contains('thịt kho')) {
      return [
        'Bước 1: Sườn non/thịt ba chỉ rửa sạch, chần nước sôi 2 phút rồi vớt ra ráo.',
        'Bước 2: Ướp thịt với nước mắm, đường kẹo đắng, hành tím băm và tiêu trong 15 phút.',
        'Bước 3: Cho thịt vào nồi đảo săn, thêm nước dừa tươi xâm xấp mặt thịt, hạ nhỏ lửa đun 25 phút.',
        'Bước 4: Cho trứng gà luộc đã bóc vỏ vào kho cùng cho thấm vị đến khi nước sệt lên màu cánh gián.',
      ];
    }
    if (t.contains('tôm hấp dừa')) {
      return [
        'Bước 1: Tôm tươi rửa sạch, cắt bỏ râu và kiếm tôm.',
        'Bước 2: Chặt quả dừa lấy nước, cho nước dừa vào nồi cùng ít cọng sả đập dập đun sôi.',
        'Bước 3: Cho tôm vào hấp trong nước dừa 5-7 phút đến khi tôm chuyển màu đỏ cam bóng đẹp.',
        'Bước 4: Xếp tôm quanh miệng quả dừa, chan ít nước dừa hấp lên và dùng nóng với muối tiêu chanh.',
      ];
    }
    return [
      'Bước 1: Sơ chế các nguyên liệu sạch sẽ, thái miếng vừa ăn.',
      'Bước 2: Tẩm ướp gia vị vừa ăn trong 10-15 phút.',
      'Bước 3: Chế biến theo phương pháp xào/nấu/kho với lửa vừa đến khi chín tới.',
      'Bước 4: Bày ra đĩa, trang trí rau thơm và thưởng thức cùng gia đình.',
    ];
  }

  String _getLocalTipForRecipe(String title) {
    final t = title.toLowerCase();

    if (t.contains('sandwich') || t.contains('mứt dâu') || t.contains('bánh mì')) {
      return 'Mẹo tại Châu Âu/Phần Lan: Bạn có thể dễ dàng mua bánh mì sandwich lúa mạch (Ruisleipä) và mứt dâu tây Lingonberry/Strawberry Jam tự nhiên tại các siêu thị Prisma hoặc K-Market.';
    }

    if (t.contains('phở') || t.contains('bún')) {
      return 'Mẹo tại Châu Âu/Phần Lan: Bánh phở khô, bún khô và bộ gia vị Phở/Bún Việt Nam chuẩn vị có bán sẵn tại các chợ Á Châu địa phương (như Aasia Market, Jiahe).';
    }

    if (t.contains('cá hồi') || t.contains('cá')) {
      return 'Mẹo tại Châu Âu/Phần Lan: Cá hồi (Lohi) ở Bắc Âu cực kỳ tươi ngon và giá tốt. Bạn nên mua file lườn cá hồi tươi tại K-Citymarket hoặc Lidl.';
    }

    return 'Mẹo tại Châu Âu/Phần Lan: Có thể thay thế các loại rau nhiệt đới bằng rau bina tươi (Spinach), cải thìa hoặc xà lách mỡ địa phương tại siêu thị gần nhà.';
  }
}
