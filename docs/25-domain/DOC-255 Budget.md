---
Document ID: DOC-255
Title: Budget Domain Specification
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-252 Menu](./DOC-252%20Menu.md)
- [DOC-254 Shopping](./DOC-254%20Shopping.md)
---

# Budget Domain Specification

## 1. Objective
Đặc tả cấu trúc dữ liệu và các quy tắc nghiệp vụ quản lý Ngân sách thực phẩm (Budget) của gia đình, đảm bảo các hoạt động ăn uống và đi chợ tuân thủ các giới hạn tài chính được đề ra.

## 2. Scope
Bao gồm thiết lập hạn mức ngân sách tuần/tháng, ghi nhận chi tiêu thực tế, theo dõi số dư còn lại (Remaining Budget) và phân tích lịch sử chi tiêu thực phẩm của gia đình.

## 3. Business Context
Cốt lõi của việc quản lý tiền bạc là tính minh bạch và tức thời. Khi gia đình biết chính xác họ còn bao nhiêu tiền cho việc ăn uống trong tuần, họ sẽ đưa ra quyết định chọn món ăn và đi chợ thông minh hơn, tránh tình trạng vung tay quá trán vào những ngày đầu tháng.

## 4. Functional Requirements
- Thiết lập hạn mức ngân sách (Budget Limit) linh hoạt cho gia đình.
- Ghi nhận chi tiêu thực tế từ các giao dịch đi chợ (Shopping transactions) và ăn ngoài (Dining out transactions).
- Biểu đồ phân tích tiến độ tiêu dùng và dự báo ngày vượt hạn mức.

## 5. Non-Functional Requirements
- Xử lý các phép toán tài chính bằng kiểu dữ liệu chính xác (ví dụ: Decimal/BigDecimal), tuyệt đối không dùng kiểu float/double để tránh sai số làm tròn tiền tệ.

## 6. Business Rules
- Chỉ tài khoản có vai trò Admin/Owner mới có quyền sửa đổi hạn mức ngân sách.
- Số dư ngân sách cuối tuần của tuần này có thể được cấu hình tự động cộng dồn sang tuần sau (Rollover) hoặc chuyển vào quỹ tiết kiệm gia đình tùy theo cài đặt của người dùng.

## 7. Data Model
- BudgetPeriod:
  - id: UUID (Primary Key)
  - amily_id: UUID (Foreign Key)
  - start_date: Date
  - end_date: Date
  - llocated_amount: Decimal (Số tiền cấp phát)
  - spent_amount: Decimal (Số tiền đã tiêu)
- FoodTransaction:
  - id: UUID (Primary Key)
  - udget_period_id: UUID (Foreign Key)
  - mount: Decimal
  - 	ransaction_type: String (GROCERY, DINING_OUT, EXPERT_RECIPE)
  - description: String
  - created_at: DateTime

## 8. Flow
- Admin nhập hạn mức tuần là 1.500.000 VNĐ -> Hệ thống hiển thị ngân sách còn lại là 1.500.000 VNĐ -> Người dùng đi chợ hết 400.000 VNĐ -> Bấm hoàn thành đơn -> Số dư cập nhật tức thì còn 1.100.000 VNĐ.

## 9. API
- GET /api/v1/budgets/current
- POST /api/v1/budgets/transactions

## 10. Acceptance Criteria
- Mọi giao dịch chi tiêu thực tế được ghi nhận đều phải được đối trừ chính xác vào ngân sách của chu kỳ thời gian tương ứng.

## 11. Future Improvements
- Liên kết API với tài khoản ngân hàng để tự động ghi nhận giao dịch chi tiêu tại các cửa hàng tiện lợi và siêu thị mà không cần người dùng nhập tay.

## 12. References
- Phương pháp quản lý phong bì tiền mặt (Envelope budgeting system).

## 13. Related Documents
- [DOC-107 Financial Projection](../10-business/DOC-107%20Financial%20Projection.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
