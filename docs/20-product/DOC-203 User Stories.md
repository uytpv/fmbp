---
Document ID: DOC-203
Title: User Stories
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-200 PRD](./DOC-200%20PRD.md)
---

# User Stories

## 1. Objective
Tài liệu này tổng hợp danh sách các User Stories để định nghĩa hành vi hệ thống từ góc nhìn của người dùng cuối, làm cơ sở để lập kế hoạch phát triển và viết test case.

## 2. Scope
Các User Stories xoay quanh 4 nhóm tính năng lớn (Epics): Quản lý gia đình, Lập kế hoạch bữa ăn, Đi chợ thông minh, và Quản lý tài chính thực phẩm.

## 3. Business Context
Đảm bảo tất cả các tính năng được xây dựng đều mang lại giá trị thực tế cho người dùng và giải quyết đúng nỗi đau về chi phí ăn uống gia đình.

## 4. Functional Requirements
- **US-01:** Là người quản lý tài chính gia đình, tôi muốn thiết lập hạn mức chi tiêu thực phẩm hàng tuần để cả nhà cùng theo dõi và kiểm soát.
- **US-02:** Là người nấu ăn chính, tôi muốn AI gợi ý thực đơn 7 ngày dựa trên ngân sách còn lại và các nguyên liệu đang có trong tủ lạnh để tiết kiệm tiền và thời gian.
- **US-03:** Là người đi chợ, tôi muốn danh sách nguyên liệu tự động gộp và phân loại theo khu vực siêu thị để tôi có thể mua đồ nhanh nhất.
- **US-04:** Là thành viên gia đình, tôi muốn cập nhật lượng thực phẩm đã mua để mọi người cùng thấy số dư ngân sách thay đổi ngay lập tức.

## 5. Non-Functional Requirements
- Ghi nhận trạng thái đồng bộ dữ liệu thời gian thực giữa các thiết bị gia đình dưới 2 giây.

## 6. Business Rules
- Chỉ Admin gia đình mới có quyền sửa đổi hạn mức ngân sách tuần.

## 7. Data Model
- UserStory: Định nghĩa cấu trúc lưu trữ và trạng thái triển khai của User Story.

## 8. Flow
- Không áp dụng.

## 9. API
- Không áp dụng.

## 10. Acceptance Criteria
- Mỗi User Story phải đi kèm đầy đủ tiêu chí nghiệm thu dạng Scenario: Given - When - Then.

## 11. Future Improvements
- Tự động chuyển đổi các User Story thành tài liệu kiểm thử tự động (BDD/Gherkin).

## 12. References
- Tiêu chuẩn viết User Story chuyên nghiệp (INVEST).

## 13. Related Documents
- [DOC-204 Feature List](./DOC-204%20Feature%20List.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
