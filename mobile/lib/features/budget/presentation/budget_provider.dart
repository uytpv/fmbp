import 'package:fmbp_models/fmbp_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/services/firebase_auth_service.dart';
import '../../../core/services/firestore_service.dart';

part 'budget_provider.g.dart';

@riverpod
class BudgetState extends _$BudgetState {
  @override
  Stream<BudgetPeriod?> build() {
    final userStream = ref.watch(authStateChangesProvider);
    final user = userStream.value;

    if (user == null) {
      return Stream.value(null);
    }

    // Lấy family_id của user từ Firestore
    return ref.watch(firestoreServiceProvider).watchUser(user.uid).asyncExpand((userDoc) {
      if (userDoc == null || userDoc.familyId == null) {
        return Stream.value(null);
      }
      return ref.watch(firestoreServiceProvider).watchCurrentBudget(userDoc.familyId!);
    });
  }

  /// Cập nhật hạn mức ngân sách tuần
  Future<void> updateBudgetLimit(int newAmount) async {
    final firestore = ref.read(firestoreServiceProvider);
    final currentBudget = state.value;

    if (currentBudget != null) {
      final updatedBudget = currentBudget.copyWith(allocatedAmount: newAmount);
      await firestore.setBudget(currentBudget.familyId, updatedBudget);
    }
  }

  /// Ghi nhận giao dịch chi tiêu mới
  Future<void> recordTransaction(int amount, String type, String description) async {
    final firestore = ref.read(firestoreServiceProvider);
    final currentBudget = state.value;

    if (currentBudget != null) {
      final tx = FoodTransaction(
        id: const Uuid().v4(),
        budgetPeriodId: currentBudget.id,
        amount: amount,
        transactionType: type,
        description: description,
        createdAt: DateTime.now(),
      );

      await firestore.addTransaction(currentBudget.familyId, tx);
    }
  }
}
