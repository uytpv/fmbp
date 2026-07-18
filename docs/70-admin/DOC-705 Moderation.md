---
Document ID: DOC-705
Title: Admin Marketplace Moderation Specs
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-103 Marketplace](../10-business/DOC-103%20Marketplace.md)
---

# Admin Marketplace Moderation Specs

## 1. Objective
Đặc tả quy trình và bộ công cụ kiểm duyệt hồ sơ Creator, đánh giá chất lượng sản phẩm số và xử lý các tranh chấp/báo cáo vi phạm trên Marketplace.

## 2. Scope
Áp dụng cho luồng duyệt tài khoản chuyên gia dinh dưỡng (Creator onboarding verification) và luồng xử lý báo cáo vi phạm nội dung (Reported content queue).

## 3. Business Context
Để giữ gìn uy tín chất lượng của Marketplace, tránh các thông tin dinh dưỡng sai lệch có thể gây hại cho sức khỏe người dùng, mọi nội dung trả phí và danh tính chuyên gia đều phải được kiểm duyệt khắt khe trước khi giao dịch.

## 4. Functional Requirements
- Hệ thống xem và đối chiếu tài liệu hồ sơ năng lực của Creator (chứng chỉ hành nghề, bằng cấp chuyên môn).
- Danh sách tiếp nhận và xử lý các báo cáo vi phạm từ người dùng về sản phẩm Marketplace (ví dụ: báo cáo công thức sai lệch, ảnh món ăn không đúng thực tế, nội dung sao chép).
- Công cụ hoàn tiền thủ công (Manual refund) cho người dùng trong các trường hợp tranh chấp được xử lý thắng cuộc.

## 5. Non-Functional Requirements
- Đảm bảo lưu vết kiểm duyệt (Moderation Audit Trail) chi tiết để quản lý chất lượng làm việc của đội ngũ kiểm duyệt viên nội bộ.

## 6. Business Rules
- Chỉ các chuyên gia có chứng chỉ hành nghề được xác thực (Verified Badge) mới được phép thiết lập giá bán cho các sản phẩm Meal Plan trên Marketplace.
- Thời gian tối đa để xử lý một báo cáo vi phạm của người dùng là 48 giờ kể từ khi tiếp nhận.

## 7. Data Model
- CreatorVerification: Trạng thái và tài liệu chứng minh năng lực của Creator.
- MarketplaceDispute: Quản lý các ca tranh chấp giao dịch giữa người dùng và Creator.

## 8. Flow
- Người dùng gửi báo cáo vi phạm sản phẩm -> Sản phẩm tự động gắn cờ cảnh báo -> Chuyển vào Reported Queue -> Kiểm duyệt viên mở kiểm tra -> Đối chiếu quy chuẩn nội dung -> Quyết định: Giữ nguyên / Yêu cầu sửa / Gỡ sản phẩm -> Gửi thông báo cho hai bên.

## 9. API
- GET /api/v1/admin/marketplace/reports
- POST /api/v1/admin/marketplace/reports/{id}/resolve

## 10. Acceptance Criteria
- Khi một sản phẩm bị quyết định gỡ bỏ (Unpublished), hệ thống phải chặn hoàn toàn các giao dịch mua mới đối với sản phẩm đó trên ứng dụng Client ngay lập tức.

## 11. Future Improvements
- Sử dụng AI để tự động quét kiểm duyệt ngôn từ thô tục, bạo lực hoặc hình ảnh không phù hợp trong các bài đánh giá (Reviews) của người dùng trên Marketplace.

## 12. References
- Online Marketplace Trust and Safety Guidelines.

## 13. Related Documents
- [DOC-702 Recipe](./DOC-702%20Recipe.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
