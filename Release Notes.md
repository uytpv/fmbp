# Release Notes — Family Meal Budget Planner (FMBP)

## Phiên bản MVP (v0.1.0) — 18/07/2026

Đây là phiên bản phát hành đầu tiên (MVP) của dự án **Family Meal Budget Planner** chạy hoàn toàn trên môi trường cục bộ (local-first) để đảm bảo chất lượng, tốc độ và tính bảo mật trước khi triển khai lên đám mây.

---

## 🚀 Tính năng nổi bật

### 🔐 1. Xác thực & Quản lý Nhóm Gia Đình (Auth & Family)
- Hỗ trợ đăng ký và đăng nhập tài khoản bằng Email/Mật khẩu cục bộ kết nối qua Firebase Auth Emulator.
- Cơ chế khởi tạo nhóm gia đình mới (Family Group) và phân quyền vai trò (Owner, Admin, Member, Kid) rõ ràng.
- Tự động đồng bộ hóa thông tin thành viên gia đình và các dữ liệu liên quan.

### 💰 2. Quản lý Ngân Sách Thông Minh (Budget Module)
- Thiết lập hạn mức chi tiêu ăn uống tuần dễ dàng.
- Tự động theo dõi số dư còn lại thời gian thực với thanh trạng thái đổi màu thông minh (Xanh/Cam/Đỏ).
- Cổng ghi nhận giao dịch chi tiêu nhanh chóng cho hai hoạt động chính: Đi chợ (Grocery) và Ăn ngoài (Dining Out).

### 📖 3. Thư Viện Món Ăn & Bóc Tách AI (Recipe Module)
- Kho lưu trữ công thức nấu ăn gia đình chi tiết (khẩu phần, thời gian nấu, các bước thực hiện).
- **Tích hợp AI Parser:** Nhập nhanh công thức bằng cách dán URL hoặc nội dung văn bản bất kỳ, AI sẽ tự động phân loại nguyên liệu và các bước nấu trong < 3s.

### 📅 4. Lập Thực Đơn Tuần & Gợi Ý AI (Meal Plan)
- Lịch ăn uống chi tiết các ngày trong tuần (Sáng, Trưa, Tối).
- **Trợ lý AI Lập Thực Đơn:** Tự động đề xuất thực đơn tuần tối ưu chi phí và tận dụng tối đa các nguyên liệu đang có sẵn trong tủ lạnh để tránh lãng phí.

### 🛒 5. Danh Sách Đi Chợ & Quản Lý Tủ Lạnh (Shopping & Pantry)
- Tự động sinh danh sách đi chợ thông minh (Cần mua = Thực đơn − Tủ lạnh).
- Giao diện đi chợ check-off phân loại theo quầy kệ tiện lợi.
- **Auto-import:** Khi hoàn tất đi chợ, toàn bộ mặt hàng đã mua sẽ tự động chuyển vào kho Tủ lạnh (Pantry) của gia đình với số lượng tương ứng.

---

## 🛠️ Kiến trúc Công nghệ Cục bộ (Local-First)

- **Mobile Client:** Flutter 3.38.7 + Dart 3.10.7 + State Management Riverpod 3.x.
- **Local Cache:** Isar Database kết hợp cơ chế Offline Caching của Firestore SDK.
- **Local Backend:** Firebase Local Emulator Suite (Auth, Firestore).
- **Local AI Service:** FastAPI Gateway + Ollama (glm4 model).

---

## 📋 Hướng dẫn Khởi chạy Cục bộ

1. Khởi chạy bộ giả lập Firebase và AI Gateway:
   ```bash
   # Chạy script tự động (trong thư mục scripts/)
   double-click file: scripts/start-all.bat
   ```
2. Chạy ứng dụng Flutter:
   ```bash
   cd mobile
   flutter run
   ```

---

## Changelog chi tiết
- Khởi tạo cấu hình monorepo bằng Melos.
- Thiết lập mã nguồn chung `shared/constants` và `shared/models`.
- Viết 100% tài liệu tiêu chuẩn code (`Coding Standard.md`) và đặc tả MVP (`DOC-900 MVP.md`).
- Xây dựng Cloud Functions triggers tự động dọn dẹp dữ liệu nhóm gia đình.
- Hoàn thành viết unit tests và cấu hình môi trường.
