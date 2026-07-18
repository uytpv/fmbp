---
Document ID: DOC-501
Title: Database Architecture (SQL & Graph)
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-402 Firestore](../40-platform/DOC-402%20Firestore.md)
---

# Database Architecture (SQL & Graph)

## 1. Objective
Đặc tả kiến trúc cơ sở dữ liệu quan hệ và phi quan hệ (Graph Database) phụ trợ để lưu trữ và phân tích các cấu trúc dữ liệu phức tạp của hệ thống.

## 2. Scope
Áp dụng cho cơ sở dữ liệu chính của AI Gateway và Graph Database phục vụ Bản đồ nguyên liệu ẩm thực (Food Genome).

## 3. Business Context
Trong khi Firestore lưu trữ dữ liệu người dùng thời gian thực rất tốt, việc phân tích mối quan hệ chằng chịt giữa các nguyên liệu, giá trị dinh dưỡng, công thức thay thế và dị ứng yêu cầu một mô hình cơ sở dữ liệu đồ thị (Graph Database) để truy vấn nhanh và hiệu quả nhất.

## 4. Functional Requirements
- Sử dụng **Neo4j** làm Graph Database lưu trữ các thực thể: Ingredient, Recipe, Nutrient, Allergen và các mối quan hệ (ví dụ: CONTAINS, SUBSTITUTES_FOR, TRIGGERS).
- Tích hợp cơ sở dữ liệu SQL phụ trợ để phục vụ đối soát chi tiết tài chính và tiếp thị liên kết.

## 5. Non-Functional Requirements
- Đảm bảo thời gian phản hồi của các truy vấn đồ thị tìm kiếm nguyên liệu thay thế dưới 200ms.

## 6. Business Rules
- Mọi quan hệ kết nối giữa các nguyên liệu trong Food Genome phải được kiểm chứng bởi đội ngũ chuyên gia dinh dưỡng trước khi đưa vào Production.

## 7. Data Model
- Sơ đồ Node và Edge của Graph Database.

## 8. Flow
- Người dùng khai báo hết chanh -> Ứng dụng gọi API -> Backend truy vấn Graph DB -> Tìm Node Chanh -> Quét các Edge SUBSTITUTES_FOR -> Trả về Node Giấm hoặc Tắc -> Đề xuất cho người dùng.

## 9. API
- Neo4j Bolt Protocol, Cypher Query Language APIs.

## 10. Acceptance Criteria
- Cấu hình thành công kết nối an toàn giữa AI Server và Neo4j Database sử dụng giao thức bảo mật cao.

## 11. Future Improvements
- Xây dựng hệ thống tự động học (Auto-learning database) cập nhật các quan hệ nguyên liệu dựa trên thói quen hoán đổi thực tế của hàng triệu người dùng.

## 12. References
- Graph Databases: New Opportunities for Connected Data.

## 13. Related Documents
- [DOC-250 Ingredient](../25-domain/DOC-250%20Ingredient.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
