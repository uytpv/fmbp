---
Document ID: DOC-505
Title: Recipe & Ingredient Search Engine
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-251 Recipe](../25-domain/DOC-251%20Recipe.md)
---

# Recipe & Ingredient Search Engine

## 1. Objective
Đặc tả hệ thống tìm kiếm công thức nấu ăn và nguyên liệu thông minh (Search Engine), đảm bảo người dùng tìm kiếm nhanh và chính xác nhất.

## 2. Scope
Áp dụng cho tính năng tìm kiếm văn bản (Text search), tìm kiếm theo bộ lọc (dị ứng, chế độ ăn, khoảng giá, thời gian nấu) và tìm kiếm mờ (Fuzzy Search).

## 3. Business Context
Thư viện công thức của ứng dụng sẽ nhanh chóng tăng lên hàng chục ngàn món. Nếu bộ lọc tìm kiếm hoạt động kém, người dùng sẽ mất nhiều thời gian tìm kiếm món ăn mình thích, gây ức chế trải nghiệm sử dụng.

## 4. Functional Requirements
- Hỗ trợ tìm kiếm mờ (Fuzzy Search - tự động sửa lỗi chính tả nhỏ của người dùng, ví dụ gõ "thit bo" vẫn ra "thịt bò").
- Lọc nâng cao theo nhiều tiêu chí kết hợp (Ví dụ: Tìm món "Ăn tối", nguyên liệu có "Cà chua", chế độ "Keto", chi phí dưới "50.000đ").

## 5. Non-Functional Requirements
- Đảm bảo thời gian phản hồi kết quả tìm kiếm dưới 100ms với cơ sở dữ liệu lớn.

## 6. Business Rules
- Thứ tự ưu tiên hiển thị kết quả tìm kiếm mặc định: Các món ăn sử dụng nhiều nguyên liệu đang có sẵn trong Pantry của gia đình nhất sẽ được đẩy lên trên cùng để khuyến khích tiết kiệm thực phẩm.

## 7. Data Model
- Chỉ mục tìm kiếm (Search Indexes) đồng bộ giữa Firestore và Search Engine.

## 8. Flow
- Người dùng nhập từ khóa tìm kiếm -> Hệ thống gọi Search Engine (như Algolia/Elasticsearch) -> Thực hiện truy vấn -> Trả về danh sách IDs món ăn tương thích -> Query dữ liệu chi tiết từ cache -> Hiển thị lên màn hình.

## 9. API
- GET /api/v1/search/recipes
- GET /api/v1/search/ingredients

## 10. Acceptance Criteria
- Kết quả tìm kiếm hiển thị chính xác các công thức nấu ăn tương thích với bộ lọc dị ứng đã cấu hình trong hồ sơ gia đình.

## 11. Future Improvements
- Tích hợp tìm kiếm ngữ nghĩa (Semantic Vector Search) sử dụng công nghệ Embeddings để người dùng có thể tìm kiếm bằng các câu tự nhiên (ví dụ: "món gì ấm nóng thích hợp cho ngày mưa").

## 12. References
- Algolia Search API guidelines, Elasticsearch documentation.

## 13. Related Documents
- [DOC-500 API](./DOC-500%20API.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
