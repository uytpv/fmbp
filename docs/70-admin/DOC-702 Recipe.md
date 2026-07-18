---
Document ID: DOC-702
Title: Admin Recipe Moderation Specifications
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-251 Recipe](../25-domain/DOC-251%20Recipe.md)
---

# Admin Recipe Moderation Specifications

## 1. Objective
Đặc tả các công cụ quản lý, chỉnh sửa và kiểm duyệt cơ sở dữ liệu công thức nấu ăn (Recipes) trên Cổng quản trị của đội ngũ biên tập nội dung ẩm thực.

## 2. Scope
Áp dụng cho các tính năng duyệt công thức công cộng, sửa đổi lỗi nguyên liệu trong công thức, phê duyệt sản phẩm của Creator trên Marketplace.

## 3. Business Context
Cơ sở dữ liệu công thức là tài sản cốt lõi của ứng dụng. Để AI có thể hoạt động chính xác và người dùng tin tưởng làm theo, các công thức nấu ăn phải đảm bảo chuẩn hóa về mặt ngôn từ, định lượng và hình ảnh đẹp mắt.

## 4. Functional Requirements
- Giao diện duyệt danh sách công thức chờ phê duyệt (Moderation Queue).
- Công cụ chuẩn hóa định lượng nguyên liệu (ví dụ: phát hiện công thức ghi "1 muỗng" -> hướng dẫn sửa lại thành "5g" hoặc đơn vị chuẩn tương đương).
- Quản lý phân loại tag món ăn (Ăn sáng, Món kho, Đồ chay, Keto...).

## 5. Non-Functional Requirements
- Hỗ trợ tải lên và tối ưu hóa hình ảnh món ăn tự động (nén ảnh, chuyển sang định dạng WebP) để tăng tốc độ tải trên ứng dụng di động.

## 6. Business Rules
- Bất kỳ công thức nào do người dùng đóng góp công cộng (Community recipes) nếu bị báo cáo vi phạm (flagged) quá 3 lần từ cộng đồng sẽ tự động bị ẩn đi để chờ kiểm duyệt viên xử lý.

## 7. Data Model
- RecipeModeration: Lưu lịch sử phê duyệt, từ chối và lý do từ chối công thức của kiểm duyệt viên.

## 8. Flow
- Creator gửi công thức lên Marketplace -> Công thức chuyển vào Moderation Queue -> Biên tập viên mở xem -> Kiểm tra chất lượng -> Nhấn "Phê duyệt" hoặc "Từ chối kèm lý do" -> Hệ thống gửi mail thông báo cho Creator.

## 9. API
- GET /api/v1/admin/recipes/queue
- POST /api/v1/admin/recipes/{id}/approve

## 10. Acceptance Criteria
- Khi công thức được duyệt, nó phải xuất hiện ngay lập tức trong kết quả tìm kiếm của Search Engine trên toàn bộ ứng dụng Client.

## 11. Future Improvements
- Tích hợp AI tự động phát hiện lỗi sai lệch định lượng nguyên liệu phi thực tế trong công thức để cảnh báo trước cho biên tập viên.

## 12. References
- Content Moderation Workflow Design.

## 13. Related Documents
- [DOC-705 Moderation](./DOC-705%20Moderation.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
