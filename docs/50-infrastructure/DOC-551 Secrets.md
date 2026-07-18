---
Document ID: DOC-551
Title: Secret & Key Management
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-550 Environment](./DOC-550%20Environment.md)
---

# Secret & Key Management

## 1. Objective
Quy định cách thức quản lý, lưu trữ và bảo vệ các thông tin nhạy cảm (Secrets) như API Keys, mật khẩu cơ sở dữ liệu, chứng chỉ ký số ứng dụng.

## 2. Scope
Áp dụng cho Google Cloud Secret Manager, GitHub Encrypted Secrets, và quy tắc xử lý biến bảo mật cục bộ.

## 3. Business Context
Việc để lộ các khóa bảo mật (như OpenAI API Key, Stripe Secret Key) trên mã nguồn mở có thể dẫn đến việc kẻ xấu lợi dụng rút tiền, truy cập dữ liệu trái phép hoặc phá hoại hệ thống của sản phẩm.

## 4. Functional Requirements
- Tích hợp hệ thống quản lý secrets tập trung ở đám mây (Google Cloud Secret Manager).
- Tự động nạp secrets vào Cloud Functions khi chạy ở run-time mà không lưu trữ trong mã nguồn.

## 5. Non-Functional Requirements
- Đảm bảo mã hóa 2 lớp đối với tất cả secrets lưu trữ trên đám mây.

## 6. Business Rules
- **Quy tắc tuyệt đối:** Không bao giờ commit bất kỳ API Key, mật khẩu, hoặc file chứng chỉ lên Git. Nếu phát hiện rò rỉ, lập tức thu hồi và vô hiệu hóa khóa đó trên trang quản trị nhà cung cấp trong vòng dưới 10 phút.

## 7. Data Model
- Không áp dụng.

## 8. Flow
- Deploy code -> CI/CD kéo secrets từ GitHub Secrets -> Nạp vào hệ thống deploy -> Tạo bản build hoàn chỉnh an toàn.

## 9. API
- Google Secret Manager API.

## 10. Acceptance Criteria
- Quá trình scan mã nguồn tự động (TruffleHog/GitGuardian) trong CI/CD không phát hiện bất kỳ khóa bảo mật nào bị lộ lọt.

## 11. Future Improvements
- Tự động xoay vòng khóa bảo mật (Automatic secret rotation) định kỳ 90 ngày một lần.

## 12. References
- Google Cloud Secret Manager best practices.

## 13. Related Documents
- [DOC-405 Security](../40-platform/DOC-405%20Security.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
