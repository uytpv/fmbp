// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Family Meal Budget Planner';

  @override
  String get dashboard => 'Tổng quan';

  @override
  String get mealPlan => 'Thực đơn';

  @override
  String get shoppingList => 'Đi chợ';

  @override
  String get pantry => 'Tủ lạnh';

  @override
  String get settings => 'Cài đặt';

  @override
  String get budget => 'Ngân sách';

  @override
  String get recipe => 'Công thức';

  @override
  String get family => 'Gia đình';

  @override
  String get login => 'Đăng nhập';

  @override
  String get register => 'Đăng ký';

  @override
  String get logout => 'Đăng xuất';

  @override
  String get save => 'Lưu';

  @override
  String get cancel => 'Hủy';

  @override
  String get delete => 'Xóa';

  @override
  String get edit => 'Sửa';

  @override
  String get add => 'Thêm';

  @override
  String get search => 'Tìm kiếm';

  @override
  String get loading => 'Đang tải...';

  @override
  String get error => 'Đã xảy ra lỗi';

  @override
  String get retry => 'Thử lại';

  @override
  String get welcome => 'Chào mừng';

  @override
  String get onboardingTitle => 'Bắt đầu lập kế hoạch bữa ăn';

  @override
  String get onboardingSubtitle => 'Muốn quản lý tiền, hãy bắt đầu từ bữa ăn';

  @override
  String get budgetSetup => 'Thiết lập ngân sách';

  @override
  String get income => 'Thu nhập';

  @override
  String get fixedExpenses => 'Chi phí cố định';

  @override
  String get foodBudget => 'Ngân sách ăn uống';

  @override
  String get remaining => 'Còn lại';

  @override
  String get spent => 'Đã chi';

  @override
  String get totalEstimated => 'Tổng ước tính';

  @override
  String get weeklyBudget => 'Ngân sách tuần';

  @override
  String get monthlyBudget => 'Ngân sách tháng';

  @override
  String get currency => '₫';

  @override
  String get today => 'Hôm nay';

  @override
  String get thisWeek => 'Tuần này';

  @override
  String get breakfast => 'Bữa sáng';

  @override
  String get lunch => 'Bữa trưa';

  @override
  String get dinner => 'Bữa tối';

  @override
  String get snack => 'Bữa phụ';

  @override
  String get ingredients => 'Nguyên liệu';

  @override
  String get steps => 'Các bước';

  @override
  String get servings => 'Phần ăn';

  @override
  String get prepTime => 'Thời gian chuẩn bị';

  @override
  String get cookTime => 'Thời gian nấu';

  @override
  String get estimatedCost => 'Chi phí ước tính';

  @override
  String get addToMealPlan => 'Thêm vào thực đơn';

  @override
  String get generateShoppingList => 'Tạo danh sách đi chợ';

  @override
  String get startShopping => 'Bắt đầu đi chợ';

  @override
  String get completeShopping => 'Hoàn thành đi chợ';

  @override
  String get checkAll => 'Chọn tất cả';

  @override
  String get uncheckAll => 'Bỏ chọn tất cả';

  @override
  String itemsRemaining(int count) {
    return '$count mặt hàng còn lại';
  }

  @override
  String get expiringItems => 'Sắp hết hạn';

  @override
  String get expiredItems => 'Đã hết hạn';

  @override
  String get addIngredient => 'Thêm nguyên liệu';

  @override
  String get storageLocation => 'Vị trí lưu trữ';

  @override
  String get fridge => 'Tủ mát';

  @override
  String get freezer => 'Tủ đông';

  @override
  String get cabinetPantry => 'Tủ khô';

  @override
  String get expirationDate => 'Hạn sử dụng';

  @override
  String get quantity => 'Số lượng';

  @override
  String get unit => 'Đơn vị';

  @override
  String get familyName => 'Tên gia đình';

  @override
  String get inviteMembers => 'Mời thành viên';

  @override
  String get familyMembers => 'Thành viên gia đình';

  @override
  String get role => 'Vai trò';

  @override
  String get owner => 'Chủ sở hữu';

  @override
  String get admin => 'Quản lý';

  @override
  String get member => 'Thành viên';

  @override
  String get kid => 'Trẻ em';

  @override
  String get budgetExceeded => 'Vượt ngân sách!';

  @override
  String budgetWarning(String amount) {
    return 'Cảnh báo: Chi phí thực đơn vượt ngân sách tuần $amount';
  }

  @override
  String get aiSuggestion => 'Gợi ý AI';

  @override
  String get suggestMenu => 'Gợi ý thực đơn';

  @override
  String get estimateCost => 'Ước tính chi phí';
}
