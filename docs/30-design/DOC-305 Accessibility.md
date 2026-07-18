---
Document ID: DOC-305
Title: Accessibility Specification (WCAG)
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-301 Typography](./DOC-301%20Typography.md)
- [DOC-302 Colors](./DOC-302%20Colors.md)
---

# Accessibility Specification (WCAG)

## 1. Objective
Quy định các tiêu chuẩn trợ năng (Accessibility) để đảm bảo ứng dụng có thể được sử dụng dễ dàng bởi tất cả mọi người, bao gồm cả người khiếm thị, người lớn tuổi mắt kém hoặc người khuyết tật vận động nhẹ.

## 2. Scope
Tập trung tuân thủ tiêu chuẩn **WCAG 2.1 AA** bao gồm: Độ tương phản màu sắc, kích thước vùng chạm (Touch Targets), hỗ trợ Screen Reader và điều chỉnh cỡ chữ hệ thống.

## 3. Business Context
Hoạt động quản lý tài chính và nấu nướng trong gia đình thường có sự tham gia của ông bà lớn tuổi. Thiết kế hỗ trợ trợ năng tốt giúp sản phẩm tiếp cận được lượng lớn tệp khách hàng gia đình nhiều thế hệ.

## 4. Functional Requirements
- **Touch Target Size:** Vùng chạm tối thiểu cho mọi nút bấm, liên kết là **44 x 44 dp** để tránh bấm nhầm.
- **Alt Text:** Tất cả hình ảnh (đặc biệt là ảnh công thức món ăn) phải có thuộc tính mô tả thay thế (lt text) để trình đọc màn hình đọc được.
- Đảm bảo các trường nhập liệu (TextField) luôn đi kèm nhãn (Label) rõ ràng, không ẩn nhãn khi người dùng nhập chữ.

## 5. Non-Functional Requirements
- Đạt điểm số trợ năng tối thiểu 90% trên các công cụ chấm điểm tự động (như Lighthouse Accessibility audit).

## 6. Business Rules
- Không sử dụng màu sắc làm chỉ thị thông tin duy nhất. Ví dụ: Để cảnh báo thực phẩm hết hạn, không chỉ bôi đỏ mà phải có thêm biểu tượng cảnh báo hoặc chữ "Đã hết hạn".

## 7. Data Model
- Không áp dụng.

## 8. Flow
- Không áp dụng.

## 9. API
- Không áp dụng.

## 10. Acceptance Criteria
- Người dùng có thể điều hướng toàn bộ các chức năng chính của app bằng bàn phím hoặc công cụ hỗ trợ giọng nói (VoiceOver/TalkBack).

## 11. Future Improvements
- Hỗ trợ chế độ mù màu (Colorblind mode) chuyên biệt.

## 12. References
- W3C Web Content Accessibility Guidelines (WCAG) 2.1.

## 13. Related Documents
- [DOC-306 Responsive](./DOC-306%20Responsive.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
