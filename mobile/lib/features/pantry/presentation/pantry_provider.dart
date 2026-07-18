import 'package:fmbp_models/fmbp_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/services/firebase_auth_service.dart';
import '../../../core/services/firestore_service.dart';

part 'pantry_provider.g.dart';

@riverpod
class PantryState extends _$PantryState {
  @override
  Stream<List<PantryItem>> build() {
    final user = ref.watch(firebaseAuthServiceProvider).currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return ref.watch(firestoreServiceProvider).watchUser(user.uid).asyncExpand((userDoc) {
      if (userDoc == null || userDoc.familyId == null) {
        return Stream.value([]);
      }
      return ref.watch(firestoreServiceProvider).watchPantryItems(userDoc.familyId!);
    });
  }

  /// Cập nhật số lượng của nguyên liệu trong Pantry
  Future<void> updateItemQuantity(PantryItem item, double newQuantity) async {
    final firestore = ref.read(firestoreServiceProvider);
    final updated = item.copyWith(quantity: newQuantity);
    await firestore.updatePantryItem(item.familyId, updated);
  }
}
