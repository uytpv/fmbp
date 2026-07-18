// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Family Meal Budget Planner';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get mealPlan => 'Meal Plan';

  @override
  String get shoppingList => 'Shopping List';

  @override
  String get pantry => 'Pantry';

  @override
  String get settings => 'Settings';

  @override
  String get budget => 'Budget';

  @override
  String get recipe => 'Recipe';

  @override
  String get family => 'Family';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get logout => 'Logout';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get search => 'Search';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'An error occurred';

  @override
  String get retry => 'Retry';

  @override
  String get welcome => 'Welcome';

  @override
  String get onboardingTitle => 'Start Meal Planning';

  @override
  String get onboardingSubtitle => 'Start managing budget from daily meals';

  @override
  String get budgetSetup => 'Budget Setup';

  @override
  String get income => 'Income';

  @override
  String get fixedExpenses => 'Fixed Expenses';

  @override
  String get foodBudget => 'Food Budget';

  @override
  String get remaining => 'Remaining';

  @override
  String get spent => 'Spent';

  @override
  String get totalEstimated => 'Total Estimated';

  @override
  String get weeklyBudget => 'Weekly Budget';

  @override
  String get monthlyBudget => 'Monthly Budget';

  @override
  String get currency => '\$';

  @override
  String get today => 'Today';

  @override
  String get thisWeek => 'This Week';

  @override
  String get breakfast => 'Breakfast';

  @override
  String get lunch => 'Lunch';

  @override
  String get dinner => 'Dinner';

  @override
  String get snack => 'Snack';

  @override
  String get ingredients => 'Ingredients';

  @override
  String get steps => 'Steps';

  @override
  String get servings => 'Servings';

  @override
  String get prepTime => 'Prep Time';

  @override
  String get cookTime => 'Cook Time';

  @override
  String get estimatedCost => 'Estimated Cost';

  @override
  String get addToMealPlan => 'Add to Meal Plan';

  @override
  String get generateShoppingList => 'Generate Shopping List';

  @override
  String get startShopping => 'Start Shopping';

  @override
  String get completeShopping => 'Complete Shopping';

  @override
  String get checkAll => 'Check All';

  @override
  String get uncheckAll => 'Uncheck All';

  @override
  String itemsRemaining(int count) {
    return '$count items remaining';
  }

  @override
  String get expiringItems => 'Expiring Soon';

  @override
  String get expiredItems => 'Expired';

  @override
  String get addIngredient => 'Add Ingredient';

  @override
  String get storageLocation => 'Storage Location';

  @override
  String get fridge => 'Fridge';

  @override
  String get freezer => 'Freezer';

  @override
  String get cabinetPantry => 'Cabinet/Pantry';

  @override
  String get expirationDate => 'Expiration Date';

  @override
  String get quantity => 'Quantity';

  @override
  String get unit => 'Unit';

  @override
  String get familyName => 'Family Name';

  @override
  String get inviteMembers => 'Invite Members';

  @override
  String get familyMembers => 'Family Members';

  @override
  String get role => 'Role';

  @override
  String get owner => 'Owner';

  @override
  String get admin => 'Admin';

  @override
  String get member => 'Member';

  @override
  String get kid => 'Kid';

  @override
  String get budgetExceeded => 'Budget Exceeded!';

  @override
  String budgetWarning(String amount) {
    return 'Warning: Meal plan cost exceeds weekly budget by $amount';
  }

  @override
  String get aiSuggestion => 'AI Suggestion';

  @override
  String get suggestMenu => 'Suggest Menu';

  @override
  String get estimateCost => 'Estimate Cost';
}
