import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// Tên ứng dụng
  ///
  /// In vi, this message translates to:
  /// **'Family Meal Budget Planner'**
  String get appTitle;

  /// No description provided for @dashboard.
  ///
  /// In vi, this message translates to:
  /// **'Tổng quan'**
  String get dashboard;

  /// No description provided for @mealPlan.
  ///
  /// In vi, this message translates to:
  /// **'Thực đơn'**
  String get mealPlan;

  /// No description provided for @shoppingList.
  ///
  /// In vi, this message translates to:
  /// **'Đi chợ'**
  String get shoppingList;

  /// No description provided for @pantry.
  ///
  /// In vi, this message translates to:
  /// **'Tủ lạnh'**
  String get pantry;

  /// No description provided for @settings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get settings;

  /// No description provided for @budget.
  ///
  /// In vi, this message translates to:
  /// **'Ngân sách'**
  String get budget;

  /// No description provided for @recipe.
  ///
  /// In vi, this message translates to:
  /// **'Công thức'**
  String get recipe;

  /// No description provided for @family.
  ///
  /// In vi, this message translates to:
  /// **'Gia đình'**
  String get family;

  /// No description provided for @login.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get login;

  /// No description provided for @register.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get register;

  /// No description provided for @logout.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get logout;

  /// No description provided for @save.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In vi, this message translates to:
  /// **'Sửa'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In vi, this message translates to:
  /// **'Thêm'**
  String get add;

  /// No description provided for @search.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm'**
  String get search;

  /// No description provided for @loading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In vi, this message translates to:
  /// **'Đã xảy ra lỗi'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get retry;

  /// No description provided for @welcome.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng'**
  String get welcome;

  /// No description provided for @onboardingTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu lập kế hoạch bữa ăn'**
  String get onboardingTitle;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Muốn quản lý tiền, hãy bắt đầu từ bữa ăn'**
  String get onboardingSubtitle;

  /// No description provided for @budgetSetup.
  ///
  /// In vi, this message translates to:
  /// **'Thiết lập ngân sách'**
  String get budgetSetup;

  /// No description provided for @income.
  ///
  /// In vi, this message translates to:
  /// **'Thu nhập'**
  String get income;

  /// No description provided for @fixedExpenses.
  ///
  /// In vi, this message translates to:
  /// **'Chi phí cố định'**
  String get fixedExpenses;

  /// No description provided for @foodBudget.
  ///
  /// In vi, this message translates to:
  /// **'Ngân sách ăn uống'**
  String get foodBudget;

  /// No description provided for @remaining.
  ///
  /// In vi, this message translates to:
  /// **'Còn lại'**
  String get remaining;

  /// No description provided for @spent.
  ///
  /// In vi, this message translates to:
  /// **'Đã chi'**
  String get spent;

  /// No description provided for @totalEstimated.
  ///
  /// In vi, this message translates to:
  /// **'Tổng ước tính'**
  String get totalEstimated;

  /// No description provided for @weeklyBudget.
  ///
  /// In vi, this message translates to:
  /// **'Ngân sách tuần'**
  String get weeklyBudget;

  /// No description provided for @monthlyBudget.
  ///
  /// In vi, this message translates to:
  /// **'Ngân sách tháng'**
  String get monthlyBudget;

  /// No description provided for @currency.
  ///
  /// In vi, this message translates to:
  /// **'₫'**
  String get currency;

  /// No description provided for @today.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get today;

  /// No description provided for @thisWeek.
  ///
  /// In vi, this message translates to:
  /// **'Tuần này'**
  String get thisWeek;

  /// No description provided for @breakfast.
  ///
  /// In vi, this message translates to:
  /// **'Bữa sáng'**
  String get breakfast;

  /// No description provided for @lunch.
  ///
  /// In vi, this message translates to:
  /// **'Bữa trưa'**
  String get lunch;

  /// No description provided for @dinner.
  ///
  /// In vi, this message translates to:
  /// **'Bữa tối'**
  String get dinner;

  /// No description provided for @snack.
  ///
  /// In vi, this message translates to:
  /// **'Bữa phụ'**
  String get snack;

  /// No description provided for @ingredients.
  ///
  /// In vi, this message translates to:
  /// **'Nguyên liệu'**
  String get ingredients;

  /// No description provided for @steps.
  ///
  /// In vi, this message translates to:
  /// **'Các bước'**
  String get steps;

  /// No description provided for @servings.
  ///
  /// In vi, this message translates to:
  /// **'Phần ăn'**
  String get servings;

  /// No description provided for @prepTime.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian chuẩn bị'**
  String get prepTime;

  /// No description provided for @cookTime.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian nấu'**
  String get cookTime;

  /// No description provided for @estimatedCost.
  ///
  /// In vi, this message translates to:
  /// **'Chi phí ước tính'**
  String get estimatedCost;

  /// No description provided for @addToMealPlan.
  ///
  /// In vi, this message translates to:
  /// **'Thêm vào thực đơn'**
  String get addToMealPlan;

  /// No description provided for @generateShoppingList.
  ///
  /// In vi, this message translates to:
  /// **'Tạo danh sách đi chợ'**
  String get generateShoppingList;

  /// No description provided for @startShopping.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu đi chợ'**
  String get startShopping;

  /// No description provided for @completeShopping.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành đi chợ'**
  String get completeShopping;

  /// No description provided for @checkAll.
  ///
  /// In vi, this message translates to:
  /// **'Chọn tất cả'**
  String get checkAll;

  /// No description provided for @uncheckAll.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ chọn tất cả'**
  String get uncheckAll;

  /// No description provided for @itemsRemaining.
  ///
  /// In vi, this message translates to:
  /// **'{count} mặt hàng còn lại'**
  String itemsRemaining(int count);

  /// No description provided for @expiringItems.
  ///
  /// In vi, this message translates to:
  /// **'Sắp hết hạn'**
  String get expiringItems;

  /// No description provided for @expiredItems.
  ///
  /// In vi, this message translates to:
  /// **'Đã hết hạn'**
  String get expiredItems;

  /// No description provided for @addIngredient.
  ///
  /// In vi, this message translates to:
  /// **'Thêm nguyên liệu'**
  String get addIngredient;

  /// No description provided for @storageLocation.
  ///
  /// In vi, this message translates to:
  /// **'Vị trí lưu trữ'**
  String get storageLocation;

  /// No description provided for @fridge.
  ///
  /// In vi, this message translates to:
  /// **'Tủ mát'**
  String get fridge;

  /// No description provided for @freezer.
  ///
  /// In vi, this message translates to:
  /// **'Tủ đông'**
  String get freezer;

  /// No description provided for @cabinetPantry.
  ///
  /// In vi, this message translates to:
  /// **'Tủ khô'**
  String get cabinetPantry;

  /// No description provided for @expirationDate.
  ///
  /// In vi, this message translates to:
  /// **'Hạn sử dụng'**
  String get expirationDate;

  /// No description provided for @quantity.
  ///
  /// In vi, this message translates to:
  /// **'Số lượng'**
  String get quantity;

  /// No description provided for @unit.
  ///
  /// In vi, this message translates to:
  /// **'Đơn vị'**
  String get unit;

  /// No description provided for @familyName.
  ///
  /// In vi, this message translates to:
  /// **'Tên gia đình'**
  String get familyName;

  /// No description provided for @inviteMembers.
  ///
  /// In vi, this message translates to:
  /// **'Mời thành viên'**
  String get inviteMembers;

  /// No description provided for @familyMembers.
  ///
  /// In vi, this message translates to:
  /// **'Thành viên gia đình'**
  String get familyMembers;

  /// No description provided for @role.
  ///
  /// In vi, this message translates to:
  /// **'Vai trò'**
  String get role;

  /// No description provided for @owner.
  ///
  /// In vi, this message translates to:
  /// **'Chủ sở hữu'**
  String get owner;

  /// No description provided for @admin.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý'**
  String get admin;

  /// No description provided for @member.
  ///
  /// In vi, this message translates to:
  /// **'Thành viên'**
  String get member;

  /// No description provided for @kid.
  ///
  /// In vi, this message translates to:
  /// **'Trẻ em'**
  String get kid;

  /// No description provided for @budgetExceeded.
  ///
  /// In vi, this message translates to:
  /// **'Vượt ngân sách!'**
  String get budgetExceeded;

  /// No description provided for @budgetWarning.
  ///
  /// In vi, this message translates to:
  /// **'Cảnh báo: Chi phí thực đơn vượt ngân sách tuần {amount}'**
  String budgetWarning(String amount);

  /// No description provided for @aiSuggestion.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý AI'**
  String get aiSuggestion;

  /// No description provided for @suggestMenu.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý thực đơn'**
  String get suggestMenu;

  /// No description provided for @estimateCost.
  ///
  /// In vi, this message translates to:
  /// **'Ước tính chi phí'**
  String get estimateCost;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
