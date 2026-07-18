---
Document ID: DOC-952
Title: Widget Testing Specifications
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-950 Test Strategy](./DOC-950%20Test%20Strategy.md)
---

# Widget Testing Specifications

## 1. Objective
Quy định tiêu chuẩn viết và tổ chức các bài kiểm thử thành phần giao diện di động (Widget Tests) để đảm bảo các nút bấm, thẻ thông tin hiển thị đúng cấu trúc và tương tác tốt.

## 2. Scope
Áp dụng cho kiểm thử các widgets Flutter cô lập (ví dụ: nút bấm CustomButton, thẻ RecipeCard, hộp thoại cảnh báo).

## 3. Business Context
Đảm bảo giao diện người dùng hoạt động chính xác về mặt hiển thị và tương tác vuốt chạm mà không cần phải khởi chạy toàn bộ ứng dụng trên thiết bị mô phỏng nặng nề.

## 4. Functional Requirements
- Sử dụng công cụ lutter_test mặc định.
- Sử dụng phương pháp bơm dữ liệu giả lập (Widget Pump) để kích hoạt trạng thái giao diện.
- Viết các bài kiểm thử kiểm tra sự xuất hiện của các phần tử văn bản, icon và hành vi kích hoạt callback khi nhấn nút.

## 5. Non-Functional Requirements
- Đảm bảo thời gian chạy của bộ widget test dưới 3 phút.

## 6. Business Rules
- Không kết nối với mạng internet hay cơ sở dữ liệu thật trong các bài widget test; bắt buộc phải mock hoàn toàn các tầng dữ liệu phụ thuộc.

## 7. Data Model
- Không áp dụng.

## 8. Flow
- Khởi tạo môi trường test widget -> Bơm widget vào cây giao diện (tester.pumpWidget) -> Tìm kiếm phần tử (find.byType/find.byText) -> Mô phỏng hành động tap -> Kiểm tra kết quả hiển thị mong muốn.

## 9. API
- Flutter Widget Tester API.

## 10. Acceptance Criteria
- Toàn bộ các component dùng chung trong Design System phải vượt qua bài kiểm thử hiển thị ở mọi trạng thái (Default, Disabled, Active).

## 11. Future Improvements
- Tích hợp kiểm thử so khớp hình ảnh (Golden Image Tests) để tự động phát hiện sự sai lệch pixel giao diện giữa các phiên bản hệ điều hành.

## 12. References
- Flutter Widget Testing guide.

## 13. Related Documents
- [DOC-303 Components](../30-design/DOC-303%20Components.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
