---
Document ID: ADR-001
Title: Architectural Decision - Firebase as Primary Backend
Version: 1.0
Status: Accepted
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-401 Firebase](../40-platform/DOC-401%20Firebase.md)
---

# Architectural Decision - Firebase as Primary Backend

## 1. Objective
Tài liệu này ghi nhận quyết định kiến trúc lựa chọn dịch vụ đám mây Firebase làm hạ tầng Backend chính thức phục vụ giai đoạn MVP và v1 của sản phẩm.

## 2. Scope
Áp dụng cho toàn bộ các thiết kế luồng dữ liệu, phân quyền và hạ tầng máy chủ của hệ thống.

## 3. Business Context
Cần một giải pháp Backend ổn định, phát triển cực nhanh, hỗ trợ đồng bộ dữ liệu thời gian thực vượt trội với chi phí vận hành ban đầu thấp để nhanh chóng đưa sản phẩm ra thị trường kiểm chứng mô hình kinh doanh.

## 4. Functional Requirements
- Hệ thống hỗ trợ lưu trữ NoSQL (Firestore), Xác thực người dùng (Auth), Cloud Storage và Cloud Functions.

## 5. Non-Functional Requirements
- Đảm bảo khả năng phục hồi dữ liệu và uptime hệ thống cao dựa trên uy tín hạ tầng Google Cloud.

## 6. Business Rules
- **Quyết định:** Chọn **Firebase Serverless Suite** làm Backend chính thay vì tự xây dựng máy chủ Backend Node.js/Java truyền thống chạy trên VPS tự quản lý.

## 7. Data Model
- Không áp dụng.

## 8. Flow
- Lập trình viên tập trung viết logic App di động -> Kết nối trực tiếp Firestore qua SDK -> Không mất thời gian viết API CRUD cơ bản -> Đẩy nhanh tiến độ dự án gấp 2 lần.

## 9. API
- Firebase SDKs.

## 10. Acceptance Criteria
- Vượt qua vòng thẩm định kiến trúc của các đối tác đầu tư công nghệ về tính khả thi và an toàn bảo mật.

## 11. Future Improvements
- Lập kế hoạch di chuyển dữ liệu (Migration Plan) sang hệ thống Backend microservices riêng trên Google Cloud Run nếu số lượng người dùng đồng thời vượt quá giới hạn chi phí tối ưu của Firestore trong tương lai.

## 12. References
- Firebase vs Custom Backend comparative studies.

## 13. Related Documents
- [ADR-004 Firestore](./ADR-004%20Firestore.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
