---
Document ID: DOC-400
Title: System Architecture
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-000 Product Vision](../00-vision/DOC-000%20Product%20Vision.md)
---

# System Architecture

## 1. Objective
Đặc tả kiến trúc hệ thống tổng thể của Family Meal Budget Planner, bao gồm cấu trúc Client-Server, luồng đồng bộ dữ liệu thời gian thực và kiến trúc Monorepo.

## 2. Scope
Quy định sơ đồ kiến trúc lớp, mô hình luồng dữ liệu (Data flow), kiến trúc tích hợp Firebase và AI Gateway bên ngoài.

## 3. Business Context
Kiến trúc hệ thống phải hỗ trợ tính năng làm việc nhóm gia đình thời gian thực, hoạt động ổn định khi offline (ở trong siêu thị) và xử lý linh hoạt các tác vụ AI gợi ý thực đơn mà không làm nghẽn hệ thống.

## 4. Functional Requirements
- Hệ thống Client-Server phân rã: Frontend (Flutter) giao tiếp trực tiếp với Firebase Services và AI Gateway.
- Cơ chế đồng bộ trạng thái (State Sync) thời gian thực của nhóm gia đình.

## 5. Non-Functional Requirements
- Đảm bảo tính mở rộng cao (Scalability) với cấu trúc Serverless.
- Độ trễ phản hồi hệ thống (Network Latency) trung bình < 150ms.

## 6. Business Rules
- Mọi dữ liệu nhạy cảm của người dùng khi truyền đi phải được mã hóa qua HTTPS/TLS 1.3.

## 7. Data Model
- Xem chi tiết tại các tài liệu Database.

## 8. Flow
- Xem luồng nghiệp vụ tại các tài liệu User Flow.

## 9. API
- Tích hợp Firestore SDK, Firebase Auth SDK và REST API cho các AI services.

## 10. Acceptance Criteria
- Hệ thống duy trì hoạt động bình thường ngay cả khi máy chủ bên thứ ba (như cổng thanh toán) gặp sự cố nhờ cơ chế Failover.

## 11. Future Improvements
- Tích hợp mạng lưới CDN để tối ưu hóa thời gian tải hình ảnh công thức nấu ăn toàn cầu.

## 12. References
- Serverless Architectures on Google Cloud.

## 13. Related Documents
- [DOC-401 Firebase](./DOC-401%20Firebase.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
