---
Document ID: DOC-804
Title: AI Shopping Assistant Specs
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-254 Shopping](../25-domain/DOC-254%20Shopping.md)
---

# AI Shopping Assistant Specs

## 1. Objective
Đặc tả trợ lý mua sắm AI (Shopping Assistant), hỗ trợ tối ưu hóa danh sách đi chợ, gợi ý lựa chọn gói mua sỉ để đạt hiệu quả chi phí cao nhất.

## 2. Scope
Áp dụng cho việc phân tích kích thước đóng gói sản phẩm, đề xuất mua sỉ/lẻ và liên kết giá cả cửa hàng.

## 3. Business Context
Đi chợ thông minh không chỉ là mua đúng thứ cần mà còn là chọn phương thức đóng gói thông minh (ví dụ: mua vỉ 10 quả trứng sẽ rẻ hơn mua lẻ từng quả nếu thực đơn tuần cần dùng tới 9 quả). AI Shopping Assistant giải quyết bài toán tối ưu hóa này cho người dùng.

## 4. Functional Requirements
- Đề xuất kích thước đóng gói (Pack size optimization) dựa trên lượng cần dùng của thực đơn tuần.
- Cảnh báo nếu người dùng thêm vào giỏ hàng món đồ đắt tiền hơn mức giá trung bình của khu vực.

## 5. Non-Functional Requirements
- Xử lý các phép so khớp giá cả sản phẩm dưới 500ms.

## 6. Business Rules
- Không áp dụng.

## 7. Data Model
- Không áp dụng.

## 8. Flow
- Người dùng mở Shopping List -> AI Assistant quét danh sách -> Phát hiện cần mua 1.2kg hành tây -> Gợi ý: "Mua túi 1.5kg giá 30k thay vì mua lẻ 1.2kg giá 35k tại siêu thị X".

## 9. API
- POST /api/v1/ai/shopping/optimize

## 10. Acceptance Criteria
- Các gợi ý mua sỉ/lẻ của AI phải chứng minh được việc tiết kiệm chi phí thực tế cho tổng hóa đơn đi chợ.

## 11. Future Improvements
- Tự động bóc tách các chương trình khuyến mãi thực tế của các siêu thị lân cận để lồng ghép vào gợi ý đi chợ.

## 12. References
- Grocery pricing structures and packaging optimization models.

## 13. Related Documents
- [DOC-250 Ingredient](../25-domain/DOC-250%20Ingredient.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
