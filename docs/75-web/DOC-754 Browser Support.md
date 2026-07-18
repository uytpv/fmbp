---
Document ID: DOC-754
Title: Web Browser Compatibility Matrix
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-750 Flutter Web](./DOC-750%20Flutter%20Web.md)
---

# Web Browser Compatibility Matrix

## 1. Objective
Quy định danh sách các trình duyệt web và phiên bản được hỗ trợ chính thức, đảm bảo trải nghiệm người dùng đồng nhất và không phát sinh lỗi giao diện.

## 2. Scope
Áp dụng cho kiểm thử khả năng tương thích của ứng dụng Web trên các trình duyệt máy tính và di động: Chrome, Safari, Firefox, Edge.

## 3. Business Context
Người dùng có thói quen sử dụng nhiều loại trình duyệt khác nhau. Bản đặc tả khả năng tương thích giúp lập trình viên biết phạm vi cần kiểm thử và các API trình duyệt nào an toàn để sử dụng (tránh sử dụng các tính năng thử nghiệm chưa phổ biến).

## 4. Functional Requirements
- **Danh sách trình duyệt hỗ trợ chính thức:**
  - Google Chrome: Phiên bản N-2 (phiên bản hiện tại và 2 bản trước đó).
  - Apple Safari: Phiên bản 15 trở lên.
  - Mozilla Firefox: Phiên bản N-1.
  - Microsoft Edge: Các phiên bản chạy nhân Chromium.
- Tự động chèn các Polyfills cần thiết cho trình duyệt cũ hơn khi biên dịch code.

## 5. Non-Functional Requirements
- Đảm bảo các lỗi giao diện (CSS styling bugs) trên các trình duyệt không làm đứt gãy luồng chức năng thanh toán và quản lý ngân sách.

## 6. Business Rules
- Không hỗ trợ chính thức các trình duyệt đã quá cũ hoặc đã bị khai tử như Internet Explorer (IE).

## 7. Data Model
- Không áp dụng.

## 8. Flow
- Người dùng mở trình duyệt -> Hệ thống kiểm tra User-Agent -> Nếu phát hiện trình duyệt quá cũ không tương thích -> Hiển thị thông báo khuyến nghị cập nhật trình duyệt để trải nghiệm tốt nhất.

## 9. API
- Trình duyệt User-Agent API.

## 10. Acceptance Criteria
- Ứng dụng Web hiển thị đúng font chữ Outfit/Inter và xử lý mượt mà các nút kéo thả thực đơn trên cả Google Chrome và Apple Safari.

## 11. Future Improvements
- Tích hợp dịch vụ kiểm thử tự động đa trình duyệt trên đám mây (BrowserStack) vào pipeline CI/CD.

## 12. References
- Can I Use database for browser compatibility checking.

## 13. Related Documents
- [DOC-306 Responsive](../30-design/DOC-306%20Responsive.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
