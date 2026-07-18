import 'package:freezed_annotation/freezed_annotation.dart';

part 'pantry_batch.freezed.dart';
part 'pantry_batch.g.dart';

@freezed
class PantryBatch with _$PantryBatch {
  const factory PantryBatch({
    required String pantryItemId,
    required DateTime purchaseDate,
    required DateTime expirationDate,
    required double quantity,
  }) = _PantryBatch;

  factory PantryBatch.fromJson(Map<String, dynamic> json) => _$PantryBatchFromJson(json);
}
