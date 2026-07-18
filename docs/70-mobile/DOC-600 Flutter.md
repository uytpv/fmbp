---
Document ID: DOC-600
Title: Flutter Mobile App Specification
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-400 Architecture](../40-platform/DOC-400%20Architecture.md)
---

# Flutter Mobile App Specification

## 1. Objective
Đặc tả kỹ thuật của ứng dụng di động (iOS & Android) phát triển bằng nền tảng Flutter, quy định cấu hình dự án, cấu trúc mã nguồn và thư viện phụ thuộc.

## 2. Scope
Áp dụng cho dự án trong thư mục mobile/ của monorepo, bao gồm cấu trúc thư mục code, thiết lập môi trường phát triển Flutter.

## 3. Business Context
Ứng dụng di động là kênh tương tác chính của người dùng với sản phẩm. Trải nghiệm ứng dụng di động phải nhanh, mượt mà và tiết kiệm pin để người dùng sử dụng hàng ngày khi đi chợ hoặc nấu ăn.

## 4. Functional Requirements
- Build ứng dụng đa nền tảng (iOS và Android) từ một mã nguồn duy nhất.
- Tích hợp các SDK phần cứng (Camera cho OCR, Sinh trắc học bảo mật).

## 5. Non-Functional Requirements
- Đạt tốc độ hiển thị khung hình ổn định ở mức 60 FPS (hoặc 120 FPS trên các màn hình tần số quét cao).
- Tương thích tốt với các phiên bản hệ điều hành iOS 15+ và Android 8+.

## 6. Business Rules
- Không áp dụng.

## 7. Data Model
- Xem chi tiết cấu trúc lưu trữ local tại DOC-603.

## 8. Flow
- Khởi chạy App -> Kiểm tra phiên đăng nhập -> Nạp State từ local storage -> Đồng bộ bất đồng bộ từ Cloud -> Hiển thị Dashboard.

## 9. API
- Tích hợp Flutter SDK, Firebase Packages (irebase_core, cloud_firestore, irebase_auth).

## 10. Acceptance Criteria
- Ứng dụng biên dịch thành công cho cả hai nền tảng mà không phát sinh cảnh báo lỗi deprecation nghiêm trọng của các thư viện phụ thuộc.

## 11. Future Improvements
- Tinh chỉnh kích thước ứng dụng qua cơ chế Tree Shaking nâng cao của Flutter.

## 12. References
- Flutter official developer documentation.

## 13. Related Documents
- [DOC-602 State Management](./DOC-602%20State%20Management.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
