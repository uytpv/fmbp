---
Document ID: DOC-602
Title: Mobile State Management
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-600 Flutter](./DOC-600%20Flutter.md)
---

# Mobile State Management

## 1. Objective
Quy chuẩn hóa kiến trúc quản lý trạng thái dữ liệu (State Management) trên ứng dụng di động, đảm bảo dữ liệu hiển thị đồng bộ và tối ưu hiệu năng tái tạo widget (re-builds).

## 2. Scope
Áp dụng cho thư viện quản lý trạng thái, mô hình cập nhật dữ liệu và các luồng phản ứng trạng thái (Reactive state flow).

## 3. Business Context
Khi một thành viên gia đình cập nhật tủ lạnh Pantry, dữ liệu trên máy của thành viên khác phải tự động thay đổi mà không cần tải lại trang. Hệ thống quản lý trạng thái đóng vai trò là "mạch máu" phân phối dữ liệu trong App Client.

## 4. Functional Requirements
- Sử dụng **Flutter Riverpod** làm thư viện quản lý trạng thái chính thức của dự án.
- Thiết kế các Provider riêng biệt cho từng khối nghiệp vụ độc lập: budgetProvider, pantryProvider, shoppingListProvider.
- Cơ chế lắng nghe dòng dữ liệu thời gian thực (StreamProvider) từ Firestore.

## 5. Non-Functional Requirements
- Tránh hiện tượng rò rỉ bộ nhớ (Memory leaks) bằng cách hủy lắng nghe (dispose) các provider khi màn hình tương ứng bị đóng.

## 6. Business Rules
- Trạng thái UI (chữ đang gõ, tab đang chọn) phải được phân tách hoàn toàn khỏi Trạng thái Nghiệp vụ (dữ liệu ngân sách, danh sách nguyên liệu).

## 7. Data Model
- Các lớp Notifier và State tương ứng của Riverpod.

## 8. Flow
- Người dùng click mua trứng -> Gọi Action của shoppingListProvider -> Cập nhật State cục bộ -> Riverpod thông báo cho UI vẽ lại dòng gạch ngang -> Gọi API đồng bộ Server.

## 9. API
- Riverpod API (Ref, NotifierProvider, StreamProvider).

## 10. Acceptance Criteria
- Các component chỉ được re-build khi dữ liệu cụ thể mà chúng lắng nghe thực sự thay đổi (tối ưu hóa qua select của Riverpod).

## 11. Future Improvements
- Nghiên cứu cơ chế đồng bộ hóa trạng thái cục bộ tự động giữa các máy cùng mạng Wifi không qua Server (P2P State Sync).

## 12. References
- Riverpod official documentation (riverpod.dev).

## 13. Related Documents
- [DOC-603 Local Storage](./DOC-603%20Local%20Storage.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
