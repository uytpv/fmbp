import 'package:freezed_annotation/freezed_annotation.dart';

part 'shopping_list.freezed.dart';
part 'shopping_list.g.dart';

@freezed
abstract class ShoppingList with _$ShoppingList {
  const factory ShoppingList({
    required String id,
    required String familyId,
    required DateTime targetDate,
    required String status,          // PENDING, ACTIVE, COMPLETED
  }) = _ShoppingList;

  factory ShoppingList.fromJson(Map<String, dynamic> json) => _$ShoppingListFromJson(json);
}
