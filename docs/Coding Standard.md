---
Document ID: 
Title: Coding Standard
Version: 1.0
Status: Active
Owner: Engineering Team
Reviewer: Uy Tra
Last Updated: 2026-07-18
Related Documents:
  - Overall Main Concept Specification
  - DOC-600 Flutter
  - DOC-602 State Management
---

# Coding Standard

## 1. Mục đích

Tài liệu này quy chuẩn hóa phong cách viết code, cấu trúc thư mục và quy trình phát triển cho toàn bộ đội ngũ tham gia dự án Family Meal Budget Planner.

Mọi đóng góp code (commit, pull request) phải tuân thủ các quy tắc trong tài liệu này.

---

## 2. Ngôn ngữ lập trình

| Thành phần | Ngôn ngữ | Framework |
|---|---|---|
| Mobile & Web App | Dart 3.10+ | Flutter 3.38+ |
| Cloud Functions | TypeScript 5.x | Firebase Functions |
| AI Gateway | Python 3.10+ | FastAPI |
| Firestore Rules | Firebase Rules DSL | — |

---

## 3. Quy tắc đặt tên (Naming Conventions)

### 3.1 Dart / Flutter

| Loại | Quy tắc | Ví dụ |
|---|---|---|
| File | `snake_case` | `budget_provider.dart` |
| Class | `PascalCase` | `BudgetProvider` |
| Variable / Function | `camelCase` | `totalSpent`, `calculateRemaining()` |
| Constant | `camelCase` (với `const`) | `const defaultBudget = 1500000` |
| Enum | `PascalCase` (giá trị `camelCase`) | `MealType.breakfast` |
| Private | prefix `_` | `_calculateTotal()` |
| Widget | `PascalCase` + suffix mô tả | `BudgetSummaryCard` |
| Provider | `camelCase` + suffix `Provider` | `budgetProvider` |
| Model | `PascalCase` (số ít) | `Recipe`, `PantryItem` |

### 3.2 TypeScript (Cloud Functions)

| Loại | Quy tắc | Ví dụ |
|---|---|---|
| File | `kebab-case` | `on-user-created.ts` |
| Function | `camelCase` | `onUserCreated()` |
| Interface | `PascalCase` + prefix `I` (tùy chọn) | `FamilyGroup` |
| Constant | `UPPER_SNAKE_CASE` | `MAX_FAMILY_MEMBERS` |

### 3.3 Python (AI Gateway)

| Loại | Quy tắc | Ví dụ |
|---|---|---|
| File | `snake_case` | `meal_suggestion.py` |
| Class | `PascalCase` | `PromptTemplate` |
| Function / Variable | `snake_case` | `suggest_menu()` |
| Constant | `UPPER_SNAKE_CASE` | `DEFAULT_MODEL` |

---

## 4. Cấu trúc thư mục Flutter (mobile/)

```
mobile/
├── lib/
│   ├── app/                    # App-level config (router, theme, app widget)
│   │   ├── app.dart
│   │   ├── router.dart
│   │   └── theme.dart
│   ├── core/                   # Utilities, extensions, constants
│   │   ├── constants/
│   │   ├── extensions/
│   │   ├── utils/
│   │   └── services/          # Firebase, AI, Storage services
│   ├── features/              # Feature-first architecture
│   │   ├── auth/
│   │   │   ├── data/          # Repositories, data sources
│   │   │   ├── domain/        # Entities, use cases
│   │   │   ├── presentation/  # Screens, widgets, providers
│   │   │   └── auth.dart      # Feature barrel file
│   │   ├── budget/
│   │   ├── recipe/
│   │   ├── meal_plan/
│   │   ├── shopping/
│   │   ├── pantry/
│   │   ├── family/
│   │   └── dashboard/
│   ├── l10n/                  # Localization (ARB files)
│   │   ├── app_vi.arb
│   │   └── app_en.arb
│   ├── shared/                # Shared widgets, models
│   │   ├── widgets/
│   │   └── models/
│   └── main.dart
├── test/
│   ├── unit/
│   ├── widget/
│   └── integration/
├── pubspec.yaml
└── analysis_options.yaml
```

### Nguyên tắc tổ chức

1. **Feature-first**: Mỗi tính năng nằm trong thư mục riêng dưới `features/`.
2. **Clean Architecture Layers**: Mỗi feature chia 3 lớp: `data/`, `domain/`, `presentation/`.
3. **Barrel files**: Mỗi feature có file `.dart` export public API.
4. **Không import chéo features**: Feature A không được import trực tiếp từ Feature B. Dữ liệu chia sẻ phải đi qua `shared/` hoặc Provider.

---

## 5. State Management (Riverpod)

### Quy tắc Provider

```dart
// ✅ Đúng: Đặt tên rõ ràng, có annotation
@riverpod
class BudgetNotifier extends _$BudgetNotifier {
  @override
  AsyncValue<BudgetPeriod> build() => const AsyncLoading();
}

// ❌ Sai: Provider toàn cục không có annotation
final budgetProvider = StateProvider((ref) => null);
```

### Quy tắc sử dụng

1. Sử dụng **code generation** (`@riverpod` annotation) cho tất cả providers.
2. Tách **UI State** và **Business State** riêng biệt.
3. Sử dụng `ref.watch()` trong Widget, `ref.read()` trong callbacks.
4. Không lưu `ref` trong biến.

---

## 6. Firestore Data Conventions

### Collection Naming

- Collection: `snake_case` (số nhiều): `families`, `recipes`, `pantry_items`
- Document fields: `snake_case`: `family_id`, `created_at`, `total_estimated_cost`

### Timestamp

- Luôn sử dụng `FieldValue.serverTimestamp()` cho `created_at` và `updated_at`.
- Lưu trữ timezone-agnostic (UTC).

### Decimal / Currency

- **Bắt buộc** lưu trữ giá tiền dưới dạng `int` (đơn vị nhỏ nhất, VD: đồng, cent).
- Ví dụ: 1.500.000 VNĐ → lưu `1500000`.
- Không bao giờ dùng `double` cho tiền tệ.

---

## 7. Git Conventions

### Branch Naming

```
feature/budget-setup
bugfix/shopping-list-sync
hotfix/auth-crash
refactor/pantry-provider
docs/coding-standard
```

### Commit Messages

Sử dụng [Conventional Commits](https://www.conventionalcommits.org/):

```
feat(budget): add weekly budget setup screen
fix(shopping): resolve offline sync conflict
docs(spec): update DOC-900 MVP scope
refactor(pantry): extract batch management logic
test(budget): add unit tests for budget calculator
chore(deps): upgrade riverpod to 3.x
```

### Pull Request

- Tiêu đề: `[Feature/Module] Mô tả ngắn`
- Mô tả: What, Why, How + Screenshots (nếu UI)
- Phải pass CI trước khi merge

---

## 8. Code Quality

### Linting

- Sử dụng `flutter_lints` (hoặc `very_good_analysis`) cho Dart.
- Sử dụng `eslint` cho TypeScript.
- Sử dụng `ruff` cho Python.
- **Zero warnings** policy: Không merge code có warning.

### Documentation

- Mọi public class/function phải có doc comment (`///` trong Dart).
- Business logic phức tạp phải có comment giải thích WHY, không phải WHAT.
- Không commit code bị comment out.

### Testing

- Unit test cho mọi business logic (calculators, validators, converters).
- Widget test cho mọi custom component.
- Integration test cho các user flow cốt lõi.
- Code coverage tối thiểu: 70%.

---

## 9. Quy tắc Bảo mật

1. **Không commit secrets**: API keys, passwords, certificates.
2. **Sử dụng `.env`** cho configuration (thêm vào `.gitignore`).
3. **Không log dữ liệu nhạy cảm**: email, password, token.
4. **Validate input** ở cả client và server.
5. **HTTPS only** cho mọi API call.

---

## 10. Performance Guidelines

1. **Lazy loading**: Chỉ tải dữ liệu khi cần.
2. **Pagination**: Firestore queries phải có `limit()`.
3. **Image optimization**: Compress trước khi upload.
4. **Riverpod select**: Chỉ rebuild widget khi dữ liệu thực sự thay đổi.
5. **const constructors**: Sử dụng `const` cho mọi widget có thể.

---

## Changelog

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-18 | Engineering Team | Khởi tạo quy chuẩn code |

---

## Related Documents

- [DOC-600 Flutter](./70-mobile/DOC-600%20Flutter.md)
- [DOC-602 State Management](./70-mobile/DOC-602%20State%20Management.md)
- [DOC-950 Test Strategy](./95-testing/DOC-950%20Test%20Strategy.md)
