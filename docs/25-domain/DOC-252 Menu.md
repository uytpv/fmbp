---
Document ID: DOC-252
Title: Menu (Meal Plan) Domain Specification
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-251 Recipe](./DOC-251%20Recipe.md)
- [DOC-255 Budget](./DOC-255%20Budget.md)
---

# Menu (Meal Plan) Domain Specification

## 1. Objective
Đặc tả cấu trúc dữ liệu kế hoạch ăn uống (Menu/Meal Plan) của gia đình theo tuần hoặc tháng, làm cơ sở để tính toán ngân sách và lập danh sách đi chợ.

## 2. Scope
Tài liệu quy định cấu trúc thực thể Meal Plan, các bữa ăn trong ngày (Sáng, Trưa, Tối), cơ cấu phân quyền chỉnh sửa thực đơn trong gia đình và cách thức AI tham gia đề xuất thực đơn.

## 3. Business Context
Kế hoạch ăn uống là SSOT cho các hoạt động tiêu dùng tiếp theo của gia đình. Một thực đơn được lên kế hoạch tốt sẽ giúp phân phối dinh dưỡng hợp lý và đảm bảo chi phí thực phẩm không vượt quá ngân sách tài chính đã đề ra.

## 4. Functional Requirements
- Lên lịch ăn uống chi tiết cho từng ngày trong tuần.
- Tự động tính toán tổng calo và tổng chi phí dự kiến cho toàn bộ thực đơn tuần.
- Gửi thông báo nhắc nhở chuẩn bị nguyên liệu trước ngày nấu ăn.

## 5. Non-Functional Requirements
- Trạng thái thay đổi thực đơn phải được đồng bộ hóa tức thì tới toàn bộ thiết bị của các thành viên gia đình (độ trễ < 2s).

## 6. Business Rules
- Thực đơn tuần chỉ được kích hoạt sau khi tổng chi phí dự kiến được kiểm tra là không vượt quá hạn mức ngân sách tuần (Weekly Budget limit), trừ khi có sự đồng ý ghi đè của tài khoản Admin.

## 7. Data Model
- MealPlan:
  - id: UUID (Primary Key)
  - amily_id: UUID (Foreign Key)
  - start_date: Date
  - end_date: Date
  - 	otal_estimated_cost: Decimal
  - status: String (DRAFT, ACTIVE, COMPLETED)
- MealPlanItem:
  - meal_plan_id: UUID (Foreign Key)
  - date: Date
  - meal_type: String (BREAKFAST, LUNCH, DINNER, SNACK)
  - ecipe_id: UUID (Foreign Key)
  - servings: Integer

## 8. Flow
- Người dùng chọn tuần cần lên thực đơn -> Kéo thả các món ăn vào từng bữa -> Hệ thống cập nhật 	otal_estimated_cost thời gian thực -> Nhấn "Kích hoạt" -> Shopping List được sinh ra tự động.

## 9. API
- POST /api/v1/meal-plans
- GET /api/v1/meal-plans/current

## 10. Acceptance Criteria
- Khi người dùng xóa một món ăn khỏi thực đơn, tổng chi phí dự tính của thực đơn tuần đó phải giảm đi tương ứng ngay lập tức.

## 11. Future Improvements
- AI đề xuất thực đơn thông minh tự động thay đổi các bữa ăn dựa trên thời tiết, mùa vụ thực phẩm để tối ưu hóa chi phí.

## 12. References
- Các ứng dụng lên thực đơn hàng đầu: Mealime, Samsung Food.

## 13. Related Documents
- [DOC-254 Shopping](./DOC-254%20Shopping.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
