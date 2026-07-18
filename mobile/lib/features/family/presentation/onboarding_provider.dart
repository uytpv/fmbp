import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fmbp_models/fmbp_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/services/firebase_auth_service.dart';
import '../../../core/services/firestore_service.dart';

part 'onboarding_provider.g.dart';

@riverpod
class OnboardingStateNotifier extends _$OnboardingStateNotifier {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> setupFamilyAndBudget({
    required String familyName,
    required int weeklyBudgetAmount,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = ref.read(firebaseAuthServiceProvider).currentUser;
      if (user == null) {
        throw Exception('Người dùng chưa đăng nhập');
      }

      final firestore = ref.read(firestoreServiceProvider);

      // 1. Tạo nhóm gia đình mới (đồng thời cập nhật user.family_id và role sang OWNER)
      final familyId = await firestore.createFamilyGroup(familyName, user.uid);

      // 2. Thiết lập ngân sách tuần đầu tiên
      final now = DateTime.now();
      // Tìm ngày thứ hai đầu tuần và ngày chủ nhật cuối tuần
      final monday = now.subtract(Duration(days: now.weekday - 1));
      final startOfWeek = DateTime(monday.year, monday.month, monday.day);
      final endOfWeek = startOfWeek.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

      final budgetId = const Uuid().v4();
      final firstBudget = BudgetPeriod(
        id: budgetId,
        familyId: familyId,
        startDate: startOfWeek,
        endDate: endOfWeek,
        allocatedAmount: weeklyBudgetAmount,
        spentAmount: 0,
      );

      await firestore.setBudget(familyId, firstBudget);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
