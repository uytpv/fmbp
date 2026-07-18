---
Document ID: DOC-554
Title: Release Life Cycle
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-206 Release Plan](../20-product/DOC-206%20Release%20Plan.md)
---

# Release Life Cycle

## 1. Objective
Quy định quy trình chuẩn bị, đóng gói và phê duyệt phát hành một phiên bản sản phẩm mới ra thị trường.

## 2. Scope
Áp dụng cho toàn bộ các sản phẩm di động, web và backend của hệ sinh thái Family Meal Budget Planner.

## 3. Business Context
Một quy trình phát hành lỏng lẻo có thể dẫn đến việc đưa bản build chứa lỗi nghiêm trọng lên Store, gây ảnh hưởng tiêu cực đến trải nghiệm của khách hàng và uy tín sản phẩm.

## 4. Functional Requirements
- Cơ chế gắn thẻ phiên bản (Git tagging) và tạo các bản nháp Release trên GitHub.
- Quản lý luồng kiểm duyệt nội bộ trước khi gửi lên App Store/Google Play.

## 5. Non-Functional Requirements
- Đảm bảo có thể khôi phục nhanh (Rollback) về phiên bản cũ ổn định trong vòng dưới 15 phút nếu phát hiện lỗi nghiêm trọng sau khi phát hành.

## 6. Business Rules
- Mọi bản phát hành Production phải được phê duyệt chính thức bởi Product Owner và Lead Architect.

## 7. Data Model
- Trạng thái phiên bản phát hành (DRAFT, STAGED, ROLLOUT, ARCHIVED).

## 8. Flow
- Code freeze -> Đóng gói Release Candidate (RC) -> QA chạy kiểm thử tích cực -> Phê duyệt phát hành -> Cập nhật Changelog -> Triển khai Rollout (tiến trình 10% -> 50% -> 100%).

## 9. API
- Không áp dụng.

## 10. Acceptance Criteria
- Quy trình Rollback thử nghiệm hoạt động trơn tru mà không làm hỏng tính toàn vẹn của dữ liệu cơ sở dữ liệu hiện tại.

## 11. Future Improvements
- Tự động hóa quá trình sinh báo cáo phiên bản (Release report) cho các bên liên quan.

## 12. References
- Google Play và Apple App Store Review Guidelines.

## 13. Related Documents
- [DOC-555 Versioning](./DOC-555%20Versioning.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
