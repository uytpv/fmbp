---
Document ID: DOC-353
Title: Interaction & Motion Specification
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-300 Design System](../30-design/DOC-300%20Design%20System.md)
---

# Interaction & Motion Specification

## 1. Objective
Đặc tả các quy tắc chuyển động (Motion), hiệu ứng chuyển cảnh (Transitions) và tương tác vật lý (Gestures) để mang lại cảm giác sống động, mượt mà và trực quan cho ứng dụng.

## 2. Scope
Quy định thời lượng chuyển động (Duration), đường cong gia tốc (Easing), các tương tác cử chỉ vuốt chạm và phản hồi xúc giác (Haptic Feedback).

## 3. Business Context
Các hiệu ứng vi chuyển động (Micro-animations) giúp giảm thời gian chờ đợi cảm nhận (Perceived latency) của người dùng khi ứng dụng đang tải dữ liệu hoặc AI đang xử lý thực đơn.

## 4. Functional Requirements
- **Thời lượng chuyển động tiêu chuẩn:**
  - Tương tác nút bấm/Hiệu ứng nhỏ: 150ms.
  - Chuyển trang/Mở Bottom Sheet: 300ms.
  - AI đang tính toán (Shimmer loading): Hiệu ứng lặp vô tận chu kỳ 1.5s.
- **Tương tác cử chỉ (Gestures):**
  - Vuốt sang trái (Swipe Left) trên dòng nguyên liệu Pantry để mở nhanh nút Xóa.
  - Kéo thả (Drag and Drop) công thức từ danh sách gợi ý vào các ngày trong tuần ở màn hình Meal Plan.
  - Kéo xuống để làm mới (Pull-to-refresh) dữ liệu tủ lạnh và ngân sách.

## 5. Non-Functional Requirements
- Đảm bảo tốc độ khung hình hiệu ứng đạt tối thiểu 60 FPS trên các thiết bị di động tầm trung.

## 6. Business Rules
- Mọi hành động gạch bỏ thành công một mặt hàng trong Shopping List phải đi kèm một hiệu ứng gạch ngang nhẹ nhàng và phản hồi rung xúc giác ngắn (light haptic feedback) để tạo cảm giác hài lòng cho người dùng.

## 7. Data Model
- Không áp dụng.

## 8. Flow
- Không áp dụng.

## 9. API
- Không áp dụng.

## 10. Acceptance Criteria
- Hiệu ứng chuyển động không được gây giật lag hoặc gãy khung hình khi thực hiện trên các dòng máy phân khúc phổ thông.

## 11. Future Improvements
- Tích hợp hiệu ứng âm thanh nhỏ (Sound UI) vui tai khi người dùng nấu xong một bữa ăn hoặc tiết kiệm được ngân sách tuần.

## 12. References
- Material Design Motion system.

## 13. Related Documents
- [DOC-350 User Flow](./DOC-350%20User%20Flow.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
