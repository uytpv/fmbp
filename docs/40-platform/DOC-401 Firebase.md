---
Document ID: DOC-401
Title: Firebase Integration
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-400 Architecture](./DOC-400%20Architecture.md)
---

# Firebase Integration

## 1. Objective
Đặc tả cách thức cấu hình và tích hợp các dịch vụ của nền tảng Firebase làm hạ tầng Backend cho ứng dụng di động và web.

## 2. Scope
Áp dụng cho các dịch vụ: Firebase Authentication, Cloud Firestore, Cloud Functions, Cloud Storage, Firebase Cloud Messaging (FCM) và Firebase Hosting.

## 3. Business Context
Sử dụng Firebase làm hạ tầng Serverless giúp đẩy nhanh tốc độ phát triển (Time-to-market), giảm chi phí vận hành hạ tầng ban đầu và hỗ trợ tính năng đồng bộ dữ liệu thời gian thực vượt trội.

## 4. Functional Requirements
- Đồng bộ hóa dữ liệu tủ lạnh (Pantry) và danh sách đi chợ thời gian thực giữa các thiết bị gia đình qua Firestore.
- Quản lý tải lên hình ảnh công thức tự nấu lên Cloud Storage.

## 5. Non-Functional Requirements
- Đảm bảo tính năng Offline Persistence của Firestore được bật mặc định trên ứng dụng Mobile.

## 6. Business Rules
- Tất cả các dịch vụ Firebase phải được triển khai trên vùng máy chủ (Region) gần nhất với thị trường người dùng mục tiêu (đối với Việt Nam là sia-east2 hoặc sia-southeast1).

## 7. Data Model
- Sơ đồ Firestore Collections.

## 8. Flow
- Cấu hình Firebase SDK trên App -> Người dùng thực hiện thao tác -> Firestore tự động cập nhật local cache -> Đẩy đồng bộ lên đám mây khi có mạng.

## 9. API
- Firebase Admin SDK, Firebase Client SDK.

## 10. Acceptance Criteria
- Dữ liệu đồng bộ thành công giữa 2 thiết bị khác nhau sử dụng cùng tài khoản gia đình dưới 2 giây.

## 11. Future Improvements
- Sử dụng Firebase Local Emulator Suite phục vụ quá trình kiểm thử tự động CI/CD.

## 12. References
- Firebase Documentation.

## 13. Related Documents
- [DOC-402 Firestore](./DOC-402%20Firestore.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
