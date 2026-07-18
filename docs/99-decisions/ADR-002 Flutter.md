---
Document ID: ADR-002
Title: Architectural Decision - Flutter for Multi-platform Clients
Version: 1.0
Status: Accepted
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-600 Flutter](../70-mobile/DOC-600%20Flutter.md)
---

# Architectural Decision - Flutter for Multi-platform Clients

## 1. Objective
Ghi nhận quyết định lựa chọn khung phát triển Flutter (Dart) làm công nghệ chính thức để xây dựng các phiên bản ứng dụng di động (iOS/Android) và Web Client của dự án.

## 2. Scope
Áp dụng cho mã nguồn Client di động, cấu hình build và thư viện dùng chung trong monorepo.

## 3. Business Context
Cần tối ưu hóa nguồn lực nhân sự phát triển. Thay vì duy trì 3 đội ngũ viết code riêng biệt (Swift cho iOS, Kotlin cho Android, React cho Web), việc sử dụng Flutter cho phép chia sẻ tới **85% mã nguồn** và đảm bảo giao diện hiển thị đồng nhất (Pixel-perfect) trên mọi màn hình.

## 4. Functional Requirements
- Biên dịch mã nguồn ra các gói cài đặt iOS (IPA), Android (AAB) và Web Assets.
- Khả năng tương thích tốt với các thư viện native.

## 5. Non-Functional Requirements
- Đạt hiệu năng render đồ họa cao nhờ engine Impeller thế hệ mới của Flutter.

## 6. Business Rules
- **Quyết định:** Chọn **Flutter SDK** thay vì React Native hay viết ứng dụng Native thuần túy.

## 7. Data Model
- Không áp dụng.

## 8. Flow
- Viết code UI bằng Dart -> Biên dịch thành mã máy native cho iOS/Android và JS/WASM cho Web -> Đảm bảo trải nghiệm nhanh chóng, đồng bộ.

## 9. API
- Flutter Framework APIs.

## 10. Acceptance Criteria
- Bản build chạy thử nghiệm trên các dòng máy iPhone và Samsung phổ thông đạt chỉ số ổn định và tốc độ phản hồi vuốt chạm tương đương ứng dụng native.

## 11. Future Improvements
- Nghiên cứu cập nhật tính năng chia sẻ code với Desktop App nếu dự án có nhu cầu mở rộng phần mềm quản lý cho các cửa hàng thực phẩm trên máy tính.

## 12. References
- Flutter vs React Native performance comparison reports.

## 13. Related Documents
- [DOC-750 Flutter Web](../75-web/DOC-750%20Flutter%20Web.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
