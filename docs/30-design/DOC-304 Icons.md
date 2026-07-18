---
Document ID: DOC-304
Title: Iconography Specification
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-303 Components](./DOC-303%20Components.md)
---

# Iconography Specification

## 1. Objective
Quy định bộ icon (biểu tượng) chuẩn được sử dụng trong hệ thống, đảm bảo sự đồng bộ về nét vẽ, độ dày và ý nghĩa biểu thị.

## 2. Scope
Quy định thư viện icon nguồn (Lucide/Feather), kích thước tiêu chuẩn và cách áp dụng icon cho các tính năng tương ứng.

## 3. Business Context
Icon giúp người dùng quét nhanh giao diện và nhận diện chức năng mà không cần đọc chữ, tối ưu hóa tốc độ tương tác trên màn hình nhỏ.

## 4. Functional Requirements
- **Thư viện icon nguồn:** **Lucide Icons** (dạng nét vẽ outline mảnh, hiện đại).
- **Kích thước tiêu chuẩn (Sizing Scale):**
  - Small (trong text/badge): 16px, nét dày 1.5px.
  - Medium (nút bấm, list item, bottom nav): 24px, nét dày 2px.
  - Large (header, empty state): 32px hoặc 48px, nét dày 2px.
- **Ý nghĩa áp dụng:**
  - Home: Tổng quan ngân sách (Dashboard).
  - Utensils: Thực đơn (Meal Plan).
  - ShoppingCart: Danh sách đi chợ.
  - Refrigerator: Tủ lạnh/Kho hàng (Pantry).

## 5. Non-Functional Requirements
- Tất cả các icon phải được lưu ở dạng SVG để đảm bảo độ sắc nét khi phóng to thu nhỏ.

## 6. Business Rules
- Không áp dụng.

## 7. Data Model
- Không áp dụng.

## 8. Flow
- Không áp dụng.

## 9. API
- Không áp dụng.

## 10. Acceptance Criteria
- Tuyệt đối không phối trộn các icon nét dày (Solid) và nét mảnh (Outline) trên cùng một thanh điều hướng.

## 11. Future Improvements
- Thiết kế riêng một bộ icon độc quyền mang dấu ấn thương hiệu Family Meal Budget Planner.

## 12. References
- Lucide Icons library.

## 13. Related Documents
- [DOC-300 Design System](./DOC-300%20Design%20System.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
