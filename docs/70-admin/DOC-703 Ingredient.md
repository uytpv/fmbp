---
Document ID: DOC-703
Title: Admin Ingredient Master List Specs
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-250 Ingredient](../25-domain/DOC-250%20Ingredient.md)
---

# Admin Ingredient Master List Specs

## 1. Objective
Đặc tả công cụ quản trị danh mục nguyên liệu chuẩn (Ingredient Master List), quản lý mối quan hệ đo lường và ánh xạ tên gọi thay thế (Aliases).

## 2. Scope
Áp dụng cho màn hình quản lý nguyên liệu, bảng cấu hình aliases và thuộc tính dinh dưỡng chuẩn của từng thực thể nguyên liệu.

## 3. Business Context
Cơ sở dữ liệu nguyên liệu chuẩn hóa chính là xương sống của toàn bộ hệ thống tính toán tồn kho tủ lạnh và so sánh giá. Đội ngũ dữ liệu cần một công cụ mạnh mẽ để liên tục cập nhật, gộp các nguyên liệu trùng lặp và duy trì độ sạch của cơ sở dữ liệu.

## 4. Functional Requirements
- Danh sách quản lý tất cả các nguyên liệu chuẩn trong hệ thống.
- Công cụ Gộp nguyên liệu (Merge Ingredients): Cho phép chọn 2 nguyên liệu trùng lặp (ví dụ: "thịt ba rọi" và "thịt ba chỉ") để gộp thành một nguyên liệu chuẩn, hệ thống tự động cập nhật lại toàn bộ liên kết trong Recipes và Pantry hiện tại.
- Quản lý bảng quy đổi đơn vị đo lường cho từng nguyên liệu cụ thể.

## 5. Non-Functional Requirements
- Đảm bảo tính nhất quán dữ liệu ở mức cao nhất, thực hiện các thao tác gộp nguyên liệu trong Transaction an toàn để tránh mất mát dữ liệu liên kết.

## 6. Business Rules
- Không được phép xóa một nguyên liệu chuẩn nếu nguyên liệu đó đang được liên kết sử dụng trong ít nhất một công thức nấu ăn hoạt động.

## 7. Data Model
- IngredientMergeLog: Ghi nhận lịch sử gộp nguyên liệu để phục vụ truy vết lỗi dữ liệu nếu có.

## 8. Flow
- Người dùng nhập nguyên liệu lạ -> Hệ thống báo cáo nguyên liệu chưa được chuẩn hóa -> Admin vào trang quản lý -> Chọn nguyên liệu lạ -> Ánh xạ nó làm alias của một nguyên liệu chuẩn có sẵn -> Hệ thống lưu cấu hình mới.

## 9. API
- POST /api/v1/admin/ingredients/merge
- GET /api/v1/admin/ingredients/unstandardized

## 10. Acceptance Criteria
- Sau khi thực hiện lệnh gộp nguyên liệu, toàn bộ danh sách đi chợ và tủ lạnh của tất cả người dùng đang chứa nguyên liệu cũ phải tự động chuyển đổi sang tên nguyên liệu chuẩn mới mà không gây lỗi giao diện.

## 11. Future Improvements
- Sử dụng AI để tự động phát hiện và gợi ý gộp các nguyên liệu có tên gọi tương đồng trong hệ thống.

## 12. References
- Database Normalization and Master Data Management (MDM).

## 13. Related Documents
- [DOC-704 Food Price](./DOC-704%20Food%20Price.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
