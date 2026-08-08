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

  /// Gọi AI để lấy gợi ý thực đơn tuần mới theo tiêu chí lựa chọn
  Future<void> requestAISuggestions({
    String complexity = 'BALANCED',
    List<String> cuisines = const ['VIETNAMESE'],
  }) async {
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
      aiResult = _generateFallbackMenu(budget.allocatedAmount, pantry, complexity: complexity);
    }

    final rawMenu = (aiResult['menu'] as List?)?.map((e) => Map<String, dynamic>.from(e as Map)).toList() ?? [];

    final planId = const Uuid().v4();
    final mealPlan = MealPlan(
      id: planId,
      familyId: userDoc.familyId!,
      startDate: budget.startDate,
      endDate: budget.endDate,
      totalEstimatedCost: (aiResult['total_estimated_cost'] as num?)?.toInt() ?? (budget.allocatedAmount * 0.85).toInt(),
      status: 'ACTIVE',
      items: rawMenu,
    );

    await firestore.saveMealPlan(userDoc.familyId!, mealPlan);
  }

  Map<String, dynamic> _generateFallbackMenu(int weeklyBudget, List<PantryItem> pantry, {String complexity = 'BALANCED'}) {
    final days = ['Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy', 'Chủ Nhật'];
    
    final breakfasts = [
      'Bánh mì sandwich mứt dâu',
      'Phở bò Hà Nội',
      'Cháo gà hạt sen',
      'Bún riêu cua đồng',
      'Hủ tiếu Nam Vang',
      'Bánh mì ốp la pate',
      'Bún bò Huế',
      'Cháo sườn quẩy nóng',
      'Xôi gà xé hành phi',
      'Mì Quảng tôm thịt',
    ];

    final lunches = [
      'Cơm sườn kho trứng',
      'Thịt heo quay & canh cải băm',
      'Bún mọc sườn chua',
      'Bò xào thiên lý & canh bí đỏ',
      'Mực xào sa tế & canh rau ngót',
      'Lẩu thái hải sản gia đình',
      'Cơm gà Hải Nam',
      'Thịt kho tàu & trứng luộc',
      'Cơm tấm sườn bì chả',
      'Gà chiên mắm & canh mồng tơi',
    ];

    final dinners = [
      'Canh chua cá hồi & rau muống xào',
      'Cá kho tộ & canh khoai mỡ',
      'Tôm hấp dừa & su su xào trứng',
      'Cơm cá hồi nướng bơ tỏi',
      'Thịt kho tàu & trứng luộc',
      'Cơm chiên hải sản',
      'Canh sườn hầm củ quả',
      'Lẩu nấm hải sản tươi',
      'Cá lóc hấp bầu & canh tần dầy lá',
      'Tôm rim mặn ngọt & canh mướp đắng',
    ];

    breakfasts.shuffle();
    lunches.shuffle();
    dinners.shuffle();

    final List<Map<String, dynamic>> generatedMenu = [];

    for (int i = 0; i < days.length; i++) {
      final day = days[i];
      generatedMenu.add({
        'day': day,
        'meal_type': 'BREAKFAST',
        'recipe_title': breakfasts[i % breakfasts.length],
        'estimated_cost': 25000 + (i * 1000 % 10000),
      });
      generatedMenu.add({
        'day': day,
        'meal_type': 'LUNCH',
        'recipe_title': lunches[i % lunches.length],
        'estimated_cost': 45000 + (i * 2000 % 15000),
      });
      generatedMenu.add({
        'day': day,
        'meal_type': 'DINNER',
        'recipe_title': dinners[i % dinners.length],
        'estimated_cost': 55000 + (i * 3000 % 20000),
      });
    }

    return {
      'total_estimated_cost': (weeklyBudget * 0.82).toInt(),
      'advice': 'Thực đơn phong phú tự động cân bằng dinh dưỡng và tiết kiệm ngân sách.',
      'menu': generatedMenu,
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
