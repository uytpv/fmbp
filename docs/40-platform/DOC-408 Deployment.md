---
Document ID: DOC-408
Title: Client Build & Deployment Specs
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-400 Architecture](./DOC-400%20Architecture.md)
---

# Client Build & Deployment Specs

## 1. Objective
Quy chuẩn hóa quy trình biên dịch (Build) ứng dụng khách Flutter và triển khai lên các kho ứng dụng Apple App Store, Google Play Store cũng như Hosting cho bản Web.

## 2. Scope
Tài liệu hướng dẫn quy trình ký số ứng dụng (Code Signing), quản lý cấu hình certificates, provisioning profiles, và các mốc phát hành ứng dụng.

## 3. Business Context
Tự động hóa và chuẩn hóa quy trình triển khai giúp giảm thiểu sai sót do con người, đảm bảo các bản sửa lỗi nóng (Hotfixes) được cập nhật đến tay người dùng nhanh nhất có thể.

## 4. Functional Requirements
- Quy trình ký số tự động trên môi trường đám mây sử dụng công cụ Fastlane.
- Phát hành phiên bản Web thông qua Firebase Hosting.
- Quản lý phiên bản thử nghiệm nội bộ qua TestFlight (iOS) và Google Play Console Beta (Android).

## 5. Non-Functional Requirements
- Đảm bảo kích thước gói cài đặt ứng dụng (App bundle size) được tối ưu hóa tối đa (mục tiêu: < 30MB cho tải xuống ban đầu).

## 6. Business Rules
- Bắt buộc phải thực hiện kiểm thử tự động (Unit test, Integration test) thành công trên môi trường CI/CD trước khi xuất bản bản build chính thức lên các kho ứng dụng.

## 7. Data Model
- Không áp dụng.

## 8. Flow
- Lập trình viên đẩy code lên nhánh main -> Kích hoạt Pipeline -> Tự động chạy test -> Biên dịch file cài đặt (IPA, AAB) -> Ký số tự động -> Đẩy lên Google Play Beta / TestFlight.

## 9. API
- App Store Connect API, Google Play Developer Publishing API.

## 10. Acceptance Criteria
- Bản build được đẩy lên các Store phải qua được vòng kiểm duyệt tự động về mặt chính sách và kỹ thuật của Apple và Google mà không bị từ chối (rejection).

## 11. Future Improvements
- Tích hợp công cụ cập nhật mã nguồn nóng (Codepush/OTA) cho phép sửa các lỗi giao diện nhỏ của Flutter mà không cần người dùng phải cập nhật lại ứng dụng từ Store.

## 12. References
- Flutter Deployment Guidelines, Fastlane Documentation.

## 13. Related Documents
- [DOC-552 CI-CD](../50-infrastructure/DOC-552%20CI-CD.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
