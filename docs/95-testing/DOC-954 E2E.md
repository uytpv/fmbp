---
Document ID: DOC-954
Title: End-to-End (E2E) Testing Specs
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-950 Test Strategy](./DOC-950%20Test%20Strategy.md)
---

# End-to-End (E2E) Testing Specs

## 1. Objective
Quy định tiêu chuẩn và công cụ kiểm thử toàn trình (E2E Testing), mô phỏng hoàn chỉnh hành vi của người dùng thực tế trên thiết bị để đảm bảo tính sẵn sàng phát hành.

## 2. Scope
Áp dụng cho E2E Testing của ứng dụng di động di chuyển qua tất cả các màn hình chính và ứng dụng Web/Admin.

## 3. Business Context
E2E Test là chốt chặn chất lượng cuối cùng. Nếu một bản build vượt qua unit test nhưng bị lỗi đen màn hình (black screen) ngay khi mở app do xung đột thư viện native, E2E Test trên thiết bị thật sẽ phát hiện ra ngay lập tức, bảo vệ người dùng khỏi trải nghiệm tồi tệ.

## 4. Functional Requirements
- Sử dụng công cụ **Patrol** (cho Flutter Mobile E2E) và **Playwright** (cho Web/Admin E2E).
- Viết kịch bản test luồng đi chợ hoàn chỉnh: Mở app -> Chọn thực đơn tuần -> Nhấn tạo danh sách -> Gạch bỏ trứng -> Xác nhận đi chợ -> Kiểm tra số dư ngân sách bị giảm.

## 5. Non-Functional Requirements
- Đảm bảo E2E test có thể chạy tự động trên các thiết bị ảo (Emulators/Simulators) trong pipeline CI/CD mà không cần can thiệp thủ công.

## 6. Business Rules
- Bảng cơ sở dữ liệu dùng cho E2E test phải tách biệt hoàn toàn và được tự động reset trạng thái ban đầu trước mỗi lượt chạy.

## 7. Data Model
- Không áp dụng.

## 8. Flow
- Kích hoạt script test -> Mở app -> Click tọa độ màn hình -> Nhập chữ giả lập -> Quét giao diện kiểm tra phần tử -> Đóng app -> Kết xuất báo cáo video/ảnh chụp màn hình nếu lỗi.

## 9. API
- Patrol CLI, Playwright Test APIs.

## 10. Acceptance Criteria
- Luồng E2E test cốt lõi (Happy path của việc Đi chợ & Quản lý ngân sách) phải chạy thành công 100% không gặp lỗi ngắt quãng trên cả hai hệ điều hành iOS và Android.

## 11. Future Improvements
- Tích hợp dịch vụ chạy test trên đám mây thiết bị thật (AWS Device Farm hoặc Firebase Test Lab) để kiểm tra tương thích trên nhiều dòng máy thực tế khác nhau.

## 12. References
- Patrol by LeanCode documentation, Playwright automation framework guide.

## 13. Related Documents
- [DOC-955 UAT](./DOC-955%20UAT.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
