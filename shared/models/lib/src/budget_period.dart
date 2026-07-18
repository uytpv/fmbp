import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_period.freezed.dart';
part 'budget_period.g.dart';

@freezed
abstract class BudgetPeriod with _$BudgetPeriod {
  const factory BudgetPeriod({
    required String id,
    required String familyId,
    required DateTime startDate,
    required DateTime endDate,
    required int allocatedAmount, // integer VNĐ
    required int spentAmount,     // integer VNĐ
  }) = _BudgetPeriod;

  factory BudgetPeriod.fromJson(Map<String, dynamic> json) => _$BudgetPeriodFromJson(json);
}
