---
Document ID: DOC-605
Title: Mobile Two-Way Data Sync Engine
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-604 Offline](./DOC-604%20Offline.md)
---

# Mobile Two-Way Data Sync Engine

## 1. Objective
Đặc tả thuật toán và cơ chế đồng bộ dữ liệu hai chiều (Two-Way Sync Engine) giữa thiết bị di động của người dùng và máy chủ đám mây.

## 2. Scope
Áp dụng cho việc đồng bộ hóa dữ liệu danh sách đi chợ, tủ lạnh Pantry và số dư ngân sách giữa các thiết bị gia đình.

## 3. Business Context
Đảm bảo tính nhất quán dữ liệu cao nhất. Tránh trường hợp vợ đi chợ gạch bỏ "Trứng" nhưng chồng ở quầy khác không thấy đồng bộ dẫn đến việc mua thừa, gây lãng phí chi phí.

## 4. Functional Requirements
- Đồng bộ hóa tăng dư (Incremental Synchronization - chỉ tải các tài liệu thay đổi từ lần đồng bộ cuối thay vì tải lại toàn bộ DB).
- Thuật toán giải quyết xung đột (Conflict resolution logic) dựa trên mốc thời gian (Timestamp-based resolution).

## 5. Non-Functional Requirements
- Tiêu hao pin và băng thông di động ở mức thấp nhất nhờ tối ưu hóa kích thước gói tin đồng bộ.

## 6. Business Rules
- Trong trường hợp xung đột dữ liệu (ví dụ: Vợ cập nhật số lượng trứng thành 5 quả lúc 10h00, Chồng cập nhật thành 6 quả lúc 10h01 khi offline), hệ thống sẽ ưu tiên áp dụng giá trị của người dùng ghi nhận cuối cùng (10h01) khi cả hai cùng online trở lại.

## 7. Data Model
- SyncMetadata: Lưu mốc thời gian đồng bộ thành công gần nhất của thiết bị di động.

## 8. Flow
- Có kết nối mạng -> Thiết bị gửi last_sync_timestamp lên Server -> Server tìm các tài liệu thay đổi sau mốc thời gian đó -> Gửi về thiết bị -> Thiết bị cập nhật DB cục bộ -> Đổi trạng thái last_sync_timestamp thành hiện tại.

## 9. API
- Firestore Real-time Streams API.

## 10. Acceptance Criteria
- Đồng bộ hoàn tất chính xác và không gây hiện tượng trùng lặp dòng dữ liệu (duplicate entries) trên màn hình hiển thị của người dùng.

## 11. Future Improvements
- Áp dụng kỹ thuật đồng bộ hóa CRDT (Conflict-free Replicated Data Types) cho các tính năng soạn thảo kế hoạch bữa ăn chung thời gian thực.

## 12. References
- Data Synchronization Patterns for Mobile Devices.

## 13. Related Documents
- [DOC-603 Local Storage](./DOC-603%20Local%20Storage.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
