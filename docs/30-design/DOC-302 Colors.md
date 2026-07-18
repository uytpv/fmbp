---
Document ID: DOC-302
Title: Color Palette & Mappings
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-300 Design System](./DOC-300%20Design%20System.md)
---

# Color Palette & Mappings

## 1. Objective
Định nghĩa hệ màu sắc chuẩn của ứng dụng, quy định cách map màu cho các thành phần giao diện ở cả chế độ Sáng (Light) và Tối (Dark).

## 2. Scope
Bao gồm định nghĩa mã màu HEX cho màu Chủ đạo (Primary), màu Nhấn (Accent), màu Trung tính (Neutrals) và màu Trạng thái (Semantic).

## 3. Business Context
Màu sắc đại diện cho ngôn ngữ thương hiệu. Màu xanh bạc hà gợi lên sự tươi ngon của thực phẩm và sự an tâm về tài chính, kết hợp màu cam san hô kích thích vị giác sẽ tạo ra cảm xúc tích cực cho người dùng.

## 4. Functional Requirements
- **Primary Color (Fresh Mint):** #10B981 (Emerald-500) - Tượng trưng cho thực phẩm tươi sạch và tài chính lành mạnh.
- **Accent Color (Coral Orange):** #F97316 (Orange-500) - Kích thích vị giác, dùng cho các nút CTA chính và cảnh báo tài chính.
- **Semantic Colors:**
  - Success: #10B981 (Đã mua đồ/Hoàn thành mục tiêu chi tiêu).
  - Warning: #F59E0B (Ngân sách sắp chạm hạn mức).
  - Error: #EF4444 (Vượt hạn mức ngân sách/Thực phẩm hết hạn).
- **Neutrals:**
  - Background Light: #F8FAFC (Slate-50)
  - Surface Light: #FFFFFF

## 5. Non-Functional Requirements
- Đảm bảo độ tương phản màu sắc (Color Contrast Ratio) giữa chữ và nền đạt tối thiểu 4.5:1.

## 6. Business Rules
- Không áp dụng.

## 7. Data Model
- Không áp dụng.

## 8. Flow
- Không áp dụng.

## 9. API
- Không áp dụng.

## 10. Acceptance Criteria
- Giao diện phải chuyển đổi chính xác toàn bộ bảng màu khi người dùng bật tắt Dark Mode.

## 11. Future Improvements
- Hỗ trợ Dynamic Color dựa trên hệ điều hành Android (Material You).

## 12. References
- WCAG Color Contrast Checker.

## 13. Related Documents
- [DOC-307 Dark Mode](./DOC-307%20Dark%20Mode.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
