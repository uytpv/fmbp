---
Document ID: DOC-257
Title: AI Models & Workflows Domain Specification
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-251 Recipe](./DOC-251%20Recipe.md)
- [DOC-252 Menu](./DOC-252%20Menu.md)
---

# AI Models & Workflows Domain Specification

## 1. Objective
Đặc tả kỹ thuật luồng xử lý trí tuệ nhân tạo (AI Workflows), các mô hình học máy áp dụng và cách thức AI hỗ trợ người dùng tối ưu hóa thực đơn và ngân sách gia đình.

## 2. Scope
Nằm trong phạm vi là định nghĩa kiến trúc tích hợp AI Gateway, cấu trúc Prompt mẫu cho các tác vụ gợi ý thực đơn, thuật toán bóc tách công thức nấu ăn từ trang web, và quy trình phân tích giá cả tối ưu hóa chi phí nguyên liệu.

## 3. Business Context
AI không phải là tính năng bổ sung cho vui mà là **động cơ cốt lõi giúp giảm tải cognitive load (áp lực suy nghĩ)** cho người dùng. Thay vì bắt người dùng phải tự suy nghĩ xem hôm nay ăn gì với số tiền ít ỏi còn lại, AI sẽ làm việc đó trong vòng 1 giây, tạo ra trải nghiệm sản phẩm kỳ diệu và thông minh vượt trội.

## 4. Functional Requirements
- Trình nhập công thức qua URL sử dụng LLM để bóc tách chính xác các nguyên liệu thô thành dữ liệu cấu trúc chuẩn.
- AI gợi ý thực đơn tuần cá nhân hóa dựa trên: Sở thích ăn uống, Số lượng thành viên, Hạn mức ngân sách còn lại, và Nguyên liệu sắp hết hạn có sẵn trong tủ lạnh (Pantry).
- AI đề xuất thay thế nguyên liệu đắt tiền bằng nguyên liệu tương đương rẻ tiền hơn (Budget-friendly swap).

## 5. Non-Functional Requirements
- Đảm bảo thời gian phản hồi đề xuất thực đơn dưới 3 giây.
- Thiết kế hệ thống Prompt Caching để giảm thiểu chi phí API Token và tăng tốc độ xử lý cho các yêu cầu lặp lại.

## 6. Business Rules
- AI tuyệt đối không được đề xuất các thực đơn chứa nguyên liệu gây dị ứng đã được người dùng khai báo trong hồ sơ sức khỏe gia đình.
- Mọi đề xuất món ăn của AI phải đi kèm với một **Chỉ số tự tin (Confidence Score)** và ước lượng chi phí dự kiến để người dùng đưa ra quyết định.

## 7. Data Model
- AiConversation: Lưu lịch sử tương tác đề xuất giữa người dùng và AI Assistant.
- RecipeParsedResult: Cấu trúc dữ liệu trung gian lưu kết quả bóc tách công thức thô trước khi lưu chính thức.
- AiPromptTemplate: Quản lý các mẫu System Prompt và User Prompt.

## 8. Flow
- Người dùng nhấn "Gợi ý thực đơn tuần này" -> Hệ thống gửi payload (ngân sách, dị ứng, tồn kho Pantry) đến AI Gateway -> AI Gateway điền dữ liệu vào AiPromptTemplate -> Gọi API LLM -> Phân tích kết quả trả về JSON -> Kiểm tra an toàn dị ứng -> Hiển thị thực đơn lên ứng dụng cho người dùng duyệt.

## 9. API
- POST /api/v1/ai/suggest-menu
- POST /api/v1/ai/parse-recipe

## 10. Acceptance Criteria
- AI Parser phải bóc tách đúng danh sách nguyên liệu và định lượng tương ứng từ các website công thức phổ biến đạt tỷ lệ chính xác trên 90%.
- Thực đơn AI gợi ý phải có tổng chi phí dự kiến nằm trong khoảng sai số cho phép (+/- 10%) của ngân sách tuần được cấu hình.

## 11. Future Improvements
- Phát triển mô hình AI huấn luyện riêng (Fine-tuned Local LLM) chuyên sâu về ẩm thực Việt Nam để giảm chi phí gọi API bên thứ ba và tăng tính bảo mật thông tin gia đình.

## 12. References
- OpenAI API Guidelines, Google Gemini API documentation.

## 13. Related Documents
- [DOC-800 AI Overview](../80-ai/DOC-800%20AI%20Overview.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Khởi tạo tài liệu đặc tả AI Models & Workflows |
