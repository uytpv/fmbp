---
Document ID: DOC-701
Title: Admin User Management Portal
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-256 Family](../25-domain/DOC-256%20Family.md)
---

# Admin User Management Portal

## 1. Objective
Đặc tả tính năng quản lý tài khoản người dùng và nhóm gia đình trên Cổng quản trị dành cho bộ phận Hỗ trợ khách hàng (Customer Support).

## 2. Scope
Áp dụng cho các tính năng: Tìm kiếm tài khoản, xem chi tiết nhóm gia đình, thay đổi thủ công trạng thái gói cước (Premium/Family), khóa/mở khóa tài khoản vi phạm.

## 3. Business Context
Khi khách hàng gặp sự cố thanh toán, lỗi dữ liệu tủ lạnh hoặc cần hỗ trợ tài khoản, đội ngũ Customer Support cần một công cụ quản trị mạnh mẽ để kiểm tra nhanh lịch sử của khách hàng và khắc phục sự cố trực tiếp cho họ.

## 4. Functional Requirements
- Tìm kiếm tài khoản người dùng theo Email, Tên hiển thị hoặc mã Family ID.
- Xem lịch sử giao dịch thanh toán và trạng thái đăng ký thuê bao của gia đình.
- Tính năng kích hoạt thủ công quyền Premium (Manual override) cho các trường hợp đặc biệt (đền bù sự cố, tặng code VIP).
- Ghi nhận lịch sử hoạt động của Admin (Audit Log) để đảm bảo không có sự lạm quyền của nhân viên nội bộ.

## 5. Non-Functional Requirements
- Đảm bảo an toàn bảo mật: Nhân viên Support chỉ được xem thông tin cơ bản, không được nhìn thấy mật khẩu hoặc thông tin thẻ chi tiết của khách hàng.

## 6. Business Rules
- Mọi thao tác thay đổi gói cước thủ công của nhân viên Support bắt buộc phải nhập lý do (Reason field) và lưu lại trong Audit Log.

## 7. Data Model
- AdminAuditLog: Lưu vết các thao tác thay đổi dữ liệu người dùng của admin (dmin_id, ction_type, 	arget_user_id, old_value, 
ew_value, eason, 	imestamp).

## 8. Flow
- Khách hàng báo lỗi thanh toán -> Nhân viên Support vào Admin Portal -> Tìm email khách hàng -> Xem trạng thái thuê bao -> Xác nhận lỗi của Stripe -> Bấm "Kích hoạt Premium thủ công" -> Nhập lý do -> Xác nhận -> Hệ thống cập nhật DB và lưu Audit Log.

## 9. API
- GET /api/v1/admin/users
- POST /api/v1/admin/users/{id}/override-subscription

## 10. Acceptance Criteria
- Trạng thái Premium của gia đình được kích hoạt ngay lập tức trên app client sau khi nhân viên Support thực hiện lệnh override trên Admin Portal.

## 11. Future Improvements
- Tích hợp trực tiếp công cụ chat hỗ trợ (Intercom/Zendesk) ngay bên cạnh hồ sơ người dùng trên Admin Portal để hỗ trợ khách hàng nhanh nhất.

## 12. References
- Customer Support Tool Design Patterns.

## 13. Related Documents
- [DOC-102 Subscription](../10-business/DOC-102%20Subscription.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
