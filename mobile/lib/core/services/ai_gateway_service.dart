import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fmbp_models/fmbp_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
    if (kIsWeb) return 'http://localhost:8000';
    if (Platform.isAndroid) {
      // 10.0.2.2 đại diện cho localhost của máy host từ Android Emulator
      return 'http://10.0.2.2:8000';
    }
    return 'http://localhost:8000';
  }

  /// Gợi ý thực đơn dựa trên ngân sách tuần và nguyên liệu trong tủ lạnh
  Future<Map<String, dynamic>> suggestMenu({
    required int weeklyBudget,
    required List<PantryItem> pantryItems,
  }) async {
    try {
      final itemsJson = pantryItems
          .map((item) => {
                'name': item.ingredientId, // Tạm thời dùng ID nguyên liệu làm tên
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

      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// Ước tính chi phí thực tế cho món ăn
  Future<int> estimateCost({
    required String recipeTitle,
    required List<RecipeIngredient> ingredients,
  }) async {
    try {
      final itemsJson = ingredients
          .map((ing) => {
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
