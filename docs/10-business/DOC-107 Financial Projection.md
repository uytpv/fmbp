---
Document ID: DOC-107
Title: Financial Projection (3-Year Plan)
Version: 1.0
Status: Draft
Owner: Product Team
Reviewer: 
Last Updated: 2026-07-14
Related Documents: 
- [DOC-100 Business Model](./DOC-100%20Business%20Model.md)
- [DOC-101 Pricing](./DOC-101%20Pricing.md)
---

# Financial Projection (3-Year Plan)

## 1. Objective
Tài liệu này trình bày mô hình dự báo tài chính (Financial Projection) trong 3 năm đầu hoạt động của dự án **Family Meal Budget Planner**, ước tính chi phí, doanh thu, lợi nhuận và xác định điểm hòa vốn để làm cơ sở ra quyết định kinh doanh và gọi vốn đầu tư.

## 2. Scope
Tài liệu bao gồm dự toán Chi phí vốn ban đầu (CapEx), Chi phí vận hành thường niên (OpEx), Dự báo tăng trưởng người dùng và tỷ lệ chuyển đổi, Dự báo doanh thu chi tiết từ các nguồn (Subscriptions, Marketplace, Affiliate) và phân tích Điểm hòa vốn (Break-even analysis).

## 3. Business Context
Xây dựng một sản phẩm công nghệ đòi hỏi đầu tư lớn vào giai đoạn nghiên cứu, thiết kế và phát triển ban đầu khi chưa có doanh thu. Khi vận hành, các chi phí liên quan đến máy chủ và đặc biệt là chi phí token API AI (GPT/Gemini) sẽ tăng dần theo số lượng người dùng hoạt động. Việc lập dự báo tài chính giúp nhóm sáng lập kiểm soát dòng tiền, chuẩn bị sẵn ngân sách dự phòng và đánh giá tính khả thi kinh tế của mô hình Subscription và Affiliate.

## 4. Functional Requirements
- Hệ thống hỗ trợ kết xuất báo cáo doanh thu thực tế định kỳ phục vụ đối chiếu với bảng dự báo.
- Công cụ tính toán vòng đời giá trị khách hàng (LTV - Lifetime Value) và chi phí thu hút khách hàng (CAC - Customer Acquisition Cost) tự động dựa trên ngân sách marketing và số lượng người dùng Premium mới đăng ký.

## 5. Non-Functional Requirements
- Bảng tính toán tài chính nội bộ được cấu trúc rõ ràng bằng các biến số có thể điều chỉnh (Variables/Assumptions) để dễ dàng chạy thử nghiệm các kịch bản tài chính khác nhau (Worst-case, Base-case, Best-case).

## 6. Business Rules
- **Các giả định tài chính cốt lõi (Assumptions):**
  - Tỷ lệ chuyển đổi từ người dùng miễn phí sang Premium (Conversion Rate): Dự kiến **2.5%** ở năm thứ nhất, tăng lên **3.5%** ở năm thứ hai và **4.0%** ở năm thứ ba nhờ tối ưu hóa phễu và AI.
  - Tỷ lệ người dùng rời bỏ dịch vụ hàng tháng (Monthly Churn Rate): Khống chế dưới **5%** đối với gói Premium và dưới **3%** đối với gói Family Pack.
  - Hoa hồng tiếp thị liên kết trung bình (Affiliate Commission): Đạt **2.5%** giá trị giỏ hàng, tần suất đi chợ trung bình của gia đình là 1.5 lần/tuần, giá trị giỏ hàng trung bình là 400.000 VNĐ (~$17).
  - Tỷ lệ chia sẻ doanh thu Marketplace: Giữ cố định ở mức **30%** hệ thống thu về.

## 7. Data Model
- `FinancialReport`: Báo cáo kết quả hoạt động kinh doanh (P&L - Profit and Loss statement) theo tháng/quý.
- `MarketingMetrics`: Lưu trữ ngân sách tiếp thị và số lượng người dùng đăng ký mới để đo lường CAC.
- `CohortData`: Theo dõi hành vi người dùng theo nhóm thời gian để tính toán LTV và tỷ lệ giữ chân.

## 8. Flow
1. **Luồng tính toán dòng tiền hàng tháng:** Đầu tháng -> Tổng hợp doanh thu từ Stripe/App Store/Affiliate -> Trừ đi chi phí hạ tầng (AWS/Firebase) -> Trừ đi chi phí token AI -> Trừ đi chi phí nhân sự và marketing -> Ghi nhận dòng tiền ròng (Net Cash Flow) -> Cập nhật vào báo cáo tài chính lũy kế.

## 9. API
- Không áp dụng API công khai cho tài liệu tài chính này. Các chỉ số được xuất bản thủ công hoặc truy vấn nội bộ qua Admin Dashboard.

## 10. Acceptance Criteria
- Các số liệu tính toán trong bảng dự báo phải đảm bảo logic toán học nhất quán (ví dụ: Tổng doanh thu = Doanh thu Subscription + Doanh thu Affiliate + Doanh thu Marketplace).
- Điểm hòa vốn phải được chỉ ra rõ ràng về mặt thời gian và số lượng người dùng trả phí hoạt động tối thiểu cần đạt.

## 11. Future Improvements
- Tích hợp công cụ tự động đồng bộ doanh thu thực tế từ Stripe API vào trang quản trị tài chính nội bộ để theo dõi biểu đồ sai lệch (variance analysis) thời gian thực giữa dự báo và thực tế.

## 12. References
- Báo cáo tài chính mẫu của các công ty SaaS và các nghiên cứu thị trường về chi tiêu thực phẩm gia đình.

## 13. Related Documents
- [DOC-100 Business Model](./DOC-100%20Business%20Model.md)
- [DOC-101 Pricing](./DOC-101%20Pricing.md)
- [DOC-102 Subscription](./DOC-102%20Subscription.md)

---

## Revision History

| Version | Date | Author | Changes |
|----------|------|---------|----------|
| 1.0 | 2026-07-14 | Product Team | Khởi tạo tài liệu dự báo tài chính 3 năm |
暗
