---
Document ID: DOC-800
Title: AI Strategy & Architecture Overview
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-504 AI Gateway](../60-backend/DOC-504%20AI%20Gateway.md)
---

# AI Strategy & Architecture Overview

## 1. Objective
Định hình chiến lược ứng dụng Trí tuệ nhân tạo (AI) trong sản phẩm, thiết lập các nguyên tắc thiết kế prompt và kiểm soát chi phí API.

## 2. Scope
Áp dụng cho toàn bộ các tác vụ xử lý AI trong hệ thống: Lên thực đơn, Bóc tách công thức, Trợ lý ngân sách và Quét hóa đơn (OCR).

## 3. Business Context
AI là yếu tố cốt lõi giúp cá nhân hóa trải nghiệm và tối ưu hóa chi tiêu thực tế cho gia đình một cách thông minh mà các ứng dụng tài chính truyền thống không làm được.

## 4. Functional Requirements
- Hệ thống tích hợp đa mô hình: Sử dụng mô hình thương mại (GPT, Gemini) và mô hình nội bộ (Local LLM) tùy tác vụ.
- Thiết lập hệ thống Prompt Library tập trung.

## 5. Non-Functional Requirements
- Kiểm soát chi phí API Token ở mức tối thiểu bằng các kỹ thuật Prompt Caching và định tuyến mô hình thông minh.

## 6. Business Rules
- AI tuyệt đối không được tự ý quyết định giao dịch tài chính của người dùng mà chỉ đóng vai trò trợ lý đề xuất (Co-pilot).

## 7. Data Model
- Xem chi tiết tại DOC-257.

## 8. Flow
- Xem chi tiết tại DOC-257.

## 9. API
- Tích hợp AI Gateway APIs.

## 10. Acceptance Criteria
- 100% các câu trả lời của AI phải đi qua lớp Filter từ ngữ nhạy cảm và kiểm tra dị ứng trước khi hiển thị cho người dùng.

## 11. Future Improvements
- Huấn luyện mô hình chuyên biệt về ẩm thực Việt Nam (Fine-tuned Local LLM).

## 12. References
- Google AI and OpenAI development best practices.

## 13. Related Documents
- [DOC-807 Cost Optimization](./DOC-807%20Cost%20Optimization.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
