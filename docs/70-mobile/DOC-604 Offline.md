---
Document ID: DOC-604
Title: Mobile Offline Mode Specs
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-406 Offline](../40-platform/DOC-406%20Offline.md)
---

# Mobile Offline Mode Specs

## 1. Objective
Đặc tả luồng trải nghiệm người dùng và cơ chế kỹ thuật của Chế độ ngoại tuyến (Offline Mode) trên ứng dụng di động.

## 2. Scope
Áp dụng cho các màn hình: Dashboard, Shopping List, Pantry và luồng thông báo chỉ báo trạng thái kết nối mạng của Client.

## 3. Business Context
Mang lại trải nghiệm liền mạch, không bị đứt gãy và tạo cảm giác an tâm cho người dùng khi đi chợ ở các khu vực sóng yếu (tầng hầm siêu thị) mà vẫn kiểm tra và check được đồ đi chợ bình thường.

## 4. Functional Requirements
- Hiển thị thanh trạng thái nhỏ chỉ báo "Đang chạy Offline" (Offline Banner) khi mất mạng để người dùng biết.
- Chặn các tính năng yêu cầu kết nối mạng bắt buộc (như AI đề xuất thực đơn hoặc thanh toán) kèm thông điệp hướng dẫn thân thiện.
- Lưu trữ các tác vụ thay đổi dữ liệu của người dùng khi offline vào hàng đợi đồng bộ cục bộ (Local Sync Queue).

## 5. Non-Functional Requirements
- Đảm bảo ứng dụng không bị treo (crash) khi mất mạng đột ngột giữa một giao dịch.

## 6. Business Rules
- Khi offline, cho phép người dùng xem dữ liệu cũ đã lưu trong Isar DB nhưng hiển thị ghi chú "Dữ liệu được cập nhật lần cuối lúc [Thời gian]".

## 7. Data Model
- OfflineActionQueue: Hàng đợi lưu các hành động offline cần đồng bộ lại.

## 8. Flow
- Người dùng mất kết nối -> Hiển thị Offline Banner -> Người dùng sửa số lượng trứng trong tủ lạnh -> Lưu thay đổi vào Isar DB cục bộ và ghi nhận vào OfflineActionQueue -> Có mạng lại -> Ẩn banner, đẩy hàng đợi lên Server để đồng bộ.

## 9. API
- Connectivity Plus package APIs.

## 10. Acceptance Criteria
- Ứng dụng tự động phát hiện trạng thái mất kết nối mạng và chuyển đổi chế độ hoạt động trong vòng dưới 1 giây mà không yêu cầu tương tác từ người dùng.

## 11. Future Improvements
- Tự động nén dữ liệu hàng đợi đồng bộ để tiết kiệm băng thông 3G/4G khi kết nối lại.

## 12. References
- Designing Offline-First Mobile User Experiences.

## 13. Related Documents
- [DOC-605 Sync](./DOC-605%20Sync.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
