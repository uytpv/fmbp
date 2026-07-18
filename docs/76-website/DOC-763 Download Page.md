---
Document ID: DOC-763
Title: App Download Page Specs
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-760 Landing](./DOC-760%20Landing.md)
---

# App Download Page Specs

## 1. Objective
Đặc tả luồng điều hướng và kỹ thuật của Trang tải ứng dụng (Download Page), đảm bảo đưa người dùng đến đúng kho ứng dụng tương thích với thiết bị của họ nhanh nhất.

## 2. Scope
Áp dụng cho trang web phụ /download, cơ chế phát hiện thiết bị (User-Agent detection) và hiển thị mã QR tải app nhanh cho máy tính.

## 3. Business Context
Nhiều người dùng truy cập website bằng máy tính nhưng muốn tải app về điện thoại di động. Một trang tải app chứa mã QR quét nhanh hoặc tự động phát hiện hệ điều hành điện thoại để chuyển hướng thẳng vào App Store giúp tối giản tối đa ma sát tải app.

## 4. Functional Requirements
- Tự động quét chuỗi User-Agent của trình duyệt khách truy cập:
  - Nếu là iOS (iPhone/iPad) -> Tự động chuyển hướng thẳng sang App Store.
  - Nếu là Android -> Tự động chuyển hướng sang Google Play Store.
  - Nếu là Desktop -> Hiển thị giao diện trang Download chứa mã QR sắc nét (mã hóa link tải app) kèm hướng dẫn dùng camera quét tải app.
- Theo dõi nguồn tải app thông qua các chiến dịch quảng cáo (Install Attribution tracking).

## 5. Non-Functional Requirements
- Đảm bảo thời gian tải và phân tích thiết bị để chuyển hướng dưới 500ms.

## 6. Business Rules
- Không áp dụng.

## 7. Data Model
- Không áp dụng.

## 8. Flow
- Khách hàng quét mã QR trên Landing Page hoặc click link quảng cáo -> Truy cập /download -> Hệ thống nhận diện là Android -> Chuyển hướng sang Google Play Store -> Người dùng nhấn cài đặt.

## 9. API
- Các công cụ tracking tải app như AppsFlyer, Firebase Dynamic Links APIs.

## 10. Acceptance Criteria
- Khi người dùng quét mã QR bằng camera iPhone, hệ thống mở đúng trang chi tiết của app trên App Store.

## 11. Future Improvements
- Hỗ trợ gửi link tải app qua tin nhắn SMS tự động khi người dùng nhập số điện thoại vào form trên máy tính.

## 12. References
- Mobile User-Agent Parsing databases.

## 13. Related Documents
- [DOC-206 Release Plan](../20-product/DOC-206%20Release%20Plan.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
