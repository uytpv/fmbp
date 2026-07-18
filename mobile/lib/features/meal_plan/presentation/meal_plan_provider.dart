import 'package:fmbp_models/fmbp_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/services/ai_gateway_service.dart';
import '../../../core/services/firebase_auth_service.dart';
import '../../../core/services/firestore_service.dart';
import '../../budget/presentation/budget_provider.dart';
import '../../pantry/presentation/pantry_provider.dart';

part 'meal_plan_provider.g.dart';

@riverpod
class MealPlanState extends _$MealPlanState {
  @override
  Stream<MealPlan?> build() {
    final user = ref.watch(firebaseAuthServiceProvider).currentUser;
    if (user == null) {
      return Stream.value(null);
    }

    return ref.watch(firestoreServiceProvider).watchUser(user.uid).asyncExpand((userDoc) {
      if (userDoc == null || userDoc.familyId == null) {
        return Stream.value(null);
      }
      return ref.watch(firestoreServiceProvider).watchCurrentMealPlan(userDoc.familyId!);
    });
  }

  /// Gọi AI để lấy gợi ý thực đơn tuần mới
  Future<void> requestAISuggestions() async {
    final aiService = ref.read(aiGatewayServiceProvider);
    final firestore = ref.read(firestoreServiceProvider);
    
    // Lấy ngân sách và tủ lạnh hiện tại
    final budget = ref.read(budgetStateProvider).value;
    final pantry = ref.read(pantryStateProvider).value ?? [];
    final userDoc = await firestore.watchUser(ref.read(firebaseAuthServiceProvider).currentUser!.uid).first;

    if (budget == null || userDoc == null || userDoc.familyId == null) {
      throw Exception('Vui lòng hoàn thành thiết lập ngân sách trước khi lập thực đơn');
    }

    // 1. Gọi AI Gateway lấy thực đơn gợi ý
    final aiResult = await aiService.suggestMenu(
      weeklyBudget: budget.allocatedAmount,
      pantryItems: pantry,
    );

    // 2. Tạo một MealPlan mới từ kết quả của AI
    final planId = const Uuid().v4();
    final mealPlan = MealPlan(
      id: planId,
      familyId: userDoc.familyId!,
      startDate: budget.startDate,
      endDate: budget.endDate,
      totalEstimatedCost: aiResult['total_estimated_cost'] ?? 0,
      status: 'ACTIVE',
    );

    await firestore.saveMealPlan(userDoc.familyId!, mealPlan);
  }

  /// Hủy/Hoàn thành thực đơn tuần hiện tại
  Future<void> updateMealPlanStatus(String status) async {
    final firestore = ref.read(firestoreServiceProvider);
    final currentPlan = state.value;
    if (currentPlan != null) {
      final updated = currentPlan.copyWith(status: status);
      await firestore.saveMealPlan(currentPlan.familyId, updated);
    }
  }
}
