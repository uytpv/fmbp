import 'package:freezed_annotation/freezed_annotation.dart';

part 'meal_plan.freezed.dart';
part 'meal_plan.g.dart';

@freezed
abstract class MealPlan with _$MealPlan {
  const factory MealPlan({
    required String id,
    required String familyId,
    required DateTime startDate,
    required DateTime endDate,
    required int totalEstimatedCost, // integer VNĐ
    required String status,          // DRAFT, ACTIVE, COMPLETED
  }) = _MealPlan;

  factory MealPlan.fromJson(Map<String, dynamic> json) => _$MealPlanFromJson(json);
}
