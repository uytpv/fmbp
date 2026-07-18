---
Document ID: DOC-704
Title: Admin Food Price Database Specs
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-503 Price Engine](../60-backend/DOC-503%20Price%20Engine.md)
---

# Admin Food Price Database Specs

## 1. Objective
Đặc tả công cụ quản lý cơ sở dữ liệu giá cả thực phẩm, kiểm soát hoạt động của các tiến trình cào dữ liệu giá (Scrapers) và điều chỉnh giá thủ công.

## 2. Scope
Áp dụng cho giao diện theo dõi giá cả thị trường, cấu hình lịch trình chạy của máy cào giá và giao diện phê duyệt báo cáo giá từ người dùng.

## 3. Business Context
Giá thực phẩm biến động mạnh theo thời vụ và thiên tai. Đội ngũ vận hành cần giám sát chặt chẽ cơ sở dữ liệu giá, kịp thời phát hiện các điểm giá bất thường (do lỗi cào dữ liệu hoặc người dùng cố tình nhập giá sai lệch lớn) để giữ cho tính năng dự báo ngân sách đi chợ luôn chính xác.

## 4. Functional Requirements
- Theo dõi lịch sử giá cả của từng nguyên liệu theo khu vực địa lý trên bản đồ.
- Quản lý trạng thái và nhật ký hoạt động (Logs) của các máy cào dữ liệu giá trực tuyến từ các siêu thị đối tác.
- Công cụ điều chỉnh giá hàng loạt (Bulk price update) cho một nhóm thực phẩm khi có biến động lạm phát lớn ngoài thị trường.

## 5. Non-Functional Requirements
- Xử lý đồng thời các yêu cầu tính toán lại giá trung bình của hàng ngàn nguyên liệu mà không gây treo hệ thống dữ liệu.

## 6. Business Rules
- Bất kỳ điểm dữ liệu giá nào lệch quá 50% so với giá trị trung bình lịch sử của 7 ngày gần nhất sẽ bị hệ thống tự động đánh dấu SUSPICIOUS và yêu cầu kiểm duyệt viên duyệt thủ công trước khi đưa vào tính toán giá chung.

## 7. Data Model
- PriceAlert: Cảnh báo biến động giá bất thường phát hiện tự động.

## 8. Flow
- Máy cào giá chạy hoàn tất -> Phát hiện giá trứng tăng 60% -> Tạo PriceAlert -> Admin mở Admin Portal -> Xem chi tiết alert -> Xác nhận giá tăng thực tế ngoài chợ -> Nhấn duyệt -> Hệ thống cập nhật giá mới vào Price Engine.

## 9. API
- GET /api/v1/admin/prices/alerts
- POST /api/v1/admin/prices/override

## 10. Acceptance Criteria
- Đảm bảo các điểm giá bị đánh dấu SUSPICIOUS được loại bỏ hoàn toàn khỏi các phép tính toán giá trung bình của Price Engine cho đến khi được admin phê duyệt.

## 11. Future Improvements
- Tích hợp trực tiếp API giá cả thời gian thực của các chợ đầu mối nông sản quốc gia để làm mốc giá đối chiếu chuẩn.

## 12. References
- Data Quality Management (DQM) standards.

## 13. Related Documents
- [DOC-703 Ingredient](./DOC-703%20Ingredient.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
