---
Document ID: DOC-983
Title: Cookie & Tracking Policy
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-980 Privacy Policy](./DOC-980%20Privacy%20Policy.md)
---

# Cookie & Tracking Policy

## 1. Objective
Quy định việc sử dụng cookie và các công nghệ theo dõi hành vi (Tracking technologies) trên Landing Page và ứng dụng Web chính thức.

## 2. Scope
Áp dụng cho mọi loại cookie: Cookie bắt buộc hệ thống (Strictly Necessary Cookies), Cookie hiệu năng (Performance Cookies) và Cookie tiếp thị (Marketing/Targeting Cookies).

## 3. Business Context
Tuân thủ đầy đủ các chính sách ePrivacy Directive và GDPR của Châu Âu, đảm bảo quyền tự quyết định của người dùng đối với việc cho phép ứng dụng theo dõi hành vi duyệt web của họ hay không.

## 4. Functional Requirements
- Banner xin chấp thuận cookie (Cookie Consent Banner) xuất hiện khi người dùng truy cập trang web lần đầu tiên.
- Bảng cấu hình chi tiết cho phép người dùng tùy chọn bật/tắt từng nhóm cookie cụ thể.

## 5. Non-Functional Requirements
- Đảm bảo ứng dụng web vẫn hoạt động bình thường đối với các chức năng cốt lõi ngay cả khi người dùng từ chối tất cả cookie tiếp thị.

## 6. Business Rules
- **Thời gian lưu trữ cookie mặc định:** Không quá 12 tháng kể từ lần chấp thuận gần nhất của người dùng.

## 7. Data Model
- CookieConsentRecord: Ghi nhận sự lựa chọn của người dùng đối với các nhóm cookie.

## 8. Flow
- Người dùng truy cập web -> Hiển thị Cookie Banner -> Người dùng nhấn "Chỉ chấp nhận cookie bắt buộc" -> Hệ thống tắt các mã theo dõi Google Analytics/Facebook Pixel -> Lưu trạng thái và tải trang.

## 9. API
- Cookie Consent Manager API.

## 10. Acceptance Criteria
- Banner cookie hiển thị đúng giao diện, không chặn các tương tác đọc nội dung chính của trang web.

## 11. Future Improvements
- Nghiên cứu chuyển đổi sang các giải pháp theo dõi không dùng cookie (Cookieless tracking) bảo mật hơn trong tương lai.

## 12. References
- EU ePrivacy Directive (Cookie Law) specifications.

## 13. Related Documents
- [DOC-761 SEO](../76-website/DOC-761%20SEO.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
