---
Document ID: DOC-407
Title: Push Notification System
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-401 Firebase](./DOC-401%20Firebase.md)
---

# Push Notification System

## 1. Objective
Đặc tả hệ thống thông báo đẩy (Push Notifications) và thông báo trong ứng dụng (In-app Notifications) nhằm gia tăng tương tác và nhắc nhở thói quen tài chính/ăn uống của người dùng.

## 2. Scope
Áp dụng cho các loại thông báo: Cảnh báo hết hạn thực phẩm, Nhắc nhở lập thực đơn tuần, Cảnh báo ngân sách chạm hạn mức đỏ, và Lời mời tham gia nhóm gia đình.

## 3. Business Context
Thông báo thông minh, đúng thời điểm là công cụ giữ chân người dùng (Retention tool) mạnh mẽ nhất. Nhắc nhở chuẩn bị nguyên liệu rã đông từ tối hôm trước hoặc cảnh báo một hộp sữa sắp hết hạn trong tủ lạnh mang lại giá trị tiện ích thực tế rất cao.

## 4. Functional Requirements
- Quản lý đăng ký Token thiết bị (FCM Token Registration).
- Hỗ trợ gửi thông báo theo nhóm gia đình (Group-based notifications).
- Tích hợp thông báo tương tác nhanh (Interactive Notifications) cho phép thực hiện hành động trực tiếp từ màn hình khóa (ví dụ nút "Đã rã đông").

## 5. Non-Functional Requirements
- Đảm bảo thời gian gửi nhận thông báo dưới 5 giây kể từ khi sự kiện được kích hoạt từ máy chủ.

## 6. Business Rules
- Không gửi thông báo quảng cáo hay nhắc nhở thông thường trong khoảng thời gian từ 22h00 đến 06h00 sáng để tránh làm phiền giấc ngủ của người dùng gia đình (Silent hours), ngoại trừ các cảnh báo khẩn cấp do người dùng thiết lập.

## 7. Data Model
- NotificationToken: Lưu trữ token FCM, dòng máy và trạng thái hoạt động của thiết bị người dùng.
- NotificationHistory: Lịch sử các thông báo đã gửi.

## 8. Flow
- Hệ thống quét lịch sử tủ lạnh -> Phát hiện thịt gà sắp hết hạn -> Gọi dịch vụ thông báo đẩy -> Gửi qua Firebase Cloud Messaging -> Điện thoại người dùng đổ chuông cảnh báo.

## 9. API
- Firebase Cloud Messaging REST API.

## 10. Acceptance Criteria
- Người dùng có thể tùy chỉnh bật/tắt từng nhóm thông báo cụ thể (ví dụ: tắt thông báo ngân sách, giữ thông báo hạn sử dụng) trong trang cài đặt.

## 11. Future Improvements
- Sử dụng AI để dự đoán khung giờ rảnh của người dùng để gửi thông báo lập thực đơn tuần vào thời điểm họ dễ phản hồi nhất.

## 12. References
- Apple Push Notification service (APNs), Google Cloud Messaging.

## 13. Related Documents
- [DOC-253 Pantry](../25-domain/DOC-253%20Pantry.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
