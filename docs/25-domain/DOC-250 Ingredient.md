---
Document ID: DOC-250
Title: Ingredient Domain Specification
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-251 Recipe](./DOC-251%20Recipe.md)
- [DOC-253 Pantry](./DOC-253%20Pantry.md)
---

# Ingredient Domain Specification

## 1. Objective
Đặc tả chi tiết thực thể nguyên liệu (Ingredient) trong hệ thống, cấu trúc dữ liệu và các quy tắc nghiệp vụ liên quan đến phân loại, đo lường và theo dõi giá nguyên liệu.

## 2. Scope
Nằm trong phạm vi là định nghĩa cấu trúc dữ liệu nguyên liệu, bảng đơn vị quy đổi chuẩn (grams, ml, pieces...), phân loại nhóm thực phẩm và quản lý dữ liệu lịch sử giá của từng nguyên liệu.

## 3. Business Context
Nguyên liệu là đơn vị cơ bản nhất của cả hệ thống thực đơn và kho hàng. Nếu nguyên liệu không được thiết kế chuẩn hóa (ví dụ: người nhập ghi "thịt bò", người khác ghi "thịt ba chỉ bò"), hệ thống sẽ không thể gộp danh sách đi chợ hay tính toán lượng tồn kho chính xác để tối ưu ngân sách.

## 4. Functional Requirements
- Hệ thống hỗ trợ chuẩn hóa tên nguyên liệu (Aliases Mapping).
- Tự động chuyển đổi đơn vị đo lường linh hoạt (ví dụ: 1kg = 1000g).
- Lưu trữ lịch sử giá của từng nguyên liệu theo khu vực để phục vụ dự báo ngân sách đi chợ.

## 5. Non-Functional Requirements
- Truy vấn thông tin nguyên liệu và đơn vị quy đổi dưới 100ms.

## 6. Business Rules
- Mỗi nguyên liệu phải thuộc về một Nhóm thực phẩm chuẩn (Category) cụ thể để hỗ trợ phân loại quầy siêu thị trong Shopping List.
- Tên nguyên liệu gốc (Standardized Name) phải là duy nhất.

## 7. Data Model
- Ingredient:
  - id: UUID (Primary Key)
  - 
ame: String (Tên chuẩn)
  - category_id: UUID (Foreign Key)
  - ase_unit: String (Đơn vị cơ sở, ví dụ: g, ml, piece)
  - 
utrition_info: JSON (Calo, Protein, Carbs, Fat trên 100g)
  - liases: List<String> (Các tên gọi khác)
  - verage_price: Decimal (Giá trung bình hiện tại)

## 8. Flow
- Thêm nguyên liệu mới -> Nhập tên và chọn nhóm thực phẩm -> Định cấu hình đơn vị chuẩn -> Lưu vào cơ sở dữ liệu dùng chung.

## 9. API
- GET /api/v1/ingredients
- POST /api/v1/ingredients/standardize

## 10. Acceptance Criteria
- Khi người dùng thêm "thịt ba rọi" và hệ thống đã cấu hình "thịt ba rọi" là alias của "thịt ba chỉ", hệ thống phải tự động nhận diện và quy về thực thể "thịt ba chỉ".

## 11. Future Improvements
- Bản đồ nguyên liệu thông minh (Food Genome) giúp tự động gợi ý nguyên liệu thay thế khi một loại nguyên liệu bị hết hàng hoặc tăng giá đột biến.

## 12. References
- Cơ sở dữ liệu dinh dưỡng quốc gia.

## 13. Related Documents
- [DOC-253 Pantry](./DOC-253%20Pantry.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
