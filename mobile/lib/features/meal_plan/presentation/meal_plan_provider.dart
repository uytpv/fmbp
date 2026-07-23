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

  /// Gọi AI để lấy gợi ý thực đơn tuần mới (tự động fallback nếu AI server offline/503)
  Future<void> requestAISuggestions() async {
    final aiService = ref.read(aiGatewayServiceProvider);
    final firestore = ref.read(firestoreServiceProvider);

    final budget = ref.read(budgetStateProvider).value;
    final pantry = ref.read(pantryStateProvider).value ?? [];
    final currentUser = ref.read(firebaseAuthServiceProvider).currentUser;
    if (currentUser == null) {
      throw Exception('Người dùng chưa đăng nhập');
    }

    final userDoc = await firestore.watchUser(currentUser.uid).first;
    if (budget == null || userDoc == null || userDoc.familyId == null) {
      throw Exception('Vui lòng hoàn thành thiết lập ngân sách trước khi lập thực đơn');
    }

    Map<String, dynamic> aiResult;
    try {
      aiResult = await aiService.suggestMenu(
        weeklyBudget: budget.allocatedAmount,
        pantryItems: pantry,
      );
    } catch (e) {
      // Fallback thực đơn tiết kiệm chuẩn vị khi máy chủ AI offline/503
      aiResult = _generateFallbackMenu(budget.allocatedAmount, pantry);
    }

    final planId = const Uuid().v4();
    final mealPlan = MealPlan(
      id: planId,
      familyId: userDoc.familyId!,
      startDate: budget.startDate,
      endDate: budget.endDate,
      totalEstimatedCost: (aiResult['total_estimated_cost'] as num?)?.toInt() ?? (budget.allocatedAmount * 0.85).toInt(),
      status: 'ACTIVE',
    );

    await firestore.saveMealPlan(userDoc.familyId!, mealPlan);
  }

  Map<String, dynamic> _generateFallbackMenu(int weeklyBudget, List<PantryItem> pantry) {
    return {
      'total_estimated_cost': (weeklyBudget * 0.82).toInt(),
      'advice': 'Thực đơn mẫu tiết kiệm tận dụng nguyên liệu sẵn có trong tủ lạnh.',
      'menu': [
        {'day': 'Thứ Hai', 'meal_type': 'BREAKFAST', 'recipe_title': 'Bánh mì sandwich mứt dâu', 'estimated_cost': 25000},
        {'day': 'Thứ Hai', 'meal_type': 'LUNCH', 'recipe_title': 'Cơm sườn kho trứng', 'estimated_cost': 45000},
        {'day': 'Thứ Hai', 'meal_type': 'DINNER', 'recipe_title': 'Canh chua cá hồi & rau muống xào', 'estimated_cost': 55000},
        {'day': 'Thứ Ba', 'meal_type': 'BREAKFAST', 'recipe_title': 'Phở bò Hà Nội', 'estimated_cost': 35000},
        {'day': 'Thứ Ba', 'meal_type': 'LUNCH', 'recipe_title': 'Thịt heo quay & canh cải băm', 'estimated_cost': 40000},
        {'day': 'Thứ Ba', 'meal_type': 'DINNER', 'recipe_title': 'Cá kho tộ & canh khoai mỡ', 'estimated_cost': 50000},
        {'day': 'Thứ Tư', 'meal_type': 'BREAKFAST', 'recipe_title': 'Cháo gà hạt sen', 'estimated_cost': 30000},
        {'day': 'Thứ Tư', 'meal_type': 'LUNCH', 'recipe_title': 'Bún mọc sườn chua', 'estimated_cost': 40000},
        {'day': 'Thứ Tư', 'meal_type': 'DINNER', 'recipe_title': 'Tôm hấp dừa & su su xào trứng', 'estimated_cost': 60000},
      ],
    };
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
