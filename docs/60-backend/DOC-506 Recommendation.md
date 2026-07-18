---
Document ID: DOC-506
Title: Meal Recommendation Engine
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-252 Menu](../25-domain/DOC-252%20Menu.md)
---

# Meal Recommendation Engine

## 1. Objective
Đặc tả thuật toán và hệ thống gợi ý thực đơn thông minh (Recommendation Engine) nhằm tối ưu hóa dinh dưỡng và tiết kiệm ngân sách tài chính tối đa cho gia đình.

## 2. Scope
Áp dụng cho tính năng gợi ý món ăn đơn lẻ hàng ngày và đề xuất thực đơn tuần 7 ngày trọn gói.

## 3. Business Context
Trọng tâm giá trị của ứng dụng nằm ở khả năng đưa ra giải pháp thực tế cho câu hỏi "Hôm nay ăn gì vừa ngon, vừa bổ, lại rẻ?". Hệ thống gợi ý thông minh là chìa khóa để giữ chân người dùng và tạo sự khác biệt cạnh tranh vượt trội.

## 4. Functional Requirements
- Gợi ý thực đơn cá nhân hóa dựa trên dữ liệu lịch sử thói quen ăn uống của gia đình.
- Thuật toán tối ưu hóa chi phí: Ưu tiên đề xuất các công thức sử dụng chung nguyên liệu mua sỉ (ví dụ mua 1 con gà sẽ đề xuất làm 3 món gà khác nhau trong tuần để dùng hết) nhằm giảm thiểu chi phí đi chợ.

## 5. Non-Functional Requirements
- Đảm bảo thời gian chạy thuật toán gợi ý thực đơn tuần dưới 3 giây.

## 6. Business Rules
- Bắt buộc phải loại bỏ các món ăn chứa thành phần gây dị ứng của gia đình ra khỏi danh sách đề xuất.
- Đảm bảo sự đa dạng món ăn (không đề xuất trùng một món chính quá 2 lần trong cùng một tuần).

## 7. Data Model
- UserPreferenceProfile: Lưu trữ điểm sở thích của gia đình đối với các nhóm hương vị và nguyên liệu.

## 8. Flow
- Người dùng bấm "AI gợi ý thực đơn tuần" -> Hệ thống tổng hợp các tham số đầu vào -> Gọi Recommendation Engine -> Thuật toán tính điểm (Score) cho hàng ngàn món ăn -> Lựa chọn tổ hợp món ăn có tổng điểm cao nhất và tổng chi phí tối ưu nhất -> Trả kết quả về giao diện.

## 9. API
- POST /api/v1/recommendations/weekly-plan

## 10. Acceptance Criteria
- Đề xuất thực đơn phải thỏa mãn đồng thời cả 3 ràng buộc: Không có chất gây dị ứng, nằm trong giới hạn ngân sách tuần, và tổng lượng dinh dưỡng (Calo/Macros) cân bằng ở mức hợp lý.

## 11. Future Improvements
- Tích hợp dữ liệu phản hồi sinh học (Biofeedback) từ thiết bị đeo thông minh (Smartwatches) để đề xuất món ăn phục vụ hồi phục sức khỏe sau tập luyện của từng thành viên.

## 12. References
- Collaborative Filtering and Content-based recommendation algorithms.

## 13. Related Documents
- [DOC-802 Recipe Generator](../80-ai/DOC-802%20Recipe%20Generator.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
