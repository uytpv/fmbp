# 🥗 MealSave — Family Meal Budget Planner

> **Triết lý**: *"Quản lý bữa ăn trước, quản lý tiền sau. Ăn có kế hoạch — Sống có dư."*

MealSave (trước đây là FMBP) là ứng dụng di động hỗ trợ các gia đình quản lý tài chính thông qua việc lập kế hoạch bữa ăn, quản lý tủ lạnh và tối ưu hóa danh sách mua sắm với sự trợ giúp của AI local (Ollama).

---

## 🏗️ Kiến trúc Hệ thống

Dự án được tổ chức dạng **Monorepo** quản lý bởi [Melos](https://melos.invertase.dev/):

```
fmbp/
├── mobile/             # 📱 Ứng dụng Flutter Mobile (Android/iOS)
├── shared/             # 📦 Thư viện dùng chung
│   ├── constants/      # App constants & styling tokens
│   └── models/         # Freezed & JsonSerializable data models
├── ai-server/          # 🤖 AI Gateway FastAPI Server (kết nối Ollama)
├── firebase/           # 🔥 Firebase Config & Firestore Security Rules
├── scripts/            # ⚡ Scripts tiện ích khởi chạy một cú nhấp chuột (One-click)
└── docs/               # 📚 Tài liệu đặc tả sản phẩm & kỹ thuật
```

---

## 🛠️ Yêu cầu Tiền đề (Prerequisites)

1. **Flutter SDK**: `>= 3.10.7` (Đã test trên Flutter 3.38.x)
2. **Python**: `>= 3.10`
3. **Node.js**: `>= 18` & **Firebase CLI**: `npm install -g firebase-tools`
4. **Melos**: `dart pub global activate melos`
5. **Ollama**: Tải tại [ollama.com](https://ollama.com) và pull model AI:
   ```bash
   ollama pull glm4
   # Hoặc: ollama pull gemma2
   ```

---

## 🚀 Hướng dẫn Chạy Nhanh (One-Click Quick Start)

### Bước 1: Thiết lập môi trường tự động

Chạy script cài đặt môi trường (chỉ cần chạy lần đầu tiên):

```cmd
scripts\setup.bat
```

Script này sẽ tự động:
- Tạo môi trường ảo Python `ai-server/venv` và cài đặt các thư viện phụ thuộc (`FastAPI`, `uvicorn`, `pydantic`, `httpx`, `python-dotenv`).
- Tạo file `.env` cho AI Server.
- Chạy `melos bootstrap` để liên kết toàn bộ packages trong monorepo.

---

### Bước 2: Khởi chạy các dịch vụ Backend Cục bộ

Chạy script khởi động dịch vụ:

```cmd
scripts\start-all.bat
```

Script này sẽ tự động:
- Cấu hình **Port Forwarding (`adb reverse`)** nếu bạn cắm thiết bị Android thật qua cáp USB.
- Mở cửa sổ riêng chạy **Firebase Emulator Suite** (Auth: 9099, Firestore: 8080, UI: 4000).
- Mở cửa sổ riêng chạy **AI Gateway FastAPI Server** (Host: http://localhost:8000).

---

### Bước 3: Chạy ứng dụng Mobile

Mở một cửa sổ Terminal mới và chạy ứng dụng Flutter:

```cmd
cd mobile
flutter run
```

---

## 📱 Hướng dẫn Kết nối Thiết bị Android Thật (USB Debugging)

Khi bạn chạy thử ứng dụng trên **thiết bị Android thật**:
1. Bật **USB Debugging** trên điện thoại.
2. Cắm cáp kết nối máy tính.
3. Chạy lệnh forward port (đã được tự động tích hợp trong `start-all.bat`):
   ```cmd
   adb reverse tcp:8080 tcp:8080
   adb reverse tcp:9099 tcp:9099
   adb reverse tcp:8000 tcp:8000
   adb reverse tcp:11434 tcp:11434
   ```
4. Chạy `flutter run` và chọn thiết bị Android của bạn.

---

## 🧪 Kiểm thử (Testing)

Chạy bộ kiểm thử tự động của ứng dụng Flutter:

```cmd
cd mobile
flutter test
```

Tạo lại mã nguồn generated code (Freezed / Riverpod Generator / JSON Serializable):

```cmd
melos run codegen
```

---

## 📜 Giấy phép & Tuyên bố Bản quyền

Dự án thuộc bản quyền của **MealSave Team / Uy Tra**. 
Mọi thông tin tài liệu đặc tả tham khảo tại thư mục `docs/`.
