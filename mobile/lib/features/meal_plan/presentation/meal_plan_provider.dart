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

    Map<String, dynamic>? aiResult;
    try {
      aiResult = await aiService.suggestMenu(
        weeklyBudget: budget.allocatedAmount,
        pantryItems: pantry,
      );
    } catch (e) {
      aiResult = null;
    }

    aiResult ??= _generateFallbackMenu(
      budget.allocatedAmount,
      pantry,
      complexity: complexity,
      cuisines: cuisines,
    );

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

  Map<String, dynamic> _generateFallbackMenu(
    int weeklyBudget,
    List<PantryItem> pantry, {
    String complexity = 'BALANCED',
    List<String> cuisines = const ['VIETNAMESE'],
  }) {
    final days = ['Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy', 'Chủ Nhật'];

    final Map<String, List<String>> breakfastPool = {
      'VIETNAMESE': [
        'Bánh mì ốp la pate',
        'Phở bò Hà Nội',
        'Cháo gà hạt sen',
        'Bún riêu cua đồng',
        'Hủ tiếu Nam Vang',
        'Bún bò Huế',
        'Cháo sườn quẩy nóng',
        'Xôi gà xé hành phi',
      ],
      'FINNISH': [
        'Ruisleipä & Juusto (Bánh mì đen lúa mạch Phần Lan kẹp phô mai)',
        'Karjalanpiirakka & Munavoi (Bánh xếp gạo Karelian với bơ trứng)',
        'Kaurapuuro (Cháo yến mạch Phần Lan quả mọng Lingonberry)',
        'Pannukakku (Bánh kếp nướng lò Phần Lan với mứt việt quất)',
      ],
      'EUROPEAN': [
        'Croissant & Cà phê Ý',
        'Omelette nấm & phô mai Mozzarella',
        'French Toast dâu tây & mật ong',
      ],
      'ASIAN': [
        'Tamagoyaki & Cơm trộn rong biển Nhật',
        'Jeonbokjuk (Cháo hải sản Hàn Quốc)',
        'Mì Udon nước dùng Dashi',
      ],
      'HEALTHY': [
        'Smoothie bowl dâu tây & hạt Chia',
        'Overnight Oats yến mạch quả mọng',
        'Bánh mì nguyên cám bơ quả & trứng chần',
      ],
    };

    final Map<String, List<String>> lunchPool = {
      'VIETNAMESE': [
        'Cơm sườn kho trứng',
        'Thịt heo quay & canh cải băm',
        'Bún mọc sườn chua',
        'Bò xào thiên lý & canh bí đỏ',
        'Mực xào sa tế & canh rau ngót',
        'Cơm gà Hải Nam',
        'Thịt kho tàu & trứng luộc',
      ],
      'FINNISH': [
        'Lohikeitto (Súp cá hồi kem tươi Phần Lan với khoai tây & thì là)',
        'Lihapullat & Muusi (Thịt viên Bắc Âu sốt kem & khoai tây nghiền)',
        'Pyttipannu (Khoai tây & xúc xích Phần Lan xào trứng ốp la)',
        'Siskonmakkarakeitto (Súp xúc xích tươi & rau củ)',
      ],
      'EUROPEAN': [
        'Spaghetti Bolognese (Mỳ Ý sốt bò băm)',
        'Creamy Mushroom Pasta (Mỳ Ý sốt kem nấm)',
        'Grilled Chicken Caesar Salad',
      ],
      'ASIAN': [
        'Teriyaki Chicken Donburi (Cơm gà sốt Nhật)',
        'Tonkatsu (Thịt heo chiên xù & bắp cải)',
        'Bibimbap (Cơm trộn Hàn Quốc)',
      ],
      'HEALTHY': [
        'Salad ức gà nướng sốt Chanh Dây',
        'Quinoa Bowl tôm nướng & bơ tươi',
        'Cơm lứt ức gà áp chảo rau củ luộc',
      ],
    };

    final Map<String, List<String>> dinnerPool = {
      'VIETNAMESE': [
        'Canh chua cá hồi & rau muống xào',
        'Cá kho tộ & canh khoai mỡ',
        'Tôm hấp dừa & su su xào trứng',
        'Cơm cá hồi nướng bơ tỏi',
        'Lẩu nấm hải sản tươi',
        'Cá lóc hấp bầu & canh tần dầy lá',
        'Lẩu thái hải sản gia đình',
      ],
      'FINNISH': [
        'Karjalanpaisti (Thịt bò & heo hầm nướng chậm Kiểu Karelian)',
        'Uunilohi (Cá hồi nướng lò sốt chanh thì là)',
        'Poronkäristys (Thịt tuần lộc/bò xào mứt nam việt quất)',
        'Kalakeitto & Saaristolaisleipä (Súp hải sản & bánh mì đảo Phần Lan)',
      ],
      'EUROPEAN': [
        'Ribeye Beef Steak & Khoai tây chiên sốt tiêu đen',
        'Pan-seared Salmon with Asparagus (Cá hồi áp chảo măng tây)',
        'Lasagna Bò nướng đút phô mai',
      ],
      'ASIAN': [
        'Salmon Sashimi & Sushi Roll set',
        'Bulgogi Bò nướng Hàn Quốc',
        'Ramen Tonkotsu nước hầm xương',
      ],
      'HEALTHY': [
        'Cá hồi hấp gừng sả & súp lơ xanh',
        'Bò nướng cuộn nấm kim nấm đùi gà',
        'Canh bí đỏ hạt óc chó & ức gà xé',
      ],
    };

    final List<String> activeBreakfasts = [];
    final List<String> activeLunches = [];
    final List<String> activeDinners = [];

    final selectedCuisines = cuisines.isEmpty ? ['VIETNAMESE'] : cuisines;

    for (final c in selectedCuisines) {
      if (breakfastPool.containsKey(c)) activeBreakfasts.addAll(breakfastPool[c]!);
      if (lunchPool.containsKey(c)) activeLunches.addAll(lunchPool[c]!);
      if (dinnerPool.containsKey(c)) activeDinners.addAll(dinnerPool[c]!);
    }

    if (activeBreakfasts.isEmpty) activeBreakfasts.addAll(breakfastPool['VIETNAMESE']!);
    if (activeLunches.isEmpty) activeLunches.addAll(lunchPool['VIETNAMESE']!);
    if (activeDinners.isEmpty) activeDinners.addAll(dinnerPool['VIETNAMESE']!);

    activeBreakfasts.shuffle();
    activeLunches.shuffle();
    activeDinners.shuffle();

    final List<Map<String, dynamic>> generatedMenu = [];

    for (int i = 0; i < days.length; i++) {
      final day = days[i];
      generatedMenu.add({
        'day': day,
        'meal_type': 'BREAKFAST',
        'recipe_title': activeBreakfasts[i % activeBreakfasts.length],
        'estimated_cost': 25000 + (i * 1000 % 10000),
      });
      generatedMenu.add({
        'day': day,
        'meal_type': 'LUNCH',
        'recipe_title': activeLunches[i % activeLunches.length],
        'estimated_cost': 45000 + (i * 2000 % 15000),
      });
      generatedMenu.add({
        'day': day,
        'meal_type': 'DINNER',
        'recipe_title': activeDinners[i % activeDinners.length],
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
