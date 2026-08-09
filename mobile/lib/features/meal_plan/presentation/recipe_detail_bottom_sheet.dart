import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fmbp_models/fmbp_models.dart';
import '../../../app/theme.dart';
import '../../../core/services/firebase_auth_service.dart';
import '../../../core/services/firestore_service.dart';
import '../../../shared/utils/currency_formatter.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../core/utils/recipe_ingredient_parser.dart';
import '../../pantry/presentation/pantry_provider.dart';

class RecipeDetailBottomSheet extends ConsumerStatefulWidget {
  final String recipeTitle;
  final String dayName;
  final String mealType;
  final num estimatedCost;
  final String currency;
  final List<Map<String, dynamic>> ingredients;
  final List<String>? cookingSteps;
  final String prepTime;
  final String complexity;
  final String? localTip;

  const RecipeDetailBottomSheet({
    super.key,
    required this.recipeTitle,
    required this.dayName,
    required this.mealType,
    required this.estimatedCost,
    required this.currency,
    this.ingredients = const [],
    this.cookingSteps,
    this.prepTime = '25 phút',
    this.complexity = '⚡ Nấu nhanh (< 30 phút)',
    this.localTip,
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
                                  _formatIngredientQuantity(ing, memberCount),
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

  String _formatIngredientQuantity(Map<String, dynamic> ing, int memberCount) {
    final unit = (ing['unit'] as String?) ?? 'phần';

    num? qtyNum;
    final qVal = ing['quantity'] ?? ing['rawQty'] ?? ing['qty'] ?? ing['amount'];

    if (qVal != null) {
      if (qVal is num) {
        qtyNum = qVal;
      } else if (qVal is String) {
        final cleanStr = qVal.replaceAll(RegExp(r'[^0-9.]'), '');
        if (cleanStr.isNotEmpty) {
          qtyNum = double.tryParse(cleanStr);
        }
      }
    }

    if (qtyNum == null || qtyNum <= 0) {
      final u = unit.toLowerCase();
      if (u == 'g' || u == 'ml') {
        qtyNum = memberCount * 150.0;
      } else if (u == 'kg') {
        qtyNum = memberCount * 0.15;
      } else if (u == 'hũ' || u == 'chai' || u == 'gói' || u == 'bó' || u == 'hộp') {
        qtyNum = memberCount > 2 ? 1.0 : 0.5;
      } else {
        qtyNum = memberCount * 1.0;
      }
    }

    String formattedQty;
    if (unit == 'g' || unit == 'ml') {
      formattedQty = qtyNum >= 1000 ? '${(qtyNum / 1000).toStringAsFixed(1)} kg' : '${qtyNum.toInt()} $unit';
    } else if (unit == 'kg') {
      formattedQty = '${qtyNum.toStringAsFixed(1)} kg';
    } else {
      formattedQty = qtyNum.truncateToDouble() == qtyNum ? '${qtyNum.toInt()} $unit' : '${qtyNum.toStringAsFixed(1)} $unit';
    }

    return formattedQty;
  }

  List<Map<String, dynamic>> _getIngredientsForRecipe(
    String title, {
    required int memberCount,
    required List<PantryItem> pantryItems,
  }) {
    final parsed = RecipeIngredientParser.parseMealPlanToShoppingList(
      recipeTitles: [title],
      memberCount: memberCount,
      pantryItems: [], // Tải đầy đủ danh sách nguyên liệu của món ăn
    );

    if (parsed.isNotEmpty) {
      return parsed.map((item) {
        final name = item['name'] as String;
        final unit = item['unit'] as String;
        final rawQty = item['rawQty'] as double? ?? 1.0;
        final bool inPantry = pantryItems.any((p) {
          final pName = p.ingredientId.toLowerCase();
          final searchName = name.toLowerCase();
          return pName.contains(searchName) || searchName.contains(pName);
        });

        String formattedQty;
        if (unit == 'g' || unit == 'ml') {
          formattedQty = rawQty >= 1000 ? '${(rawQty / 1000).toStringAsFixed(1)}' : '${rawQty.toInt()}';
        } else {
          formattedQty = rawQty.truncateToDouble() == rawQty ? '${rawQty.toInt()}' : rawQty.toStringAsFixed(1);
        }

        return {
          'name': name,
          'quantity': formattedQty,
          'unit': unit,
          'inPantry': inPantry,
        };
      }).toList();
    }

    final t = title.toLowerCase();
    final factor = memberCount <= 0 ? 1 : memberCount;

    bool inPantryCheck(String searchKeyword) {
      final key = searchKeyword.toLowerCase();
      return pantryItems.any((p) {
        final name = p.ingredientId.toLowerCase();
        final loc = p.storageLocation.toLowerCase();
        return name.contains(key) || key.contains(name) || loc.contains(key);
      });
    }

    List<Map<String, dynamic>> dynamicIngs = [];

    if (t.contains('cá hồi') || t.contains('lohi')) {
      dynamicIngs.add({
        'name': 'Lườn cá hồi tươi (Lohifilee)',
        'quantity': '${factor * 150}',
        'unit': 'g',
        'inPantry': inPantryCheck('cá hồi') || inPantryCheck('lohi') || inPantryCheck('salmon'),
      });
      dynamicIngs.add({
        'name': 'Kem tươi / Bơ lạt / Thì là',
        'quantity': '${factor * 50}',
        'unit': 'g',
        'inPantry': inPantryCheck('kem') || inPantryCheck('bơ') || inPantryCheck('thì là'),
      });
    } else if (t.contains('gà')) {
      dynamicIngs.add({
        'name': 'Thịt gà tươi nạc',
        'quantity': '${factor * 150}',
        'unit': 'g',
        'inPantry': inPantryCheck('gà') || inPantryCheck('chicken'),
      });
    } else if (t.contains('bò') || t.contains('steak')) {
      dynamicIngs.add({
        'name': 'Thịt bò phi lê / Ribeye',
        'quantity': '${factor * 150}',
        'unit': 'g',
        'inPantry': inPantryCheck('bò') || inPantryCheck('beef'),
      });
    } else {
      dynamicIngs.add({
        'name': 'Nguyên liệu chính cho $title',
        'quantity': '${factor * 1}',
        'unit': 'phần',
        'inPantry': false,
      });
    }

    return dynamicIngs;
  }

  List<String> _getCookingStepsForRecipe(String title) {
    if (widget.cookingSteps != null && widget.cookingSteps!.isNotEmpty) {
      return widget.cookingSteps!;
    }
    final t = title.toLowerCase();

    if (t.contains('poronkäristys') || t.contains('poronkaristys') || t.contains('tuần lộc') || (t.contains('bò') && t.contains('mứt'))) {
      return [
        'Bước 1: Thái thịt bò / thịt tuần lộc tươi (Poronkäristys) thành lát thật mỏng (dạng bào mỏng).',
        'Bước 2: Cho bơ lạt vào chảo nóng, phi thơm hành tây củ rồi cho thịt vào xào nhanh trên lửa lớn.',
        'Bước 3: Nêm muối tiêu đập dập, rưới chút nước hầm ninh nhỏ lửa 5-8 phút cho thịt mềm mọng.',
        'Bước 4: Bày thịt xào ra đĩa ăn kèm khoai tây nghiền mịn (Muusi) và 1 muỗng mứt nam việt quất (Puolukkahillo) chuẩn vị Phần Lan.',
      ];
    }

    if (t.contains('uunilohi') || (t.contains('cá hồi') && t.contains('nướng'))) {
      return [
        'Bước 1: Rửa sạch lườn cá hồi tươi (Lohifilee), thấm khô và đặt lên khay nướng có lót giấy nướng.',
        'Bước 2: Trộn bơ lạt đun chảy với nước cốt chanh vàng, muối biển, tiêu đen và thì là tươi băm nhỏ.',
        'Bước 3: Rưới đều sốt chanh thì là lên mặt cá hồi, nướng ở 200°C trong 15-18 phút cho thịt cá mọng nước.',
        'Bước 4: Bày cá hồi nướng vàng mọng ra đĩa cùng khoai tây củ nhỏ luộc và trang trí thì là tươi.',
      ];
    }

    if (t.contains('pannukakku') || t.contains('kếp')) {
      return [
        'Bước 1: Đánh tan trứng gà cùng sữa tươi (Maito), thêm bột làm bánh kếp và ít bơ lạt đánh mịn.',
        'Bước 2: Đổ hỗn hợp vào khay nướng có lót giấy nướng lò ở 200°C trong 25-30 phút cho bánh phồng vàng.',
        'Bước 3: Rút khay bánh ra khỏi lò, cắt thành từng miếng vuông hình chữ nhật vừa ăn.',
        'Bước 4: Phết mứt việt quất / nam việt quất (Puolukkahillo) lên mặt bánh và thưởng thức khi còn ấm.',
      ];
    }

    if (t.contains('lohikeitto') || (t.contains('súp') && t.contains('cá hồi'))) {
      return [
        'Bước 1: Thái lườn cá hồi tươi (Lohifilee) thành khối vuông 2-3cm, khoai tây (Peruna) thái hạt lựu.',
        'Bước 2: Đun sôi nước dùng cá, cho khoai tây và hành tây vào ninh 10-12 phút cho khoai mềm.',
        'Bước 3: Hạ nhỏ lửa, thả cá hồi vào rưới kem tươi Cooking Cream (Ruokakerma) khuấy nhẹ 5 phút.',
        'Bước 4: Nêm muối, tiêu đen và rắc thật nhiều thì là tươi cắt nhỏ lên súp trước khi múc ra bát.',
      ];
    }

    if (t.contains('kaurapuuro') || t.contains('cháo yến mạch')) {
      return [
        'Bước 1: Cho yến mạch cán dẹt (Kaurahiutale) và sữa tươi (Maito) vào nồi theo tỷ lệ 1:2.',
        'Bước 2: Đun nhỏ lửa khuấy đều tay trong 5-7 phút đến khi cháo yến mạch nở sánh mịn.',
        'Bước 3: Cho một chút muối bơ lạt vào khuấy đều cho cháo có vị béo ngậy tự nhiên.',
        'Bước 4: Múc cháo ra bát, cho 1 muỗng mứt nam việt quất Lingonberry vào giữa bát và dùng nóng.',
      ];
    }

    if (t.contains('lihapullat') || t.contains('thịt viên')) {
      return [
        'Bước 1: Trộn thịt bò & heo băm nhuyễn với vụn bánh mì, trứng gà, hành tây băm và tiêu.',
        'Bước 2: Vo thịt thành những viên tròn nhỏ, chiên vàng đều các mặt trên chảo bơ lạt.',
        'Bước 3: Rưới kem tươi Cooking Cream vào chảo thịt viên đun nhỏ lửa 8 phút cho sệt sốt kem.',
        'Bước 4: Thưởng thức cùng khoai tây nghiền mịn và mứt nam việt quất (Puolukkahillo) chuẩn vị Phần Lan.',
      ];
    }

    if (t.contains('karjalanpaisti') || t.contains('thịt hầm')) {
      return [
        'Bước 1: Thái thịt bò & heo thành khối lớn, ướp gia vị hầm, lá nguyệt quế và tiêu hạt.',
        'Bước 2: Xếp thịt, cà rốt và hành tây vào nồi gốm nướng lò.',
        'Bước 3: Đổ nước xâm xấp mặt thịt, đậy nắp nướng hầm chậm trong lò 160°C trong 2 - 2.5 giờ.',
        'Bước 4: Thưởng thức thịt hầm mềm mượt tan trong miệng cùng khoai tây luộc và dưa chuột muối.',
      ];
    }

    if (t.contains('spaghetti') || t.contains('bolognese') || t.contains('pasta')) {
      return [
        'Bước 1: Luộc mỳ Ý Spaghetti trong nước sôi có muối 8-10 phút cho chín tới (al dente).',
        'Bước 2: Phi thơm tỏi băm, xào chín thịt bò băm rồi đổ sốt cà chua Ý Bolognese vào đun sệt.',
        'Bước 3: Nêm lá húng tây nướng, tiêu đen và nêm vị vừa ăn.',
        'Bước 4: Trộn mỳ Ý ra đĩa, rưới sốt bò băm lên trên và rắc phô mai Parmesan bào mịn.',
      ];
    }

    if (t.contains('steak') || t.contains('ribeye') || t.contains('bít tết')) {
      return [
        'Bước 1: Thấm khô miếng thịt thăn bò Ribeye, rắc muối biển và tiêu đen đập dập 2 mặt.',
        'Bước 2: Áp chảo thịt bò với dầu olive ở nhiệt độ cao 2-3 phút mỗi mặt cùng tỏi và bơ lạt.',
        'Bước 3: Áp chảo măng tây tươi và khoai tây chiên ăn kèm.',
        'Bước 4: Đặt thịt nghỉ 5 phút trước khi thái lát mỏng, rưới sốt tiêu đen và dùng nóng.',
      ];
    }

    if (t.contains('salad') || t.contains('clean') || t.contains('healthy')) {
      return [
        'Bước 1: Ức gà áp chảo chín vàng hai mặt, thái lát mỏng vừa ăn.',
        'Bước 2: Rửa sạch xà lách tươi và cắt đôi cà chua bi.',
        'Bước 3: Trộn xà lách, cà chua bi và ức gà vào tô lớn.',
        'Bước 4: Rưới sốt Caesar / Chanh Dây Healthy lên trên và trộn đều thưởng thức.',
      ];
    }

    if (t.contains('cơm gà') || t.contains('hải nam')) {
      return [
        'Bước 1: Thịt gà ta luộc chín cùng gừng đập dập và hành tây cho nước dùng ngọt lịm.',
        'Bước 2: Vớt gà ra ngâm nước đá cho da giòn vàng, dùng mỡ gà xào sơ gạo thơm trước khi nấu.',
        'Bước 3: Nấu cơm bằng chính nước dùng gà vừa luộc cho hạt cơm dẻo thơm ngậy màu vàng óng.',
        'Bước 4: Chặt gà thành miếng vừa ăn, xếp ra đĩa cùng cơm dẻo, dưa leo và nước chấm gừng tỏi ớt.',
      ];
    }

    if (t.contains('phở bò')) {
      return [
        'Bước 1: Ninh xương ống lấy nước dùng trong 45 phút cùng gừng nướng, hành khô và bộ gia vị phở.',
        'Bước 2: Sơ chế thịt bò tái thành từng lát mỏng. Chần sơ bánh phở qua nước sôi rồi xếp vào tô.',
        'Bước 3: Xếp thịt bò tái, hành lá, ngò rí lên mặt bánh phở.',
        'Bước 4: Chan nước dùng phở thật sôi vào tô cho thịt bò chín tái vừa tới. Dùng nóng kèm chanh, ớt.',
      ];
    }

    // Phân tích kỹ thuật nấu ăn & loại đạm chính từ tên món ăn để sinh ra 4 bước chuẩn bếp
    String mainProtein = 'thực phẩm tươi';
    if (t.contains('cá')) mainProtein = 'thịt cá tươi fillet';
    if (t.contains('bò')) mainProtein = 'thịt bò tươi ngon';
    if (t.contains('gà')) mainProtein = 'thịt gà tươi nạc';
    if (t.contains('heo') || t.contains('sườn')) mainProtein = 'thịt heo / sườn tươi';
    if (t.contains('tôm') || t.contains('mực')) mainProtein = 'hải sản tươi ngon';

    if (t.contains('nướng') || t.contains('uuni') || t.contains('bake') || t.contains('roast')) {
      return [
        'Bước 1: Rửa sạch $mainProtein và cắt miếng vừa ăn, rửa sạch rau củ nêm kèm theo.',
        'Bước 2: Pha sốt ướp với bơ lạt, tiêu đen, tỏi băm và gia vị thơm. Thoa đều lên mặt $mainProtein.',
        'Bước 3: Xếp vào khay nướng lót giấy bạc, nướng lò ở 190°C - 200°C trong 15-20 phút cho vàng ngậy.',
        'Bước 4: Rưới phần sốt còn lại lên trên, bày ra đĩa ăn kèm khoai tây / cơm dẻo nóng hổi.',
      ];
    }

    if (t.contains('hầm') || t.contains('súp') || t.contains('canh') || t.contains('stew') || t.contains('soup')) {
      return [
        'Bước 1: Sơ chế $mainProtein và rau củ tươi sạch sẽ, thái khối vuông vừa ăn.',
        'Bước 2: Đun sôi nước dùng, cho củ quả ăn kèm vào ninh trước 10 phút cho chín mềm.',
        'Bước 3: Thả $mainProtein vào ninh nhỏ lửa, rưới kem tươi / nước cốt nêm vị vừa ăn.',
        'Bước 4: Rắc hành thì là tươi cắt nhỏ lên trên, múc súp ra bát dùng nóng cùng gia đình.',
      ];
    }

    if (t.contains('xào') || t.contains('áp chảo') || t.contains('pan-seared') || t.contains('fried')) {
      return [
        'Bước 1: Thái mỏng $mainProtein, ướp cùng tỏi băm, tiêu và hạt nêm đậm đà trong 10 phút.',
        'Bước 2: Đun nóng chảo cùng ít dầu olive / bơ lạt, phi thơm hành tỏi.',
        'Bước 3: Cho $mainProtein và rau củ vào đảo nhanh tay trên lửa lớn cho chín tới giữ độ ngọt.',
        'Bước 4: Rưới thêm sốt đậm đà, bày ra đĩa rắc tiêu hạt và dùng nóng.',
      ];
    }

    return [
      'Bước 1: Sơ chế $mainProtein tươi sạch sẽ, ướp cùng chút gia vị bơ tỏi trong 10 phút.',
      'Bước 2: Đun nóng chảo/nồi, phi thơm hành tỏi rồi cho $mainProtein vào chế biến chín tới.',
      'Bước 3: Nêm nếm nước sốt đậm đà cùng rau củ quả tươi cho dậy mùi thơm phức.',
      'Bước 4: Bày ra đĩa rắc chút tiêu tươi, ăn kèm cơm dẻo / khoai tây cùng gia đình.',
    ];
  }

  String _getLocalTipForRecipe(String title) {
    if (widget.localTip != null && widget.localTip!.isNotEmpty) {
      return widget.localTip!;
    }
    final t = title.toLowerCase();

    if (t.contains('pannukakku') || t.contains('kaurapuuro') || t.contains('lihapullat') || t.contains('ruisleipä')) {
      return 'Mẹo tại Châu Âu/Phần Lan: Các nguyên liệu như yến mạch (Kaurahiutale), sữa tươi (Maito), mứt nam việt quất (Puolukkahillo) được bán phổ biến giá cực tốt tại K-Citymarket, Lidl hoặc Prisma.';
    }

    if (t.contains('lohikeitto') || t.contains('cá hồi') || t.contains('lohi')) {
      return 'Mẹo tại Châu Âu/Phần Lan: Cá hồi (Lohi) ở Bắc Âu cực kỳ tươi ngon và giàu Omega-3. Bạn nên chọn file lườn cá hồi tươi tại quầy cá K-Citymarket hoặc Lidl.';
    }

    if (t.contains('phở') || t.contains('bún')) {
      return 'Mẹo tại Châu Âu/Phần Lan: Bánh phở khô, bún khô và bộ gia vị Phở/Bún Việt Nam chuẩn vị có bán sẵn tại các chợ Á Châu địa phương (như Aasia Market, Jiahe).';
    }

    return 'Mẹo tại Châu Âu/Phần Lan: Có thể thay thế các loại rau nhiệt đới bằng rau bina tươi (Spinach), cải thìa hoặc xà lách mỡ địa phương tại siêu thị gần nhà.';
  }
}
