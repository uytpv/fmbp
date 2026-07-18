---
Document ID: DOC-404
Title: User Authentication Specification
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-401 Firebase](./DOC-401%20Firebase.md)
---

# User Authentication Specification

## 1. Objective
Đặc tả hệ thống đăng ký, đăng nhập và xác thực danh tính người dùng bảo mật cao cho ứng dụng.

## 2. Scope
Bao gồm đăng nhập bằng Email/Password, đăng nhập một chạm (Social Logins: Google, Apple) và luồng lấy lại mật khẩu.

## 3. Business Context
Quy trình xác thực an toàn, không ma sát (frictionless) giúp tối ưu tỷ lệ đăng ký tài khoản thành công của người dùng mới ngay từ màn hình giới thiệu.

## 4. Functional Requirements
- Xác thực và lưu trữ phiên đăng nhập (Session persistence).
- Hỗ trợ cơ chế Đăng nhập bằng Apple (Sign in with Apple) - bắt buộc đối với ứng dụng iOS có tích hợp đăng nhập bên thứ ba.
- Đăng nhập bằng Google (Google Sign-In) cho các dòng máy Android.

## 5. Non-Functional Requirements
- Sử dụng mã hóa một chiều bảo mật cao đối với mật khẩu người dùng (Firebase Auth tự động xử lý).

## 6. Business Rules
- Mật khẩu thiết lập thủ công phải dài tối thiểu 8 ký tự, bao gồm ít nhất 1 chữ hoa, 1 chữ thường và 1 chữ số.

## 7. Data Model
- Thực thể UserCredential (quản lý bởi Firebase Auth).

## 8. Flow
- Người dùng chọn "Đăng nhập bằng Google" -> Xác nhận qua hộp thoại hệ điều hành -> Nhận ID Token -> Xác thực với Firebase Auth -> Chuyển hướng vào trang chính của gia đình.

## 9. API
- Firebase Auth SDK APIs.

## 10. Acceptance Criteria
- Trạng thái đăng nhập của người dùng được duy trì ổn định qua các lần mở app trừ khi người dùng chủ động nhấn "Đăng xuất".

## 11. Future Improvements
- Tích hợp xác thực sinh trắc học (Biometrics: FaceID, TouchID) để đăng nhập và xác nhận các giao dịch thanh toán nhanh.

## 12. References
- OAuth 2.0 and OpenID Connect standards.

## 13. Related Documents
- [DOC-256 Family](../25-domain/DOC-256%20Family.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
