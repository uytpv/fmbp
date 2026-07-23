import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fmbp_models/fmbp_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firestore_service.g.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ----------------- USER OPERATIONS -----------------

  Stream<User?> watchUser(String userId) {
    return _db.collection('users').doc(userId).snapshots().map((snap) {
      if (!snap.exists) return null;
      final data = snap.data()!;
      final familyId = data['familyId'] as String? ?? data['family_id'] as String?;
      final email = data['email'] as String? ?? '';
      final displayName = data['displayName'] as String? ?? data['display_name'] as String? ?? '';
      final role = data['role'] as String? ?? 'MEMBER';

      return User(
        id: snap.id,
        familyId: familyId,
        email: email,
        displayName: displayName,
        role: role,
      );
    });
  }

  /// Đảm bảo User Document luôn tồn tại trong Firestore (tạo mới nếu chưa có, hoặc merge nếu đã có)
  Future<void> ensureUserDocument(String userId, String email, {String? displayName}) async {
    final userRef = _db.collection('users').doc(userId);
    await userRef.set({
      'id': userId,
      'email': email,
      'display_name': displayName ?? (email.isNotEmpty ? email.split('@')[0] : 'User'),
      'role': 'MEMBER',
      'created_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> updateUserFamily(String userId, String? familyId, String role) async {
    await _db.collection('users').doc(userId).set({
      'id': userId,
      'family_id': familyId,
      'role': role,
    }, SetOptions(merge: true));
  }

  // ----------------- FAMILY OPERATIONS -----------------

  Future<String> createFamilyGroup(
    String name,
    String ownerId, {
    String currency = 'VND',
    double? monthlyIncome,
    List<FixedExpense> fixedExpenses = const [],
  }) async {
    final familyRef = _db.collection('families').doc();
    final familyId = familyRef.id;

    final familyMap = {
      'id': familyId,
      'name': name,
      'ownerId': ownerId,
      'createdAt': DateTime.now().toIso8601String(),
      'currency': currency,
      'monthlyIncome': monthlyIncome,
      'fixedExpenses': fixedExpenses.map((e) => e.toJson()).toList(),
    };

    // Run transaction to ensure family is created and user's family_id is updated atomically
    // Sử dụng set với SetOptions(merge: true) để tránh lỗi "no entity to update" khi user doc chưa từng khởi tạo
    await _db.runTransaction((transaction) async {
      transaction.set(familyRef, familyMap);
      transaction.set(_db.collection('users').doc(ownerId), {
        'id': ownerId,
        'family_id': familyId,
        'role': 'OWNER',
      }, SetOptions(merge: true));
    });

    return familyId;
  }

  Stream<FamilyGroup?> watchFamily(String familyId) {
    return _db.collection('families').doc(familyId).snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) return null;
      return FamilyGroup.fromJson({...snap.data()!, 'id': snap.id});
    });
  }

  // ----------------- FAMILY MEMBER OPERATIONS -----------------

  Stream<List<FamilyMember>> watchFamilyMembers(String familyId) {
    if (familyId.isEmpty || familyId == 'null') {
      return Stream.value([]);
    }
    return _db
        .collection('families')
        .doc(familyId)
        .collection('members')
        .snapshots()
        .map((snap) {
      return snap.docs
          .map((doc) => FamilyMember.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    });
  }

  Future<void> saveFamilyMember(String familyId, FamilyMember member) async {
    await _db
        .collection('families')
        .doc(familyId)
        .collection('members')
        .doc(member.id)
        .set(member.toJson());
  }

  Future<void> deleteFamilyMember(String familyId, String memberId) async {
    await _db
        .collection('families')
        .doc(familyId)
        .collection('members')
        .doc(memberId)
        .delete();
  }

  // ----------------- BUDGET OPERATIONS -----------------

  Stream<BudgetPeriod?> watchCurrentBudget(String familyId) {
    return _db
        .collection('families')
        .doc(familyId)
        .collection('budgets')
        .orderBy('startDate', descending: true)
        .limit(1)
        .snapshots()
        .map((snap) {
      if (snap.docs.isEmpty) return null;
      final doc = snap.docs.first;
      return BudgetPeriod.fromJson({...doc.data(), 'id': doc.id});
    });
  }

  Future<void> setBudget(String familyId, BudgetPeriod budget) async {
    await _db
        .collection('families')
        .doc(familyId)
        .collection('budgets')
        .doc(budget.id)
        .set(budget.toJson());
  }

  Future<void> addTransaction(String familyId, FoodTransaction tx) async {
    final txRef = _db
        .collection('families')
        .doc(familyId)
        .collection('transactions')
        .doc(tx.id);

    final budgetRef = _db
        .collection('families')
        .doc(familyId)
        .collection('budgets')
        .doc(tx.budgetPeriodId);

    await _db.runTransaction((transaction) async {
      transaction.set(txRef, tx.toJson());
      // Increment spentAmount in current BudgetPeriod
      transaction.set(budgetRef, {
        'spentAmount': FieldValue.increment(tx.amount),
      }, SetOptions(merge: true));
    });
  }

  // ----------------- RECIPE OPERATIONS -----------------

  Stream<List<Recipe>> watchRecipes({bool includePublic = true, String? creatorId}) {
    Query query = _db.collection('recipes');
    if (creatorId != null) {
      query = query.where('creatorId', isEqualTo: creatorId);
    }
    return query.snapshots().map((snap) {
      return snap.docs
          .map((doc) => Recipe.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
          .toList();
    });
  }

  Future<void> saveRecipe(Recipe recipe) async {
    await _db.collection('recipes').doc(recipe.id).set(recipe.toJson());
  }

  // ----------------- MEAL PLAN OPERATIONS -----------------

  Stream<MealPlan?> watchCurrentMealPlan(String familyId) {
    return _db
        .collection('families')
        .doc(familyId)
        .collection('meal_plans')
        .where('status', isEqualTo: 'ACTIVE')
        .limit(1)
        .snapshots()
        .map((snap) {
      if (snap.docs.isEmpty) return null;
      final doc = snap.docs.first;
      return MealPlan.fromJson({...doc.data(), 'id': doc.id});
    });
  }

  Future<void> saveMealPlan(String familyId, MealPlan plan) async {
    await _db
        .collection('families')
        .doc(familyId)
        .collection('meal_plans')
        .doc(plan.id)
        .set(plan.toJson());
  }

  // ----------------- SHOPPING LIST OPERATIONS -----------------

  Stream<ShoppingList?> watchActiveShoppingList(String familyId) {
    return _db
        .collection('families')
        .doc(familyId)
        .collection('shopping_lists')
        .where('status', isEqualTo: 'ACTIVE')
        .limit(1)
        .snapshots()
        .map((snap) {
      if (snap.docs.isEmpty) return null;
      final doc = snap.docs.first;
      return ShoppingList.fromJson({...doc.data(), 'id': doc.id});
    });
  }

  Future<void> saveShoppingList(String familyId, ShoppingList list) async {
    await _db
        .collection('families')
        .doc(familyId)
        .collection('shopping_lists')
        .doc(list.id)
        .set(list.toJson());
  }

  // ----------------- PANTRY OPERATIONS -----------------

  Stream<List<PantryItem>> watchPantryItems(String familyId) {
    return _db
        .collection('families')
        .doc(familyId)
        .collection('pantry_items')
        .snapshots()
        .map((snap) {
      return snap.docs
          .map((doc) => PantryItem.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    });
  }

  Future<void> updatePantryItem(String familyId, PantryItem item) async {
    await _db
        .collection('families')
        .doc(familyId)
        .collection('pantry_items')
        .doc(item.id)
        .set(item.toJson());
  }

  Future<void> deletePantryItem(String familyId, String itemId) async {
    await _db
        .collection('families')
        .doc(familyId)
        .collection('pantry_items')
        .doc(itemId)
        .delete();
  }
}

@riverpod
FirestoreService firestoreService(ref) {
  return FirestoreService();
}
