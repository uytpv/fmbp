import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fmbp_models/fmbp_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../config/app_config.dart';

part 'ai_gateway_service.g.dart';

class AIGatewayService {
  final Dio _dio;

  AIGatewayService()
      : _dio = Dio(BaseOptions(
          baseUrl: _getDefaultBaseUrl(),
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ));

  static String _getDefaultBaseUrl() {
    const envUrl = String.fromEnvironment('AI_GATEWAY_URL');
    if (envUrl.isNotEmpty) return envUrl;
    if (kIsWeb && !kDebugMode) {
      return '';
    }
    return 'http://${AppConfig.localHost}:5001/fmbp-dev/us-central1/aiGateway';
  }

  /// Gợi ý thực đơn 21 bữa từ AI dựa trên tất cả các tiêu chí cá nhân hóa
  Future<Map<String, dynamic>?> suggestMenu({
    required int weeklyBudget,
    required String currency,
    required String location,
    required int memberCount,
    required List<String> cuisines,
    required String complexity,
    required List<PantryItem> pantryItems,
    List<Map<String, dynamic>> historicalPrices = const [],
  }) async {
    final pantryJson = pantryItems
        .map((item) => <String, dynamic>{
              'name': item.ingredientId,
              'quantity': item.quantity,
              'unit': item.unit,
            })
        .toList();

    // 1. Thử gọi Cloud Function / AI Gateway nếu có baseUrl
    if (_dio.options.baseUrl.isNotEmpty) {
      try {
        final response = await _dio.post(
          '/api/v1/ai/suggest-menu',
          data: {
            'weekly_budget': weeklyBudget,
            'currency': currency,
            'location': location,
            'member_count': memberCount,
            'cuisines': cuisines,
            'complexity': complexity,
            'pantry_items': pantryJson,
            'historical_prices': historicalPrices,
          },
        );
        if (response.statusCode == 200 && response.data != null) {
          return response.data as Map<String, dynamic>;
        }
      } catch (_) {}
    }

    // 2. Nếu không có Backend Server proxy, tự động gọi Gemini API trực tiếp từ Client side
    return await _callDirectGeminiForMenu(
      weeklyBudget: weeklyBudget,
      currency: currency,
      location: location,
      memberCount: memberCount,
      cuisines: cuisines,
      complexity: complexity,
      pantryJson: pantryJson,
      historicalPrices: historicalPrices,
    );
  }

  /// Lấy chi tiết công thức nấu ăn động từ AI
  Future<Map<String, dynamic>?> getRecipeDetail({
    required String recipeTitle,
    required String location,
    required String currency,
  }) async {
    if (_dio.options.baseUrl.isNotEmpty) {
      try {
        final response = await _dio.post(
          '/api/v1/ai/parse-recipe',
          data: {
            'recipe_title': recipeTitle,
            'location': location,
            'currency': currency,
          },
        );
        if (response.statusCode == 200 && response.data != null) {
          return response.data as Map<String, dynamic>;
        }
      } catch (_) {}
    }

    return await _callDirectGeminiForRecipeDetail(
      recipeTitle: recipeTitle,
      location: location,
      currency: currency,
    );
  }

  /// Bóc tách thông tin công thức nấu ăn từ text hoặc URL
  Future<Map<String, dynamic>> parseRecipe(String urlOrText) async {
    final detail = await getRecipeDetail(
      recipeTitle: urlOrText,
      location: 'FI',
      currency: 'EUR',
    );
    return detail ?? {
      'title': urlOrText,
      'instructions': ['Sơ chế nguyên liệu tươi sạch', 'Chế biến và nêm nếm vừa ăn', 'Thưởng thức khi còn nóng'],
      'servings': 4,
      'prep_time': 15,
      'cook_time': 25,
      'ingredients': [],
    };
  }

  /// Gọi Gemini REST API trực tiếp từ Client side
  Future<Map<String, dynamic>?> _callDirectGeminiForMenu({
    required int weeklyBudget,
    required String currency,
    required String location,
    required int memberCount,
    required List<String> cuisines,
    required String complexity,
    required List<Map<String, dynamic>> pantryJson,
    required List<Map<String, dynamic>> historicalPrices,
  }) async {
    const apiKey = String.fromEnvironment('GEMINI_API_KEY');
    if (apiKey.isEmpty) {
      return null;
    }

    try {
      final isEurUsd = ['EUR', 'USD', 'GBP'].contains(currency.toUpperCase());
      final minWeeklyBudgetPerPerson = isEurUsd ? 17.5 : 175000;
      final minRecommendedWeeklyBudget = minWeeklyBudgetPerPerson * memberCount;
      final isExtremeSurvival = weeklyBudget < minRecommendedWeeklyBudget;

      final dio = Dio();
      final url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey';

      final prompt = '''
Bạn là Chuyên gia Dinh dưỡng AI gia đình. Hãy lập thực đơn 21 bữa (Thứ Hai đến Chủ Nhật, 3 bữa Sáng/Trưa/Tối) với các tiêu chí:
- Vị trí địa lý: $location, Tiền tệ: $currency.
- Số thành viên: $memberCount người. Ngân sách tuần: $weeklyBudget $currency. (Mức tối thiểu khuyến nghị: $minRecommendedWeeklyBudget $currency).
- Phong cách ẩm thực yêu cầu: ${cuisines.join(', ')}.
- Mức độ nấu nướng: $complexity.
- Tủ lạnh hiện có: ${jsonEncode(pantryJson)}.
- Lịch sử giá mua thực tế: ${jsonEncode(historicalPrices)}.
${isExtremeSurvival ? '⚠️ CẢNH BÁO: Ngân sách $weeklyBudget $currency cho $memberCount người là CỰC HẠN (quá thấp so với mức tối thiểu $minRecommendedWeeklyBudget $currency). Bạn PHẢI bật Chế Độ Tiết Kiệm Cực Hạn (Extreme Survival Mode): lặp lại các nguyên liệu/món ăn cực rẻ (Khoai tây, Yến mạch, Trứng, Cơm chiên, Bắp cải) để mua sỉ tối ưu ngân sách. "advice" PHẢI ghi rõ ngân sách quá thiếu và đề xuất tăng ngân sách.' : ''}

Yêu cầu trả về đúng cấu trúc JSON:
{
  "budget_status": "${isExtremeSurvival ? 'SURVIVAL' : 'BALANCED'}",
  "min_recommended_budget": $minRecommendedWeeklyBudget,
  "menu": [
    {
      "day": "Thứ Hai",
      "meal_type": "BREAKFAST",
      "recipe_title": "Tên món",
      "estimated_cost": 2.5,
      "ingredients": [
        {"name": "Tên nguyên liệu", "quantity": 150, "unit": "g", "aisle": "Thịt & Hải sản"}
      ],
      "cooking_steps": [
        "Bước 1...", "Bước 2...", "Bước 3...", "Bước 4..."
      ],
      "local_tip": "Mẹo siêu thị"
    }
  ],
  "total_estimated_cost": ${weeklyBudget * 0.85},
  "advice": "Lời khuyên"
}
''';

      final response = await dio.post(
        url,
        data: {
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'responseMimeType': 'application/json',
          }
        },
      );

      final text = response.data['candidates'][0]['content']['parts'][0]['text'] as String;
      return jsonDecode(text) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// Gọi Gemini REST API trực tiếp cho chi tiết 1 món ăn
  Future<Map<String, dynamic>?> _callDirectGeminiForRecipeDetail({
    required String recipeTitle,
    required String location,
    required String currency,
  }) async {
    const apiKey = String.fromEnvironment('GEMINI_API_KEY');
    if (apiKey.isEmpty) return null;

    try {
      final dio = Dio();
      final url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey';

      final prompt = '''
Cung cấp chi tiết nguyên liệu và 4 bước hướng dẫn nấu cho món: "$recipeTitle" tại $location ($currency).
Trả về JSON duy nhất:
{
  "recipe_title": "$recipeTitle",
  "estimated_cost": 8.0,
  "currency": "$currency",
  "ingredients": [
    {"name": "Tên nguyên liệu", "quantity": 150, "unit": "g", "aisle": "Gian hàng"}
  ],
  "cooking_steps": [
    "Bước 1...", "Bước 2...", "Bước 3...", "Bước 4..."
  ],
  "local_tip": "Mẹo siêu thị địa phương"
}
''';

      final response = await dio.post(
        url,
        data: {
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'responseMimeType': 'application/json',
          }
        },
      );

      final text = response.data['candidates'][0]['content']['parts'][0]['text'] as String;
      return jsonDecode(text) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}

@riverpod
AIGatewayService aiGatewayService(ref) {
  return AIGatewayService();
}
