---
Document ID: DOC-504
Title: AI Gateway Service
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-257 AI](../25-domain/DOC-257%20AI.md)
---

# AI Gateway Service

## 1. Objective
Đặc tả kỹ thuật của dịch vụ trung gian AI Gateway, làm nhiệm vụ kết nối, quản lý, tối ưu chi phí và điều phối các yêu cầu gọi tới các mô hình ngôn ngữ lớn (LLMs) bên ngoài.

## 2. Scope
Áp dụng cho luồng gọi API đến OpenAI (GPT-4o), Google (Gemini 1.5 Pro/Flash) và cơ chế Prompt Caching, Rate-limiting, Failover.

## 3. Business Context
Việc gọi trực tiếp các API của LLM từ ứng dụng khách rất nguy hiểm (lộ Key bảo mật) và khó quản lý chi phí. AI Gateway đóng vai trò như một Proxy bảo mật, tối ưu hóa cấu trúc prompt gửi đi để giảm thiểu tối đa số lượng Token tiêu thụ và tự động chuyển đổi mô hình dự phòng khi một nhà cung cấp gặp sự cố.

## 4. Functional Requirements
- Định tuyến động (Dynamic Routing) yêu cầu đến mô hình phù hợp (ví dụ: bóc tách công thức đơn giản dùng Gemini Flash rẻ tiền; lên thực đơn tuần phức tạp dùng Gemini Pro).
- Tích hợp bộ nhớ đệm (Prompt Caching) cho các yêu cầu có dữ liệu đầu vào giống nhau (ví dụ: cùng danh sách nguyên liệu và ngân sách).
- Cơ chế giới hạn tần suất gọi (Rate-limiting) theo từng hộ gia đình để tránh bị lạm dụng/tấn công từ chối dịch vụ.

## 5. Non-Functional Requirements
- Đảm bảo tính sẵn sàng cao (High Availability) với cơ chế tự động chuyển đổi nhà cung cấp (API Failover) dưới 1 giây.

## 6. Business Rules
- Mọi dữ liệu JSON đầu ra từ AI Gateway trả về cho Client bắt buộc phải đi qua lớp kiểm tra cú pháp (JSON Validator) trước khi truyền đi để đảm bảo không bị lỗi giao diện.

## 7. Data Model
- AiRequestLog: Theo dõi số token sử dụng, chi phí, thời gian phản hồi và trạng thái của mỗi lượt gọi API qua Gateway.

## 8. Flow
- App gửi request -> AI Gateway kiểm tra Rate-limit -> Nạp System Prompt chuẩn -> Gọi API OpenAI/Gemini -> Nhận phản hồi -> Parse & Validate JSON -> Trả kết quả sạch cho App.

## 9. API
- POST /api/v1/ai-gateway/meal-plan
- POST /api/v1/ai-gateway/parse-recipe

## 10. Acceptance Criteria
- AI Gateway tự động chuyển đổi kết nối thành công từ OpenAI sang Gemini nếu API của OpenAI trả về mã lỗi 5xx hoặc quá thời gian chờ (timeout) 5 giây.

## 11. Future Improvements
- Triển khai mô hình chấm điểm chất lượng câu trả lời của AI tự động (Automatic LLM Evaluation) để liên tục tinh chỉnh Prompt.

## 12. References
- LangChain / LangFuse observability tools.

## 13. Related Documents
- [DOC-800 AI Overview](../80-ai/DOC-800%20AI%20Overview.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
