import 'package:freezed_annotation/freezed_annotation.dart';

part 'meal_plan_item.freezed.dart';
part 'meal_plan_item.g.dart';

@freezed
class MealPlanItem with _$MealPlanItem {
  const factory MealPlanItem({
    required String mealPlanId,
    required DateTime date,
    required String mealType, // BREAKFAST, LUNCH, DINNER, SNACK
    required String recipeId,
    required int servings,
  }) = _MealPlanItem;

  factory MealPlanItem.fromJson(Map<String, dynamic> json) => _$MealPlanItemFromJson(json);
}
