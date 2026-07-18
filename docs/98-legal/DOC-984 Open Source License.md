---
Document ID: DOC-984
Title: Open Source License Specifications
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-985 Third-party Licenses](./DOC-985%20Third-party%20Licenses.md)
---

# Open Source License Specifications

## 1. Objective
Quy định giấy phép bản quyền nguồn mở (Open Source License) cho các phần mã nguồn được đóng góp công khai của dự án và chính sách bản quyền cốt lõi.

## 2. Scope
Áp dụng cho toàn bộ mã nguồn của dự án trong các kho lưu trữ công khai và mã nguồn độc quyền của hệ thống Backend/AI.

## 3. Business Context
Xác định rõ ràng bản quyền giúp bảo vệ tài sản trí tuệ của startup, đồng thời tạo điều kiện nếu dự án muốn mở rộng cộng đồng phát triển bằng cách mở mã nguồn một phần tính năng (ví dụ mở mã nguồn thư viện quy đổi đơn vị đo lường).

## 4. Functional Requirements
- Đính kèm tệp tin LICENSE tiêu chuẩn tại thư mục gốc của dự án.
- Tự động chèn thông tin bản quyền (Copyright header) vào phần đầu của mỗi file mã nguồn chính.

## 5. Non-Functional Requirements
- Đảm bảo ngôn từ pháp lý của giấy phép bản quyền rõ ràng, không mập mờ để tránh các tranh chấp sở hữu trí tuệ sau này.

## 6. Business Rules
- **Quyết định bản quyền:**
  - Mã nguồn lõi (Backend, Cloud Functions, AI Gateway, thuật toán đề xuất): **Proprietary (Bản quyền độc quyền của doanh nghiệp)**, tuyệt đối không mở mã nguồn.
  - Các thư viện UI Flutter hoặc SDK phụ trợ tự phát triển: Có thể lựa chọn giấy phép **MIT License** hoặc **Apache License 2.0** nếu muốn đóng góp công khai cho cộng đồng để xây dựng thương hiệu kỹ thuật (Employer branding).

## 7. Data Model
- Không áp dụng.

## 8. Flow
- Không áp dụng.

## 9. API
- Không áp dụng.

## 10. Acceptance Criteria
- File LICENSE được lưu trữ đúng định dạng văn bản thô ở thư mục gốc của kho mã nguồn.

## 11. Future Improvements
- Đăng ký bảo hộ sở hữu trí tuệ chính thức cho thương hiệu và các thuật toán AI độc quyền của dự án tại các cơ quan nhà nước có thẩm quyền.

## 12. References
- Open Source Initiative (OSI) license templates.

## 13. Related Documents
- [DOC-981 Terms of Service](./DOC-981%20Terms%20of%20Service.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
