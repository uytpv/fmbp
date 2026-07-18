---
Document ID: DOC-200
Title: Product Requirement Document (PRD)
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-000 Product Vision](../00-vision/DOC-000%20Product%20Vision.md)
- [DOC-204 Feature List](./DOC-204%20Feature%20List.md)
---

# Product Requirement Document (PRD)

## 1. Objective
Xác định các yêu cầu sản phẩm chi tiết cho Family Meal Budget Planner phiên bản MVP, thiết lập nền tảng để phát triển giao diện (UX/UI) và xây dựng hệ thống kỹ thuật.

## 2. Scope
Tài liệu này tập trung vào các tính năng cốt lõi phục vụ chu trình: Lập kế hoạch chi tiêu -> Tạo thực đơn -> Quản lý nguyên liệu -> Đi chợ tự động.

## 3. Business Context
Dự án nhằm giải quyết nỗi đau của các gia đình trung lưu đô thị: Chi phí ăn uống chiếm tỷ trọng lớn và dễ bị lãng phí do không lên thực đơn trước hoặc mua thừa nguyên liệu rồi vứt bỏ. Việc kết nối trực tiếp Kế hoạch ăn uống với Ngân sách tài chính giúp tối ưu hóa chi tiêu một cách tự nhiên.

## 4. Functional Requirements
- Đăng ký/Đăng nhập tài khoản gia đình (Shared Family Account).
- Thiết lập và quản lý ngân sách ăn uống theo tuần/tháng.
- Lập thực đơn tuần bằng cách chọn công thức từ thư viện hoặc AI gợi ý.
- Tự động đồng bộ nguyên liệu từ thực đơn vào danh sách đi chợ, có khấu trừ lượng nguyên liệu đang có sẵn trong tủ lạnh (Pantry).

## 5. Non-Functional Requirements
- **Thời gian phản hồi (Latency):** < 1.5s đối với các truy vấn AI gợi ý thực đơn.
- **Tính năng Offline:** Danh sách đi chợ phải hoạt động offline ổn định khi người dùng ở trong siêu thị không có sóng di động.

## 6. Business Rules
- Một nhóm gia đình chỉ có tối đa 1 Ngân sách hoạt động tại một thời điểm.
- Khi một nguyên liệu được check đã mua trong Shopping List, nó phải tự động được cộng vào số lượng tồn kho trong Pantry.

## 7. Data Model
Xem chi tiết tại các tài liệu Domain tương ứng (từ DOC-250 đến DOC-257).

## 8. Flow
1. Admin thiết lập ngân sách tuần.
2. Gia đình chọn món ăn cho từng ngày.
3. Ứng dụng tính toán chênh lệch nguyên liệu cần mua.
4. Người dùng đi chợ, check các món đã mua -> Pantry cập nhật -> Dòng tiền ngân sách bị trừ tương ứng.

## 9. API
- POST /api/v1/prd/meal-plan/generate
- GET /api/v1/prd/budget/summary

## 10. Acceptance Criteria
- Gia đình có thể tạo nhóm, mời thành viên qua mã QR/link liên kết và cùng chia sẻ một kế hoạch ăn uống thời gian thực.

## 11. Future Improvements
- Quét hóa đơn siêu thị tự động nhận diện giá tiền và nguyên liệu.

## 12. References
- Nghiên cứu đối thủ: [YNAB](../15-research/YNAB.md), [Samsung Food](../15-research/Samsung%20Food.md).

## 13. Related Documents
- [DOC-205 Product Scope](./DOC-205%20Product%20Scope.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
