---
Document ID: DOC-101
Title: Pricing
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-100 Business Model](./DOC-100%20Business%20Model.md)
- [DOC-102 Subscription](./DOC-102%20Subscription.md)
---

# Pricing

## 1. Objective
Tài liệu này xác định chi tiết cơ cấu các gói dịch vụ, chính sách giá (Pricing Strategy) và các đặc quyền đi kèm đối với từng nhóm đối tượng người dùng của ứng dụng **Family Meal Budget Planner**.

## 2. Scope
Tài liệu bao gồm định giá các gói dịch vụ cơ bản và nâng cao (Free, Premium, Family Pack), chính sách dùng thử (Free Trial), cơ chế giảm giá (Discounts) và nguyên tắc điều chỉnh giá theo khu vực địa lý (Regional Pricing).

## 3. Business Context
Để thu hút người dùng đại trà ban đầu, ứng dụng cần một gói dịch vụ miễn phí đủ hấp dẫn để giải quyết nhu cầu cơ bản. Tuy nhiên, các tính năng sử dụng tài nguyên đắt đỏ như AI đề xuất thực đơn cá nhân hóa và đồng bộ hóa gia đình thời gian thực cần được đặt sau bức tường thu phí (Paywall) để đảm bảo bù đắp chi phí vận hành máy chủ và API AI, đồng thời tạo ra dòng tiền dương cho doanh nghiệp.

## 4. Functional Requirements
- Hệ thống hỗ trợ hiển thị giá động và thay đổi tiền tệ dựa trên vị trí địa lý của người dùng.
- Cơ chế quản lý mã giảm giá (Coupon Code) linh hoạt.
- Quản lý hạn mức (Rate-limiting) tự động dựa trên cấp độ tài khoản của gia đình (ví dụ: giới hạn số lượng công thức nhập bằng URL của tài khoản Free).

## 5. Non-Functional Requirements
- Thời gian tải bảng giá và phản hồi giao dịch thanh toán dưới 1.5 giây.
- Đảm bảo đồng bộ thông tin gói cước tức thì giữa các thiết bị của các thành viên trong cùng một Family Group.

## 6. Business Rules
- **Gói Free:**
  - Tối đa 2 thành viên trong nhóm gia đình.
  - Tối đa import 10 công thức/tháng qua URL.
  - Hiển thị quảng cáo biểu ngữ không gây gián đoạn.
  - Không hỗ trợ AI đề xuất tối ưu ngân sách nâng cao.
- **Gói Premium (Dành cho cá nhân/cặp đôi):**
  - Giá: $4.99/tháng hoặc $39.99/năm.
  - Tối đa 3 thành viên trong nhóm gia đình.
  - Không giới hạn số lượng công thức import.
  - Không quảng cáo.
  - Hỗ trợ AI lập thực đơn tối ưu ngân sách cơ bản.
- **Gói Family Pack (Dành cho hộ gia đình đông người):**
  - Giá: $7.99/tháng hoặc $59.99/năm.
  - Tối đa 8 thành viên trong nhóm gia đình.
  - Quản lý tối đa 3 Pantry/Tủ lạnh khác nhau (nhà riêng, nhà nội, nhà ngoại).
  - Đầy đủ tính năng AI tối ưu hóa ngân sách nâng cao, phân tích thói quen dinh dưỡng và ước lượng giá cả đi chợ thời gian thực.
  - Báo cáo tài chính gia đình hợp nhất (Consolidated Financial Reports).
- **Chính sách dùng thử:** Cho phép dùng thử gói Premium miễn phí 14 ngày (yêu cầu nhập thông tin thẻ thanh toán trước).

## 7. Data Model
- `PricingTier`: Chứa định nghĩa các gói (ID, Name, MonthlyPrice, YearlyPrice, Currency).
- `TierPermission`: Định nghĩa quyền hạn cụ thể của từng gói (MaxMembers, MaxPantry, ImportLimit, HasAI).
- `UserPromotion`: Quản lý các chương trình ưu đãi, mã giảm giá áp dụng cho người dùng.

## 8. Flow
1. **Luồng kiểm tra giới hạn gói:** Người dùng thực hiện hành động (ví dụ: import công thức thứ 11 trong tháng) -> Hệ thống truy vấn `UserSubscription` -> Nhận diện gói Free đã chạm giới hạn -> Hiển thị màn hình Paywall gợi ý nâng cấp lên gói Premium.
2. **Luồng áp dụng mã giảm giá:** Người dùng nhập mã giảm giá tại màn hình thanh toán -> Hệ thống kiểm tra tính hợp lệ của mã (`UserPromotion`) -> Tính toán lại số tiền phải trả -> Hiển thị giá mới -> Người dùng xác nhận thanh toán.

## 9. API
- `GET /api/v1/pricing/tiers`: Lấy danh sách các gói giá hiện tại phù hợp với khu vực địa lý của người dùng.
- `POST /api/v1/pricing/apply-promo`: Xác thực và áp dụng mã giảm giá.

## 10. Acceptance Criteria
- Khi tài khoản Free đạt tới giới hạn thành viên (2 người) hoặc giới hạn import công thức (10 lần), ứng dụng phải hiển thị đúng màn hình Paywall và chặn hành động tiếp theo một cách thân thiện.
- Giá hiển thị trên màn hình thanh toán phải khớp chính xác với số tiền bị trừ trên hóa đơn của Stripe/MoMo.

## 11. Future Improvements
- Định giá linh hoạt dựa trên mức độ sử dụng (Usage-based pricing) dành cho các nhóm gia đình cực lớn hoặc các homestay có nhu cầu quản lý ăn uống tập thể.
- Hợp tác phân phối gói Premium kèm với các gói bảo hiểm sức khỏe gia đình.

## 12. References
- Phân tích đối thủ: [DOC-151 YNAB](../15-research/YNAB.md) ($14.99/tháng), [DOC-153 Samsung Food](../15-research/Samsung%20Food.md) ($6.99/tháng).

## 13. Related Documents
- [DOC-100 Business Model](./DOC-100%20Business%20Model.md)
- [DOC-102 Subscription](./DOC-102%20Subscription.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Khởi tạo tài liệu đặc tả Chính sách giá |
