---
Document ID: DOC-807
Title: AI Cost & Token Optimization Specifications
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-800 AI Overview](./DOC-800%20AI%20Overview.md)
---

# AI Cost & Token Optimization Specifications

## 1. Objective
Quy định các kỹ thuật tối ưu hóa mã thông báo (Tokens) và kiểm soát hóa đơn chi phí gọi các dịch vụ AI đám mây của dự án.

## 2. Scope
Áp dụng cho thiết kế cấu trúc prompt, cơ chế nén văn bản đầu vào, lưu bộ đệm và chính sách rate-limiting tài nguyên AI.

## 3. Business Context
Nếu không được kiểm soát tốt, chi phí API AI có thể ăn mòn toàn bộ biên lợi nhuận của gói dịch vụ Premium. Tối ưu hóa chi phí AI là điều kiện sống còn để sản phẩm đạt hiệu quả kinh tế cao và tự nuôi sống được doanh nghiệp.

## 4. Functional Requirements
- Áp dụng kỹ thuật nén Prompt (Prompt Compression): Loại bỏ các từ thừa, viết prompt cô đọng tối đa.
- Cơ chế Prompt Caching: Lưu lại các prompt hệ thống dài trên đám mây để không phải gửi lại trong mỗi lượt gọi (OpenAI và Gemini đều hỗ trợ giảm 50% giá token khi cache).

## 5. Non-Functional Requirements
- Đảm bảo chi phí API trung bình trên mỗi lượt sinh thực đơn tuần của một gia đình dưới 500 VNĐ.

## 6. Business Rules
- Giới hạn số lượng yêu cầu gọi AI tối đa của một tài khoản Premium là 5 lần/ngày cho tính năng sinh thực đơn để phòng ngừa việc lạm dụng hoặc spam hệ thống.

## 7. Data Model
- Không áp dụng.

## 8. Flow
- Người dùng bấm nút -> Gateway kiểm tra cache -> Nếu khớp -> Trả kết quả ngay (chi phí = 0) -> Nếu lệch -> Gửi yêu cầu tối giản lên API -> Ghi nhận token -> Trả kết quả.

## 9. API
- Không áp dụng.

## 10. Acceptance Criteria
- Hệ thống tự động kích hoạt giới hạn rate-limit và hiển thị thông báo "Bạn đã hết lượt sử dụng AI trong ngày" khi tài khoản chạm ngưỡng cấu hình.

## 11. Future Improvements
- Triển khai thuật toán định tuyến động (Semantic Routing) để tự động chọn mô hình rẻ nhất cho từng câu lệnh cụ thể của người dùng.

## 12. References
- OpenAI Prompt Engineering Guide - Cost Optimization section.

## 13. Related Documents
- [DOC-107 Financial Projection](../10-business/DOC-107%20Financial%20Projection.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
