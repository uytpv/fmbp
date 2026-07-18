---
Document ID: DOC-352
Title: Wireflow Layout Specifications
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-351 Information Architecture](./DOC-351%20Information%20Architecture.md)
---

# Wireflow Layout Specifications

## 1. Objective
Quy định bố cục thô (Wireframe Layout) của các màn hình chính và mối liên kết điều hướng giữa chúng khi người dùng thực hiện tác vụ (Wireflow).

## 2. Scope
Đặc tả bố cục màn hình: Dashboard (Tổng quan), Pantry (Tủ lạnh), Meal Planner (Lên thực đơn tuần) và Shopping List.

## 3. Business Context
Tài liệu wireflow đóng vai trò như một bản vẽ kiến trúc thô giúp Designer thiết kế giao diện chi tiết (UI High-fidelity) mà không bị lệch hướng về mặt sắp xếp thông tin cốt lõi.

## 4. Functional Requirements
- **Bố cục Dashboard:**
  - Phần trên: Radial Progress hiển thị Ngân sách.
  - Phần giữa: Ngang (Horizontal Scroll) hiển thị món ăn 3 bữa hôm nay.
  - Phần dưới: Danh sách cảnh báo gấp (nguyên liệu sắp hỏng, ngân sách chạm đỏ).
- **Bố cục Pantry:**
  - Thanh tìm kiếm và bộ lọc nhanh (Tủ đông, Tủ mát) ở trên cùng.
  - Thân trang: Grid View các nguyên liệu kèm chỉ báo màu sắc hạn sử dụng.
  - Dưới cùng: Nút "+" nổi (Floating Action Button) để thêm nhanh đồ.

## 5. Non-Functional Requirements
- Bố cục wireframe phải tối ưu hóa tỷ lệ nội dung trên màn hình (Content-to-chrome ratio > 80% trên mobile).

## 6. Business Rules
- Không áp dụng.

## 7. Data Model
- Không áp dụng.

## 8. Flow
- Không áp dụng.

## 9. API
- Không áp dụng.

## 10. Acceptance Criteria
- Sắp xếp vị trí các nút chức năng cốt lõi (như nút Hoàn thành đi chợ) phải nằm trong vùng dễ chạm của ngón cái (Thumb zone) trên màn hình di động.

## 11. Future Improvements
- Thử nghiệm A/B testing bố cục màn hình chính để tìm ra thiết kế mang lại tỷ lệ giữ chân người dùng (Retention Rate) cao nhất.

## 12. References
- UX Pin Guide to Wireflows.

## 13. Related Documents
- [DOC-353 Interaction](./DOC-353%20Interaction.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
