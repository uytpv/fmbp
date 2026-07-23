import 'package:freezed_annotation/freezed_annotation.dart';

part 'fixed_expense.freezed.dart';
part 'fixed_expense.g.dart';

@freezed
abstract class FixedExpense with _$FixedExpense {
  const factory FixedExpense({
    required String id,
    required String title,
    required double amount,
    int? termMonths, // Thời hạn tính theo tháng (nếu có, VD: 12 tháng trả góp xe)
    String? category, // Ví dụ: 'housing', 'vehicle', 'loan', 'utility', 'education', 'insurance', 'other'
  }) = _FixedExpense;

  factory FixedExpense.fromJson(Map<String, dynamic> json) => _$FixedExpenseFromJson(json);
}
