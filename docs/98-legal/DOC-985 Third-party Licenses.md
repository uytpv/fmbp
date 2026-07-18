---
Document ID: DOC-985
Title: Third-party Licenses Compliance
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-984 Open Source License](./DOC-984%20Open%20Source%20License.md)
---

# Third-party Licenses Compliance

## 1. Objective
Quy định quy trình kiểm tra và tuân thủ giấy phép bản quyền của các thư viện phần mềm bên thứ ba (Third-party libraries/packages) được tích hợp trong dự án.

## 2. Scope
Áp dụng cho toàn bộ các gói phụ thuộc khai báo trong pubspec.yaml (Flutter) và package.json (Node.js/Web).

## 3. Business Context
Việc vô tình tích hợp một thư viện nguồn mở có giấy phép lây nhiễm nghiêm ngặt (như GPL v3) vào mã nguồn độc quyền của doanh nghiệp có thể buộc doanh nghiệp phải công khai toàn bộ mã nguồn của mình theo luật pháp. Do đó, kiểm soát bản quyền bên thứ ba là cực kỳ quan trọng để bảo vệ tài sản doanh nghiệp.

## 4. Functional Requirements
- Hệ thống tự động quét và phân loại giấy phép của toàn bộ các package phụ thuộc (License scanning) trong quy trình CI/CD.
- Trang "Giấy phép bên thứ ba" (Open Source Licenses Page) trong phần Cài đặt của ứng dụng di động hiển thị thông tin bản quyền của các thư viện đã sử dụng (đây là yêu cầu bắt buộc của Apple và Google).

## 5. Non-Functional Requirements
- Đảm bảo công cụ quét giấy phép hoạt động ổn định và không làm chậm tốc độ build của pipeline CI/CD.

## 6. Business Rules
- **Chính sách chấp thuận giấy phép:**
  - Cho phép sử dụng các thư viện có giấy phép: **MIT, Apache 2.0, BSD-2-Clause, BSD-3-Clause**.
  - Cấm hoàn toàn việc sử dụng trực tiếp các thư viện có giấy phép: **GPL (v2/v3), LGPL, AGPL** trong mã nguồn độc quyền của dự án mà không có sự phê duyệt bằng văn bản của Lead Architect.

## 7. Data Model
- Bảng danh mục giấy phép được phép và cấm sử dụng.

## 8. Flow
- Dev thêm package mới -> Chạy npm install / flutter pub get -> CI/CD quét giấy phép của package đó -> Nếu phát hiện giấy phép GPL -> Đánh dấu lỗi (Fail pipeline) -> Dev phải tìm thư viện thay thế.

## 9. API
- Các công cụ CLI quét bản quyền (FOSSA, License Checker).

## 10. Acceptance Criteria
- Trang hiển thị Open Source Licenses trong app di động hiển thị đầy đủ thông tin bản quyền của các thư viện phụ thuộc theo đúng quy định.

## 11. Future Improvements
- Tự động sinh danh sách giấy phép bên thứ ba khi đóng gói phiên bản mới.

## 12. References
- Software Package Data Exchange (SPDX) specifications.

## 13. Related Documents
- [DOC-600 Flutter](../70-mobile/DOC-600%20Flutter.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
