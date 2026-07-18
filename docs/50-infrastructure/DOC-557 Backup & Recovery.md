---
Document ID: DOC-557
Title: Database Backup & Recovery Plan
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-402 Firestore](../40-platform/DOC-402%20Firestore.md)
---

# Database Backup & Recovery Plan

## 1. Objective
Quy định cơ chế sao lưu dữ liệu (Backup) định kỳ và lập kế hoạch khôi phục sau sự cố (Disaster Recovery) để đảm bảo an toàn dữ liệu người dùng tuyệt đối trong mọi tình huống thiên tai, lỗi hệ thống hay tấn công ác ý.

## 2. Scope
Áp dụng cho cơ sở dữ liệu Cloud Firestore, tệp tin lưu trữ trên Cloud Storage, và các thông tin cấu hình hệ thống quan trọng.

## 3. Business Context
Mất mát dữ liệu tài chính hoặc kế hoạch ăn uống của người dùng là thảm họa đối với một ứng dụng uy tín. Doanh nghiệp bắt buộc phải có phương án sao lưu dự phòng và quy trình khôi phục nhanh để đảm bảo tính liên tục của dịch vụ.

## 4. Functional Requirements
- Hệ thống tự động sao lưu toàn bộ dữ liệu Firestore hàng ngày (Daily Export) và lưu trữ tại Cloud Storage Bucket riêng biệt.
- Cấu hình chính sách lưu giữ bản sao lưu (Retention policy) trong vòng tối thiểu 30 ngày gần nhất.

## 5. Non-Functional Requirements
- Đảm bảo chỉ số phục hồi mục tiêu:
  - **RPO (Recovery Point Objective):** < 24 giờ (mất tối đa 1 ngày dữ liệu).
  - **RTO (Recovery Time Objective):** < 4 giờ (hệ thống hoạt động lại bình thường sau tối đa 4 tiếng khắc phục).

## 6. Business Rules
- Bản sao lưu dữ liệu phải được lưu giữ ở một vùng máy chủ (Region) khác biệt hoàn toàn với máy chủ chính để đề phòng thảm họa vật lý thiên tai phá hủy trung tâm dữ liệu.

## 7. Data Model
- BackupJob: Theo dõi trạng thái, thời gian bắt đầu, kết thúc và dung lượng của các bản sao lưu.

## 8. Flow
- Đến giờ quy định (ví dụ 02h00 sáng) -> Cloud Scheduler kích hoạt Cloud Function -> Gọi lệnh Firestore Export -> Lưu file nén vào GCS Bucket -> Gửi mail xác nhận trạng thái thành công.

## 9. API
- Google Cloud Storage API, Firestore Admin API.

## 10. Acceptance Criteria
- Tổ chức diễn tập khôi phục dữ liệu (Recovery simulation) định kỳ 6 tháng một lần để đảm bảo các tệp tin sao lưu hoạt động tốt và quy trình khôi phục được đội ngũ kỹ thuật nắm rõ.

## 11. Future Improvements
- Cấu hình tính năng Point-in-Time Recovery (PITR) của Firestore để khôi phục dữ liệu chi tiết đến từng phút khi có sự cố xóa nhầm dữ liệu trên diện rộng.

## 12. References
- Google Cloud Disaster Recovery Planning Guide.

## 13. Related Documents
- [DOC-556 Monitoring](./DOC-556%20Monitoring.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
