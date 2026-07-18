---
Document ID: DOC-555
Title: Versioning Policy
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-554 Release](./DOC-554%20Release.md)
---

# Versioning Policy

## 1. Objective
Quy định chuẩn mực đặt tên phiên bản cho toàn bộ mã nguồn, thư viện chia sẻ, ứng dụng và API của dự án để đảm bảo tính đồng bộ và dễ truy vết.

## 2. Scope
Áp dụng cho các sản phẩm Client (Mobile/Web), API endpoints, các gói npm/pub nội bộ và cấu trúc git tags.

## 3. Business Context
Việc đánh số phiên bản rõ ràng giúp đội ngũ phát triển và vận hành biết chính xác bản build nào đang chạy trên máy khách, hỗ trợ đắc lực cho công tác gỡ lỗi (Debugging) và quản lý tính tương thích ngược của hệ thống.

## 4. Functional Requirements
- Tuân thủ nghiêm ngặt chuẩn **Semantic Versioning 2.0.0 (SemVer)**: Định dạng phiên bản MAJOR.MINOR.PATCH (Ví dụ: 1.2.3).
  - MAJOR: Khi có thay đổi kiến trúc lớn, phá vỡ tính tương thích ngược (Breaking changes).
  - MINOR: Khi bổ sung tính năng mới nhưng vẫn tương thích ngược.
  - PATCH: Khi sửa lỗi (Bug fixes) tương thích ngược.

## 5. Non-Functional Requirements
- Đánh số phiên bản tự động bằng các công cụ như semantic-release dựa trên cú pháp commit Git (Conventional Commits).

## 6. Business Rules
- Phiên bản API phải được đưa vào URL của endpoint (ví dụ: /api/v1/...). Khi chuyển đổi sang /api/v2/..., hệ thống cũ v1 vẫn phải hoạt động song song tối thiểu 6 tháng.

## 7. Data Model
- Không áp dụng.

## 8. Flow
- conventional commits -> Merge PR -> CI/CD tự động phân tích commit -> Tính toán phiên bản tiếp theo -> Gắn git tag -> Sinh file CHANGELOG.md.

## 9. API
- Không áp dụng.

## 10. Acceptance Criteria
- Số phiên bản hiển thị trong phần thông tin ứng dụng (App Info) phải khớp chính xác 100% với phiên bản được release trên App Store/Google Play.

## 11. Future Improvements
- Tích hợp hệ thống phân tích phụ thuộc tự động để cảnh báo nếu việc nâng cấp phiên bản một package nội bộ gây lỗi cho các package khác trong monorepo.

## 12. References
- Semantic Versioning 2.0.0 standard.

## 13. Related Documents
- [Coding Standard.md](../Coding%20Standard.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
