---
Document ID: DOC-750
Title: Flutter Web Integration
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-600 Flutter](../70-mobile/DOC-600%20Flutter.md)
---

# Flutter Web Integration

## 1. Objective
Đặc tả cấu hình, quy trình biên dịch và tối ưu hiệu năng của ứng dụng Web phát triển bằng Flutter Web để chia sẻ mã nguồn tối đa với bản Mobile.

## 2. Scope
Áp dụng cho dự án trong thư mục web/ của monorepo, quy định cơ chế dựng hình (HTML renderer vs CanvasKit/WebAssembly).

## 3. Business Context
Cung cấp phiên bản Web giúp người dùng có thể dễ dàng quản lý thực đơn gia đình trên màn hình máy tính lớn khi ở nhà hoặc văn phòng mà không phụ thuộc vào điện thoại di động.

## 4. Functional Requirements
- Biên dịch mã nguồn Flutter thành ứng dụng Web chạy trên môi trường trình duyệt.
- Tự động cấu hình định tuyến URL (Web Routing) thân thiện với trình duyệt (ví dụ: pp.fmpb.com/meal-plan).

## 5. Non-Functional Requirements
- Tối ưu hóa thời gian tải trang ban đầu (Initial load time) dưới 3 giây.
- Hỗ trợ cơ chế kết xuất CanvasKit cho các tương tác hoạt họa phức tạp và HTML renderer cho các dòng máy cấu hình yếu để tải nhanh.

## 6. Business Rules
- Phiên bản Web của ứng dụng chính phải được đặt sau lớp xác thực bảo mật (chỉ cho phép người dùng đã đăng nhập truy cập, không cho phép công cụ tìm kiếm index).

## 7. Data Model
- Không áp dụng.

## 8. Flow
- Người dùng truy cập URL -> Web server tải tệp JS/WASM -> Khởi tạo Flutter Engine -> Vẽ giao diện trên trình duyệt -> Yêu cầu đăng nhập -> Hiển thị dashboard Web.

## 9. API
- Flutter Web Engine APIs.

## 10. Acceptance Criteria
- Ứng dụng Web hoạt động ổn định, hiển thị đúng bố cục responsive trên các trình duyệt máy tính phổ biến.

## 11. Future Improvements
- Chuyển đổi hoàn toàn sang kết xuất WebAssembly (Wasm) khi Flutter Web đạt độ chín kỹ thuật tối đa để tăng hiệu năng vẽ giao diện gấp 2 lần.

## 12. References
- Flutter Web documentation.

## 13. Related Documents
- [DOC-751 Responsive](./DOC-751%20Responsive.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
