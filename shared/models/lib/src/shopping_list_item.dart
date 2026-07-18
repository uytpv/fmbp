import 'package:freezed_annotation/freezed_annotation.dart';

part 'shopping_list_item.freezed.dart';
part 'shopping_list_item.g.dart';

@freezed
class ShoppingListItem with _$ShoppingListItem {
  const factory ShoppingListItem({
    required String shoppingListId,
    required String ingredientId,
    required double quantityNeeded,
    required double quantityPurchased,
    required String unit,
    required bool isChecked,
    required int estimatedPrice, // integer VNĐ
  }) = _ShoppingListItem;

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) => _$ShoppingListItemFromJson(json);
}
