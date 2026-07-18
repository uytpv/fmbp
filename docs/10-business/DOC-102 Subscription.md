---
Document ID: DOC-102
Title: Subscription Management
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-100 Business Model](./DOC-100%20Business%20Model.md)
- [DOC-101 Pricing](./DOC-101%20Pricing.md)
---

# Subscription Management

## 1. Objective
Tài liệu này đặc tả kỹ thuật và nghiệp vụ liên quan đến vòng đời thuê bao (Subscription Lifecycle), quản lý trạng thái thanh toán định kỳ, nâng cấp/hạ cấp gói dịch vụ và các tương tác với cổng thanh toán bên thứ ba.

## 2. Scope
Nằm trong phạm vi tài liệu là luồng đăng ký (Subscribe), dùng thử (Trial), thanh toán định kỳ (Recurring Payment), gia hạn (Renewal), hủy gói (Cancellation), xử lý lỗi thanh toán (Dunning Process), nâng cấp/hạ cấp gói (Upgrade/Downgrade) và chính sách hoàn tiền (Refund Policy).

## 3. Business Context
Quản lý đăng ký thuê bao là cốt lõi của dòng doanh thu định kỳ (MRR/ARR) của sản phẩm. Việc xử lý không mượt mà quá trình nâng cấp, hạ cấp hoặc lỗi thẻ có thể gây mất mát khách hàng (Churn rate) và giảm trải nghiệm người dùng đáng kể. Hệ thống cần được thiết kế tự động tối đa và giảm thiểu ma sát giao dịch.

## 4. Functional Requirements
- Tích hợp với Apple In-App Purchase (App Store), Google Play Billing (Google Play) và Stripe Webhooks.
- Quản lý trạng thái thuê bao thời gian thực của nhóm Gia đình.
- Tự động thông báo qua Email/Push Notification khi sắp đến ngày gia hạn hoặc khi thanh toán gặp lỗi.
- Xử lý cơ chế nâng cấp gói (Upgrade - lập tức áp dụng, tính tiền chênh lệch theo ngày sử dụng còn lại) và hạ cấp gói (Downgrade - áp dụng vào chu kỳ thanh toán tiếp theo).

## 5. Non-Functional Requirements
- Đồng bộ hóa trạng thái tài khoản Premium/Family lập tức sau khi Webhook từ cổng thanh toán gửi về (độ trễ < 3 giây).
- Khả năng khôi phục giao dịch mua hàng (Restore Purchase) trên thiết bị di động trong trường hợp đổi thiết bị hoặc cài lại app.

## 6. Business Rules
- **Trạng thái thuê bao gồm:** `TRIALING`, `ACTIVE`, `PAST_DEUE`, `CANCELED`, `UNPAID`.
- **Grace Period (Thời gian ân hạn):** Cấp quyền truy cập Premium thêm 3 ngày sau khi thanh toán định kỳ thất bại để người dùng cập nhật thông tin thẻ.
- **Dunning Process:** Trong vòng 7 ngày kể từ khi thanh toán thất bại, hệ thống sẽ thực hiện thử lại giao dịch (retry) 3 lần vào các ngày 1, 3, 5 trước khi chuyển trạng thái sang `UNPAID` và hạ cấp tài khoản về Free.
- **Chính sách hoàn tiền:** Hoàn tiền 100% trong vòng 48 giờ kể từ khi gia hạn năm nếu người dùng quên hủy và gửi yêu cầu hỗ trợ (chỉ áp dụng đối với đăng ký qua Web/Stripe; đăng ký qua Store di động tuân thủ chính sách của Apple/Google).

## 7. Data Model
- `Subscription`: Chi tiết thông tin thuê bao của Family Group (`id`, `family_id`, `plan_id`, `status`, `current_period_start`, `current_period_end`, `cancel_at_period_end`).
- `PaymentMethod`: Lưu thông tin thẻ đã mã hóa (Tokenized card info).
- `SubscriptionInvoice`: Lịch sử hóa đơn thanh toán của khách hàng.

## 8. Flow
1. **Luồng hủy thuê bao:** Người dùng bấm Hủy gói trên ứng dụng -> Hệ thống cập nhật trường `cancel_at_period_end` thành `true` -> Tài khoản vẫn giữ quyền Premium cho đến hết chu kỳ thanh toán hiện tại (`current_period_end`) -> Đến ngày kết thúc chu kỳ, hệ thống nhận sự kiện từ Stripe/App Store -> Chuyển trạng thái thuê bao sang `CANCELED`, hạ quyền truy cập của gia đình về gói Free.
2. **Luồng nâng cấp gói:** Người dùng gói Premium nâng cấp lên Family Pack -> Stripe tính toán số tiền chưa sử dụng của gói Premium hiện tại -> Cấn trừ vào hóa đơn gói Family Pack -> Trừ tiền phần chênh lệch -> Cập nhật trạng thái thuê bao ngay lập tức.

## 9. API
- `POST /api/v1/subscriptions/stripe-webhook`: Endpoint nhận các sự kiện thanh toán từ Stripe.
- `POST /api/v1/subscriptions/cancel`: Đặt lệnh hủy thuê bao vào cuối chu kỳ.
- `POST /api/v1/subscriptions/restore`: Khôi phục giao dịch mua hàng trên thiết bị di động.

## 10. Acceptance Criteria
- Đảm bảo khi một thành viên hủy đăng ký của gia đình, quyền lợi Premium vẫn phải hoạt động bình thường cho tất cả các thành viên liên kết khác cho tới cuối chu kỳ thanh toán.
- Hệ thống ghi nhận chính xác doanh thu thực tế sau khi đã trừ đi các khoản hoàn tiền (refunds) và phí giao dịch của cổng thanh toán.

## 11. Future Improvements
- Tích hợp AI để phát hiện sớm các dấu hiệu người dùng sắp hủy thuê bao (churn prediction) dựa trên tần suất truy cập giảm dần để tự động đưa ra các chương trình khuyến mãi/giảm giá giữ chân.

## 12. References
- Apple In-App Purchase Guidelines, Stripe Billing Documentation.

## 13. Related Documents
- [DOC-100 Business Model](./DOC-100%20Business%20Model.md)
- [DOC-101 Pricing](./DOC-101%20Pricing.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Khởi tạo tài liệu đặc tả Quản lý đăng ký thuê bao |
