---
Document ID: DOC-751
Title: Web Responsive Grid Specs
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-306 Responsive](../30-design/DOC-306%20Responsive.md)
---

# Web Responsive Grid Specs

## 1. Objective
Quy định chi tiết lưới phản hồi (Responsive Grid) và cách thức chuyển đổi bố cục giao diện của ứng dụng Web trên các kích thước trình duyệt máy tính.

## 2. Scope
Đặc tả lưới 12 cột cho màn hình Desktop, khoảng lề (Margin), khoảng cách giữa các cột (Gutter) và hành vi thích ứng của sidebar.

## 3. Business Context
Màn hình máy tính có không gian hiển thị rộng rãi, giao diện Web cần tận dụng tối đa diện tích này để hiển thị song song nhiều thông tin (ví dụ: vừa xem thực đơn tuần, vừa xem danh sách nguyên liệu đi chợ ở cột bên cạnh) thay vì kéo giãn giao diện di động ra.

## 4. Functional Requirements
- Hệ thống lưới 12 cột hoạt động động theo chiều rộng cửa sổ trình duyệt.
- Thanh điều hướng bên trái (Navigation Sidebar) có thể thu gọn (collapsed) về dạng icon để tăng diện tích hiển thị nội dung chính.

## 5. Non-Functional Requirements
- Đảm bảo không xảy ra hiện tượng chồng chéo văn bản (Text clipping) khi người dùng co giãn cửa sổ trình duyệt đột ngột.

## 6. Business Rules
- Khoảng lề ngoài cùng (Outer margin) tối thiểu là 24px trên máy tính để bàn để đảm bảo giao diện có không gian thở (White space).

## 7. Data Model
- Không áp dụng.

## 8. Flow
- Người dùng co giãn trình duyệt -> Hệ thống bắt sự kiện resize -> Tính toán lại số cột hiển thị -> Sắp xếp lại các thẻ Widget -> Vẽ lại giao diện.

## 9. API
- Flutter MediaQuery và LayoutBuilder APIs.

## 10. Acceptance Criteria
- Giao diện tự động chuyển đổi mượt mà giữa bố cục 2 cột (cho màn hình nhỏ/máy tính bảng) và 3 cột (cho màn hình máy tính lớn) mà không bị lỗi tràn viền (Overflow pixels).

## 11. Future Improvements
- Phát triển hệ thống lưới tự động thích ứng dựa trên công nghệ Flexbox và CSS Grid cho phiên bản Web thuần.

## 12. References
- Responsive Grid Design Principles.

## 13. Related Documents
- [DOC-754 Browser Support](./DOC-754%20Browser%20Support.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
