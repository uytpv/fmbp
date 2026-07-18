---
Document ID: 
Title: Overall Main Concpept Specification
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-08
Related Documents: 
---

# Overall Main Concpept Specification

# Family Meal Budget Planner
## Tài liệu Đặc tả Ý tưởng Tổng quan (Overall Main Concept Specification)

**Version:** 0.1 (Concept)
**Author:** Uy Tra
**Last Updated:** 08/07/2026

---

# 1. Giới thiệu

## 1.1 Mục tiêu

Xây dựng một ứng dụng hỗ trợ các gia đình quản lý tài chính theo hướng **quản lý bữa ăn trước, quản lý tiền sau**.

Khác với các ứng dụng quản lý tài chính truyền thống, ứng dụng không bắt đầu từ việc ghi chép thu chi, mà bắt đầu từ việc lập kế hoạch ăn uống.

Thông qua việc xây dựng thực đơn, lập danh sách mua sắm, theo dõi nguyên liệu và tối ưu chi phí thực phẩm, người dùng có thể kiểm soát khoản chi lớn nhất và biến động nhất trong gia đình.

---

# 2. Triết lý sản phẩm

## Money is the Result.

Tiền tiết kiệm không phải là mục tiêu đầu tiên.

Tiền tiết kiệm là kết quả của:

```
Kế hoạch bữa ăn
        ↓
Kế hoạch mua sắm
        ↓
Kiểm soát chi phí ăn uống
        ↓
Quản lý tài chính
        ↓
Tiết kiệm
```

Ứng dụng không ép người dùng tiết kiệm.

Ứng dụng giúp người dùng sống có kế hoạch.

Khi cuộc sống có kế hoạch thì việc tiết kiệm sẽ diễn ra tự nhiên.

---

# 3. Vấn đề của các ứng dụng hiện nay

## Các ứng dụng hiện tại

Ví dụ

- Money Lover
- Spendee
- Wallet
- YNAB
- Excel

đều có chung một giả định:

> Người dùng đã biết mình sẽ tiêu tiền như thế nào.

Nhưng thực tế:

Gia đình thường không lên kế hoạch chi tiêu.

Gia đình chỉ đơn giản là:

```
"Hôm nay ăn gì?"
```

Chính câu hỏi đó tạo ra:

- mua đồ ngẫu hứng
- ăn ngoài
- đặt đồ ăn
- lãng phí thực phẩm
- phát sinh nhiều lần đi siêu thị
- vượt ngân sách

---

# 4. Tuyên ngôn sản phẩm

Ứng dụng này KHÔNG phải là:

> Ứng dụng ghi chép thu chi.

Ứng dụng này là:

> Hệ thống lập kế hoạch cuộc sống gia đình thông qua bữa ăn.

---

# 5. Đối tượng người dùng

## Gia đình trẻ

- Có con nhỏ
- Thu nhập ổn định
- Muốn tiết kiệm

---

## Gia đình có thu nhập trung bình

Không thiếu thu nhập.

Nhưng cuối tháng luôn hết tiền.

---

## Người sống một mình

Muốn:

- ăn lành mạnh
- tiết kiệm
- giảm lãng phí

---

## Người thích Meal Prep

Chuẩn bị đồ ăn cho nhiều ngày.

---

## Người muốn quản lý tài chính nhưng ghét ghi chép

Đây là nhóm người dùng rất lớn.

Họ không thích:

- nhập từng hóa đơn
- ghi từng ly cà phê
- phân loại từng khoản chi

---

# 6. Giá trị cốt lõi

## Chủ động

Không phải nghĩ:

"Hôm nay ăn gì?"

---

## Tiết kiệm

Không phải cắt giảm.

Mà là:

Chi tiêu có kế hoạch.

---

## Sức khỏe

Ăn uống cân bằng.

---

## Gia đình

Nấu ăn cùng nhau.

---

## Giáo dục

Giúp trẻ em hiểu:

- tiền
- thức ăn
- giá trị lao động
- lập kế hoạch

---

# 7. Khái niệm trung tâm

## Thu nhập

↓

## Chi phí cố định

Ví dụ

- thuê nhà
- điện
- internet
- bảo hiểm
- khoản vay

↓

## Ngân sách thực phẩm

↓

## Thực đơn

↓

## Danh sách mua sắm

↓

## Mua sắm thông minh

↓

## Chuẩn bị đồ ăn

↓

## Theo dõi tiêu thụ

↓

## Tiết kiệm

---

# 8. Công thức quản lý tài chính

```
Thu nhập

-

Chi phí cố định

=

Ngân sách ăn uống
```

Ứng dụng KHÔNG chia:

- 50%
- 30%
- 20%

Ứng dụng chỉ quan tâm:

```
Gia đình còn bao nhiêu tiền để ăn trong tháng?
```

---

# 9. Nguyên lý thiết kế

## Đơn giản

Mọi người đều dùng được.

Không cần kiến thức tài chính.

---

## Thực tế

Xuất phát từ cuộc sống.

Không từ sách giáo khoa.

---

## Ít thao tác

Càng ít phải nhập dữ liệu càng tốt.

---

## AI hỗ trợ

AI là trợ lý.

Không phải người quyết định.

---

## Tự động

Hệ thống tự:

- gợi ý
- tính toán
- cảnh báo
- tối ưu

---

# 10. Mô hình hoạt động

```
Thu nhập

↓

Chi phí cố định

↓

Ngân sách ăn uống

↓

AI lập thực đơn

↓

Danh sách mua sắm

↓

Đi siêu thị

↓

Meal Prep

↓

Ăn theo kế hoạch

↓

Theo dõi chi phí

↓

Tiết kiệm
```

---

# 11. Các trụ cột chức năng

## 1. Income

Quản lý:

- thu nhập
- lương
- nguồn thu

---

## 2. Fixed Expenses

Quản lý:

- tiền nhà
- điện
- nước
- internet
- bảo hiểm
- khoản vay

---

## 3. Meal Planning

Lập thực đơn:

- theo tuần
- theo tháng

---

## 4. Recipes

Quản lý:

- món ăn
- công thức
- thời gian nấu
- chi phí

---

## 5. Pantry

Theo dõi:

- nguyên liệu
- tồn kho
- hạn sử dụng

---

## 6. Shopping

Sinh:

- danh sách mua
- số lượng
- chi phí

---

## 7. Meal Prep

Lập kế hoạch:

- nấu trước
- cấp đông
- bảo quản

---

## 8. Budget Tracking

Theo dõi:

- đã chi
- còn lại
- dự đoán cuối tháng

---

## 9. Family

Quản lý:

- thành viên
- khẩu vị
- dị ứng
- lịch ăn

---

## 10. AI Assistant

AI giúp:

- lên menu
- cân đối ngân sách
- tối ưu nguyên liệu
- giảm lãng phí
- gợi ý thay thế

---

# 12. Điểm khác biệt

| Ứng dụng tài chính truyền thống | Family Meal Budget Planner |
|-------------------------------|-----------------------------|
| Quản lý tiền | Quản lý bữa ăn |
| Ghi chép sau khi chi | Lập kế hoạch trước khi chi |
| Theo dõi lịch sử | Chủ động tương lai |
| Báo cáo | Hành động |
| Ngân sách | Thực đơn |
| Danh mục chi tiêu | Danh sách mua sắm |
| Biểu đồ | Kế hoạch bữa ăn |
| Kiểm soát chi tiêu | Kiểm soát cuộc sống |

---

# 13. Tầm nhìn

Xây dựng một nền tảng giúp các gia đình:

- sống có kế hoạch
- ăn uống lành mạnh
- giảm lãng phí thực phẩm
- tiết kiệm tự nhiên
- gắn kết gia đình qua những bữa ăn

Thay vì chỉ là một ứng dụng quản lý tài chính, sản phẩm hướng đến trở thành **trợ lý quản lý cuộc sống gia đình**, nơi tài chính, dinh dưỡng, mua sắm và sinh hoạt được kết nối trong một quy trình thống nhất.

---

# 14. Câu slogan đề xuất

### Phiên bản 1

> Muốn quản lý tiền, hãy bắt đầu từ bữa ăn.

---

### Phiên bản 2

> Lập kế hoạch bữa ăn hôm nay. An tâm tài chính ngày mai.

---

### Phiên bản 3

> Ăn có kế hoạch. Sống có dư.

---

### Phiên bản 4

> Bữa ăn thông minh, tài chính vững vàng.

---

# 15. Triết lý phát triển sản phẩm

Ứng dụng được xây dựng dựa trên một niềm tin đơn giản:

> **Một gia đình không trở nên khá giả chỉ vì ghi chép chi tiêu tốt hơn. Một gia đình trở nên ổn định khi biết chủ động lên kế hoạch cho những điều diễn ra mỗi ngày, và bữa ăn chính là thói quen lặp lại quan trọng nhất.**

Vì vậy, sản phẩm không đặt mục tiêu tạo ra thêm một ứng dụng quản lý tài chính, mà hướng đến việc xây dựng một hệ thống giúp các gia đình sống nhẹ nhàng hơn, bớt áp lực hơn và dành nhiều thời gian hơn cho nhau.

## Changelog

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-08 | Product Team | Initial draft |

---

## Related Documents

