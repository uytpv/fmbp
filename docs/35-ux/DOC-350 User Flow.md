---
Document ID: DOC-350
Title: Core User Flows
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-202 User Journey](../20-product/DOC-202%20User%20Journey.md)
---

# Core User Flows

## 1. Objective
Mô tả chi tiết các bước thực hiện thao tác (User Flows) của các luồng tác vụ cốt lõi trên ứng dụng để làm căn cứ thiết kế sơ đồ màn hình và phát triển tính năng.

## 2. Scope
Bao gồm 3 luồng chính: Luồng lập thực đơn và sinh danh sách đi chợ, Luồng đi chợ check-off và cập nhật kho Pantry, Luồng thiết lập và ghi nhận giao dịch trừ ngân sách.

## 3. Business Context
Việc tối ưu hóa số bước thao tác (click/tap) trong luồng đi chợ giúp người dùng rảnh tay chọn đồ và không cảm thấy việc sử dụng app là một gánh nặng khi đang xách đồ nặng trong siêu thị.

## 4. Functional Requirements
- **Luồng 1 (Lên thực đơn tuần):**
  - Dashboard -> Chọn Lên thực đơn -> AI gợi ý / Chọn thủ công -> Xác nhận thực đơn -> Hệ thống đối chiếu Pantry -> Hiển thị danh sách nguyên liệu thiếu cần mua.
- **Luồng 2 (Đi chợ & Nhập kho):**
  - Mở Shopping List -> Check từng món đã lấy vào giỏ -> Nhấn "Hoàn thành đi chợ" -> Hiển thị popup xác nhận giá tiền thực tế -> Đồng ý -> Tự động chuyển các món sang Pantry và ghi nhận giao dịch trừ ngân sách.

## 5. Non-Functional Requirements
- Đảm bảo các luồng quan trọng có thể hoàn tất mà không bị đứt gãy ngay cả khi kết nối mạng chập chờn.

## 6. Business Rules
- Bắt buộc phải hiển thị cảnh báo nếu tổng giá trị dự tính của giỏ hàng đi chợ vượt quá số tiền còn lại trong ngân sách tuần của gia đình.

## 7. Data Model
- Không áp dụng.

## 8. Flow
- Xem chi tiết sơ đồ luồng mô tả ở phần Functional Requirements.

## 9. API
- Không áp dụng.

## 10. Acceptance Criteria
- Người dùng có thể hoàn thành luồng "Đi chợ và nhập kho" với tối đa 3 lần bấm chạm.

## 11. Future Improvements
- Hỗ trợ ra lệnh bằng giọng nói (Voice commands) để thực hiện nhanh các bước trong luồng khi người dùng đang trực tiếp nấu nướng.

## 12. References
- Các mẫu thiết kế luồng người dùng tối giản (Task-oriented UX design).

## 13. Related Documents
- [DOC-351 Information Architecture](./DOC-351%20Information%20Architecture.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
