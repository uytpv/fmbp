---
Document ID: DOC-550
Title: Environment Configuration
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-400 Architecture](../40-platform/DOC-400%20Architecture.md)
---

# Environment Configuration

## 1. Objective
Quy định và cấu trúc các môi trường chạy ứng dụng (Development, Staging, Production) cùng các biến cấu hình tương ứng.

## 2. Scope
Áp dụng cho cấu trúc tệp .env của các ứng dụng Client, biến cấu hình Cloud Functions, và thiết lập các biến môi trường trên GitHub Actions CI/CD.

## 3. Business Context
Việc tách biệt hoàn toàn dữ liệu và cấu hình giữa môi trường phát triển (Dev) và môi trường vận hành thực tế (Prod) giúp lập trình viên thoải mái thử nghiệm tính năng mới mà không sợ ảnh hưởng đến dữ liệu thực tế hay gây mất mát tiền bạc trong tài khoản của người dùng.

## 4. Functional Requirements
- Hệ thống hỗ trợ nạp cấu hình động tại thời điểm khởi chạy ứng dụng (Run-time configuration injection).
- Phân biệt cấu hình API endpoints, API Keys bên thứ ba và cấu hình kết nối database theo từng môi trường.

## 5. Non-Functional Requirements
- Các tệp cấu hình chứa giá trị nhạy cảm tuyệt đối không được đưa lên hệ thống quản lý mã nguồn Git (Git tracking).

## 6. Business Rules
- Môi trường:
  - development: Dành cho lập trình viên chạy local thử nghiệm.
  - staging: Môi trường thử nghiệm chung, cấu trúc giống hệt Prod nhưng chạy dữ liệu giả lập.
  - production: Môi trường phục vụ khách hàng thực tế.

## 7. Data Model
- EnvConfig: Lưu trữ cấu trúc biến môi trường chuẩn.

## 8. Flow
- Khởi chạy App -> Đọc file cấu hình môi trường -> Nạp các giá trị key/endpoint tương ứng -> Khởi chạy các kết nối SDK.

## 9. API
- Không áp dụng.

## 10. Acceptance Criteria
- Ứng dụng khi biên dịch ở chế độ Release tự động nạp đúng cấu hình Production mà không cần bất kỳ thao tác thủ công nào từ lập trình viên.

## 11. Future Improvements
- Sử dụng Google Cloud Run để tự động nhân bản các môi trường thử nghiệm tạm thời (Ephemeral Environments) cho mỗi Pull Request được tạo.

## 12. References
- The Twelve-Factor App - Config methodology.

## 13. Related Documents
- [DOC-551 Secrets](./DOC-551%20Secrets.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
