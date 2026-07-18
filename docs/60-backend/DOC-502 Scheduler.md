---
Document ID: DOC-502
Title: Background Schedulers & Cron Jobs
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-403 Cloud Function](../40-platform/DOC-403%20Cloud%20Function.md)
---

# Background Schedulers & Cron Jobs

## 1. Objective
Đặc tả cấu hình các tác vụ chạy ngầm định kỳ (Cron Jobs/Schedulers) phục vụ việc dọn dẹp dữ liệu, tính toán thống kê tài chính và gửi cảnh báo tự động.

## 2. Scope
Áp dụng cho Google Cloud Scheduler, Firebase Scheduled Cloud Functions.

## 3. Business Context
Nhiều tác vụ vận hành không thể thực hiện theo tương tác của người dùng mà cần được lập lịch chạy tự động vào các khung giờ thấp điểm (đêm muộn) để tối ưu hiệu năng máy chủ.

## 4. Functional Requirements
- **Cron 1 (Hàng ngày - 07h00 sáng):** Quét Pantry phát hiện thực phẩm sắp hết hạn để gửi thông báo đẩy.
- **Cron 2 (Hàng tuần - 00h00 Chủ nhật):** Reset chu kỳ ngân sách tuần của gia đình và lưu báo cáo tuần cũ vào lịch sử.
- **Cron 3 (Hàng tháng - Ngày 10):** Chạy lệnh đối soát tự động doanh thu từ các đối tác siêu thị.

## 5. Non-Functional Requirements
- Đảm bảo các tác vụ lập lịch có cơ chế kiểm tra trùng lặp (Idempotency) để tránh việc một công việc bị thực thi 2 lần gây lỗi dữ liệu.

## 6. Business Rules
- Thời gian chạy cron phải được thiết lập theo múi giờ địa phương của người dùng (ví dụ: Asia/Ho_Chi_Minh đối với Việt Nam).

## 7. Data Model
- CronJobHistory: Theo dõi nhật ký chạy, kết quả (Success/Failed) và thời gian thực thi của từng Cron Job.

## 8. Flow
- Cloud Scheduler kích hoạt sự kiện theo lịch -> Gửi tin nhắn tới Cloud Pub/Sub -> Kích hoạt Cloud Function xử lý -> Hoàn tất và ghi log kết quả.

## 9. API
- Google Cloud Scheduler API, Pub/Sub Events.

## 10. Acceptance Criteria
- Hệ thống gửi cảnh báo khẩn cấp cho đội kỹ thuật nếu một tác vụ Cron Job quan trọng (như đối soát tài chính) bị chạy thất bại.

## 11. Future Improvements
- Tích hợp công cụ quản lý hàng đợi tác vụ phức tạp (Cloud Tasks) hỗ trợ cơ chế tự động thử lại (Retry backoff) khi gặp sự cố mạng tạm thời.

## 12. References
- Unix Cron format standards.

## 13. Related Documents
- [DOC-556 Monitoring](../50-infrastructure/DOC-556%20Monitoring.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
