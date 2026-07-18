---
Document ID: DOC-354
Title: Navigation UX Specification
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-351 Information Architecture](./DOC-351%20Information%20Architecture.md)
---

# Navigation UX Specification

## 1. Objective
Quy định chi tiết cơ chế điều hướng (Navigation) của ứng dụng để người dùng di chuyển giữa các màn hình và tính năng một cách tự nhiên, không bị lạc lối.

## 2. Scope
Đặc tả hành vi của Bottom Navigation Bar (Mobile), Sidebar (Web/Admin), nút Back hệ thống, và cơ chế chuyển đổi sâu (Deep Linking).

## 3. Business Context
Hệ thống điều hướng tốt giúp tăng khả năng khám phá tính năng của người dùng và giảm thiểu tỷ lệ thoát app do không tìm thấy lối ra hoặc lối quay lại màn hình trước.

## 4. Functional Requirements
- **Bottom Navigation Bar (Mobile):** Cố định dưới chân trang, luôn hiển thị 4 icon chính. Khi nhấn vào icon của tab hiện tại, trang sẽ tự động cuộn lên đầu (Scroll to top).
- **Navigation Drawer (Mobile - phụ):** Dùng để truy cập các tính năng ít dùng như Cài đặt tài khoản, Hướng dẫn sử dụng, Liên hệ hỗ trợ.
- **Nút Back hệ thống (Android/iOS Swipe):** Luôn đưa người dùng quay lại màn hình cấp cha gần nhất thay vì thoát app đột ngột.

## 5. Non-Functional Requirements
- Hỗ trợ lưu trữ trạng thái điều hướng (Navigation State Preservation) khi người dùng tạm thời chuyển sang ứng dụng khác (ví dụ: chuyển sang ngân hàng để chuyển khoản rồi quay lại app vẫn giữ nguyên màn hình thanh toán).

## 6. Business Rules
- Khi người dùng đang ở luồng đi chợ (Shopping List) mà chưa bấm "Hoàn thành đi chợ", nếu họ bấm nút Back để thoát ra, hệ thống bắt buộc phải hiển thị hộp thoại cảnh báo (Confirmation Dialog) để tránh mất mát dữ liệu đang đi chợ dở.

## 7. Data Model
- Không áp dụng.

## 8. Flow
- Không áp dụng.

## 9. API
- Không áp dụng.

## 10. Acceptance Criteria
- Trình điều hướng phải hỗ trợ Deep Linking chính xác. Ví dụ: Khi người dùng bấm vào link chia sẻ thực đơn từ tin nhắn, ứng dụng phải tự động mở đúng màn hình chi tiết thực đơn đó.

## 11. Future Improvements
- Áp dụng điều hướng dự đoán bằng AI: Tự động đưa ra gợi ý phím tắt chuyển màn hình dựa trên thời điểm trong ngày (sáng sớm gợi ý mở tủ lạnh, chiều tối gợi ý mở danh sách đi chợ).

## 12. References
- Mobile Navigation UX best practices.

## 13. Related Documents
- [DOC-350 User Flow](./DOC-350%20User%20Flow.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
