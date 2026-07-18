---
Document ID: DOC-982
Title: AI Usage & Safety Policy
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-800 AI Overview](../80-ai/DOC-800%20AI%20Overview.md)
---

# AI Usage & Safety Policy

## 1. Objective
Quy định các nguyên tắc sử dụng và chính sách an toàn đối với các nội dung do Trí tuệ nhân tạo (AI) tạo ra trong ứng dụng, bảo vệ sức khỏe và tài chính người dùng.

## 2. Scope
Áp dụng cho các tính năng AI gợi ý thực đơn tuần, AI bóc tách công thức nấu ăn, AI đề xuất thay thế nguyên liệu và Trợ lý tư vấn ngân sách.

## 3. Business Context
AI có thể gặp hiện tượng "ảo tưởng" (Hallucination) - ví dụ đề xuất sai thời gian nướng thịt hoặc tính toán nhầm lượng calo, nguy hiểm hơn là đề xuất nhầm nguyên liệu gây dị ứng. Chính sách an toàn AI là bắt buộc để ngăn ngừa các rủi ro sức khỏe thực tế cho gia đình người dùng.

## 4. Functional Requirements
- Luôn hiển thị dòng cảnh báo nhỏ dưới mỗi thực đơn/công thức do AI tạo ra: *"Nội dung được tạo tự động bởi AI. Vui lòng kiểm tra kỹ nguyên liệu và hướng dẫn trước khi nấu để đảm bảo an toàn vệ sinh thực phẩm và dị ứng gia đình"*.
- Bộ lọc từ chối đề xuất các chất độc hại hoặc nguyên liệu không ăn được do lỗi LLM đầu ra.

## 5. Non-Functional Requirements
- Bộ lọc an toàn (Safety Filter) kiểm tra nội dung đầu ra hoạt động với độ trễ dưới 200ms.

## 6. Business Rules
- **Tuyên bố từ chối trách nhiệm (Disclaimer):** Ứng dụng không chịu trách nhiệm pháp lý nếu người dùng làm theo các hướng dẫn nấu ăn của AI dẫn đến hỏng thiết bị bếp hoặc ngộ độc thực phẩm. Người dùng phải đóng vai trò là chốt chặn kiểm tra cuối cùng.

## 7. Data Model
- Không áp dụng.

## 8. Flow
- AI sinh thực đơn -> Đi qua lớp lọc an toàn -> Phát hiện nguyên liệu lạ không có trong database -> Từ chối kết quả -> Yêu cầu AI sinh lại -> Trả kết quả sạch kèm disclaimer cho người dùng.

## 9. API
- Không áp dụng.

## 10. Acceptance Criteria
- Cảnh báo an toàn AI hiển thị rõ ràng, dễ đọc trên tất cả các màn hình có sự tham gia của AI.

## 11. Future Improvements
- Tích hợp công cụ kiểm duyệt dinh dưỡng tự động dựa trên thuật toán y khoa chính xác thay vì chỉ dựa vào mô hình ngôn ngữ lớn LLM.

## 12. References
- Responsible AI practices (Google Cloud).

## 13. Related Documents
- [DOC-981 Terms of Service](./DOC-981%20Terms%20of%20Service.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
