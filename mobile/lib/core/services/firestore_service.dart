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
      return User.fromJson({...snap.data()!, 'id': snap.id});
    });
  }

  Future<void> updateUserFamily(String userId, String? familyId, String role) async {
    await _db.collection('users').doc(userId).update({
      'family_id': familyId,
      'role': role,
    });
  }

  // ----------------- FAMILY OPERATIONS -----------------

  Future<String> createFamilyGroup(String name, String ownerId) async {
    final familyRef = _db.collection('families').doc();
    final familyId = familyRef.id;

    final family = FamilyGroup(
      id: familyId,
      name: name,
      ownerId: ownerId,
      createdAt: DateTime.now(),
    );

    // Run transaction to ensure family is created and user's family_id is updated atomically
    await _db.runTransaction((transaction) async {
      transaction.set(familyRef, family.toJson());
      transaction.update(_db.collection('users').doc(ownerId), {
        'family_id': familyId,
        'role': 'OWNER',
      });
    });

    return familyId;
  }

  Stream<FamilyGroup?> watchFamily(String familyId) {
    return _db.collection('families').doc(familyId).snapshots().map((snap) {
      if (!snap.exists) return null;
      return FamilyGroup.fromJson({...snap.data()!, 'id': snap.id});
    });
  }

  // ----------------- BUDGET OPERATIONS -----------------

  Stream<BudgetPeriod?> watchCurrentBudget(String familyId) {
    return _db
        .collection('families')
        .doc(familyId)
        .collection('budgets')
        .orderBy('start_date', descending: true)
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
      transaction.update(budgetRef, {
        'spent_amount': FieldValue.increment(tx.amount),
      });
    });
  }

  // ----------------- RECIPE OPERATIONS -----------------

  Stream<List<Recipe>> watchRecipes({bool includePublic = true, String? creatorId}) {
    Query query = _db.collection('recipes');
    if (creatorId != null) {
      query = query.where('creator_id', isEqualTo: creatorId);
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
}

@riverpod
FirestoreService firestoreService(ref) {
  return FirestoreService();
}
