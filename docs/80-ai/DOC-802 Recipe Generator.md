---
Document ID: DOC-802
Title: AI Recipe Customization Spec
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-251 Recipe](../25-domain/DOC-251%20Recipe.md)
---

# AI Recipe Customization Spec

## 1. Objective
Đặc tả tính năng biến đổi công thức nấu ăn bằng AI theo nhu cầu sức khỏe hoặc cắt giảm chi phí nguyên liệu.

## 2. Scope
Áp dụng cho tính năng "Tailor Recipe" (Điều chỉnh công thức), thay thế nguyên liệu thông minh bằng AI.

## 3. Business Context
Giúp người dùng linh hoạt biến đổi món ăn yêu thích phù hợp với chế độ ăn kiêng đột xuất hoặc thay thế các nguyên liệu đắt đỏ bằng các lựa chọn tiết kiệm hơn mà không mất đi vị ngon cốt lõi.

## 4. Functional Requirements
- AI tự động thay thế nguyên liệu (ví dụ: thay thế thịt bằng đậu hũ cho người ăn chay).
- Tự động tính toán lại định lượng và các bước nấu ăn tương ứng.

## 5. Non-Functional Requirements
- Đảm bảo cấu trúc JSON đầu ra đồng bộ hoàn toàn với Schema công thức nấu ăn chuẩn để không gây lỗi hiển thị.

## 6. Business Rules
- Không được thay thế các nguyên liệu cơ bản làm thay đổi hoàn toàn bản chất món ăn (ví dụ: thay thế cá bằng thịt gà trong món cá kho tộ).

## 7. Data Model
- Không áp dụng.

## 8. Flow
- Người dùng chọn công thức -> Nhấn "Cắt giảm chi phí" -> AI phân tích nguyên liệu đắt -> Đề xuất nguyên liệu thay thế rẻ hơn -> Cập nhật công thức mới.

## 9. API
- POST /api/v1/ai/recipe/tailor

## 10. Acceptance Criteria
- Công thức nấu ăn mới tạo ra phải hiển thị rõ ràng phần nguyên liệu thay đổi để người dùng dễ nhận biết.

## 11. Future Improvements
- Tích hợp cộng đồng đánh giá mức độ thành công của các công thức đã được AI biến đổi.

## 12. References
- Food Substitutions databases.

## 13. Related Documents
- [DOC-801 Meal Planner](./DOC-801%20Meal%20Planner.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
