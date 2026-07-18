---
Document ID: DOC-760
Title: Landing Page Specification
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-100 Business Model](../10-business/DOC-100%20Business%20Model.md)
---

# Landing Page Specification

## 1. Objective
Đặc tả cấu trúc thông tin, bố cục thiết kế và nội dung tiếp thị của Trang chủ giới thiệu sản phẩm (Landing Page) nhằm tối ưu hóa tỷ lệ chuyển đổi khách truy cập thành lượt tải ứng dụng.

## 2. Scope
Áp dụng cho trang web chính thức chạy ở tên miền gốc (ví dụ: mpb.com), định nghĩa các khối nội dung tiếp thị và các nút kêu gọi hành động (CTA).

## 3. Business Context
Landing Page là bộ mặt thương hiệu của dự án trên internet. Đây là nơi tiếp cận khách hàng tiềm năng đầu tiên từ các chiến dịch chạy quảng cáo hoặc tìm kiếm tự nhiên. Giao diện trang chủ phải cực kỳ ấn tượng, truyền tải thông điệp nhanh trong 3 giây đầu và kích thích họ nhấn nút Tải app.

## 4. Functional Requirements
- Bố cục Landing Page gồm các phần: Hero Section (thông điệp chính + ảnh chụp app), Khối giải pháp (nêu nỗi đau + cách app xử lý), Khối tính năng chính (Lập thực đơn, Tiết kiệm ngân sách), Khối bảng giá minh bạch, và Chân trang (Footer).
- Tích hợp các nút CTA lớn "Tải xuống trên App Store" và "Tải xuống trên Google Play".
- Form đăng ký nhận tin tức khuyến mãi/bản tin dinh dưỡng (Newsletter signup).

## 5. Non-Functional Requirements
- Đạt điểm số hiệu năng tải trang (Lighthouse Performance Score) trên 95% để tối ưu hóa chi phí quảng cáo và SEO.
- Tốc độ tải trang dưới 1.5 giây trên kết nối mạng di động 3G/4G thông thường.

## 6. Business Rules
- Landing Page phải là trang tĩnh hoàn toàn (Static HTML/CSS hoặc sử dụng Next.js SSG) để tối đa tốc độ phản hồi và bảo mật.

## 7. Data Model
- LeadRegistration: Lưu thông tin email người dùng đăng ký nhận tin tức.

## 8. Flow
- Người dùng truy cập trang chủ -> Đọc thông điệp hấp dẫn -> Cuộn xem tính năng -> Nhấn nút "Tải App" -> Hệ thống tự động phát hiện thiết bị (iOS/Android) -> Chuyển hướng đến App Store tương ứng.

## 9. API
- POST /api/v1/leads/register: Lưu email đăng ký newsletter của khách truy cập.

## 10. Acceptance Criteria
- Trang web tương thích và hiển thị hoàn hảo trên cả trình duyệt di động (Mobile-friendly layout).

## 11. Future Improvements
- Triển khai công cụ kiểm thử A/B Testing tiêu đề (Headlines) và màu sắc nút bấm để tìm ra phiên bản tối ưu tỷ lệ chuyển đổi (CRO) cao nhất.

## 12. References
- Conversion Rate Optimization (CRO) best practices.

## 13. Related Documents
- [DOC-763 Download Page](./DOC-763%20Download%20Page.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
