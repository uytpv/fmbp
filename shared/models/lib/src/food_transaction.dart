import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_transaction.freezed.dart';
part 'food_transaction.g.dart';

@freezed
class FoodTransaction with _$FoodTransaction {
  const factory FoodTransaction({
    required String id,
    required String budgetPeriodId,
    required int amount, // integer VNĐ
    required String transactionType, // GROCERY, DINING_OUT, EXPERT_RECIPE
    required String description,
    required DateTime createdAt,
  }) = _FoodTransaction;

  factory FoodTransaction.fromJson(Map<String, dynamic> json) => _$FoodTransactionFromJson(json);
}
