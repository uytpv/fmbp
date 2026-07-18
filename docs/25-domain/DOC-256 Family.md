---
Document ID: DOC-256
Title: Family Group & User Domain Specification
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-201 Personas](./DOC-201%20Personas.md)
---

# Family Group & User Domain Specification

## 1. Objective
Đặc tả cấu trúc dữ liệu tài khoản người dùng (User) và nhóm gia đình chung (Family Group), quản lý cơ chế phân quyền thành viên và chia sẻ tài nguyên trong hệ thống.

## 2. Scope
Bao gồm đăng ký/đăng nhập, tạo nhóm gia đình mới, mời thành viên tham gia nhóm thông qua liên kết/mã QR, phân quyền vai trò (Owner, Admin, Member, Kid) và quản lý trạng thái đồng bộ giữa các thành viên.

## 3. Business Context
Quản lý ăn uống và tài chính gia đình là hoạt động tập thể mang tính tương tác cao. Ứng dụng phải được thiết kế xoay quanh thực thể "Hộ gia đình" (Family Group) làm trung tâm, thay vì các tài khoản cá nhân đơn lẻ, để đảm bảo tính đồng bộ thông tin tủ lạnh và ngân sách giữa vợ, chồng và các thành viên khác.

## 4. Functional Requirements
- Tạo và cấu hình nhóm gia đình mới.
- Cơ chế gửi lời mời (Invitation Link) và tiếp nhận thành viên mới an toàn.
- Phân quyền thao tác: Chỉ Admin mới được thay đổi ngân sách; Member được quyền xem ngân sách, sửa thực đơn, đi chợ; Kid chỉ được quyền xem thực đơn và thêm món ăn yêu thích vào danh sách đề xuất.

## 5. Non-Functional Requirements
- Đảm bảo tính nhất quán dữ liệu (Data consistency) cao, không xảy ra xung đột khi hai thành viên cùng sửa đổi Shopping List tại một thời điểm (xử lý xung đột đồng bộ).

## 6. Business Rules
- Một User tại một thời điểm chỉ được phép là thành viên hoạt động của duy nhất một Family Group.
- Khi người sáng lập (Owner) giải tán nhóm gia đình, toàn bộ dữ liệu lịch sử Pantry và Budget của nhóm đó sẽ bị xóa hoặc ẩn đi theo đúng quy trình bảo mật dữ liệu.

## 7. Data Model
- FamilyGroup:
  - id: UUID (Primary Key)
  - name: String (Tên gia đình, VD: Gia đình Bình An)
  - owner_id: UUID (Foreign Key)
  - created_at: DateTime
- User:
  - id: UUID (Primary Key)
  - family_id: UUID (Foreign Key, Nullable)
  - email: String (Unique)
  - display_name: String
  - role: String (OWNER, ADMIN, MEMBER, KID)
- FamilyInvitation:
  - id: UUID (Primary Key)
  - family_id: UUID (Foreign Key)
  - invite_code: String (Unique token)
  - expires_at: DateTime
  - is_used: Boolean

## 8. Flow
- Người dùng A tạo nhóm "Gia đình nhà A" -> Hệ thống sinh mã QR/Link mời -> Người dùng B quét mã QR trên điện thoại -> Đồng ý tham gia -> Người dùng B được liên kết vào family_id của nhóm -> Cả hai cùng thấy tủ lạnh và ngân sách chung ngay lập tức.

## 9. API
- POST /api/v1/families
- POST /api/v1/families/invite
- POST /api/v1/families/join

## 10. Acceptance Criteria
- Liên kết mời thành viên phải tự động hết hiệu lực sau 24 giờ kể từ khi được khởi tạo.
- Quyền Admin/Owner được xác thực chính xác trên các API sửa đổi ngân sách và quản lý thành viên.

## 11. Future Improvements
- Hỗ trợ thiết lập thông báo thông minh cá nhân hóa theo vai trò (ví dụ: Chồng đi làm về qua siêu thị sẽ nhận được nhắc nhở mua đồ, trong khi vợ ở nhà nhận được thông báo chồng đã bắt đầu đi chợ).

## 12. References
- Các mô hình quản lý gia đình của Apple Family Sharing và Spotify Family Plan.

## 13. Related Documents
- [DOC-102 Subscription](../10-business/DOC-102%20Subscription.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Khởi tạo tài liệu đặc tả thực thể Gia đình & Thành viên |
