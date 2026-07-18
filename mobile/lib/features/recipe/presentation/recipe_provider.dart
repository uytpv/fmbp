import 'package:fmbp_models/fmbp_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/services/ai_gateway_service.dart';
import '../../../core/services/firebase_auth_service.dart';
import '../../../core/services/firestore_service.dart';

part 'recipe_provider.g.dart';

@riverpod
class RecipeState extends _$RecipeState {
  @override
  Stream<List<Recipe>> build() {
    final user = ref.watch(firebaseAuthServiceProvider).currentUser;
    if (user == null) {
      return Stream.value([]);
    }
    return ref.watch(firestoreServiceProvider).watchRecipes();
  }

  /// Nhập công thức qua URL hoặc văn bản bằng AI
  Future<void> importRecipe(String urlOrText) async {
    final aiService = ref.read(aiGatewayServiceProvider);
    final firestore = ref.read(firestoreServiceProvider);
    final user = ref.read(firebaseAuthServiceProvider).currentUser;

    if (user == null) return;

    // 1. Gọi AI bóc tách
    final parsed = await aiService.parseRecipe(urlOrText);

    // 2. Lưu vào Firestore
    final recipeId = const Uuid().v4();
    final recipe = Recipe(
      id: recipeId,
      title: parsed['title'] ?? 'Công thức chưa phân loại',
      instructions: List<String>.from(parsed['instructions'] ?? []),
      servings: parsed['servings'] ?? 4,
      prepTime: parsed['prep_time'] ?? 15,
      cookTime: parsed['cook_time'] ?? 30,
      creatorId: user.uid,
      isPublic: false,
    );

    await firestore.saveRecipe(recipe);
  }

  /// Lưu công thức tạo thủ công
  Future<void> saveManualRecipe({
    required String title,
    required List<String> instructions,
    required int servings,
    required int prepTime,
    required int cookTime,
  }) async {
    final firestore = ref.read(firestoreServiceProvider);
    final user = ref.read(firebaseAuthServiceProvider).currentUser;

    if (user == null) return;

    final recipeId = const Uuid().v4();
    final recipe = Recipe(
      id: recipeId,
      title: title,
      instructions: instructions,
      servings: servings,
      prepTime: prepTime,
      cookTime: cookTime,
      creatorId: user.uid,
      isPublic: false,
    );

    await firestore.saveRecipe(recipe);
  }
}
