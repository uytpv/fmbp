---
Document ID: DOC-951
Title: Unit Testing Specifications
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-950 Test Strategy](./DOC-950%20Test%20Strategy.md)
---

# Unit Testing Specifications

## 1. Objective
Quy định tiêu chuẩn viết và tổ chức các bài kiểm thử đơn vị (Unit Tests) cho các hàm xử lý logic nghiệp vụ độc lập của hệ thống.

## 2. Scope
Áp dụng cho kiểm thử các lớp dữ liệu (Models), logic nghiệp vụ (Services, Repositories) và các hàm tiện ích dùng chung (Utils).

## 3. Business Context
Unit test là hàng phòng ngự đầu tiên chống lại các lỗi logic tính toán (ví dụ: tính toán sai số dư ngân sách, quy đổi sai đơn vị nguyên liệu). Đây là loại test chạy nhanh nhất và rẻ nhất để phát hiện lỗi lập trình.

## 4. Functional Requirements
- Sử dụng thư viện 	est mặc định của Dart/Flutter.
- Sử dụng thư viện **Mocktail** hoặc **Mockito** để giả lập (mock) các kết nối mạng và kết nối cơ sở dữ liệu bên ngoài.
- Quy tắc đặt tên file test: Trùng tên file code chính và thêm hậu tố _test.dart (ví dụ: udget_service_test.dart).

## 5. Non-Functional Requirements
- Đảm bảo thời gian chạy của toàn bộ bộ unit test dưới 2 phút trên máy cục bộ của lập trình viên.

## 6. Business Rules
- Mọi hàm logic nghiệp vụ mới được viết ra bắt buộc phải đi kèm ít nhất 3 kịch bản unit test: Kịch bản thành công (Happy path), Kịch bản lỗi đầu vào (Edge case), và Kịch bản xử lý ngoại lệ (Exception handling).

## 7. Data Model
- Các lớp Mock Classes phục vụ kiểm thử.

## 8. Flow
- Viết Test case -> Chạy test -> Phát hiện lỗi -> Sửa code chính -> Chạy lại test thành công (TDD - Test Driven Development).

## 9. API
- Mock APIs.

## 10. Acceptance Criteria
- Đạt 100% tỷ lệ chạy thành công đối với tất cả các bài unit test trước khi gửi Pull Request.

## 11. Future Improvements
- Tự động sinh mã nguồn unit test cơ bản bằng AI dựa trên đặc tả hàm logic.

## 12. References
- Flutter Unit Testing guidelines.

## 13. Related Documents
- [DOC-952 Widget Test](./DOC-952%20Widget%20Test.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
