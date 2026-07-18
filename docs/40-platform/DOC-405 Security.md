---
Document ID: DOC-405
Title: System Security & Firewalls
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-402 Firestore](./DOC-402%20Firestore.md)
---

# System Security & Firewalls

## 1. Objective
Quy định các chính sách bảo mật hệ thống, cấu hình tường lửa và các quy tắc phân quyền dữ liệu để bảo vệ thông tin người dùng tối đa.

## 2. Scope
Áp dụng cho Firestore Security Rules, Cloud Storage Security Rules, mã hóa dữ liệu tĩnh (Data-at-rest encryption) và động (Data-in-transit).

## 3. Business Context
Thông tin tài chính ngân sách gia đình và thói quen sinh hoạt là các dữ liệu nhạy cảm riêng tư. Bất kỳ sự cố rò rỉ dữ liệu nào cũng sẽ gây mất lòng tin nghiêm trọng từ phía khách hàng.

## 4. Functional Requirements
- Triển khai Firestore Security Rules đảm bảo: Một người dùng chỉ được đọc/ghi dữ liệu của nhóm gia đình (amilyId) mà họ là thành viên chính thức.
- Chặn hoàn toàn quyền đọc/ghi công cộng (Public access) trên toàn bộ cơ sở dữ liệu.

## 5. Non-Functional Requirements
- Thường xuyên quét các lỗ hổng bảo mật tự động bằng các công cụ SAST/DAST trong luồng CI/CD.

## 6. Business Rules
- Khóa Token phiên đăng nhập (JWT token expiration) tự động sau tối đa 30 ngày không có hoạt động mới.

## 7. Data Model
- Không áp dụng.

## 8. Flow
- App gửi yêu cầu đọc dữ liệu -> Firestore Security Rules kiểm tra: equest.auth.uid != null và esource.data.familyId == request.auth.token.familyId -> Nếu hợp lệ -> Trả về dữ liệu; Ngược lại -> Chặn và báo lỗi Permission Denied.

## 9. API
- Firebase Security Rules Engine.

## 10. Acceptance Criteria
- Vượt qua các bài kiểm thử xâm nhập (Penetration Testing) cơ bản đối với phân quyền Firestore.

## 11. Future Improvements
- Tích hợp dịch vụ Firebase App Check để ngăn chặn các truy cập API từ các ứng dụng giả mạo hoặc thiết bị đã bị can thiệp (rooted/jailbroken).

## 12. References
- OWASP Mobile Top 10 Security Risks.

## 13. Related Documents
- [DOC-980 Privacy Policy](../98-legal/DOC-980%20Privacy%20Policy.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Initial draft |
