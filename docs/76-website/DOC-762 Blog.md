---
Document ID: DOC-762
Title: Blog Section Specification
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-761 SEO](./DOC-761%20SEO.md)
---

# Blog Section Specification

## 1. Objective
Đặc tả cấu trúc và quy trình xuất bản của chuyên mục Tin tức/Cẩm nang (Blog), nơi chia sẻ kiến thức về quản lý tài chính gia đình, công thức món ngon tiết kiệm và mẹo vặt nhà bếp.

## 2. Scope
Áp dụng cho cấu trúc trang Blog, luồng tạo bài viết mới từ hệ thống CMS (Content Management System) và quy tắc trình bày nội dung.

## 3. Business Context
Blog là công cụ đắc lực hỗ trợ chiến lược Content Marketing và SEO. Chia sẻ các kiến thức thực tế, chất lượng cao giúp xây dựng uy tín thương hiệu như một chuyên gia hàng đầu về lối sống tiết kiệm và dinh dưỡng gia đình.

## 4. Functional Requirements
- Hệ thống quản lý bài viết phân loại theo danh mục (Tài chính gia đình, Mẹo đi chợ, Công thức tiết kiệm).
- Khả năng chèn các widget tải ứng dụng hoặc liên kết trực tiếp với các công thức có sẵn trong ứng dụng chính (ví dụ người dùng đọc bài blog thấy món ăn ngon có thể click "Thêm vào thực đơn tuần của tôi").

## 5. Non-Functional Requirements
- Trang Blog phải được thiết kế tối ưu hóa tốc độ đọc (Readability UX): Kiểu chữ rõ ràng, khoảng cách dòng thoáng, độ rộng cột chữ vừa phải (60-80 ký tự/dòng).

## 6. Business Rules
- Mọi thông tin khoa học về dinh dưỡng hoặc sức khỏe chia sẻ trên Blog bắt buộc phải có nguồn tham khảo uy tín trích dẫn ở cuối bài viết.

## 7. Data Model
- BlogPost: Lưu thông tin bài viết (id, title, slug, content_markdown, author, published_at, status).

## 8. Flow
- Biên tập viên viết bài bằng Markdown -> Tải ảnh đại diện -> Nhấn xuất bản -> Hệ thống sinh trang tĩnh (SSG) -> Cập nhật Sitemap -> Hiển thị bài viết trên web.

## 9. API
- GET /api/v1/blog/posts: Lấy danh sách bài viết hiển thị trên giao diện web.

## 10. Acceptance Criteria
- Trang bài viết blog hỗ trợ hiển thị đầy đủ và đẹp mắt các định dạng văn bản, hình ảnh, trích dẫn, bảng biểu và video nhúng.

## 11. Future Improvements
- Tính năng bình luận (Comments) và đăng ký theo dõi bài viết của từng tác giả ẩm thực.

## 12. References
- Các nền tảng blog tĩnh hàng đầu: Hugo, Gatsby, VitePress.

## 13. Related Documents
- [DOC-760 Landing](./DOC-760%20Landing.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
