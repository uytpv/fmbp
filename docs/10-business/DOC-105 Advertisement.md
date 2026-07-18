---
Document ID: DOC-105
Title: Advertisement & Sponsorship Management
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-100 Business Model](./DOC-100%20Business%20Model.md)
- [DOC-101 Pricing](./DOC-101%20Pricing.md)
---

# Advertisement & Sponsorship Management

## 1. Objective
Tài liệu này đặc tả quy định hiển thị quảng cáo, tài trợ sản phẩm và các chính sách phân phối quảng cáo trong ứng dụng dành cho nhóm người dùng sử dụng gói dịch vụ miễn phí (Free Tier).

## 2. Scope
Tài liệu quy định vị trí đặt quảng cáo trong ứng dụng (Ad Placements), tiêu chuẩn nội dung quảng cáo được phép hiển thị, cách thức đo lường hiệu quả quảng cáo (CPM, CPC) và chính sách bảo vệ trải nghiệm của người dùng gia đình.

## 3. Business Context
Mặc dù doanh thu đăng ký thuê bao (Subscription) là mục tiêu cốt lõi, phần lớn người dùng ban đầu sẽ lựa chọn gói dịch vụ miễn phí. Quảng cáo là luồng doanh thu cần thiết để duy trì chi phí hoạt động hạ tầng cơ bản phục vụ nhóm khách hàng này. Tuy nhiên, việc hiển thị quảng cáo tràn lan, phản cảm hoặc không liên quan sẽ hủy hoại trải nghiệm người dùng và thương hiệu của ứng dụng. Do đó, quảng cáo cần được chọn lọc và tích hợp một cách tự nhiên (Native Advertising).

## 4. Functional Requirements
- Tích hợp với các mạng quảng cáo di động uy tín như Google AdMob, Unity Ads hoặc các nền tảng quảng cáo hướng đối tượng chuyên biệt.
- Khả năng cấu hình bật/tắt quảng cáo động dựa trên quyền lợi của gói dịch vụ người dùng.
- Hệ thống ghi nhận lượt hiển thị (Impressions) và lượt click (Clicks) phục vụ báo cáo doanh thu quảng cáo nội bộ.
- Tính năng báo cáo quảng cáo không phù hợp dành cho người dùng.

## 5. Non-Functional Requirements
- Quảng cáo không được làm chậm thời gian tải trang của ứng dụng (phải tải bất đồng bộ - Asynchronous Ad Loading).
- Đảm bảo tuân thủ đầy đủ các tiêu chuẩn bảo mật và quyền riêng tư (chẳng hạn như GDPR, CCPA, chính sách App Tracking Transparency của Apple).

## 6. Business Rules
- **Quy tắc về Vị trí đặt quảng cáo:**
  - Tuyệt đối **không hiển thị quảng cáo dạng Pop-up (Interstitial Ads) toàn màn hình** hoặc quảng cáo dạng đếm ngược gây ức chế khi người dùng đang thao tác lên thực đơn hoặc đi chợ.
  - Quảng cáo chỉ được hiển thị ở dạng Biểu ngữ nhỏ dưới chân trang (Banner Ads) hoặc các gợi ý nguyên liệu/thương hiệu tự nhiên trong luồng đề xuất mua sắm (Sponsored Products).
- **Quy tắc về Nội dung quảng cáo:**
  - Chỉ cho phép hiển thị các nội dung quảng cáo liên quan trực tiếp đến ẩm thực, nguyên liệu thực phẩm sạch, thiết bị nhà bếp, sức khỏe gia đình, hoặc lối sống lành mạnh.
  - Chặn hoàn toàn các nội dung quảng cáo về cờ bạc, tài chính đen, game bạo lực, thuốc lá, chất kích thích hoặc các sản phẩm không lành mạnh cho gia đình và trẻ em.
- Đối với tài khoản con thuộc hệ thống tài khoản chung của trẻ em (Family Kid Accounts), hệ thống sẽ tắt hoàn toàn mọi hình thức theo dõi hành vi và không hiển thị quảng cáo cá nhân hóa.

## 7. Data Model
- `AdPlacement`: Định nghĩa các vị trí đặt quảng cáo trong ứng dụng (ID, ScreenName, AdType, ActiveStatus).
- `SponsoredPartner`: Quản lý các đối tác chạy chiến dịch tài trợ sản phẩm trực tiếp (ví dụ: thương hiệu nước mắm Chin-su muốn tài trợ xuất hiện trong phần gợi ý công thức món kho).
- `UserAdInteraction`: Ghi nhận dữ liệu tương tác ẩn danh của người dùng để cải thiện độ chính xác hiển thị.

## 8. Flow
1. **Luồng tải quảng cáo native:** Người dùng mở màn hình công thức -> Hệ thống gọi API kiểm tra trạng thái tài khoản -> Trạng thái là `Free` -> Hệ thống gọi mạng quảng cáo để lấy thông tin quảng cáo -> Hiển thị quảng cáo lồng ghép một cách tự nhiên như một gợi ý sản phẩm khuyên dùng kèm nhãn "Được tài trợ" (Sponsored).
2. **Luồng ẩn quảng cáo sau khi nâng cấp:** Người dùng thanh toán nâng cấp tài khoản Premium thành công -> Hệ thống cập nhật trạng thái thuê bao -> Ứng dụng nhận sự kiện thay đổi -> Ẩn ngay lập tức tất cả các thành phần giao diện quảng cáo mà không cần khởi động lại app.

## 9. API
- `GET /api/v1/ads/placement-config`: Lấy danh sách cấu hình các vị trí quảng cáo được kích hoạt cho ứng dụng khách.
- `POST /api/v1/ads/report-ad`: Tiếp nhận phản hồi của người dùng về quảng cáo xấu hoặc không phù hợp để tự động chặn.

## 10. Acceptance Criteria
- Đảm bảo không có bất kỳ quảng cáo nào hiển thị cho người dùng có trạng thái thuê bao `ACTIVE` (Premium/Family).
- Hệ thống tải quảng cáo bất đồng bộ thành công và không gây ảnh hưởng đến hiệu năng cuộn (scrolling) của danh sách công thức.

## 11. Future Improvements
- Phát triển mạng lưới quảng cáo tự phục vụ (Self-serve Ad Portal) dành cho các hộ kinh doanh thực phẩm sạch tại địa phương để họ có thể tự tạo chiến dịch quảng cáo tiếp cận các gia đình trong khu vực lân cận.

## 12. References
- Google AdMob Policy Guidelines.

## 13. Related Documents
- [DOC-100 Business Model](./DOC-100%20Business%20Model.md)
- [DOC-101 Pricing](./DOC-101%20Pricing.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Khởi tạo tài liệu đặc tả Quản lý quảng cáo |
