---
Document ID: DOC-202
Title: User Journey Map
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-201 Personas](./DOC-201%20Personas.md)
---

# User Journey Map

## 1. Objective
Mô tả hành trình trải nghiệm của người dùng từ khi bắt đầu lập kế hoạch ăn uống đến khi đi chợ và hoàn thành mục tiêu ngân sách tuần.

## 2. Scope
Hành trình chi tiết gồm 5 giai đoạn: Nhận thức/Thiết lập mục tiêu -> Lập thực đơn -> Đi chợ mua sắm -> Nấu nướng & Quản lý tồn kho -> Báo cáo tài chính cuối tuần.

## 3. Business Context
Bằng cách tối ưu hóa từng điểm chạm (touchpoint) trong hành trình, chúng ta giảm thiểu tỷ lệ rời bỏ ứng dụng và tăng tính kết nối giữa các thành viên gia đình.

## 4. Functional Requirements
- Luồng tạo thực đơn nhanh trong 3 bước.
- Đồng bộ danh sách đi chợ tức thì giữa điện thoại của vợ và chồng.

## 5. Non-Functional Requirements
- Trải nghiệm mượt mà, phản hồi vuốt chạm (gesture) trực quan.

## 6. Business Rules
- Khi người dùng ở siêu thị, danh sách đi chợ phải được sắp xếp theo quầy kệ để tối ưu hóa lộ trình di chuyển.

## 7. Data Model
- UserJourneyStep: Ghi nhận các bước tương tác của người dùng.

## 8. Flow
- Người dùng thiết lập ngân sách -> Chọn thực đơn tuần -> Đi chợ (Check-off) -> Theo dõi lượng calo và chi phí thực tế.

## 9. API
- Không áp dụng.

## 10. Acceptance Criteria
- Người dùng có thể hoàn thành việc lập thực đơn tuần và sinh danh sách đi chợ trong vòng dưới 3 phút.

## 11. Future Improvements
- Đưa gợi ý công thức thông minh vào ngay thời điểm người dùng chuẩn bị đi chợ dựa trên dữ liệu giá rẻ nhất của ngày hôm đó.

## 12. References
- Các mô hình trải nghiệm khách hàng của YNAB và Mealime.

## 13. Related Documents
- [DOC-203 User Stories](./DOC-203%20User%20Stories.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
