---
Document ID: DOC-104
Title: Affiliate Integration
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-100 Business Model](./DOC-100%20Business%20Model.md)
- [DOC-254 Shopping](../25-domain/DOC-254%20Shopping.md)
---

# Affiliate Integration

## 1. Objective
Tài liệu này đặc tả cơ chế tích hợp tiếp thị liên kết (Affiliate Marketing) với các đối tác siêu thị bán lẻ thực phẩm, chợ trực tuyến và các ứng dụng giao hàng đi chợ hộ (Grocery Delivery Apps) để chuyển đổi Danh sách đi chợ (Shopping List) của người dùng thành đơn hàng thực tế và tạo hoa hồng cho ứng dụng.

## 2. Scope
Tài liệu quy định cách thức đồng bộ danh mục nguyên liệu với giỏ hàng của đối tác (Cart Syncing), cơ chế gắn mã theo dõi (Affiliate Tracking Links/Parameters), quy trình đối soát đơn hàng hoàn tất (CPA - Cost Per Action) và cơ chế chia sẻ lợi ích với người dùng (ví dụ: Cashback/Ưu đãi).

## 3. Business Context
Việc viết ra danh sách đi chợ rồi phải đi bộ ra siêu thị tìm kiếm và mua từng món là một trải nghiệm có ma sát cao. Tích hợp trực tiếp với các nền tảng đi chợ hộ (ví dụ: GrabMart, ShopeeFood, Lotte Mart, Bách Hóa Xanh) giúp người dùng chốt mua toàn bộ nguyên liệu của thực đơn tuần chỉ bằng 1 cú click chuột. Doanh số bán ra từ đơn hàng tạp hóa này mang lại nguồn doanh thu tiếp thị liên kết khổng lồ và ổn định cho nền tảng.

## 4. Functional Requirements
- Hệ thống bóc tách danh sách nguyên liệu và so khớp (mapping) với danh mục sản phẩm thực tế trên hệ sinh thái siêu thị đối tác bằng thuật toán đối sánh văn bản thông minh.
- Cơ chế tạo liên kết tiếp thị động chứa mã định danh của ứng dụng và của tài khoản người dùng (`aff_sub` tracking parameters).
- Tích hợp hệ thống webhook tiếp nhận dữ liệu báo cáo đơn hàng (order success/cancel/refund) từ các mạng lưới tiếp thị (AccessTrade, v.v.) hoặc kết nối API trực tiếp từ đối tác.

## 5. Non-Functional Requirements
- API kết nối giỏ hàng đối tác hoạt động ổn định, độ trễ phản hồi đồng bộ dưới 3 giây.
- Đảm bảo quyền riêng tư: Hệ thống chỉ chia sẻ danh sách nguyên liệu và số lượng cần mua sang đối tác, không chia sẻ thông tin cá nhân nhạy cảm khác của người dùng gia đình.

## 6. Business Rules
- **Tỷ lệ hoa hồng kỳ vọng:** Từ 1% đến 5% giá trị giỏ hàng thực phẩm thành công (tùy thuộc vào chính sách của từng đối tác siêu thị).
- **Cơ chế Cashback (Tùy chọn):** Nền tảng có thể trích từ 30% đến 50% số tiền hoa hồng nhận được để hoàn lại cho người dùng dưới dạng điểm thưởng tích lũy (Reward Points) hoặc voucher mua sắm thực phẩm cho tuần tiếp theo, nhằm khuyến khích lòng trung thành.
- Chỉ các đơn hàng được đối tác xác nhận là "Hoàn thành" (Delivered & Paid) và không có yêu cầu đổi trả/hoàn tiền trong vòng 7 ngày mới được tính vào doanh thu thực tế được đối soát.

## 7. Data Model
- `AffiliatePartner`: Quản lý danh sách đối tác siêu thị, thông tin API kết nối và tỷ lệ hoa hồng cam kết.
- `ProductMapping`: Bảng cơ sở dữ liệu ánh xạ giữa các nguyên liệu chuẩn hóa của ứng dụng (ví dụ: "Thịt ba chỉ bò Mỹ") với SKU sản phẩm của siêu thị (ví dụ: "Thịt ba chỉ bò Mỹ khay 500g - MEATDeli").
- `AffiliateOrder`: Theo dõi trạng thái đơn hàng liên kết (`id`, `user_id`, `partner_id`, `partner_order_id`, `order_value`, `commission_value`, `status`).

## 8. Flow
1. **Luồng đẩy giỏ hàng sang đối tác:** Người dùng mở màn hình Shopping List -> Bấm nút "Mua sắm online qua GrabMart" -> Hệ thống gọi API đối chiếu nguyên liệu cần mua thành các SKU sản phẩm có sẵn trên GrabMart gần nhất -> Hiển thị danh sách sản phẩm tương ứng kèm giá ước tính -> Người dùng xác nhận -> Hệ thống mở app GrabMart/Trang web đối tác và tự động thêm tất cả sản phẩm đó vào giỏ hàng của người dùng kèm mã giới thiệu tiếp thị.
2. **Luồng đối soát hoa hồng:** Người dùng thanh toán đơn hàng thành công trên ứng dụng đối tác -> Đối tác ghi nhận mã giới thiệu -> Sau khi đơn hàng hoàn tất, đối tác gọi Webhook hoặc cập nhật danh sách đối soát hàng tháng -> Hệ thống đối sánh thông tin `partner_order_id` -> Cập nhật trạng thái `AffiliateOrder` thành `PAID` và ghi nhận doanh thu thực tế.

## 9. API
- `POST /api/v1/affiliate/sync-cart`: Chuẩn bị giỏ hàng đối tác từ danh sách đi chợ của người dùng.
- `GET /api/v1/affiliate/products-matching`: Tìm kiếm các sản phẩm tương thích của đối tác dựa trên từ khóa nguyên liệu.
- `POST /api/v1/affiliate/orders/webhook`: Tiếp nhận thông tin thay đổi trạng thái đơn hàng từ đối tác.

## 10. Acceptance Criteria
- Hệ thống tạo ra đúng định dạng đường dẫn liên kết chứa các tham số theo dõi mà không bị lỗi cú pháp URL.
- Thuật toán mapping sản phẩm phải đạt độ chính xác tối thiểu 80% (không đề xuất nhầm mua dầu ăn thành dầu gội đầu).

## 11. Future Improvements
- Hợp tác sâu để tích hợp dịch vụ giao hàng định kỳ: Tự động giao rau quả tươi 2 lần một tuần theo đúng lịch trình thực đơn của gia đình.
- Tự động so sánh giá nguyên liệu giữa các siêu thị đối tác để đề xuất cho người dùng siêu thị có tổng giá giỏ hàng rẻ nhất tại thời điểm đó.

## 12. References
- Phân tích đối thủ: [DOC-153 Samsung Food](../15-research/Samsung%20Food.md) (tích hợp rất tốt với Instacart và Walmart).

## 13. Related Documents
- [DOC-100 Business Model](./DOC-100%20Business%20Model.md)
- [DOC-254 Shopping](../25-domain/DOC-254%20Shopping.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Khởi tạo tài liệu đặc tả Tiếp thị liên kết siêu thị |
