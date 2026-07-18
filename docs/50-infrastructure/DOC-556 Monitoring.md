---
Document ID: DOC-556
Title: System Monitoring & Alerting
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-400 Architecture](../40-platform/DOC-400%20Architecture.md)
---

# System Monitoring & Alerting

## 1. Objective
Quy định cơ chế giám sát sức khỏe hệ thống (Monitoring) và tự động gửi cảnh báo (Alerting) khi có sự cố kỹ thuật xảy ra nhằm giảm thiểu thời gian gián đoạn dịch vụ (Downtime).

## 2. Scope
Áp dụng cho giám sát hạ tầng cloud (Firebase/GCP), thu thập log lỗi từ Client di động (Crashlytics) và giám sát hiệu năng API.

## 3. Business Context
Sự cố kỹ thuật có thể xảy ra bất cứ lúc nào (lỗi API, lỗi thanh toán...). Hệ thống giám sát tốt giúp đội ngũ kỹ thuật phát hiện và xử lý lỗi ngay lập tức, thậm chí trước khi người dùng kịp phát hiện và phàn nàn.

## 4. Functional Requirements
- Tích hợp Firebase Crashlytics để thu thập lỗi gãy app (Crashes) thời gian thực của người dùng.
- Cấu hình cảnh báo tự động qua các kênh truyền thông (Slack/Discord/Email) khi tỷ lệ lỗi của Cloud Functions tăng đột biến vượt quá 1% trong 5 phút.
- Giám sát độ trễ phản hồi của AI Gateway.

## 5. Non-Functional Requirements
- Đảm bảo hệ thống giám sát hoạt động độc lập và không làm ảnh hưởng đến hiệu năng hoạt động của ứng dụng chính.

## 6. Business Rules
- Báo cáo chỉ số ổn định (Crash-free users rate) hàng tuần. Mục tiêu duy trì tỷ lệ này ở mức > 99.8%.

## 7. Data Model
- MetricLog: Cấu trúc dữ liệu ghi nhận chỉ số hiệu năng hệ thống.

## 8. Flow
- Hệ thống gặp lỗi -> Google Cloud Alerting bắt được sự kiện -> Đối chiếu cấu hình -> Gửi tin nhắn khẩn cấp kèm thông tin log qua kênh chat của đội ngũ On-call.

## 9. API
- Google Cloud Monitoring APIs, Crashlytics API.

## 10. Acceptance Criteria
- Cảnh báo được gửi tới kênh nhận tin nhắn của đội ngũ kỹ thuật trong vòng dưới 1 phút kể từ khi sự cố hệ thống vượt ngưỡng thiết lập.

## 11. Future Improvements
- Sử dụng AI để dự báo trước các nguy cơ lỗi hệ thống dựa trên phân tích xu hướng tải của máy chủ.

## 12. References
- Site Reliability Engineering (SRE) Google handbook.

## 13. Related Documents
- [DOC-557 Backup & Recovery](./DOC-557%20Backup%20&%20Recovery.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
