---
Document ID: 
Title: Glossary
Version: 1.0
Status: Active
Owner: Product Team
Reviewer: Uy Tra
Last Updated: 2026-07-18
Related Documents:
  - Overall Main Concept Specification
---

# Glossary — Bảng thuật ngữ dự án

## A

| Thuật ngữ | Tiếng Việt | Mô tả |
|---|---|---|
| **ADR** | Architectural Decision Record | Tài liệu ghi nhận quyết định kiến trúc |
| **AI Gateway** | Cổng AI | Dịch vụ trung gian (FastAPI) xử lý yêu cầu AI, bảo vệ API keys |
| **Alias** | Tên gọi khác | Các tên gọi tương đương cho nguyên liệu (VD: "thịt ba rọi" = "thịt ba chỉ") |
| **ARB** | Application Resource Bundle | Định dạng file dịch thuật của Flutter (app_vi.arb) |

## B

| Thuật ngữ | Tiếng Việt | Mô tả |
|---|---|---|
| **Batch** | Lô hàng | Mỗi lần mua nguyên liệu tạo ra một Batch riêng với hạn sử dụng riêng |
| **Budget Period** | Chu kỳ ngân sách | Khoảng thời gian (tuần/tháng) áp dụng một hạn mức ngân sách |
| **Budget Limit** | Hạn mức ngân sách | Số tiền tối đa gia đình được phép chi tiêu ăn uống trong một chu kỳ |

## C

| Thuật ngữ | Tiếng Việt | Mô tả |
|---|---|---|
| **Check-off** | Gạch bỏ | Hành động đánh dấu đã mua một mặt hàng trong Shopping List |
| **Cloud Functions** | Hàm đám mây | Firebase serverless functions chạy logic backend |
| **Conflict Resolution** | Giải quyết xung đột | Thuật toán xử lý khi 2+ thiết bị sửa cùng dữ liệu offline |

## D

| Thuật ngữ | Tiếng Việt | Mô tả |
|---|---|---|
| **Dashboard** | Bảng điều khiển | Màn hình chính tổng hợp thông tin ngân sách, bữa ăn, cảnh báo |
| **Denormalization** | Phi chuẩn hóa | Kỹ thuật lặp lại dữ liệu trong Firestore để tăng tốc truy vấn |

## E

| Thuật ngữ | Tiếng Việt | Mô tả |
|---|---|---|
| **Emulator Suite** | Bộ giả lập | Firebase Local Emulator Suite để phát triển cục bộ |
| **Expiration Date** | Hạn sử dụng | Ngày hết hạn của nguyên liệu trong Pantry |

## F

| Thuật ngữ | Tiếng Việt | Mô tả |
|---|---|---|
| **Family Group** | Nhóm gia đình | Thực thể trung tâm; mọi dữ liệu (budget, pantry, meal plan) thuộc về Family Group |
| **FIFO** | First In, First Out | Nguyên tắc sử dụng thực phẩm cũ trước, mới sau |
| **Firestore** | — | Cơ sở dữ liệu NoSQL thời gian thực của Firebase |

## I

| Thuật ngữ | Tiếng Việt | Mô tả |
|---|---|---|
| **Ingredient** | Nguyên liệu | Đơn vị cơ bản nhất của hệ thống (VD: trứng, bơ, thịt bò) |
| **Isar** | — | Cơ sở dữ liệu cục bộ tốc độ cao cho Flutter (offline cache) |

## K

| Thuật ngữ | Tiếng Việt | Mô tả |
|---|---|---|
| **Kid** | Trẻ em | Vai trò trong Family Group: chỉ xem thực đơn, đề xuất món yêu thích |

## L

| Thuật ngữ | Tiếng Việt | Mô tả |
|---|---|---|
| **Local-first** | Cục bộ trước | Chiến lược phát triển: chạy 100% trên máy local trước khi deploy |
| **LLM** | Large Language Model | Mô hình ngôn ngữ lớn (VD: Ollama glm4) |

## M

| Thuật ngữ | Tiếng Việt | Mô tả |
|---|---|---|
| **Meal Plan** | Kế hoạch ăn uống / Thực đơn | Lịch ăn uống theo tuần, nguồn dữ liệu để sinh Shopping List |
| **Meal Prep** | Chuẩn bị đồ ăn trước | Nấu sẵn cho nhiều ngày |
| **Meal Type** | Loại bữa ăn | BREAKFAST, LUNCH, DINNER, SNACK |
| **MoSCoW** | — | Phương pháp phân loại ưu tiên: Must/Should/Could/Won't |
| **Monorepo** | — | Kiến trúc 1 repository chứa nhiều project (mobile, functions, ai-server) |

## O

| Thuật ngữ | Tiếng Việt | Mô tả |
|---|---|---|
| **OCR** | Nhận dạng ký tự quang học | Quét hóa đơn siêu thị để tự động nhận diện nguyên liệu |
| **Ollama** | — | Framework chạy mô hình AI cục bộ trên máy tính |
| **Onboarding** | Hướng dẫn ban đầu | Luồng thiết lập lần đầu: Welcome → Budget → First Meal Plan |
| **Owner** | Người sáng lập | Vai trò cao nhất trong Family Group |

## P

| Thuật ngữ | Tiếng Việt | Mô tả |
|---|---|---|
| **Pantry** | Tủ lạnh / Kho thực phẩm | Hệ thống quản lý nguyên liệu hiện có trong gia đình |
| **PantryBatch** | Lô hàng tủ lạnh | Một lần nhập kho cụ thể với hạn sử dụng riêng |
| **Provider** | — | Đơn vị quản lý state trong Riverpod |

## R

| Thuật ngữ | Tiếng Việt | Mô tả |
|---|---|---|
| **Recipe** | Công thức nấu ăn | Một món ăn với danh sách nguyên liệu, bước thực hiện, chi phí |
| **RecipeIngredient** | Nguyên liệu trong công thức | Liên kết Recipe ↔ Ingredient với số lượng cụ thể |
| **Remaining Budget** | Ngân sách còn lại | Budget Limit − Total Spent |
| **Riverpod** | — | Thư viện state management chính thức của dự án |
| **Rollover** | Cộng dồn | Tùy chọn chuyển số dư cuối tuần sang tuần tiếp theo |

## S

| Thuật ngữ | Tiếng Việt | Mô tả |
|---|---|---|
| **Servings** | Số phần ăn | Số lượng khẩu phần của một công thức |
| **Shopping List** | Danh sách đi chợ | Sinh tự động từ Meal Plan sau khi trừ Pantry |
| **SSOT** | Single Source of Truth | Nguồn dữ liệu duy nhất đáng tin cậy |
| **StreamProvider** | — | Riverpod Provider lắng nghe dòng dữ liệu real-time từ Firestore |

## T

| Thuật ngữ | Tiếng Việt | Mô tả |
|---|---|---|
| **Transaction** | Giao dịch | Mỗi lần chi tiêu (đi chợ, ăn ngoài) được ghi nhận vào Budget |

## U

| Thuật ngữ | Tiếng Việt | Mô tả |
|---|---|---|
| **Unit Conversion** | Quy đổi đơn vị | Chuyển đổi giữa các đơn vị đo lường (VD: 1kg = 1000g) |
| **User Flow** | Luồng thao tác | Chuỗi bước người dùng thực hiện để hoàn thành một tác vụ |

---

## Changelog

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-18 | Product Team | Khởi tạo bảng thuật ngữ |
