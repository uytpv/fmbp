---
Document ID: DOC-955
Title: User Acceptance Testing (UAT) Guidelines
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-201 Personas](../20-product/DOC-201%20Personas.md)
---

# User Acceptance Testing (UAT) Guidelines

## 1. Objective
Quy định quy trình tổ chức kiểm thử chấp nhận sản phẩm bởi người dùng cuối (UAT) để đảm bảo ứng dụng giải quyết đúng nhu cầu nghiệp vụ thực tế và sẵn sàng ra mắt thị trường.

## 2. Scope
Áp dụng cho các chiến dịch thử nghiệm nội bộ (Alpha test) và thử nghiệm cộng đồng nhóm nhỏ (Beta test).

## 3. Business Context
Phần mềm có thể chạy không lỗi kỹ thuật, nhưng nếu trải nghiệm quá phức tạp hoặc người dùng không hiểu cách sử dụng tính năng lập ngân sách, sản phẩm vẫn thất bại. UAT giúp thu thập phản hồi thực tế của khách hàng để tinh chỉnh UX kịp thời trước khi đổ ngân sách lớn cho Marketing.

## 4. Functional Requirements
- Hệ thống gửi lời mời tham gia chương trình Beta qua TestFlight và Google Play Beta.
- Tích hợp công cụ báo cáo lỗi/góp ý trực tiếp trong ứng dụng (In-app feedback tool) để người dùng thử nghiệm dễ dàng chụp màn hình gửi ý kiến.
- Tạo bảng khảo sát mức độ hài lòng (CSAT, NPS) tự động sau khi người dùng hoàn thành tuần lập thực đơn đầu tiên.

## 5. Non-Functional Requirements
- Đảm bảo thông tin phản hồi của người dùng được phân loại tự động và chuyển thẳng vào bảng quản lý backlog của đội ngũ sản phẩm (Jira/Linear).

## 6. Business Rules
- Bản build được coi là vượt qua vòng UAT nếu đạt tỷ lệ hài lòng về mặt trải nghiệm (UX Satisfaction Score) trên 80% từ nhóm người dùng thử nghiệm đại diện.

## 7. Data Model
- UserFeedback: Lưu thông tin phản hồi, ảnh chụp màn hình lỗi và thông số thiết bị của người dùng UAT.

## 8. Flow
- Người dùng Beta sử dụng app -> Phát hiện lỗi hoặc điểm bất tiện -> Nhấn giữ màn hình/Lắc điện thoại -> Hiển thị hộp thoại góp ý -> Nhập nội dung -> Nhấn gửi -> Hệ thống chuyển thông tin về trang quản trị.

## 9. API
- POST /api/v1/uat/feedback

## 10. Acceptance Criteria
- Bộ phận Product kiểm duyệt và phân loại xong 100% phản hồi của người dùng UAT thành các đầu việc cụ thể (Sửa lỗi, Cải tiến UX, Tính năng mới) trước ngày ra mắt chính thức.

## 11. Future Improvements
- Xây dựng cộng đồng người dùng VIP (Super Users) tham gia đồng hành thiết kế sản phẩm ngay từ các bản vẽ wireframe sơ khởi.

## 12. References
- User Acceptance Testing methodology and tools.

## 13. Related Documents
- [DOC-206 Release Plan](../20-product/DOC-206%20Release%20Plan.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
