---
Document ID: DOC-106
Title: Internationalization & Localization Strategy
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-100 Business Model](./DOC-100%20Business%20Model.md)
- [DOC-101 Pricing](./DOC-101%20Pricing.md)
---

# Internationalization & Localization Strategy

## 1. Objective
Tài liệu này xác định chiến lược quốc tế hóa (Internationalization - i18n) và bản địa hóa (Localization - l10n) nhằm chuẩn bị hạ tầng kỹ thuật và nội dung ẩm thực phù hợp cho việc mở rộng sản phẩm ra nhiều quốc gia bên ngoài Việt Nam.

## 2. Scope
Phạm vi tài liệu bao gồm hỗ trợ đa ngôn ngữ (Localization of Texts), hỗ trợ đa tiền tệ và định dạng số/ngày tháng, bản địa hóa cơ sở dữ liệu nguyên liệu và công thức nấu ăn, xử lý múi giờ (Timezones) và sự khác biệt về văn hóa ẩm thực theo từng vùng miền.

## 3. Business Context
Thói quen ăn uống, đơn vị đo lường (gram/oz/cup) và cơ cấu giá cả thực phẩm có sự khác biệt rất lớn giữa các quốc gia. Một ứng dụng lên thực đơn và quản lý ngân sách không thể thành công ở Mỹ nếu chỉ sử dụng hệ đo lường mét và cơ sở dữ liệu nguyên liệu thuần Việt. Để mở rộng quy mô toàn cầu và tối ưu chi phí vận hành, mã nguồn ứng dụng và cấu trúc cơ sở dữ liệu phải được thiết kế linh hoạt ngay từ đầu để dễ dàng bản địa hóa mà không cần viết lại mã nguồn cốt lõi.

## 4. Functional Requirements
- Hệ thống tự động phát hiện ngôn ngữ hệ điều hành và vị trí địa lý để thiết lập cấu hình ban đầu (locale).
- Cho phép người dùng chuyển đổi thủ công ngôn ngữ, đơn vị đo lường (Metric vs Imperial) và tiền tệ hiển thị trong phần cài đặt.
- Cơ chế quản lý dữ liệu tĩnh (mã dịch thuật i18n) lưu trữ tập trung và hỗ trợ tải động (Over-The-Air translation updates).
- Chuẩn hóa định dạng hiển thị ngày tháng, thời gian và tiền tệ theo chuẩn địa phương của người dùng (ví dụ: định dạng tiền VNĐ, USD, EUR).

## 5. Non-Functional Requirements
- Kiến trúc cơ sở dữ liệu hỗ trợ lưu trữ đa ngôn ngữ cho các trường dữ liệu động như Tên nguyên liệu, Mô tả công thức nấu ăn mà không làm suy giảm hiệu năng truy vấn.
- Tốc độ chuyển đổi ngôn ngữ trên ứng dụng tức thì và không yêu cầu người dùng khởi động lại ứng dụng.

## 6. Business Rules
- **Ngôn ngữ hỗ trợ trong Phase 1:** Tiếng Việt (vi-VN) và Tiếng Anh (en-US). Các ngôn ngữ tiếp theo sẽ được bổ sung dựa trên mức độ tăng trưởng thị trường (dự kiến là Tiếng Nhật ja-JP và Tiếng Hàn ko-KR).
- **Quy tắc bản địa hóa dữ liệu thực phẩm:**
  - Không dịch nghĩa đen (literal translation) các nguyên liệu đặc thù. Thay vào đó, xây dựng bảng ánh xạ (Mapping Table) tương đương. Ví dụ: "Cà pháo" trong Tiếng Việt không thể dịch thô sang Tiếng Anh, mà cần có cơ chế hiển thị hoặc thay thế nguyên liệu phù hợp khi người dùng chuyển vùng ẩm thực.
  - Cơ sở dữ liệu giá cả thực phẩm phải được phân tách riêng theo từng quốc gia/thành phố để phục vụ AI tối ưu hóa ngân sách chính xác nhất.

## 7. Data Model
- `LocaleConfig`: Định nghĩa các cấu hình locale được hỗ trợ (`id`, `language_code`, `country_code`, `currency_code`, `measurement_system`).
- `LocalizedText`: Bảng lưu trữ bản dịch động cho các đối tượng trong cơ sở dữ liệu (ví dụ: `object_type`, `object_id`, `field_name`, `language_code`, `translated_value`).
- `PriceSnapshotRegional`: Cơ sở dữ liệu giá thực phẩm trung bình theo khu vực địa lý.

## 8. Flow
1. **Luồng khởi tạo người dùng mới:** Người dùng mở ứng dụng lần đầu -> Ứng dụng đọc cài đặt hệ thống (ví dụ: `en_US`) -> Ứng dụng gửi yêu cầu cấu hình về Server -> Server phản hồi cấu hình mặc định (đơn vị: Imperial, tiền tệ: USD, ngôn ngữ: Tiếng Anh) -> Thiết lập trạng thái ban đầu cho tài khoản gia đình.
2. **Luồng cập nhật nội dung đa ngôn ngữ:** Admin thêm công thức mới lên Marketplace -> Tạo nội dung Tiếng Việt và Tiếng Anh -> Khi người dùng truy cập, hệ thống tự động kiểm tra `locale` của người dùng để trả về bản dịch phù hợp từ bảng `LocalizedText`.

## 9. API
- `GET /api/v1/i18n/translations`: Tải file ngôn ngữ tĩnh cho ứng dụng khách.
- `GET /api/v1/i18n/supported-locales`: Lấy danh sách các khu vực địa lý và ngôn ngữ hệ thống hỗ trợ.

## 10. Acceptance Criteria
- Đảm bảo toàn bộ văn bản tĩnh trên giao diện ứng dụng (nút bấm, nhãn, thông báo lỗi) được chuyển đổi chính xác khi thay đổi cài đặt ngôn ngữ mà không bị sót chữ chưa dịch.
- Các con số tài chính và định lượng nguyên liệu phải được định dạng chính xác theo chuẩn văn hóa địa phương (ví dụ ở Việt Nam hiển thị "10.000 đ", ở Mỹ hiển thị "$10.00").

## 11. Future Improvements
- Sử dụng AI để tự động dịch thuật và tối ưu hóa nội dung công thức nấu ăn từ mọi ngôn ngữ sang ngôn ngữ đích của người dùng với văn phong tự nhiên nhất.
- Hỗ trợ định vị giá thực phẩm chi tiết đến cấp quận/huyện để tối ưu hóa ngân sách đi chợ chính xác tuyệt đối theo vị trí người dùng.

## 12. References
- ISO 639-1 (Language codes), ISO 3166-1 alpha-2 (Country codes), Unicode CLDR (Common Locale Data Repository).

## 13. Related Documents
- [DOC-100 Business Model](./DOC-100%20Business%20Model.md)
- [DOC-101 Pricing](./DOC-101%20Pricing.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Khởi tạo tài liệu đặc tả Chiến lược quốc tế hóa |
