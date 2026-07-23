import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../../../shared/utils/currency_formatter.dart';
import '../../../shared/widgets/app_card.dart';

class RecipeDetailBottomSheet extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                        recipeTitle,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$dayName • Bữa $mealType',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
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
                          CurrencyFormatter.format(estimatedCost, currency),
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
                          '$prepTime • $complexity',
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
            Text(
              '🥑 Thành Phần & Nguyên Liệu Cần Thiết',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Sample Ingredients List
            Column(
              children: (ingredients.isNotEmpty ? ingredients : _getSampleIngredients()).map((ing) {
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
                          localTip,
                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Close button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Đóng'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getSampleIngredients() {
    return [
      {'name': 'Cá hồi tươi / Thịt nạc', 'quantity': '300', 'unit': 'g', 'inPantry': true},
      {'name': 'Rau muống / Cải bina', 'quantity': '1', 'unit': 'bó', 'inPantry': false},
      {'name': 'Cà chua / Củ quả', 'quantity': '2', 'unit': 'quả', 'inPantry': true},
      {'name': 'Gia vị mắm muối', 'quantity': '1', 'unit': 'ít', 'inPantry': true},
    ];
  }
}
