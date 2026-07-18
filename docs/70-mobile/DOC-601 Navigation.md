---
Document ID: DOC-601
Title: Mobile Navigation Specs
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-354 Navigation UX](../35-ux/DOC-354%20Navigation%20UX.md)
---

# Mobile Navigation Specs

## 1. Objective
Quy định cơ chế điều hướng màn hình (Routing) cho ứng dụng di động, tích hợp xử lý Deep Links và chuyển đổi trạng thái giao diện.

## 2. Scope
Áp dụng cho thư viện điều hướng của Flutter, cấu hình Router định tuyến và quản lý Stack màn hình.

## 3. Business Context
Cơ chế điều hướng trơn tru giúp người dùng dễ dàng chuyển đổi qua lại giữa các màn hình Pantry và Shopping List mà không làm tải lại giao diện hay gián đoạn thông tin.

## 4. Functional Requirements
- Tích hợp thư viện điều hướng **go_router** cho Flutter.
- Cấu hình điều hướng lồng nhau (ShellRoute) cho thanh Bottom Navigation Bar.
- Xử lý Deep Linking mở trực tiếp tab/món ăn cụ thể từ tin nhắn thông báo.

## 5. Non-Functional Requirements
- Hiệu ứng chuyển cảnh màn hình (Slide/Fade transition) thực hiện mượt mà dưới 300ms.

## 6. Business Rules
- Không áp dụng.

## 7. Data Model
- AppRouter: Lớp cấu hình định tuyến tĩnh.

## 8. Flow
- Người dùng bấm nút -> Router phân tích URL/Path -> Tải Widget tương ứng -> Đẩy vào Navigation Stack -> Hiển thị màn hình mới.

## 9. API
- GoRouter API.

## 10. Acceptance Criteria
- Hệ thống khôi phục đúng stack màn hình trước đó khi người dùng nhấn nút Back hệ thống trên điện thoại Android.

## 11. Future Improvements
- Xây dựng mô hình điều hướng phân tán (Micro-frontends navigation) khi dự án chia nhỏ thành nhiều package độc lập.

## 12. References
- go_router package documentation on pub.dev.

## 13. Related Documents
- [DOC-600 Flutter](./DOC-600%20Flutter.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
