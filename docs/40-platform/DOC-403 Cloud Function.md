---
Document ID: DOC-403
Title: Firebase Cloud Functions
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-401 Firebase](./DOC-401%20Firebase.md)
---

# Firebase Cloud Functions

## 1. Objective
Đặc tả kiến trúc, các hàm xử lý sự kiện và HTTP Endpoints của dịch vụ Firebase Cloud Functions làm nhiệm vụ xử lý logic Backend.

## 2. Scope
Bao gồm các hàm kích hoạt bằng sự kiện (Firestore Triggers, Auth Triggers) và các API gọi trực tiếp (Callable Functions).

## 3. Business Context
Sử dụng Cloud Functions giúp cô lập logic nghiệp vụ quan trọng ở phía Server, đảm bảo an toàn bảo mật và giảm tải hiệu năng xử lý cho ứng dụng Client di động.

## 4. Functional Requirements
- onUserCreated: Tự động tạo hồ sơ người dùng cơ bản và liên kết mặc định khi đăng ký mới.
- onPantryItemExpired: Trình kích hoạt định kỳ quét thực phẩm sắp hết hạn để gửi thông báo.
- piSyncGrocery: Đồng bộ giỏ hàng với đối tác tiếp thị liên kết.

## 5. Non-Functional Requirements
- Đảm bảo thời gian khởi động lạnh (Cold start) của Cloud Functions dưới 2 giây.

## 6. Business Rules
- Tất cả Cloud Functions phải được viết bằng TypeScript sử dụng Node.js LTS version.

## 7. Data Model
- Không áp dụng.

## 8. Flow
- Sự kiện diễn ra (ví dụ người dùng đăng ký tài khoản) -> Firebase kích hoạt trigger -> Cloud Function thực hiện logic -> Lưu kết quả vào Firestore.

## 9. API
- HTTPS Callable Functions, Cloud Events.

## 10. Acceptance Criteria
- Các function xử lý thanh toán và đối soát tiếp thị liên kết phải có cơ chế ghi log chi tiết (Structured logging) để phục vụ kiểm toán và xử lý lỗi khi cần.

## 11. Future Improvements
- Tối ưu hóa dung lượng bộ nhớ cấp phát (Memory allocation) cho từng function để giảm thiểu chi phí phát sinh.

## 12. References
- Firebase Functions developer guide.

## 13. Related Documents
- [DOC-405 Security](./DOC-405%20Security.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
