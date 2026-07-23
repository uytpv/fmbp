import 'package:freezed_annotation/freezed_annotation.dart';
import 'fixed_expense.dart';

part 'family_group.freezed.dart';
part 'family_group.g.dart';

@freezed
abstract class FamilyGroup with _$FamilyGroup {
  const factory FamilyGroup({
    required String id,
    required String name,
    required String ownerId,
    required DateTime createdAt,
    @Default('VND') String currency,
    double? monthlyIncome,
    @Default([]) List<FixedExpense> fixedExpenses,
  }) = _FamilyGroup;

  factory FamilyGroup.fromJson(Map<String, dynamic> json) => _$FamilyGroupFromJson(json);
}
