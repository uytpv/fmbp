---
Document ID: DOC-503
Title: Price Engine Specification
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-250 Ingredient](../25-domain/DOC-250%20Ingredient.md)
---

# Price Engine Specification

## 1. Objective
Đặc tả công cụ phân tích và xử lý giá cả nguyên liệu thực tế (Price Engine), tính toán mức giá trung bình của thực phẩm theo từng khu vực địa lý để phục vụ dự toán ngân sách.

## 2. Scope
Bao gồm công cụ bóc tách giá trực tuyến (Web Scraper), cơ chế người dùng tự cập nhật giá (Crowd-sourced pricing) và thuật toán tính giá trung bình có trọng số (Weighted average price computation).

## 3. Business Context
Để ước tính chính xác chi phí cho một thực đơn tuần trước khi đi chợ, ứng dụng cần biết giá của từng nguyên liệu thô (ví dụ: 1kg ba chỉ bò giá bao nhiêu). Do giá biến động hàng ngày và theo vùng miền, Price Engine chính là "bộ não" giữ cho các dự báo tài chính luôn sát với thực tế nhất.

## 4. Functional Requirements
- Thu thập giá nguyên liệu tự động hàng ngày từ các chuỗi siêu thị lớn qua web scraping hoặc API chính thức.
- Cơ chế ghi nhận giá do người dùng nhập khi họ check-off hóa đơn đi chợ thực tế.
- Thuật toán loại bỏ các điểm giá dị biệt (Outliers) để tránh làm sai lệch mức giá trung bình của khu vực.

## 5. Non-Functional Requirements
- Đảm bảo cơ sở dữ liệu giá (Price Index Database) được cập nhật định kỳ dưới 24 giờ.

## 6. Business Rules
- Mức giá trung bình của một nguyên liệu tại một khu vực sẽ được tính toán dựa trên công thức trung bình có trọng số: ưu tiên 70% dữ liệu giá thực tế từ hóa đơn đi chợ của người dùng trong bán kính 5km và 30% giá niêm yết trực tuyến của siêu thị đối tác.

## 7. Data Model
- PriceSnapshot: Bản ghi nhận giá của một nguyên liệu tại một thời điểm và địa điểm cụ thể (ingredient_id, price_per_unit, source_type, location_geohash, recorded_at).

## 8. Flow
- Người dùng đi chợ nhập giá -> Hệ thống tạo PriceSnapshot mới -> Kích hoạt Price Engine -> Chạy ngầm recalculate mức giá trung bình của nguyên liệu đó tại khu vực -> Cập nhật bảng giá chung.

## 9. API
- POST /api/v1/prices/report
- GET /api/v1/prices/estimate

## 10. Acceptance Criteria
- Giá ước tính của một giỏ hàng đi chợ so với giá trị thực tế thanh toán tại siêu thị của người dùng không được lệch quá 15% trong điều kiện thị trường bình thường.

## 11. Future Improvements
- Sử dụng mô hình Machine Learning để dự báo xu hướng tăng giảm giá thực phẩm (ví dụ: dự báo giá rau xanh tăng vào mùa mưa bão) để AI khuyên người dùng đổi thực đơn tiết kiệm trước.

## 12. References
- Thuật toán lọc bỏ dữ liệu nhiễu (IQR - Interquartile Range method).

## 13. Related Documents
- [DOC-104 Affiliate](../10-business/DOC-104%20Affiliate.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
