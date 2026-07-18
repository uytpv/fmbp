---
Document ID: DOC-805
Title: Receipt OCR & NLP Extraction Spec
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-254 Shopping](../25-domain/DOC-254%20Shopping.md)
---

# Receipt OCR & NLP Extraction Spec

## 1. Objective
Đặc tả kỹ thuật của mô hình quét ảnh hóa đơn đi chợ (OCR) và bóc tách thông tin giá cả, nguyên liệu bằng xử lý ngôn ngữ tự nhiên (NLP).

## 2. Scope
Áp dụng cho camera capture trên mobile app, OCR engine (Google ML Kit/Tesseract), và NLP processing backend.

## 3. Business Context
Việc phải gõ tay từng món đồ và giá tiền sau khi đi chợ về là rào cản cực lớn khiến người dùng lười nhập liệu. Tính năng chụp ảnh hóa đơn và tự động nhận diện giá tiền, nguyên liệu để nhập kho Pantry trong 5 giây sẽ tạo ra trải nghiệm "Wow" rất mạnh.

## 4. Functional Requirements
- Trình camera chụp ảnh hóa đơn độ phân giải cao và tự động căn chỉnh góc (Auto-perspective correction).
- Nhận diện ký tự quang học (OCR) chuyển ảnh thành text thô.
- AI NLP bóc tách text thô thành danh mục cấu trúc: Tên sản phẩm, Số lượng, Đơn giá, Thành tiền.

## 5. Non-Functional Requirements
- Đảm bảo thời gian xử lý toàn bộ quy trình chụp -> quét -> bóc tách dưới 5 giây.

## 6. Business Rules
- Hệ thống bắt buộc phải hiển thị lại bảng dữ liệu đã bóc tách để người dùng kiểm tra và xác nhận thủ công trước khi chính thức lưu vào Pantry và trừ ngân sách.

## 7. Data Model
- OcrSession: Lưu trữ ảnh gốc, văn bản thô nhận diện và kết quả bóc tách cuối cùng.

## 8. Flow
- Người dùng chụp hóa đơn -> App gửi ảnh lên Server -> OCR quét chữ -> LLM NLP phân tích dòng chữ thô thành các món đồ chuẩn -> Trả về danh sách xác nhận -> Người dùng bấm OK -> Cập nhật Pantry.

## 9. API
- POST /api/v1/ai/ocr/parse-receipt

## 10. Acceptance Criteria
- Nhận diện chính xác tên nguyên liệu và giá tiền của các hóa đơn siêu thị lớn (như Coopmart, Winmart) đạt độ chính xác trên 85%.

## 11. Future Improvements
- Tự động học cách bóc tách các mẫu hóa đơn mới dựa trên sửa đổi thủ công của người dùng.

## 12. References
- Google Cloud Document AI specifications.

## 13. Related Documents
- [DOC-405 Security](../40-platform/DOC-405%20Security.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
