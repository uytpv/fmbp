---
Document ID: DOC-402
Title: Cloud Firestore Database Schema
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-401 Firebase](./DOC-401%20Firebase.md)
---

# Cloud Firestore Database Schema

## 1. Objective
Đặc tả sơ đồ tổ chức dữ liệu (Collections và Documents) trên cơ sở dữ liệu Cloud Firestore NoSQL của dự án.

## 2. Scope
Áp dụng cho cấu trúc các bộ sưu tập chính: users, families, recipes, pantry_items, shopping_lists, budgets.

## 3. Business Context
Firestore là cơ sở dữ liệu phi quan hệ, đòi hỏi việc thiết kế cấu trúc dữ liệu phải tối ưu hóa số lượt đọc/ghi (Read/Write) để tiết kiệm chi phí vận hành khi số lượng người dùng tăng cao.

## 4. Functional Requirements
- Cấu trúc thư mục con (Sub-collections) để phân nhóm dữ liệu gia đình (ví dụ: families/{familyId}/pantry_items).
- Chỉ mục kết hợp (Composite Indexes) cho các câu truy vấn phức tạp (ví dụ: lọc thực phẩm sắp hết hạn).

## 5. Non-Functional Requirements
- Thiết kế dữ liệu phẳng (Denormalization) hợp lý để tăng tốc độ truy vấn hiển thị màn hình chính.

## 6. Business Rules
- Mọi tài liệu con trong nhánh families đều phải có thuộc tính familyId để phục vụ bảo mật phân quyền.

## 7. Data Model
- Sơ đồ chi tiết cấu trúc Firestore Collections.

## 8. Flow
- Người dùng cập nhật số lượng nguyên liệu -> Ứng dụng ghi đè lên tài liệu families/{familyId}/pantry_items/{itemId} -> Firestore kích hoạt sự kiện đồng bộ.

## 9. API
- Cloud Firestore SDK APIs.

## 10. Acceptance Criteria
- Cấu hình thành công các composite indexes phục vụ tìm kiếm công thức theo danh mục và thời gian nấu mà không phát sinh lỗi truy vấn từ Firestore.

## 11. Future Improvements
- Định kỳ dọn dẹp các tài liệu cũ không hoạt động (Tombstones) để giảm dung lượng lưu trữ tính phí.

## 12. References
- Firestore Best Practices (Google Cloud).

## 13. Related Documents
- [DOC-405 Security](./DOC-405%20Security.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
