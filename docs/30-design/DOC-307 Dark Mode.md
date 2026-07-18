---
Document ID: DOC-307
Title: Dark Mode Specification
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-302 Colors](./DOC-302%20Colors.md)
---

# Dark Mode Specification

## 1. Objective
Quy chuẩn thiết kế giao diện chế độ Tối (Dark Mode), giúp giảm mỏi mắt cho người dùng khi sử dụng ứng dụng vào ban đêm hoặc trong điều kiện ánh sáng yếu.

## 2. Scope
Đặc tả bảng màu tối (Dark theme colors), nguyên tắc đổ bóng trên nền tối (Elevation-based lighting) và điều chỉnh độ sáng hình ảnh.

## 3. Business Context
Nhiều gia đình có thói quen lên thực đơn tuần hoặc ghi chép ngân sách chi tiêu vào cuối ngày trước khi đi ngủ. Một giao diện Dark Mode dịu mắt sẽ gia tăng thời gian và trải nghiệm sử dụng ứng dụng trong khung giờ này.

## 4. Functional Requirements
- **Màu nền tối chủ đạo:** #0F172A (Slate-900) thay vì màu đen tuyền #000000 để tránh tạo độ tương phản quá gắt.
- **Màu thẻ/bảng biểu (Surface):** #1E293B (Slate-800) hoặc #334155 (Slate-700) tùy theo độ nổi (Elevation).
- Điều chỉnh giảm độ bão hòa (Saturation) của các màu sắc nóng để giao diện trông dịu và cao cấp hơn.

## 5. Non-Functional Requirements
- Đảm bảo độ tương phản của chữ trắng trên nền tối vẫn đạt chuẩn tối thiểu 4.5:1.

## 6. Business Rules
- Không áp dụng.

## 7. Data Model
- Không áp dụng.

## 8. Flow
- Người dùng chuyển đổi chế độ Sáng/Tối -> Ứng dụng cập nhật cấu hình -> Toàn bộ component thay đổi theme tương ứng mà không làm gián đoạn luồng dữ liệu người dùng đang nhập.

## 9. API
- Không áp dụng.

## 10. Acceptance Criteria
- Các hình ảnh minh họa (illustrations) phải tự động đổi sang phiên bản màu tối tương ứng để không gây chói mắt đột ngột.

## 11. Future Improvements
- Tự động bật/tắt Dark Mode theo múi giờ mặt trời mọc/lặn thực tế của người dùng.

## 12. References
- Material Design Dark Theme specs.

## 13. Related Documents
- [DOC-302 Colors](./DOC-302%20Colors.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
