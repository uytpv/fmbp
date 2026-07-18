---
Document ID: DOC-553
Title: GitHub Actions Workflows
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-552 CI-CD](./DOC-552%20CI-CD.md)
---

# GitHub Actions Workflows

## 1. Objective
Đặc tả chi tiết các tệp cấu hình Workflow trong thư mục .github/workflows/ của dự án để tự động hóa các tác vụ CI/CD bằng GitHub Actions.

## 2. Scope
Áp dụng cho các workflows: lutter-ci.yml, irebase-backend-cd.yml, elease-ota.yml.

## 3. Business Context
Cung cấp tài liệu cấu hình chi tiết giúp các kỹ sư DevOps dễ dàng bảo trì và sửa đổi pipeline khi dự án bổ sung công cụ hoặc cấu trúc thư mục thay đổi.

## 4. Functional Requirements
- lutter-ci: Cài đặt Flutter SDK, chạy lutter pub get, lutter test, lutter analyze.
- irebase-backend-cd: Triển khai các Cloud Functions và cấu hình Firestore Security Rules.

## 5. Non-Functional Requirements
- Sử dụng cơ chế lưu bộ nhớ đệm (Caching dependency directories) để giảm thời gian build của GitHub runner.

## 6. Business Rules
- Chỉ chạy các workflow CD (deploy thực tế) trên các nhánh được bảo vệ (main, staging).

## 7. Data Model
- Cấu trúc YAML của các file workflow.

## 8. Flow
- Code push -> GitHub Runner nhận sự kiện -> Setup environment -> Run steps -> Hoàn tất báo cáo kết quả trạng thái (Green/Red check).

## 9. API
- GitHub Actions SDK, Runner APIs.

## 10. Acceptance Criteria
- Cấu hình chạy thành công các pipeline mà không gặp lỗi phân quyền truy cập Secrets của GitHub.

## 11. Future Improvements
- Xây dựng các Custom Actions dùng chung để tối ưu hóa cấu trúc tệp YAML trong monorepo.

## 12. References
- GitHub Actions official documentation.

## 13. Related Documents
- [DOC-550 Environment](./DOC-550%20Environment.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
