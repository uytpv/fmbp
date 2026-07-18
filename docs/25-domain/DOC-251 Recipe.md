---
Document ID: DOC-251
Title: Recipe Domain Specification
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-250 Ingredient](./DOC-250%20Ingredient.md)
---

# Recipe Domain Specification

## 1. Objective
Đặc tả cấu trúc dữ liệu công thức nấu ăn (Recipe), luồng nhập và phân tích công thức, phục vụ việc lên thực đơn và ước lượng chi phí nấu nướng.

## 2. Scope
Tài liệu định nghĩa thực thể Công thức, danh sách nguyên liệu thành phần (Recipe Ingredient), các bước thực hiện, thông tin dinh dưỡng tổng hợp và ước lượng chi phí của món ăn.

## 3. Business Context
Công thức là cầu nối giúp người dùng chuyển đổi từ kế hoạch ăn uống sang hành động đi chợ thực tế. Việc bóc tách chính xác nguyên liệu từ công thức là điều kiện tiên quyết để tự động hóa danh sách đi chợ và dự toán tài chính.

## 4. Functional Requirements
- Lưu trữ chi tiết công thức nấu ăn gồm tiêu đề, ảnh minh họa, thời gian chuẩn bị, số phần ăn (servings) và các bước thực hiện.
- Tính toán tổng chi phí ước tính của công thức bằng cách cộng gộp giá của các nguyên liệu thành phần.
- Tính toán tổng dinh dưỡng của món ăn.

## 5. Non-Functional Requirements
- Bóc tách liên kết công thức từ URL thông qua dịch vụ AI Parser đạt thời gian dưới 3 giây.

## 6. Business Rules
- Định lượng nguyên liệu trong công thức phải được quy về hệ đơn vị đo lường chuẩn hóa để có thể đối chiếu với kho thực phẩm (Pantry).

## 7. Data Model
- Recipe:
  - id: UUID (Primary Key)
  - title: String
  - instructions: List<String> (Các bước thực hiện)
  - servings: Integer (Số phần ăn mặc định)
  - prep_time: Integer (Phút)
  - cook_time: Integer (Phút)
  - creator_id: UUID (Người tạo)
  - is_public: Boolean
- RecipeIngredient:
  - recipe_id: UUID (Foreign Key)
  - ingredient_id: UUID (Foreign Key)
  - quantity: Decimal (Số lượng cần)
  - unit: String (Đơn vị sử dụng trong công thức)

## 8. Flow
- Người dùng dán link công thức -> AI Parser bóc tách dữ liệu -> Trả về danh sách RecipeIngredient -> Hệ thống đối chiếu Ingredient chuẩn -> Lưu công thức vào thư viện cá nhân.

## 9. API
- POST /api/v1/recipes/import-url
- GET /api/v1/recipes/{id}/cost-estimate

## 10. Acceptance Criteria
- Tổng chi phí ước tính của công thức phải tự động thay đổi khi giá trung bình của các nguyên liệu thành phần được cập nhật.

## 11. Future Improvements
- Cho phép người dùng đánh dấu các công thức ưa thích để AI ưu tiên đề xuất trong các thực đơn tuần tiếp theo.

## 12. References
- Các tiêu chuẩn bóc tách công thức Schema.org (Recipe markup).

## 13. Related Documents
- [DOC-252 Menu](./DOC-252%20Menu.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
