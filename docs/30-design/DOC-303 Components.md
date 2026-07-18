---
Document ID: DOC-303
Title: UI Components Library
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-300 Design System](./DOC-300%20Design%20System.md)
---

# UI Components Library

## 1. Objective
Đặc tả thiết kế và trạng thái của các thành phần giao diện (UI Components) cốt lõi được sử dụng lặp lại trên ứng dụng.

## 2. Scope
Bao gồm cấu trúc và hành vi của các thành phần: Card (Thẻ công thức, thẻ ngân sách), Button, Input Field, Badge, List Item và Modal Bottom Sheet.

## 3. Business Context
Việc định nghĩa thư viện component dùng chung giúp đẩy nhanh tốc độ code của lập trình viên và đảm bảo trải nghiệm người dùng nhất quán, dễ đoán trên toàn bộ ứng dụng.

## 4. Functional Requirements
- **Budget Card (Thẻ ngân sách):** Hiển thị dạng biểu đồ vòng tròn (Radial Progress) cho thấy tỷ lệ tiền đã tiêu/ngân sách còn lại.
- **Recipe Card (Thẻ công thức):** Hiển thị ảnh món ăn, tiêu đề, thời gian nấu, mức chi phí ước tính ($ /  / $) và tag phân loại.
- **Pantry List Item (Dòng thực phẩm):** Hiển thị tên nguyên liệu, số lượng tồn kho, thanh hạn sử dụng màu sắc (Xanh: Còn lâu; Đỏ: Sắp hỏng).

## 5. Non-Functional Requirements
- Các components phải hỗ trợ các trạng thái cơ bản: Default, Hover, Focused, Disabled, và Loading.

## 6. Business Rules
- Nút Action chính (CTA) trên một màn hình chỉ được xuất hiện tối đa 1 nút nổi bật nhất (sử dụng Primary/Accent Color).

## 7. Data Model
- Không áp dụng.

## 8. Flow
- Không áp dụng.

## 9. API
- Không áp dụng.

## 10. Acceptance Criteria
- Các component được phát triển phải giống 100% bản đặc tả và các trạng thái tương ứng trong thiết kế Figma.

## 11. Future Improvements
- Xây dựng Storybook để quản lý trực quan toàn bộ thư viện component của dự án.

## 12. References
- Storybook.js documentation.

## 13. Related Documents
- [DOC-304 Icons](./DOC-304%20Icons.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
