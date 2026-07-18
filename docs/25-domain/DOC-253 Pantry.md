---
Document ID: DOC-253
Title: Pantry (Inventory) Domain Specification
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-250 Ingredient](./DOC-250%20Ingredient.md)
---

# Pantry (Inventory) Domain Specification

## 1. Objective
Đặc tả cấu trúc dữ liệu và logic vận hành của kho lưu trữ thực phẩm gia đình (Pantry/Tủ lạnh), giúp người dùng quản lý lượng thực phẩm hiện có để tối ưu hóa kế hoạch đi chợ.

## 2. Scope
Bao gồm quản lý số lượng tồn kho của từng nguyên liệu, theo dõi hạn sử dụng (Expiration Date), cảnh báo hết hạn, và vị trí lưu trữ (Tủ đông, tủ mát, tủ khô).

## 3. Business Context
Lãng phí thực phẩm lớn nhất thường diễn ra do người dùng quên mất những gì đang có trong tủ lạnh, dẫn đến việc đi chợ mua trùng hoặc thực phẩm bị hết hạn phải vứt bỏ. Quản lý Pantry hiệu quả là mấu chốt để tiết kiệm tiền cho gia đình.

## 4. Functional Requirements
- Quản lý lượng tồn kho thực tế của các nguyên liệu trong gia đình.
- Gửi cảnh báo đẩy (Push Notification) khi nguyên liệu sắp hết hạn sử dụng.
- Tự động trừ kho khi người dùng đánh dấu đã hoàn thành việc nấu một món ăn trong kế hoạch.

## 5. Non-Functional Requirements
- Đảm bảo tính toán tồn kho chính xác ngay cả khi chạy offline không có mạng.

## 6. Business Rules
- Số lượng tồn kho không được phép âm.
- Khi đi chợ mua thêm đồ mới, nếu nguyên liệu đã có sẵn trong Pantry, hệ thống sẽ đề xuất tạo lô hàng mới (Batch) có hạn sử dụng riêng biệt thay vì ghi đè lên lô cũ.

## 7. Data Model
- PantryItem:
  - id: UUID (Primary Key)
  - family_id: UUID (Foreign Key)
  - ingredient_id: UUID (Foreign Key)
  - quantity: Decimal
  - unit: String
  - storage_location: String (FRIDGE, FREEZER, PANTRY, CABINET)
- PantryBatch:
  - pantry_item_id: UUID (Foreign Key)
  - purchase_date: Date
  - expiration_date: Date
  - quantity: Decimal

## 8. Flow
- Người dùng đi chợ về -> Bấm "Xác nhận đã mua" trên Shopping List -> Các mặt hàng tự động chuyển vào PantryItem và tạo mới PantryBatch tương ứng với ngày mua.

## 9. API
- GET /api/v1/pantry/items
- POST /api/v1/pantry/items/add-manual

## 10. Acceptance Criteria
- Hệ thống gửi cảnh báo hạn sử dụng chính xác trước số ngày được thiết lập trong phần cài đặt của gia đình (mặc định là trước 2 ngày).

## 11. Future Improvements
- Tích hợp cảm biến hoặc camera tủ lạnh thông minh để tự động cập nhật tồn kho mà không cần người dùng nhập liệu bằng tay.

## 12. References
- Các mô hình quản lý kho hàng FIFO (First In, First Out).

## 13. Related Documents
- [DOC-254 Shopping](./DOC-254%20Shopping.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
