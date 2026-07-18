---
Document ID: DOC-752
Title: Web App SEO Guidelines
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-106 International](../10-business/DOC-106%20International.md)
---

# Web App SEO Guidelines

## 1. Objective
Định cấu hình SEO và quản lý thu thập dữ liệu (Search Engine Indexing) cho ứng dụng Web chính để đảm bảo bảo mật dữ liệu và tối ưu hóa tài nguyên máy chủ.

## 2. Scope
Áp dụng cho tệp tin obots.txt, các thẻ meta của ứng dụng Web, và thiết lập cấu hình chặn index đối với các trang quản trị và tài khoản cá nhân.

## 3. Business Context
Ứng dụng Web là nơi chứa thông tin cá nhân nhạy cảm của người dùng (ngân sách, thực phẩm gia đình). Việc vô tình để các công cụ tìm kiếm (Google, Bing) lập chỉ mục (index) và hiển thị các trang này trên trang kết quả tìm kiếm công cộng là một sự cố bảo mật nghiêm trọng.

## 4. Functional Requirements
- Định cấu hình chặn lập chỉ mục hoàn toàn trên toàn bộ tên miền phụ của ứng dụng Web (ví dụ: pp.fmpb.com).
- Thiết lập tệp obots.txt chuẩn để yêu cầu các bot tìm kiếm bỏ qua thư mục ứng dụng.

## 5. Non-Functional Requirements
- Đảm bảo các thẻ meta obots có giá trị 
oindex, nofollow được chèn vào phần đầu <head> của mã nguồn HTML ứng dụng Web.

## 6. Business Rules
- **Nguyên tắc bảo mật:** Tuyệt đối không cho phép bất kỳ trang nào của Web App chứa thông tin người dùng được hiển thị công khai trên công cụ tìm kiếm.

## 7. Data Model
- Cấu hình file robots.txt.

## 8. Flow
- Bot tìm kiếm truy cập pp.fmpb.com/robots.txt -> robots.txt trả về lệnh Disallow: / -> Bot quay đầu và không thu thập dữ liệu trang.

## 9. API
- Không áp dụng.

## 10. Acceptance Criteria
- Khi chạy lệnh kiểm tra thử nghiệm tìm kiếm (ví dụ dùng công cụ tìm kiếm với từ khóa site:app.fmpb.com), không có bất kỳ trang kết quả nào được lập chỉ mục hiển thị.

## 11. Future Improvements
- Triển khai tường lửa bảo mật ứng dụng Web (WAF) để chủ động phát hiện và chặn các bot quét dữ liệu tự động trái phép.

## 12. References
- Google Search Central Robots.txt specifications.

## 13. Related Documents
- [DOC-761 SEO](../76-website/DOC-761%20SEO.md) (Đối chiếu với chính sách SEO mở của Landing Page).

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
