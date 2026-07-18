---
Document ID: DOC-706
Title: Admin Analytics Portal Specifications
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-700 Dashboard](./DOC-700%20Dashboard.md)
---

# Admin Analytics Portal Specifications

## 1. Objective
Đặc tả hệ thống phân tích sâu (Analytics Portal), cung cấp các công cụ phân tích hành vi người dùng, biểu đồ phễu chuyển đổi (Conversion funnel) và báo cáo tài chính chi tiết phục vụ đội ngũ tối ưu hóa tăng trưởng (Growth Team).

## 2. Scope
Áp dụng cho chuyên mục Báo cáo chuyên sâu (Analytics Section) của Cổng quản trị Admin Portal.

## 3. Business Context
Hiểu sâu sắc hành vi người dùng (như tỷ lệ giữ chân Cohort Retention, các tính năng được sử dụng nhiều nhất, phễu từ đăng ký đến chốt thực đơn) là chìa khóa để liên tục cải tiến sản phẩm và đưa ra các quyết định kinh doanh dựa trên dữ liệu (Data-driven decisions).

## 4. Functional Requirements
- Phân tích Cohort Retention (Theo dõi tỷ lệ người dùng quay lại ứng dụng sau 1 tuần, 1 tháng, 3 tháng).
- Biểu đồ phễu chuyển đổi (Funnel Analytics): Đo lường tỷ lệ rớt qua từng bước từ Onboarding -> Thiết lập ngân sách -> Chọn món -> Đi chợ -> Nhập kho.
- Thống kê tỷ lệ sử dụng tính năng (Feature adoption rate) của AI Assistant.

## 5. Non-Functional Requirements
- Đảm bảo các truy vấn báo cáo nặng trên cơ sở dữ liệu lớn không làm ảnh hưởng đến hiệu năng hoạt động của cơ sở dữ liệu giao dịch thời gian thực (chạy báo cáo trên bản sao lưu Read-replica).

## 6. Business Rules
- Báo cáo tài chính chi tiết hàng tháng phải được xuất ra định dạng CSV/Excel và gửi tự động qua email cho Hội đồng quản trị vào ngày 1 của tháng tiếp theo.

## 7. Data Model
- AnalyticsSnapshot: Lưu trữ các bản ghi dữ liệu phân tích đã được tổng hợp sẵn theo ngày.

## 8. Flow
- Người dùng thao tác trên app -> Gửi sự kiện (Event) về Firebase Analytics -> Dữ liệu đồng bộ sang Google BigQuery -> Admin Analytics Portal truy vấn BigQuery -> Hiển thị biểu đồ phân tích trực quan.

## 9. API
- Google BigQuery REST API, Firebase Analytics Admin API.

## 10. Acceptance Criteria
- Cổng quản trị kết xuất chính xác biểu đồ phễu chuyển đổi và báo cáo Cohort theo đúng mốc thời gian lọc của Admin.

## 11. Future Improvements
- Tích hợp mô hình AI dự báo doanh thu (Revenue Forecasting) và tự động đề xuất ngân sách tiếp thị tối ưu dựa trên dữ liệu lịch sử.

## 12. References
- Lean Analytics: Use Data to Build a Better Startup Faster.

## 13. Related Documents
- [DOC-107 Financial Projection](../10-business/DOC-107%20Financial%20Projection.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
