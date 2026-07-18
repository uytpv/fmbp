---
Document ID: DOC-254
Title: Shopping List Domain Specification
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-252 Menu](./DOC-252%20Menu.md)
- [DOC-253 Pantry](./DOC-253%20Pantry.md)
---

# Shopping List Domain Specification

## 1. Objective
Đặc tả cấu trúc dữ liệu và quy trình sinh Danh sách đi chợ thông minh (Shopping List) nhằm giúp người dùng mua đủ, mua đúng và tối ưu hóa ngân sách thực phẩm.

## 2. Scope
Tài liệu định nghĩa thực thể Danh sách mua sắm, cơ chế tính toán lượng thiếu hụt nguyên liệu (Meal Plan requirement minus Pantry stock), gộp nguyên liệu trùng lặp và sắp xếp danh sách theo phân khu siêu thị.

## 3. Business Context
Đi chợ là hoạt động tốn thời gian và dễ phát sinh chi tiêu ngoài kế hoạch (impulse buying). Một danh sách đi chợ được thiết lập khoa học, hiển thị rõ ràng số lượng và phân loại sẽ giúp người dùng tập trung mua đúng thứ cần thiết, tiết kiệm tối đa thời gian và tiền bạc.

## 4. Functional Requirements
- Tự động sinh Shopping List từ kế hoạch thực đơn tuần sau khi đã khấu trừ tồn kho Pantry.
- Cho phép thêm nhanh các mặt hàng ngoài thực đơn (như giấy vệ sinh, nước rửa chén) vào danh sách mua sắm.
- Cơ chế phân loại các mặt hàng theo quầy kệ siêu thị (Rau củ, Thịt, Đồ đông lạnh, Đồ khô).

## 5. Non-Functional Requirements
- Đồng bộ hóa trạng thái gạch bỏ mặt hàng (Check-off) thời gian thực giữa các thiết bị đang đi chợ chung dưới 1 giây.

## 6. Business Rules
- Nguyên liệu chỉ được tự động khấu trừ khỏi Pantry để sinh danh sách đi chợ nếu nguyên liệu đó trong Pantry còn trong hạn sử dụng và cùng đơn vị đo lường quy đổi được.

## 7. Data Model
- ShoppingList:
  - id: UUID (Primary Key)
  - amily_id: UUID (Foreign Key)
  - 	arget_date: Date
  - status: String (PENDING, ACTIVE, COMPLETED)
- ShoppingListItem:
  - shopping_list_id: UUID (Foreign Key)
  - ingredient_id: UUID (Foreign Key)
  - quantity_needed: Decimal (Số lượng cần mua thực tế)
  - quantity_purchased: Decimal (Số lượng đã mua thực tế)
  - unit: String
  - is_checked: Boolean
  - estimated_price: Decimal

## 8. Flow
- Người dùng duyệt thực đơn -> Hệ thống chạy ngầm thuật toán: Cần mua = Tổng cần cho thực đơn - Đang có trong Pantry -> Hiển thị danh sách kết quả phân loại theo quầy kệ -> Người dùng đi chợ bấm check-off từng dòng.

## 9. API
- GET /api/v1/shopping-lists/active
- POST /api/v1/shopping-lists/items/check

## 10. Acceptance Criteria
- Khi nhấn nút "Hoàn thành đi chợ", tất cả các mặt hàng có trạng thái is_checked = true phải được tự động chuyển vào Pantry của gia đình với số lượng tương ứng.

## 11. Future Improvements
- Định vị vị trí siêu thị để sắp xếp danh sách đi chợ tối ưu nhất theo sơ đồ mặt bằng thực tế của siêu thị đó.

## 12. References
- Thiết kế trải nghiệm đi chợ của Bring! và AnyList.

## 13. Related Documents
- [DOC-104 Affiliate](../10-business/DOC-104%20Affiliate.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
