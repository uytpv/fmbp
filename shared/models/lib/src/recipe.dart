import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe.freezed.dart';
part 'recipe.g.dart';

@freezed
abstract class Recipe with _$Recipe {
  const factory Recipe({
    required String id,
    required String title,
    @Default([]) List<String> instructions,
    @Default(4) int servings,
    @Default(15) int prepTime, // phút
    @Default(30) int cookTime, // phút
    @Default('AI_SYSTEM') String creatorId,
    @Default(true) bool isPublic,
    @Default('ANY') String mealType, // BREAKFAST, LUNCH, DINNER, ANY
    @Default('VIETNAMESE') String cuisine, // VIETNAMESE, FINNISH, EUROPEAN, ASIAN, MEDITERRANEAN, HEALTHY, etc.
    @Default('BALANCED') String complexity, // FAST_15, FAST_30, BALANCED, ELABORATE
    @Default([]) List<String> dietaryTags, // VEGAN, VEGETARIAN, HEALTHY, KETO, etc.
    @Default(0.0) double estimatedCost,
    @Default('EUR') String currency,
    @JsonKey(fromJson: _ingredientsFromJson) @Default([]) List<Map<String, dynamic>> ingredients,
    String? localTip,
    @Default(1) int usageCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Recipe;

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
}

List<Map<String, dynamic>> _ingredientsFromJson(dynamic json) {
  if (json == null || json is! List) return [];
  return json.map((e) => Map<String, dynamic>.from(e as Map)).toList();
}
