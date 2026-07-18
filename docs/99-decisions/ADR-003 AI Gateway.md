---
Document ID: ADR-003
Title: Architectural Decision - AI Gateway Architecture
Version: 1.0
Status: Accepted
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-504 AI Gateway](../60-backend/DOC-504%20AI%20Gateway.md)
---

# Architectural Decision - AI Gateway Architecture

## 1. Objective
Ghi nhận quyết định kiến trúc đưa vào sử dụng dịch vụ trung gian AI Gateway thay vì cho Client di động gọi trực tiếp các API của OpenAI/Google.

## 2. Scope
Áp dụng cho toàn bộ luồng truyền thông điệp AI, thiết lập bảo mật và quản lý API keys của hệ thống.

## 3. Business Context
Cần bảo vệ an toàn tuyệt đối API Keys, kiểm soát chi phí token, chủ động định tuyến mô hình và thực hiện lọc dữ liệu dị ứng/nhạy cảm tập trung ở một nơi an toàn.

## 4. Functional Requirements
- proxy an toàn bảo vệ API keys.
- Hỗ trợ cache prompt và rate-limit theo tài khoản người dùng.

## 5. Non-Functional Requirements
- Thời gian trễ xử lý của AI Gateway proxy dưới 50ms (không bao gồm thời gian chạy của mô hình LLM).

## 6. Business Rules
- **Quyết định:** Bắt buộc xây dựng **AI Gateway Service** chạy trên hạ tầng an toàn của Backend, cấm hoàn toàn hành vi nhúng trực tiếp API Key của OpenAI/Gemini vào mã nguồn Flutter Client.

## 7. Data Model
- Không áp dụng.

## 8. Flow
- Client -> Gọi AI Gateway endpoint -> Gateway điền Prompt Template và xác thực -> Gọi LLM -> Nhận kết quả -> Trả về Client.

## 9. API
- AI Gateway internal REST APIs.

## 10. Acceptance Criteria
- Ứng dụng Client di động không chứa bất kỳ chuỗi ký tự API Key nhạy cảm nào trong file cài đặt (APK/IPA) sau khi biên dịch giải nén.

## 11. Future Improvements
- Xây dựng hệ thống tự động đổi khóa (Key rotation) và phân phối tải giữa nhiều tài khoản API khác nhau để tránh bị chạm hạn mức của nhà cung cấp.

## 12. References
- OWASP Top 10 API Security Risks.

## 13. Related Documents
- [DOC-800 AI Overview](../80-ai/DOC-800%20AI%20Overview.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
