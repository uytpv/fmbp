---
Document ID: DOC-201
Title: User Personas
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-200 PRD](./DOC-200%20PRD.md)
---

# User Personas

## 1. Objective
Phác họa chân dung người dùng mục tiêu (Personas) để định hướng thiết kế trải nghiệm người dùng (UX) và tối ưu hóa các tính năng sản phẩm phù hợp với nhu cầu thực tế của họ.

## 2. Scope
Phạm vi tài liệu này mô tả 3 chân dung người dùng chính: Mẹ bỉm sữa văn phòng bận rộn, Người chồng thích nấu ăn cuối tuần và Cặp đôi trẻ mới về chung nhà.

## 3. Business Context
Mỗi thành viên trong gia đình đóng vai trò khác nhau trong việc chuẩn bị bữa ăn: người giữ ví tiền, người lên thực đơn, và người trực tiếp đi mua sắm/nấu ăn. Hiểu rõ từng vai trò giúp tối ưu hóa tính năng chia sẻ nhóm gia đình.

## 4. Functional Requirements
- Ứng dụng phải hỗ trợ phân quyền và giao diện hiển thị phù hợp với từng Persona trong cùng một nhóm gia đình.

## 5. Non-Functional Requirements
- Giao diện đơn giản, dễ đọc, cỡ chữ phù hợp cho cả người lớn tuổi trong gia đình.

## 6. Business Rules
- Không áp dụng.

## 7. Data Model
- UserPersona: Lưu trữ các thuộc tính phân tích người dùng.

## 8. Flow
- Người dùng Onboarding -> Chọn khảo sát thói quen -> Hệ thống gợi ý giao diện và danh mục phù hợp theo Persona tương ứng.

## 9. API
- POST /api/v1/personas/onboard

## 10. Acceptance Criteria
- Onboarding hoàn tất trong vòng dưới 1 phút với các câu hỏi khảo sát ngắn gọn, trực quan.

## 11. Future Improvements
- AI phân tích thói quen sử dụng để tự động tinh chỉnh giao diện cá nhân hóa.

## 12. References
- Nghiên cứu hành vi tiêu dùng của các gia đình đô thị.

## 13. Related Documents
- [DOC-202 User Journey](./DOC-202%20User%20Journey.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
