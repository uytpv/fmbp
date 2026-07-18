---
Document ID: DOC-103
Title: Recipe & Meal Plan Marketplace
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-100 Business Model](./DOC-100%20Business%20Model.md)
- [DOC-251 Recipe](../25-domain/DOC-251%20Recipe.md)
---

# Recipe & Meal Plan Marketplace

## 1. Objective
Tài liệu này đặc tả mô hình hoạt động của chợ giao dịch nội dung số (Marketplace) trên ứng dụng, nơi các đầu bếp chuyên nghiệp, chuyên gia dinh dưỡng (Nutritionists) và các nhà sáng tạo nội dung (Creators) có thể bán các công thức độc quyền hoặc kế hoạch bữa ăn theo chế độ ăn uống chuyên biệt cho người dùng.

## 2. Scope
Phạm vi tài liệu gồm quy trình đăng ký tài khoản Creator, đăng tải công thức/kế hoạch bữa ăn, định giá bán, quy trình kiểm duyệt nội dung (Moderation), chia sẻ doanh thu (Revenue Share) và cơ chế thanh toán rút tiền (Payouts).

## 3. Business Context
Bên cạnh các công thức nấu ăn cơ bản có sẵn trên internet, người dùng thường có nhu cầu cao về các chế độ ăn uống khoa học, được thiết kế riêng bởi các chuyên gia uy tín (ví dụ: thực đơn giảm cân 21 ngày cho dân văn phòng, thực đơn cho người tiểu đường, thực đơn ăn dặm cho bé). Việc xây dựng Marketplace giúp biến ứng dụng từ một công cụ đơn thuần thành một nền tảng dịch vụ kết nối người dùng với các chuyên gia dinh dưỡng, tạo thêm nguồn thu nhập lớn và giữ chân người dùng ở lại hệ sinh thái lâu dài.

## 4. Functional Requirements
- Hệ thống đăng ký và xác minh danh tính Creator (KYC - Know Your Customer).
- Trang quản trị dành riêng cho Creator (Creator Portal) để tạo, chỉnh sửa sản phẩm số và xem báo cáo doanh thu.
- Hệ thống ví nội bộ (Internal Wallet) ghi nhận số dư của Creator sau mỗi lượt mua hàng thành công từ người dùng.
- Tính năng đánh giá (Review) và xếp hạng (Rating) 5 sao cho từng sản phẩm số trên Marketplace.

## 5. Non-Functional Requirements
- Hỗ trợ lưu trữ số lượng lớn hình ảnh và video hướng dẫn nấu ăn chất lượng cao của Creator với băng thông truyền tải nhanh.
- Cơ chế rút tiền (Payout) tự động hàng tháng qua Stripe Connect hoặc liên kết ngân hàng nội địa hoạt động chính xác tuyệt đối.

## 6. Business Rules
- **Tỷ lệ chia sẻ doanh thu (Revenue Split):** Mặc định 70% thuộc về Creator và 30% thuộc về nền tảng để chi trả chi phí vận hành máy chủ, cổng thanh toán và phí kiểm duyệt.
- **Quy tắc kiểm duyệt nội dung:** 
  - Mọi công thức/kế hoạch bữa ăn trước khi xuất bản lên chợ công cộng đều phải qua bước kiểm duyệt tự động (bằng AI) và kiểm duyệt thủ công (bằng admin của dự án) để đảm bảo chất lượng hình ảnh, tính chính xác của dinh dưỡng và tính an toàn vệ sinh thực phẩm.
  - Creator không được phép đăng tải các nội dung vi phạm bản quyền từ nguồn khác.
- **Chính sách rút tiền (Payout Policy):** Số dư ví của Creator tối thiểu phải đạt 500.000 VNĐ (hoặc $25) mới được yêu cầu rút tiền. Kỳ thanh toán rút tiền diễn ra vào ngày 10 hàng tháng.

## 7. Data Model
- `CreatorProfile`: Lưu thông tin chuyên môn, chứng chỉ hành nghề và trạng thái xác minh của Creator.
- `MarketplaceProduct`: Chi tiết sản phẩm số (MealPlan/Recipe được rao bán, mô tả, giá bán, danh sách bài học/món ăn đính kèm).
- `PurchaseRecord`: Ghi nhận lịch sử mua sản phẩm của từng tài khoản gia đình.
- `CreatorWallet`: Quản lý số dư ví, lịch sử cộng tiền và các yêu cầu rút tiền của Creator.

## 8. Flow
1. **Luồng mua và sử dụng thực đơn:** Người dùng chọn mua thực đơn trên Marketplace -> Tiến hành thanh toán 100% giá trị sản phẩm -> Hệ thống ghi nhận quyền sở hữu (`PurchaseRecord`) -> Mở khóa và tự động đưa thực đơn này vào màn hình Lập kế hoạch của người dùng -> Đồng thời chia 70% số tiền vào ví của Creator.
2. **Luồng kiểm duyệt nội dung:** Creator tạo sản phẩm mới -> Nhấn "Gửi duyệt" -> Trạng thái sản phẩm chuyển thành `PENDING_REVIEW` -> AI quét lỗi sao chép văn bản và phát hiện hình ảnh nhạy cảm -> Admin duyệt thủ công -> Chuyển trạng thái sang `PUBLISHED` và hiển thị trên Marketplace.

## 9. API
- `POST /api/v1/marketplace/products`: Creator đăng tải sản phẩm mới.
- `POST /api/v1/marketplace/products/{id}/buy`: Người dùng mua sản phẩm số.
- `POST /api/v1/marketplace/creator/payout-request`: Creator gửi yêu cầu rút tiền về tài khoản ngân hàng.

## 10. Acceptance Criteria
- Đảm bảo người dùng chỉ được sử dụng thực đơn/công thức có phí sau khi hệ thống đã xác nhận giao dịch thanh toán thành công 100%.
- Lịch sử giao dịch ví của Creator phải hiển thị đầy đủ và chính xác số tiền được nhận sau khi đã trừ 30% hoa hồng hệ thống.

## 11. Future Improvements
- Tính năng đăng ký theo dõi định kỳ (Creator Subscriptions): Người dùng trả phí tháng để truy cập tất cả công thức/meal plan của một chuyên gia dinh dưỡng cụ thể.
- Đề xuất công thức trả phí bằng AI cá nhân hóa ngay trong luồng gợi ý bữa ăn hàng ngày của người dùng.

## 12. References
- Phân tích đối thủ: [DOC-153 Samsung Food](../15-research/Samsung%20Food.md) (tính năng Communities nhưng chưa thương mại hóa nội dung số).

## 13. Related Documents
- [DOC-100 Business Model](./DOC-100%20Business%20Model.md)
- [DOC-101 Pricing](./DOC-101%20Pricing.md)
- [DOC-705 Moderation](../70-admin/DOC-705%20Moderation.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Khởi tạo tài liệu đặc tả Recipe & Meal Plan Marketplace |
