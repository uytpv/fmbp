---
Document ID: DOC-603
Title: Mobile Local Database Specifications
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-602 State Management](./DOC-602%20State%20Management.md)
---

# Mobile Local Database Specifications

## 1. Objective
Đặc tả hệ thống cơ sở dữ liệu cục bộ (Local Storage) trên thiết bị di động, phục vụ việc lưu trữ cấu hình người dùng và lưu đệm dữ liệu (Caching) khi offline.

## 2. Scope
Áp dụng cho cấu hình lưu trữ key-value nhỏ (Preferences) và cơ sở dữ liệu tài liệu cục bộ (Local DB).

## 3. Business Context
Để tăng tốc độ mở ứng dụng và hỗ trợ hoạt động ngoại tuyến, ứng dụng di động không được phụ thuộc hoàn toàn vào mạng internet mà phải có cơ sở dữ liệu cục bộ nhanh và dung lượng nhẹ để đọc ghi tức thì.

## 4. Functional Requirements
- Sử dụng **Isar Database** (hoặc **Hive**) làm cơ sở dữ liệu cục bộ tốc độ cao cho Flutter.
- Sử dụng shared_preferences cho các cài đặt nhỏ của người dùng (Dark Mode, ngôn ngữ, flag onboarding).
- Mã hóa dữ liệu cục bộ nhạy cảm bằng thư viện bảo mật thiết bị (Keystore/Keychain).

## 5. Non-Functional Requirements
- Tốc độ đọc ghi cơ sở dữ liệu local dưới 10ms đối với các tác vụ thông thường.

## 6. Business Rules
- Không lưu trữ mật khẩu người dùng ở dạng clear-text dưới bộ nhớ máy.

## 7. Data Model
- LocalPantryItem, LocalShoppingItem, LocalUserSetting (Schemas của Isar/Hive).

## 8. Flow
- App cần dữ liệu -> Đọc từ Isar DB cục bộ hiển thị ngay lên UI -> Đồng thời gọi API lấy dữ liệu mới -> Cập nhật Isar DB -> UI tự động vẽ lại nếu có thay đổi.

## 9. API
- Isar DB APIs, Shared Preferences APIs.

## 10. Acceptance Criteria
- Cơ sở dữ liệu local tự động khởi tạo thành công và chạy di chuyển sơ đồ (migration) an toàn khi ứng dụng cập nhật phiên bản mới.

## 11. Future Improvements
- Đồng bộ hóa cấu trúc schema local tự động từ định dạng schema của đám mây Firestore.

## 12. References
- Isar Database official documentation (isar.dev).

## 13. Related Documents
- [DOC-604 Offline](./DOC-604%20Offline.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
