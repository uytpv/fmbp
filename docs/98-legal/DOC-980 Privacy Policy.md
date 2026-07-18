---
Document ID: DOC-980
Title: Privacy Policy
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-405 Security](../40-platform/DOC-405%20Security.md)
---

# Privacy Policy

## 1. Objective
Quy định chính sách bảo mật thông tin cá nhân (Privacy Policy), minh bạch hóa việc thu thập, lưu trữ, xử lý và chia sẻ dữ liệu của người dùng ứng dụng theo các chuẩn mực pháp lý quốc tế.

## 2. Scope
Áp dụng cho toàn bộ người dùng đăng ký tài khoản trên Mobile App, Web App và khách truy cập Landing Page.

## 3. Business Context
Xây dựng lòng tin tuyệt đối với khách hàng về mặt an toàn thông tin là điều kiện tiên quyết để họ yên tâm kết nối và chia sẻ dữ liệu chi tiêu gia đình cho ứng dụng.

## 4. Functional Requirements
- Cơ chế cho phép người dùng yêu cầu xóa hoàn toàn tài khoản và dữ liệu liên quan tự động trong cài đặt ứng dụng (Right to be Forgotten).
- Banner xin ý kiến chấp thuận cookie và theo dõi hành vi (Cookie Consent banner).

## 5. Non-Functional Requirements
- Đảm bảo văn bản chính sách bảo mật được viết bằng ngôn từ pháp lý chuẩn xác nhưng dễ hiểu đối với người dùng phổ thông.

## 6. Business Rules
- Tuân thủ các đạo luật bảo vệ quyền riêng tư toàn cầu: **GDPR** (Châu Âu), **CCPA** (California, Mỹ) và các quy định pháp luật hiện hành về an ninh mạng tại Việt Nam.
- Nền tảng cam kết **không bán dữ liệu cá nhân hay thói quen ăn uống của người dùng** cho bất kỳ đơn vị quảng cáo bên thứ ba nào.

## 7. Data Model
- UserConsent: Lưu giữ lịch sử chấp thuận chính sách bảo mật của từng tài khoản người dùng (user_id, policy_version, accepted_at, ip_address).

## 8. Flow
- Người dùng đăng ký tài khoản -> Hiển thị hộp kiểm "Tôi đồng ý với Chính sách bảo mật" -> Người dùng tick chọn và nhấn Đăng ký -> Hệ thống ghi nhận vào UserConsent -> Cho phép truy cập app.

## 9. API
- POST /api/v1/legal/consent/accept

## 10. Acceptance Criteria
- Tính năng yêu cầu xóa tài khoản phải thực hiện xóa sạch toàn bộ dữ liệu định danh của người dùng khỏi Firestore và Cloud Storage trong vòng dưới 24h kể từ khi yêu cầu được xác nhận.

## 11. Future Improvements
- Tự động hóa việc cập nhật chính sách và thông báo cho người dùng qua ứng dụng khi có thay đổi pháp lý lớn.

## 12. References
- General Data Protection Regulation (GDPR) text, California Consumer Privacy Act (CCPA) text.

## 13. Related Documents
- [DOC-981 Terms of Service](./DOC-981%20Terms%20of%20Service.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
