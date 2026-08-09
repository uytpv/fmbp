import 'package:fmbp_models/fmbp_models.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/services/ai_gateway_service.dart';
import '../../../core/services/firebase_auth_service.dart';
import '../../../core/services/firestore_service.dart';
import '../../budget/presentation/budget_provider.dart';
import '../../pantry/presentation/pantry_provider.dart';
import '../../../core/utils/recipe_ingredient_parser.dart';

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

    final currentUser = ref.read(firebaseAuthServiceProvider).currentUser;
    if (currentUser == null) {
      throw Exception('Người dùng chưa đăng nhập');
    }

    User? userDoc;
    try {
      userDoc = await firestore.getUser(currentUser.uid);
    } catch (_) {}

    if (userDoc == null) {
      await firestore.ensureUserDocument(currentUser.uid, currentUser.email ?? '');
      userDoc = await firestore.getUser(currentUser.uid);
    }

    String? familyId = userDoc?.familyId;
    if (familyId == null || familyId.isEmpty) {
      familyId = await firestore.createFamilyGroup('Gia Đình Tôi', currentUser.uid);
    }

    var budget = ref.read(budgetStateProvider).value;
    if (budget == null) {
      final now = DateTime.now();
      budget = BudgetPeriod(
        id: const Uuid().v4(),
        familyId: familyId,
        startDate: now,
        endDate: now.add(const Duration(days: 7)),
        allocatedAmount: 100,
        spentAmount: 0,
      );
      try {
        await firestore.setBudget(familyId, budget);
      } catch (_) {}
    }

    final pantry = ref.read(pantryStateProvider).value ?? [];

    String currency = 'EUR';
    try {
      final familyGroup = await firestore.watchFamily(familyId).first.timeout(const Duration(seconds: 2));
      if (familyGroup != null) {
        currency = familyGroup.currency;
      }
    } catch (_) {}

    const memberCount = 4;
    const location = 'FI';

    Map<String, dynamic>? aiResult;
    try {
      aiResult = await aiService.suggestMenu(
        weeklyBudget: budget.allocatedAmount,
        currency: currency,
        location: location,
        memberCount: memberCount,
        cuisines: cuisines,
        complexity: complexity,
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
    final now = DateTime.now();
    final mealPlan = MealPlan(
      id: planId,
      familyId: familyId,
      startDate: now,
      endDate: now.add(const Duration(days: 7)),
      totalEstimatedCost: (aiResult['total_estimated_cost'] as num?)?.toInt() ?? (budget.allocatedAmount * 0.85).toInt(),
      status: 'ACTIVE',
      items: rawMenu,
    );

    await firestore.saveMealPlan(familyId, mealPlan);
  }

  Map<String, dynamic> _generateFallbackMenu(
    int weeklyBudget,
    List<PantryItem> pantry, {
    String complexity = 'BALANCED',
    List<String> cuisines = const ['VIETNAMESE'],
  }) {
    final List<String> days = List.generate(7, (index) {
      final targetDate = DateTime.now().add(Duration(days: index));
      final dateStr = DateFormat('dd/MM').format(targetDate);
      if (index == 0) return 'Hôm nay ($dateStr)';
      if (index == 1) return 'Ngày mai ($dateStr)';
      switch (targetDate.weekday) {
        case DateTime.monday: return 'Thứ Hai ($dateStr)';
        case DateTime.tuesday: return 'Thứ Ba ($dateStr)';
        case DateTime.wednesday: return 'Thứ Tư ($dateStr)';
        case DateTime.thursday: return 'Thứ Năm ($dateStr)';
        case DateTime.friday: return 'Thứ Sáu ($dateStr)';
        case DateTime.saturday: return 'Thứ Bảy ($dateStr)';
        case DateTime.sunday: return 'Chủ Nhật ($dateStr)';
        default: return dateStr;
      }
    });

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

    final bool isExtremeSurvival = weeklyBudget < 70;

    if (isExtremeSurvival) {
      activeBreakfasts.clear();
      activeLunches.clear();
      activeDinners.clear();

      activeBreakfasts.addAll([
        'Kaurapuuro (Cháo yến mạch Phần Lan quả mọng)',
        'Bánh mì lúa mạch kẹp trứng luộc',
        'Pannukakku (Bánh kếp nướng lò)',
      ]);
      activeLunches.addAll([
        'Súp khoai tây nghiền & bơ tỏi (Muusi)',
        'Cơm chiên trứng bắp cải tiết kiệm',
        'Mỳ xào trứng & bắp cải thái sợi',
      ]);
      activeDinners.addAll([
        'Muusi & Lihapullat (Khoai tây nghiền & thịt viên tiết kiệm)',
        'Súp hầm khoai tây & cà rốt',
        'Cơm bắp cải xào trứng & nước tương',
      ]);
    } else {
      activeBreakfasts.shuffle();
      activeLunches.shuffle();
      activeDinners.shuffle();
    }

    final double dailyBudget = weeklyBudget / 7.0;
    final num bfCost = double.parse((dailyBudget * 0.20).toStringAsFixed(2));
    final num luCost = double.parse((dailyBudget * 0.35).toStringAsFixed(2));
    final num dnCost = double.parse((dailyBudget * 0.45).toStringAsFixed(2));

    final List<Map<String, dynamic>> generatedMenu = [];

    for (int i = 0; i < days.length; i++) {
      final day = days[i];
      final bfTitle = activeBreakfasts[i % activeBreakfasts.length];
      final luTitle = activeLunches[i % activeLunches.length];
      final dnTitle = activeDinners[i % activeDinners.length];

      generatedMenu.add({
        'day': day,
        'meal_type': 'BREAKFAST',
        'recipe_title': bfTitle,
        'estimated_cost': bfCost,
        'ingredients': RecipeIngredientParser.parseMealPlanToShoppingList(recipeTitles: [bfTitle], memberCount: 4, pantryItems: []),
      });
      generatedMenu.add({
        'day': day,
        'meal_type': 'LUNCH',
        'recipe_title': luTitle,
        'estimated_cost': luCost,
        'ingredients': RecipeIngredientParser.parseMealPlanToShoppingList(recipeTitles: [luTitle], memberCount: 4, pantryItems: []),
      });
      generatedMenu.add({
        'day': day,
        'meal_type': 'DINNER',
        'recipe_title': dnTitle,
        'estimated_cost': dnCost,
        'ingredients': RecipeIngredientParser.parseMealPlanToShoppingList(recipeTitles: [dnTitle], memberCount: 4, pantryItems: []),
      });
    }

    return {
      'budget_status': isExtremeSurvival ? 'SURVIVAL' : 'BALANCED',
      'min_recommended_budget': 70,
      'total_estimated_cost': (weeklyBudget * 0.85).toInt(),
      'advice': isExtremeSurvival
          ? '⚠️ CẢNH BÁO NGHÊM TRỌNG: Ngân sách €$weeklyBudget cho 4 người là quá thấp (Khuyến nghị tối thiểu €70/tuần). Thực đơn đã tự động chuyển sang Chế Độ Tiết Kiệm Cực Hạn bằng cách lặp lại Khoai tây, Yến mạch và Trứng để mua sỉ tối ưu chi phí.'
          : 'Thực đơn phong phú tự động cân bằng dinh dưỡng và tiết kiệm ngân sách.',
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
