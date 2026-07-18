library fmbp_constants;

/// Tên Database cục bộ Isar
const String kIsarDbName = 'fmbp_local_db';

/// Vai trò trong Family Group
class FamilyRole {
  static const String owner = 'OWNER';
  static const String admin = 'ADMIN';
  static const String member = 'MEMBER';
  static const String kid = 'KID';
}

/// Loại bữa ăn
class MealType {
  static const String breakfast = 'BREAKFAST';
  static const String lunch = 'LUNCH';
  static const String dinner = 'DINNER';
  static const String snack = 'SNACK';
}

/// Vị trí bảo quản thực phẩm (Pantry Storage)
class StorageLocation {
  static const String fridge = 'FRIDGE';     // Tủ mát
  static const String freezer = 'FREEZER';   // Tủ đông
  static const String pantry = 'PANTRY';     // Tủ khô
  static const String cabinet = 'CABINET';   // Kệ tủ
}

/// Loại giao dịch tài chính liên quan đến thực phẩm
class TransactionType {
  static const String grocery = 'GROCERY';                 // Đi chợ/siêu thị
  static const String diningOut = 'DINING_OUT';             // Ăn ngoài
  static const String expertRecipe = 'EXPERT_RECIPE';       // Công thức trả phí (nếu có)
}

/// Trạng thái của thực đơn tuần (Meal Plan)
class MealPlanStatus {
  static const String draft = 'DRAFT';
  static const String active = 'ACTIVE';
  static const String completed = 'COMPLETED';
}

/// Trạng thái của danh sách đi chợ (Shopping List)
class ShoppingListStatus {
  static const String pending = 'PENDING';
  static const String active = 'ACTIVE';
  static const String completed = 'COMPLETED';
}
