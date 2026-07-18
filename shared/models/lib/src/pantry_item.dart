import 'package:freezed_annotation/freezed_annotation.dart';

part 'pantry_item.freezed.dart';
part 'pantry_item.g.dart';

@freezed
abstract class PantryItem with _$PantryItem {
  const factory PantryItem({
    required String id,
    required String familyId,
    required String ingredientId,
    required double quantity,
    required String unit,
    required String storageLocation, // FRIDGE, FREEZER, PANTRY, CABINET
  }) = _PantryItem;

  factory PantryItem.fromJson(Map<String, dynamic> json) => _$PantryItemFromJson(json);
}
