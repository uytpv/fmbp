---
Document ID: DOC-301
Title: Typography Specification
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-300 Design System](./DOC-300%20Design%20System.md)
---

# Typography Specification

## 1. Objective
Quy định kiểu chữ, kích thước, độ dày và khoảng cách dòng trên toàn bộ hệ thống giao diện để đảm bảo tính dễ đọc và thẩm mỹ cao.

## 2. Scope
Đặc tả font chữ mặc định, phân cấp chữ (Type Scale) cho Tiêu đề (Headings), Thân bài (Body), Chú thích (Captions) và các nút bấm.

## 3. Business Context
Typography tốt giúp người nội trợ dễ dàng đọc nhanh công thức nấu ăn hoặc danh sách mua sắm ngay cả khi đang cầm chảo nóng hoặc di chuyển trong siêu thị đông người.

## 4. Functional Requirements
- **Font chữ chính (Primary Font):** **Outfit** (mang lại cảm giác hiện đại, công nghệ, thân thiện).
- **Font chữ phụ (Secondary Font - cho văn bản dài):** **Inter** (tối ưu độ hiển thị sắc nét của chữ nhỏ).
- **Type Scale:**
  - Display Large: 40px, Line-height 48px, Weight Bold (700)
  - Heading Medium: 24px, Line-height 32px, Weight SemiBold (600)
  - Body Medium (mặc định): 16px, Line-height 24px, Weight Regular (400)
  - Caption: 12px, Line-height 16px, Weight Medium (500)

## 5. Non-Functional Requirements
- Đảm bảo font chữ hiển thị tốt trên cả màn hình mật độ điểm ảnh thấp và cao (Retina/OLED).

## 6. Business Rules
- Không áp dụng.

## 7. Data Model
- Không áp dụng.

## 8. Flow
- Không áp dụng.

## 9. API
- Không áp dụng.

## 10. Acceptance Criteria
- Không sử dụng quá 2 họ font chữ (font family) khác nhau trong cùng một màn hình để tránh rối mắt.

## 11. Future Improvements
- Hỗ trợ Dynamic Text Scaling tự động điều chỉnh cỡ chữ theo cấu hình trợ năng của hệ điều hành.

## 12. References
- Google Fonts (Outfit, Inter).

## 13. Related Documents
- [DOC-305 Accessibility](./DOC-305%20Accessibility.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
