import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe_ingredient.freezed.dart';
part 'recipe_ingredient.g.dart';

@freezed
abstract class RecipeIngredient with _$RecipeIngredient {
  const factory RecipeIngredient({
    required String recipeId,
    required String ingredientId,
    required double quantity,
    required String unit,
  }) = _RecipeIngredient;

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) => _$RecipeIngredientFromJson(json);
}
