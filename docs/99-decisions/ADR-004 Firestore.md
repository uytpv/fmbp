---
Document ID: ADR-004
Title: Architectural Decision - NoSQL Firestore as Primary Database
Version: 1.0
Status: Accepted
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-402 Firestore](../40-platform/DOC-402%20Firestore.md)
---

# Architectural Decision - NoSQL Firestore as Primary Database

## 1. Objective
Ghi nhận quyết định kiến trúc lựa chọn cơ sở dữ liệu NoSQL Cloud Firestore của Firebase làm nơi lưu trữ dữ liệu giao dịch và trạng thái chính thức của người dùng.

## 2. Scope
Áp dụng cho toàn bộ các thiết kế cấu trúc dữ liệu, mô hình lưu trữ và quy tắc phân quyền dữ liệu Client.

## 3. Business Context
Dự án cần một cơ sở dữ liệu có khả năng đồng bộ thời gian thực mượt mà (real-time sync) cho tính năng chia sẻ gia đình mà không cần tốn thời gian xây dựng máy chủ WebSocket phức tạp, đồng thời hỗ trợ hoạt động ngoại tuyến (offline caching) tốt ngay trong bộ cài SDK.

## 4. Functional Requirements
- Lưu trữ dữ liệu dạng tài liệu JSON linh hoạt.
- Hỗ trợ lắng nghe sự kiện thay đổi dữ liệu thời gian thực (Real-time listeners).

## 5. Non-Functional Requirements
- Khả năng mở rộng tự động (Auto-scaling) từ Google Cloud để phục vụ hàng triệu tài liệu mà không cần cấu hình cụ thể.

## 6. Business Rules
- **Quyết định:** Chọn **Cloud Firestore NoSQL** làm Database chính, chấp nhận đánh đổi tính năng quan hệ chặt chẽ (Relations/Joins) và thực hiện giải quyết quan hệ ở tầng logic ứng dụng Client/Cloud Functions.

## 7. Data Model
- Không áp dụng.

## 8. Flow
- Người dùng sửa dữ liệu -> SDK tự ghi local cache và đẩy bất đồng bộ lên Firestore Cloud -> Server phát sự kiện -> Các máy khác của gia đình tự động nhận và vẽ lại giao diện.

## 9. API
- Cloud Firestore SDK APIs.

## 10. Acceptance Criteria
- Hệ thống hỗ trợ lưu trữ và đồng bộ hóa thành công dữ liệu kho tủ lạnh và danh sách đi chợ của hàng ngàn nhóm gia đình đồng thời mà không bị nghẽn cổ chai dữ liệu.

## 11. Future Improvements
- Tích hợp thêm dịch vụ BigQuery để chạy các phân tích dữ liệu lịch sử nặng mà không làm ảnh hưởng đến hiệu năng đọc ghi của Firestore Production.

## 12. References
- NoSQL vs Relational Databases comparative analysis by Google Cloud.

## 13. Related Documents
- [DOC-501 Database](../60-backend/DOC-501%20Database.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
