---
Document ID: DOC-806
Title: Local LLM Infrastructure Specification
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-504 AI Gateway](../60-backend/DOC-504%20AI%20Gateway.md)
---

# Local LLM Infrastructure Specification

## 1. Objective
Đặc tả giải pháp hạ tầng tự vận hành mô hình ngôn ngữ lớn cục bộ (Local LLM) để tối ưu chi phí và tăng tính chủ động công nghệ.

## 2. Scope
Áp dụng cho cấu hình máy chủ AI chạy local, các mô hình mã nguồn mở (như Llama-3, Gemma, Mistral) và công cụ chạy mô hình (Ollama/vLLM).

## 3. Business Context
Chi phí gọi API thương mại của OpenAI/Google sẽ tăng phi mã khi số lượng người dùng đạt hàng trăm ngàn người. Tự vận hành Local LLM cho các tác vụ đơn giản (như phân loại nguyên liệu, gợi ý công thức cơ bản) giúp giảm 80% chi phí hóa đơn đám mây hàng tháng.

## 4. Functional Requirements
- Triển khai máy chủ AI chạy local sử dụng công cụ **Ollama** hoặc **vLLM** trên GPU.
- Định cấu hình mô hình **Llama 3 (8B)** hoặc **Gemma 2 (9B)** phục vụ các tác vụ phân tích ngôn ngữ tự nhiên cơ bản.

## 5. Non-Functional Requirements
- Đảm bảo thời gian phản hồi (Time-to-first-token) của Local LLM dưới 1.5 giây.

## 6. Business Rules
- Local LLM chỉ được sử dụng cho các tác vụ nội bộ (background tasks) hoặc làm mô hình dự phòng khi các cổng API thương mại bị quá tải hoặc mất kết nối.

## 7. Data Model
- Cấu hình server chạy vLLM.

## 8. Flow
- Yêu cầu bóc tách nguyên liệu gửi đến -> AI Gateway nhận thấy tác vụ đơn giản -> Định tuyến sang Local LLM Server -> Local LLM xử lý và trả kết quả -> Tiết kiệm chi phí gọi API ngoài.

## 9. API
- Ollama REST API endpoints.

## 10. Acceptance Criteria
- Mô hình Local LLM phải vượt qua bài kiểm tra chất lượng định dạng đầu ra (JSON schema compliance) đạt tỷ lệ 98%.

## 11. Future Improvements
- Tự huấn luyện (Fine-tuning) mô hình Llama nhỏ (3B) chuyên biệt về ẩm thực Việt Nam để có thể chạy trực tiếp trên thiết bị di động của người dùng mà không cần kết nối mạng (On-device AI).

## 12. References
- vLLM high-throughput distributed LLM serving engine.

## 13. Related Documents
- [DOC-800 AI Overview](./DOC-800%20AI%20Overview.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
