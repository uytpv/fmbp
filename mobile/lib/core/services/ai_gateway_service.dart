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
      return ''; // Trên Web Production sử dụng relative path qua Firebase Hosting rewrites
    }
    // Mặc định kết nối Firebase Cloud Functions / AI Gateway
    return 'http://${AppConfig.localHost}:5001/fmbp-dev/us-central1/aiGateway';
  }


  /// Gợi ý thực đơn dựa trên ngân sách tuần và nguyên liệu trong tủ lạnh
  Future<Map<String, dynamic>?> suggestMenu({
    required int weeklyBudget,
    required List<PantryItem> pantryItems,
  }) async {
    // Nếu ở chế độ Web Production mà chưa có AI Gateway server riêng, không gửi HTTP POST để tránh lỗi 404
    if (_dio.options.baseUrl.isEmpty) {
      return null;
    }

    try {
      final itemsJson = pantryItems
          .map((item) => <String, dynamic>{
                'name': item.ingredientId,
                'quantity': item.quantity,
                'unit': item.unit,
              })
          .toList();

      final response = await _dio.post(
        '/api/v1/ai/suggest-menu',
        data: {
          'weekly_budget': weeklyBudget,
          'pantry_items': itemsJson,
        },
      );

      return response.data as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }

  /// Ước tính chi phí thực tế cho món ăn
  Future<int> estimateCost({
    required String recipeTitle,
    required List<RecipeIngredient> ingredients,
  }) async {
    try {
      final itemsJson = ingredients
          .map((ing) => <String, dynamic>{
                'name': ing.ingredientId,
                'quantity': ing.quantity,
                'unit': ing.unit,
              })
          .toList();

      final response = await _dio.post(
        '/api/v1/ai/estimate-cost',
        data: {
          'recipe_title': recipeTitle,
          'ingredients': itemsJson,
        },
      );

      return response.data['estimated_cost'] as int;
    } catch (e) {
      rethrow;
    }
  }

  /// Bóc tách thông tin công thức nấu ăn từ text hoặc URL
  Future<Map<String, dynamic>> parseRecipe(String urlOrText) async {
    try {
      final response = await _dio.post(
        '/api/v1/ai/parse-recipe',
        data: {
          'url_or_text': urlOrText,
        },
      );

      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }
}

@riverpod
AIGatewayService aiGatewayService(ref) {
  return AIGatewayService();
}
