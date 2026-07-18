---
Document ID: DOC-700
Title: Admin Dashboard Specifications
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-706 Analytics](./DOC-706%20Analytics.md)
---

# Admin Dashboard Specifications

## 1. Objective
Đặc tả giao diện và các chỉ số hiển thị của Trang tổng quan dành cho quản trị viên (Admin Dashboard), giúp đội ngũ vận hành theo dõi nhanh sức khỏe của hệ thống.

## 2. Scope
Áp dụng cho trang chính của Cổng quản trị Admin Web Portal.

## 3. Business Context
Đội ngũ quản lý cần các con số thực tế để đánh giá hiệu quả kinh doanh, chi phí vận hành máy chủ và phát hiện các dấu hiệu bất thường của hệ thống để điều phối nguồn lực kịp thời.

## 4. Functional Requirements
- Hiển thị các chỉ số kinh doanh cốt lõi (KPIs):
  - Doanh thu: MRR, ARR, Doanh thu từ Marketplace, Hoa hồng siêu thị đối tác.
  - Người dùng: MAU (Monthly Active Users), Số lượng Family Groups mới đăng ký, tỷ lệ chuyển đổi Premium.
  - Vận hành: Chi phí API Token AI trong tháng, Tỷ lệ lỗi API, Tải máy chủ.
- Biểu đồ đường xu hướng tăng trưởng theo ngày/tuần/tháng.

## 5. Non-Functional Requirements
- Dữ liệu KPIs trên dashboard được làm mới định kỳ mỗi 5 phút (Near real-time sync).

## 6. Business Rules
- Chỉ tài khoản có vai trò SYSTEM_ADMIN hoặc BUSINESS_ANALYST mới được quyền truy cập trang tổng quan tài chính này.

## 7. Data Model
- AdminDashboardMetrics: Lưu trữ các chỉ số tổng hợp sẵn để tránh quét toàn bộ DB gây chậm hệ thống.

## 8. Flow
- Admin đăng nhập -> Hệ thống xác thực quyền hạn -> Gọi API tổng hợp KPIs -> Trả về cấu trúc JSON -> Vẽ biểu đồ và bảng số liệu trên Admin Portal.

## 9. API
- GET /api/v1/admin/dashboard/kpis

## 10. Acceptance Criteria
- Các con số doanh thu hiển thị trên Dashboard phải khớp chính xác với số liệu thực tế được báo cáo từ cổng thanh toán Stripe/MoMo.

## 11. Future Improvements
- Sử dụng AI để phân tích và tự động đưa ra các dự báo tăng trưởng hoặc cảnh báo sớm nếu chi phí AI Gateway tăng quá nhanh.

## 12. References
- Mẫu thiết kế Executive Dashboard của Stripe và Google Analytics.

## 13. Related Documents
- [DOC-701 User](./DOC-701%20User.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
