---
Document ID: DOC-761
Title: Landing Page SEO Strategy
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-760 Landing](./DOC-760%20Landing.md)
---

# Landing Page SEO Strategy

## 1. Objective
Xác định chiến lược tối ưu hóa công cụ tìm kiếm (SEO) cho Landing Page và trang Blog để thu hút lưu lượng truy cập tự nhiên (Organic Traffic) từ Google.

## 2. Scope
Bao gồm nghiên cứu từ khóa (Keywords), cấu hình On-page SEO (Thẻ tiêu đề, Meta Description, Alt text), cấu trúc dữ liệu Schema.org và chiến lược liên kết nội bộ.

## 3. Business Context
Chi phí chạy quảng cáo ngày càng đắt đỏ. SEO là kênh tiếp thị bền vững nhất trong dài hạn giúp dự án liên tục có lượt tải app mới mỗi ngày từ những người dùng đang tìm kiếm giải pháp cho câu hỏi "cách tiết kiệm tiền chợ hàng tuần" hoặc "lập thực đơn gia đình".

## 4. Functional Requirements
- Tối ưu cấu trúc URL thân thiện (Semantic URLs, ví dụ: fmpb.com/blog/cach-tiet-kiem-tien-cho).
- Tự động sinh tệp chỉ mục sitemap.xml và khai báo tự động với Google Search Console.
- Chèn thẻ dữ liệu cấu trúc Schema.org (SoftwareApplication markup) để hiển thị đánh giá sao và giá app đẹp mắt trên trang Google Search.

## 5. Non-Functional Requirements
- Đảm bảo tất cả các trang nội dung đạt điểm chuẩn SEO tuyệt đối trên công cụ Lighthouse (100% SEO Score).

## 6. Business Rules
- **Từ khóa mục tiêu cốt lõi:** "quản lý tiền ăn gia đình", "lập thực đơn tuần tiết kiệm", "tiết kiệm tiền chợ", "app đi chợ thông minh".

## 7. Data Model
- Cấu trúc file sitemap.xml.

## 8. Flow
- Người dùng tìm "cách quản lý tiền chợ" trên Google -> Thấy bài viết blog của FMPB -> Click đọc -> Nhận thấy giá trị -> Click nút tải app trên trang Blog -> Chuyển sang Store tải app.

## 9. API
- Không áp dụng.

## 10. Acceptance Criteria
- Các trang nội dung được lập chỉ mục thành công và hiển thị chính xác các thẻ Meta Title và Meta Description đã cấu hình trên Google Search.

## 11. Future Improvements
- Sử dụng AI để nghiên cứu từ khóa xu hướng hàng tuần và tự động phác thảo dàn ý nội dung (Content outlines) cho đội ngũ viết bài Blog.

## 12. References
- Google SEO Starter Guide, Schema.org specifications.

## 13. Related Documents
- [DOC-762 Blog](./DOC-762%20Blog.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
