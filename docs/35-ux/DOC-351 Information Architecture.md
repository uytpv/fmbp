---
Document ID: DOC-351
Title: Information Architecture & Sitemap
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-350 User Flow](./DOC-350%20User%20Flow.md)
---

# Information Architecture & Sitemap

## 1. Objective
Quy hoạch cấu trúc phân cấp thông tin (Information Architecture - IA) và bản đồ ứng dụng (Sitemap) để đảm bảo người dùng dễ dàng tìm thấy tính năng cần thiết một cách nhanh nhất.

## 2. Scope
Đặc tả cấu trúc của 4 tab chính trên thanh điều hướng Mobile và hệ thống menu của bản Web/Admin.

## 3. Business Context
Sắp xếp thông tin khoa học giúp giảm tải cognitive load cho người dùng. Đặt những tính năng có tần suất sử dụng cao nhất (Lập thực đơn, Danh sách đi chợ) ở những vị trí dễ tiếp cận nhất.

## 4. Functional Requirements
- **Cấu trúc Tab chính (Mobile Navigation):**
  - **Tab 1: Dashboard:** Biểu đồ ngân sách tuần, Lịch ăn hôm nay, Nút thao tác nhanh (Quick Action: Thêm chi tiêu, Thêm nguyên liệu).
  - **Tab 2: Meal Plan (Thực đơn):** Lịch tuần, thư viện công thức nấu ăn, AI gợi ý món.
  - **Tab 3: Shopping List (Đi chợ):** Danh sách nguyên liệu cần mua phân nhóm quầy siêu thị, bộ lọc cửa hàng.
  - **Tab 4: Pantry (Tủ lạnh):** Danh sách tồn kho thực phẩm, cảnh báo hạn sử dụng.
  - **Menu phụ (Profile/Settings):** Quản lý thành viên gia đình, cài đặt ngân sách, quản lý đăng ký thuê bao.

## 5. Non-Functional Requirements
- Chiều sâu phân cấp thư mục màn hình không vượt quá 3 cấp (nghĩa là người dùng bấm tối đa 3 lần từ trang chủ phải tới được trang chi tiết sâu nhất).

## 6. Business Rules
- Không áp dụng.

## 7. Data Model
- Không áp dụng.

## 8. Flow
- Không áp dụng.

## 9. API
- Không áp dụng.

## 10. Acceptance Criteria
- Cấu trúc menu và điều hướng trên bản code phải khớp chính xác 100% với sơ đồ cấu trúc thông tin đã được phê duyệt.

## 11. Future Improvements
- Hỗ trợ cá nhân hóa thanh công cụ phím tắt dựa trên tần suất sử dụng thực tế của từng người dùng.

## 12. References
- Các nguyên lý tổ chức thông tin (Information Architecture for the Web and Mobile).

## 13. Related Documents
- [DOC-354 Navigation UX](./DOC-354%20Navigation%20UX.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
