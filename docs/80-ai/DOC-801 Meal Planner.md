---
Document ID: DOC-801
Title: AI Meal Planner Agent Specs
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-252 Menu](../25-domain/DOC-252%20Menu.md)
---

# AI Meal Planner Agent Specs

## 1. Objective
Đặc tả kỹ thuật của AI Agent chịu trách nhiệm lập kế hoạch thực đơn tuần tự động tối ưu dinh dưỡng và ngân sách gia đình.

## 2. Scope
Áp dụng cho cấu trúc Prompt, các tham số đầu vào (tồn kho, ngân sách, dị ứng) và định dạng JSON đầu ra.

## 3. Business Context
Giúp giải phóng sức lao động trí óc của người nội trợ hàng tuần, đưa ra thực đơn ăn uống ngon miệng trong tầm ngân sách cho phép.

## 4. Functional Requirements
- Prompt cấu trúc System Message định hình chuyên gia dinh dưỡng và tài chính gia đình.
- Đầu ra JSON chứa danh sách ID công thức nấu ăn khớp với lịch 7 ngày trong tuần.

## 5. Non-Functional Requirements
- Thời gian chạy sinh thực đơn tuần của AI Agent dưới 3 giây.

## 6. Business Rules
- AI không được đề xuất các món ăn vi phạm danh mục dị ứng của gia đình.

## 7. Data Model
- MealPlannerPromptPayload: Cấu trúc dữ liệu đầu vào gửi lên AI.

## 8. Flow
- Thu thập tham số -> Điền vào Prompt mẫu -> Gọi LLM -> Phân tích JSON -> Trả về thực đơn đề xuất.

## 9. API
- POST /api/v1/ai/meal-planner/generate

## 10. Acceptance Criteria
- Tổng giá trị nguyên liệu dự toán cho thực đơn tuần do AI tạo ra không vượt quá hạn mức ngân sách tuần được cấu hình.

## 11. Future Improvements
- Hỗ trợ học thói quen đánh giá món ăn của gia đình để tự động tinh chỉnh khẩu vị gợi ý sau mỗi tuần.

## 12. References
- Prompt Engineering Techniques for Structured JSON Output.

## 13. Related Documents
- [DOC-802 Recipe Generator](./DOC-802%20Recipe%20Generator.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
