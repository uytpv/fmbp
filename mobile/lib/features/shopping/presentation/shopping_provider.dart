import 'package:fmbp_models/fmbp_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/services/firebase_auth_service.dart';
import '../../../core/services/firestore_service.dart';
import '../../meal_plan/presentation/meal_plan_provider.dart';
import '../../pantry/presentation/pantry_provider.dart';

part 'shopping_provider.g.dart';

@riverpod
class ShoppingState extends _$ShoppingState {
  @override
  Stream<ShoppingList?> build() {
    final user = ref.watch(firebaseAuthServiceProvider).currentUser;
    if (user == null) {
      return Stream.value(null);
    }

    return ref.watch(firestoreServiceProvider).watchUser(user.uid).asyncExpand((userDoc) {
      if (userDoc == null || userDoc.familyId == null) {
        return Stream.value(null);
      }
      return ref.watch(firestoreServiceProvider).watchActiveShoppingList(userDoc.familyId!);
    });
  }

  /// Tự động sinh danh sách đi chợ từ Meal Plan và trừ kho Pantry hiện tại
  Future<void> generateShoppingList() async {
    final firestore = ref.read(firestoreServiceProvider);
    final user = ref.read(firebaseAuthServiceProvider).currentUser;

    if (user == null) return;

    final userDoc = await firestore.watchUser(user.uid).first;
    if (userDoc == null || userDoc.familyId == null) return;

    final mealPlan = ref.read(mealPlanStateProvider).value;
    final pantryItems = ref.read(pantryStateProvider).value ?? [];

    if (mealPlan == null) {
      throw Exception('Chưa có thực đơn tuần hoạt động để sinh danh sách đi chợ');
    }

    // Ở bản MVP, ta mô phỏng thuật toán lấy nguyên liệu cần mua.
    // Thực tế sẽ duyệt qua các công thức trong Meal Plan, cộng gộp nguyên liệu cần thiết,
    // sau đó trừ đi số lượng sẵn có trong Pantry.
    final listId = const Uuid().v4();
    final shoppingList = ShoppingList(
      id: listId,
      familyId: userDoc.familyId!,
      targetDate: DateTime.now().add(const Duration(days: 1)),
      status: 'ACTIVE',
    );

    await firestore.saveShoppingList(userDoc.familyId!, shoppingList);
  }

  /// Đánh dấu đã mua mặt hàng
  Future<void> checkOffItem(String ingredientId, bool isChecked) async {
    // Lưu trạng thái check cục bộ hoặc trên Firestore
  }

  /// Hoàn thành đi chợ: cập nhật trạng thái và chuyển đồ đã mua vào Pantry (Auto-import)
  Future<void> completeShopping() async {
    final firestore = ref.read(firestoreServiceProvider);
    final activeList = state.value;

    if (activeList != null) {
      // 1. Cập nhật trạng thái shopping list sang COMPLETED
      final updatedList = activeList.copyWith(status: 'COMPLETED');
      await firestore.saveShoppingList(activeList.familyId, updatedList);

      // 2. Auto-import (MVP Mock): Thêm nguyên liệu mặc định vào Pantry để người dùng trải nghiệm
      final mockPantryItem = PantryItem(
        id: const Uuid().v4(),
        familyId: activeList.familyId,
        ingredientId: 'Thịt ba chỉ',
        quantity: 1.5,
        unit: 'kg',
        storageLocation: 'FRIDGE',
      );
      await firestore.updatePantryItem(activeList.familyId, mockPantryItem);
    }
  }
}
