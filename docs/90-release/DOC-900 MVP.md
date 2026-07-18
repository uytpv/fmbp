---
Document ID: DOC-900
Title: MVP Release Specification
Version: 1.0
Status: Active
Owner: Product Team
Reviewer: Uy Tra
Last Updated: 2026-07-18
Related Documents:
  - DOC-000 Product Vision
  - DOC-200 PRD
  - DOC-204 Feature List
  - DOC-005 Product Roadmap
---

# DOC-900 — MVP Release Specification

## 1. Mục tiêu MVP

Phát hành phiên bản đầu tiên của Family Meal Budget Planner với đầy đủ các tính năng cốt lõi cho phép một gia đình:

1. Thiết lập ngân sách ăn uống tuần.
2. Lập thực đơn tuần từ thư viện công thức.
3. Tự động sinh danh sách đi chợ thông minh (đã trừ tồn kho).
4. Đi chợ và check-off → Pantry tự cập nhật → Ngân sách tự trừ.
5. Nhận gợi ý AI cho thực đơn và ước tính chi phí.

---

## 2. Phạm vi MVP (Scope)

### Must-Have (Bắt buộc)

| Module | Tính năng | Acceptance Criteria |
|---|---|---|
| **Auth** | Đăng ký/Đăng nhập (Email + Google) | Đăng nhập thành công < 3s |
| **Family** | Tạo nhóm gia đình, mời thành viên (QR/Link) | Mã mời hết hạn sau 24h |
| **Family** | Phân quyền (Owner/Admin/Member/Kid) | Kid không thể sửa ngân sách |
| **Budget** | Thiết lập ngân sách tuần (Thu nhập − Chi phí cố định) | Số dư cập nhật real-time |
| **Budget** | Theo dõi chi tiêu, số dư còn lại | Tiền lưu dạng integer (đồng) |
| **Recipe** | CRUD công thức nấu ăn | Mỗi công thức có chi phí ước tính |
| **Recipe** | Import công thức qua URL (AI Parser) | Bóc tách < 3s |
| **Ingredient** | Thư viện nguyên liệu chuẩn hóa (aliases, đơn vị) | Aliases mapping hoạt động |
| **Meal Plan** | Lập thực đơn tuần (kéo thả, chọn bữa) | Tổng chi phí tự cập nhật |
| **Meal Plan** | Kiểm tra ngân sách trước khi kích hoạt | Cảnh báo nếu vượt budget |
| **Shopping** | Tự động sinh danh sách đi chợ (= Meal Plan − Pantry) | Gộp nguyên liệu trùng |
| **Shopping** | Check-off khi đi chợ (offline support) | Đồng bộ real-time < 2s |
| **Pantry** | Quản lý tồn kho thực phẩm | Tồn kho ≥ 0 |
| **Pantry** | Cảnh báo hạn sử dụng (push notification) | Mặc định trước 2 ngày |
| **Pantry** | Tự động nhập kho từ Shopping List hoàn thành | Chuyển kho chính xác |
| **Dashboard** | Tổng hợp: ngân sách, bữa ăn hôm nay, cảnh báo | Tải < 1.5s |
| **Onboarding** | Welcome → Budget Setup → First Meal Plan | ≤ 5 bước |

### Should-Have (Nên có)

| Module | Tính năng | Ghi chú |
|---|---|---|
| **AI** | Gợi ý thực đơn tối ưu chi phí | Qua AI Gateway (Ollama local) |
| **AI** | Ước tính chi phí bữa ăn | Tính tự động khi chọn món |
| **Shopping** | Phân loại theo khu vực siêu thị | Rau củ, thịt, đồ khô, đông lạnh |

### Could-Have (Phát triển sau V1)

| Module | Tính năng |
|---|---|
| OCR | Quét hóa đơn siêu thị |
| Marketplace | Chợ công thức cộng đồng |
| Barcode | Quét mã vạch sản phẩm |

### Won't-Have (Ngoài phạm vi)

| Tính năng | Lý do |
|---|---|
| Tích hợp IoT (tủ lạnh thông minh) | Quá phức tạp cho MVP |
| Tích hợp ngân hàng | Yêu cầu compliance |
| Đa ngôn ngữ | V2+ |

---

## 3. Kiến trúc MVP

```
Flutter Mobile App (Dart)
    ├── Firebase Auth (Xác thực)
    ├── Cloud Firestore (Database + Real-time sync)
    ├── Isar Database (Local cache + Offline)
    ├── Cloud Functions (Server-side logic)
    └── AI Gateway (FastAPI + Ollama local)
```

### Đặc điểm

- **Local-first**: Toàn bộ phát triển trên máy cục bộ (Firebase Emulator + Ollama).
- **Cloud-ready**: Kiến trúc sẵn sàng deploy lên Firebase Production.
- **Offline-capable**: Shopping List và Pantry hoạt động không cần mạng.

---

## 4. Target Users (MVP)

1. **Gia đình trẻ** có con nhỏ, muốn kiểm soát chi phí ăn uống.
2. **Người sống một mình** muốn nấu ăn tiết kiệm, giảm lãng phí.
3. **Người ghét ghi chép chi tiêu** nhưng muốn quản lý tài chính.

---

## 5. Nền tảng hỗ trợ

| Platform | Phiên bản tối thiểu |
|---|---|
| Android | 8.0 (API 26) |
| iOS | 15.0 |
| Web | Chrome, Safari, Firefox (latest) |

---

## 6. Chỉ số thành công MVP

| Metric | Mục tiêu |
|---|---|
| Thời gian onboarding | ≤ 3 phút |
| Crash rate | < 1% |
| App size (APK) | < 30 MB |
| Luồng đi chợ hoàn thành | ≤ 3 taps |
| Offline Shopping List | Hoạt động 100% |
| Firestore reads/user/day | < 500 (tối ưu chi phí) |

---

## 7. Những điều MVP KHÔNG làm

Bám sát triết lý sản phẩm:

- Không ép người dùng tiết kiệm.
- Không biến ứng dụng thành phần mềm kế toán.
- Không để AI tự quyết định giao dịch tài chính.
- Không yêu cầu kiến thức tài chính để sử dụng.

---

## Changelog

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-18 | Product Team | Khởi tạo MVP Specification |

---

## Related Documents

- [DOC-000 Product Vision](../00-vision/DOC-000%20Product%20Vision.md)
- [DOC-200 PRD](../20-product/DOC-200%20PRD.md)
- [DOC-204 Feature List](../20-product/DOC-204%20Feature%20List.md)
