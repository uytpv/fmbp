---
Document ID: DOC-406
Title: Offline-First Synchronization Strategy
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-401 Firebase](./DOC-401%20Firebase.md)
---

# Offline-First Synchronization Strategy

## 1. Objective
Đặc tả cơ chế hoạt động ngoại tuyến (Offline-first) và giải quyết xung đột đồng bộ dữ liệu khi ứng dụng hoạt động không có kết nối internet.

## 2. Scope
Áp dụng cho các tính năng: Tra cứu kho tủ lạnh Pantry, xem và đánh dấu danh sách đi chợ, ghi chép nhanh giao dịch ngân sách.

## 3. Business Context
Siêu thị hoặc chợ truyền thống thường là những nơi có sóng di động rất kém hoặc không có wifi. Người dùng bắt buộc phải dùng được danh sách đi chợ và gạch bỏ các món đã mua một cách mượt mà khi offline, dữ liệu sẽ tự đồng bộ khi họ ra ngoài có mạng.

## 4. Functional Requirements
- Bật tính năng lưu trữ cục bộ (Local persistence cache) của Firestore.
- Cơ chế giải quyết xung đột (Conflict Resolution) dựa trên nguyên tắc **"Last Write Wins" (Lượt ghi cuối cùng được ưu tiên)** hoặc hiển thị popup lựa chọn nếu có sự chênh lệch lớn về dữ liệu chung.

## 5. Non-Functional Requirements
- Đảm bảo thời gian chuyển đổi trạng thái Online sang Offline diễn ra trong dưới 500ms mà không làm đứt gãy luồng UI.

## 6. Business Rules
- Các thay đổi dữ liệu cục bộ khi offline phải được lưu vào hàng đợi đồng bộ (Sync Queue) và tự động đẩy lên server ngay khi phát hiện có kết nối mạng trở lại.

## 7. Data Model
- SyncQueueItem: Hàng đợi lưu trữ các tác vụ cần đồng bộ.

## 8. Flow
- Mất mạng -> Người dùng tick chọn "Đã mua trứng" -> Lưu vào bộ nhớ cục bộ -> Có mạng lại -> Đồng bộ lên server -> Cập nhật trạng thái cho thiết bị của các thành viên khác trong gia đình.

## 9. API
- Firestore Cache API.

## 10. Acceptance Criteria
- Người dùng có thể hoàn thành việc gạch bỏ 10 món đồ trong Shopping list khi offline, sau đó bật mạng lên -> Dữ liệu đồng bộ chính xác lên Cloud và các thiết bị khác nhận được đúng trạng thái.

## 11. Future Improvements
- Tích hợp cơ sở dữ liệu SQLite cục bộ bổ sung cho các tính năng phân tích tài chính nặng khi chạy offline.

## 12. References
- Offline-First Web Application Architecture (W3C).

## 13. Related Documents
- [DOC-254 Shopping](../25-domain/DOC-254%20Shopping.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
