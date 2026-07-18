---
Document ID: DOC-100
Title: Business Model
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-000 Product Vision](../00-vision/DOC-000%20Product%20Vision.md)
- [DOC-101 Pricing](./DOC-101%20Pricing.md)
- [DOC-103 Marketplace](./DOC-103%20Marketplace.md)
- [DOC-104 Affiliate](./DOC-104%20Affiliate.md)
---

# Business Model

## 1. Objective
Tài liệu này mô tả mô hình kinh doanh (Business Model) tổng thể của dự án **Family Meal Budget Planner**, xác định các luồng giá trị, phân khúc khách hàng, các nguồn doanh thu chính và các đối tác chiến lược để đảm bảo dự án phát triển bền vững về mặt tài chính trong dài hạn.

## 2. Scope
Nằm trong phạm vi tài liệu này là các định nghĩa về Đề xuất giá trị (Value Propositions), Luồng doanh thu (Revenue Streams), Cấu trúc chi phí (Cost Structure), Phân khúc khách hàng mục tiêu (Customer Segments) và Kênh phân phối (Channels) của dự án ở cả hai giai đoạn: MVP và Mở rộng (Scale).

## 3. Business Context
Thị trường ứng dụng quản lý tài chính hiện tại đa số tập trung vào việc ghi chép chi tiêu sau khi đã tiêu tiền, dẫn đến tỷ lệ người dùng bỏ cuộc rất cao do cảm giác tẻ nhạt và gò bó. Family Meal Budget Planner dịch chuyển trọng tâm sang việc **"hoạch định bữa ăn trước, chi tiêu tiền sau"**. Vì thực phẩm là khoản chi tiêu chiếm tỷ trọng lớn thứ nhất hoặc thứ hai trong ngân sách gia đình và là khoản có thể tối ưu hóa được thông qua việc chuẩn bị thực đơn thông minh, việc gắn liền tài chính với thói quen ăn uống hàng ngày tạo ra một động lực sử dụng công cụ mạnh mẽ và bền vững hơn rất nhiều.

## 4. Functional Requirements
- Hệ thống hỗ trợ đa luồng thanh toán và quản lý gói dịch vụ đăng ký (Subscription).
- Tích hợp cổng thanh toán Stripe (cho thị trường quốc tế) và ví điện tử/thanh toán nội địa như MoMo, VNPay (cho thị trường Việt Nam).
- Hệ thống tính toán và đối soát hoa hồng liên kết (Affiliate Commission) với các đối tác siêu thị/giao hàng.
- Nền tảng chia sẻ doanh thu (Revenue Sharing) với các chuyên gia dinh dưỡng và nhà sáng tạo thực đơn trên Marketplace.

## 5. Non-Functional Requirements
- Đảm bảo tính minh bạch, bảo mật thông tin tài chính của gia đình (tuân thủ PCI-DSS đối với thanh toán thẻ).
- Hệ thống ghi nhận lượt chuyển đổi liên kết (affiliate click & checkout tracking) hoạt động ổn định với độ trễ đối soát dưới 24h.
- Khả năng mở rộng tốt để xử lý khối lượng lớn giao dịch thanh toán trong các ngày cao điểm (đầu tháng/cuối tuần).

## 6. Business Rules
- Nền tảng cam kết **không bán dữ liệu cá nhân hay thói quen ăn uống chi tiết của người dùng** cho bên thứ ba. Dữ liệu chỉ được tổng hợp dưới dạng ẩn danh (Aggregated & Anonymized) phục vụ báo cáo xu hướng tiêu dùng chung.
- Tỷ lệ chia sẻ doanh thu mặc định trên Marketplace là **70% cho Creator và 30% cho Platform**.
- Mọi tài khoản gia đình đăng ký gói trả phí đều được áp dụng cơ chế tự động gia hạn (Auto-renewal) trừ khi người dùng chủ động tắt tính năng này trước kỳ thanh toán 24 giờ.

## 7. Data Model
- `SubscriptionPlan`: Lưu thông tin các gói dịch vụ (Free, Premium, Family).
- `UserSubscription`: Trạng thái gói dịch vụ của từng hộ gia đình (Family Group).
- `CreatorAccount`: Thông tin tài khoản và số dư ví của Creator tham gia bán công thức.
- `AffiliatePartner`: Danh sách đối tác siêu thị tích hợp và tỷ lệ chiết khấu.
- `AffiliateTransaction`: Lịch sử giao dịch đi chợ có liên kết tiếp thị để đối soát hoa hồng.

## 8. Flow
1. **Luồng nâng cấp dịch vụ:** Người dùng chọn gói -> Chọn phương thức thanh toán -> Hệ thống xử lý qua Stripe/MoMo -> Cập nhật trạng thái `UserSubscription` thành Premium -> Mở khóa tính năng AI nâng cao cho gia đình.
2. **Luồng mua sắm liên kết (Affiliate):** Người dùng chốt thực đơn -> Đồng ý chuyển giỏ hàng sang đối tác (ví dụ GrabMart/ShopeeFood) -> Thanh toán đơn hàng bên phía đối tác -> Đối tác gửi Webhook ghi nhận giao dịch -> Hệ thống tính toán hoa hồng ghi nhận vào doanh thu.
3. **Luồng giao dịch trên Marketplace:** Người dùng mua Kế hoạch ăn kiêng của chuyên gia -> Hệ thống trừ tiền người dùng -> Giữ 30% phí hệ thống -> Chuyển 70% số tiền còn lại vào tài khoản tích lũy của chuyên gia.

## 9. API
- `POST /api/v1/subscriptions/checkout`: Tạo phiên thanh toán nâng cấp tài khoản.
- `POST /api/v1/marketplace/purchase`: Mua gói thực đơn/công thức từ Marketplace.
- `POST /api/v1/affiliate/callback`: Tiếp nhận dữ liệu đối soát đơn hàng từ đối tác siêu thị.

## 10. Acceptance Criteria
- Hệ thống phân bổ đúng tỷ lệ doanh thu 70/30 trên Marketplace cho mỗi giao dịch thành công.
- Trạng thái thuê bao của gia đình lập tức chuyển sang Premium ngay sau khi nhận được tín hiệu thanh toán thành công từ cổng thanh toán.

## 11. Future Improvements
- Hợp tác sâu với các chuỗi siêu thị lớn để đưa ra gói đăng ký trọn gói (Bundle Subscription): Mua Premium được giảm giá trực tiếp trên hóa đơn grocery.
- Tích hợp ví gia đình (Family Wallet) liên kết với tài khoản ngân hàng để tự động hóa hoàn toàn dòng tiền đi chợ.

## 12. References
- Phân tích đối thủ: [DOC-151 YNAB](../15-research/YNAB.md), [DOC-153 Samsung Food](../15-research/Samsung%20Food.md).

## 13. Related Documents
- [DOC-000 Product Vision](../00-vision/DOC-000%20Product%20Vision.md)
- [DOC-101 Pricing](./DOC-101%20Pricing.md)
- [DOC-102 Subscription](./DOC-102%20Subscription.md)
- [DOC-103 Marketplace](./DOC-103%20Marketplace.md)
- [DOC-104 Affiliate](./DOC-104%20Affiliate.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Khởi tạo tài liệu Mô hình kinh doanh chi tiết |
