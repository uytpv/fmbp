---
Document ID: DOC-306
Title: Responsive & Adaptive Design
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-300 Design System](./DOC-300%20Design%20System.md)
---

# Responsive & Adaptive Design

## 1. Objective
Quy định cách thức giao diện tự động thích ứng (Responsive) và chuyển đổi hành vi (Adaptive) trên các kích thước màn hình khác nhau từ điện thoại nhỏ, máy tính bảng đến máy tính để bàn.

## 2. Scope
Bao gồm định nghĩa các điểm gãy (Breakpoints), bố cục thay đổi (Layout shift) và cách thức sắp xếp lại các thành phần thông tin trên màn hình lớn.

## 3. Business Context
Người nội trợ có thể xem thực đơn trên iPhone khi đi làm, dùng iPad đặt trên bàn bếp khi đang chuẩn bị nấu ăn, hoặc Admin dùng máy tính để bàn quản lý ngân sách. Giao diện thích ứng tốt giúp trải nghiệm không bị gãy đổ.

## 4. Functional Requirements
- **Breakpoints:**
  - Mobile: < 600px (Layout 1 cột dọc, thanh điều hướng dưới chân).
  - Tablet: 600px - 1024px (Layout 2 cột chia đôi, thanh điều hướng chuyển sang Sidebar thu gọn).
  - Desktop: > 1024px (Layout 3 cột, thanh điều hướng Sidebar mở rộng, hỗ trợ kéo thả nâng cao).

## 5. Non-Functional Requirements
- Bố cục giao diện chuyển đổi mượt mà khi xoay ngang/xoay dọc màn hình máy tính bảng.

## 6. Business Rules
- Không áp dụng.

## 7. Data Model
- Không áp dụng.

## 8. Flow
- Không áp dụng.

## 9. API
- Không áp dụng.

## 10. Acceptance Criteria
- Trên màn hình Desktop, thông tin chi tiết của công thức phải được hiển thị song song bên cạnh danh sách Meal Plan thay vì mở đè toàn màn hình như trên Mobile.

## 11. Future Improvements
- Tối ưu giao diện cho các màn hình gập (Foldable devices) thế hệ mới.

## 12. References
- Material Design Adaptive Layout guide.

## 13. Related Documents
- [DOC-305 Accessibility](./DOC-305%20Accessibility.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
