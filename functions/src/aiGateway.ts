import express, { Request, Response } from "express";
import cors from "cors";
import { GoogleGenerativeAI } from "@google/generative-ai";
import * as functions from "firebase-functions";

const app = express();
app.use(cors({ origin: true }));
app.use(express.json());

// ------------------------------------------------------------------------------
// Helper: Call Gemini 1.5 Flash API
// ------------------------------------------------------------------------------
async function callGeminiFlash(prompt: string, systemInstruction?: string): Promise<string | null> {
  const apiKey = process.env.GEMINI_API_KEY || functions.config().gemini?.key || "";
  if (!apiKey) {
    functions.logger.warn("GEMINI_API_KEY không được cấu hình. Cần bổ sung API Key vào environment.");
    return null;
  }

  try {
    const genAI = new GoogleGenerativeAI(apiKey);
    const model = genAI.getGenerativeModel({
      model: "gemini-1.5-flash",
      systemInstruction: systemInstruction,
      generationConfig: {
        responseMimeType: "application/json",
      },
    });

    const result = await model.generateContent(prompt);
    const response = await result.response;
    return response.text();
  } catch (error) {
    functions.logger.error("Lỗi khi gọi Gemini 1.5 Flash API:", error);
    return null;
  }
}

// Helper bóc tách JSON an toàn từ chuỗi phản hồi
function parseJsonFromText<T>(text: string): T | null {
  try {
    const startIdx = text.indexOf("{");
    const endIdx = text.lastIndexOf("}") + 1;
    if (startIdx === -1 || endIdx === 0) return null;
    return JSON.parse(text.substring(startIdx, endIdx)) as T;
  } catch (e) {
    functions.logger.error("Không thể parse JSON từ phản hồi:", text, e);
    return null;
  }
}

// ------------------------------------------------------------------------------
// Interfaces
// ------------------------------------------------------------------------------
interface IngredientItem {
  name: string;
  quantity: number;
  unit: string;
  aisle?: string;
}

interface PantryItem {
  name: string;
  quantity: number;
  unit: string;
}

interface HistoricalPriceItem {
  name: string;
  price: number;
  unit: string;
}

// ------------------------------------------------------------------------------
// API 1: /suggest-menu & /api/v1/ai/suggest-menu
// ------------------------------------------------------------------------------
const suggestMenuHandler = async (req: Request, res: Response) => {
  const {
    weekly_budget,
    currency = "EUR",
    location = "FI",
    member_count = 4,
    cuisines = ["VIETNAMESE"],
    complexity = "BALANCED",
    pantry_items = [],
    historical_prices = [],
    start_date,
  } = req.body || {};

  const budget = Number(weekly_budget) || 100;
  const memberCount = Number(member_count) || 4;
  const items: PantryItem[] = Array.isArray(pantry_items) ? pantry_items : [];
  const prices: HistoricalPriceItem[] = Array.isArray(historical_prices) ? historical_prices : [];
  const cuisineList = Array.isArray(cuisines) ? cuisines.join(", ") : String(cuisines);

  const isEurUsd = ["EUR", "USD", "GBP"].includes(String(currency).toUpperCase());
  const minWeeklyBudgetPerPerson = isEurUsd ? 17.5 : 175000; // ~2.5 EUR hoặc 25.000 VNĐ / người / ngày
  const minRecommendedWeeklyBudget = minWeeklyBudgetPerPerson * memberCount;
  const isExtremeSurvival = budget < minRecommendedWeeklyBudget;

  const survivalInstruction = isExtremeSurvival
    ? `\n⚠️ CẢNH BÁO NGHÊM TRỌNG VỀ NGÂN SÁCH: Ngân sách ${budget} ${currency} cho ${memberCount} người là CỰC HẠN (quá thấp so với mức tối thiểu ${minRecommendedWeeklyBudget} ${currency}).
KÍCH HOẠT CHẾ ĐỘ TIẾT KIỆM CỰC HẠN (Extreme Survival Mode):
- Bạn PHẢI thiết lập thực đơn tập trung lặp lại các món ăn và nguyên liệu cực rẻ (Yến mạch, khoai tây nghiền, trứng, cơm chiên, bắp cải, đậu hũ) để mua sỉ tối ưu ngân sách. Không chọn các món đắt tiền như cá hồi, bò băm hay hải sản.
- Trường "budget_status" PHẢI là "SURVIVAL".
- Lời khuyên ("advice") PHẢI ghi rõ cảnh báo: "Ngân sách ${budget} ${currency} chỉ đạt ${(budget / memberCount / 7).toFixed(2)} ${currency}/người/ngày (Dưới mức tối thiểu khuyến nghị ${minRecommendedWeeklyBudget} ${currency}). Thực đơn đã được tối ưu dạng Tiết Kiệm Cực Hạn bằng cách lặp lại nguyên liệu giá rẻ."`
    : `\nTrường "budget_status" PHẢI là "BALANCED".`;

  const startDateStr = start_date ? String(start_date) : "Hôm nay";

  const systemPrompt = `Bạn là Chuyên gia Dinh dưỡng và Tài chính gia đình AI toàn cầu.
Nhiệm vụ của bạn là tạo kế hoạch thực đơn 21 bữa ăn cho 7 NGÀY LIÊN TIẾP CUỐN CHIẾU tính từ ${startDateStr} (3 bữa/ngày: BREAKFAST, LUNCH, DINNER) phù hợp chính xác với thông tin người dùng.

YÊU CẦU BẮT BUỘC:
1. Trường "day" cho 7 ngày trong mảng "menu" PHẢI theo đúng thứ tự ngày cuốn chiếu 7 ngày tính từ ${startDateStr} (Ví dụ: "Hôm nay (09/08)", "Ngày mai (10/08)", "Thứ Ba (11/08)", "Thứ Tư (12/08)", "Thứ Năm (13/08)", "Thứ Sáu (14/08)", "Thứ Bảy (15/08)").
2. PHẢI tuân thủ các phong cách ẩm thực được yêu cầu: ${cuisineList}.
3. Độ phức tạp / thời gian chuẩn bị: ${complexity}.
4. Quốc gia / Vị trí địa lý: ${location}. Tiền tệ: ${currency}.
5. Ngân sách tuần: ${budget} ${currency} cho ${memberCount} người ăn. ${survivalInstruction}
6. Ưu tiên tận dụng nguyên liệu trong tủ lạnh trước để tránh lãng phí.
7. Mỗi bữa ăn PHẢI kèm theo danh sách chi tiết các nguyên liệu chính (tên, số lượng cho 1 người, đơn vị, phân loại gian hàng siêu thị) và 4 bước hướng dẫn nấu ăn chuẩn vị.

CẤU TRÚC KẾT QUẢ BẮT BUỘC TRẢ VỀ CHUẨN JSON:
{
  "budget_status": "${isExtremeSurvival ? "SURVIVAL" : "BALANCED"}",
  "min_recommended_budget": ${minRecommendedWeeklyBudget},
  "menu": [
    {
      "day": "Hôm nay (09/08)",
      "meal_type": "BREAKFAST",
      "recipe_title": "Tên món ăn",
      "estimated_cost": 2.5,
      "ingredients": [
        {"name": "Thực phẩm A", "quantity": 150, "unit": "g", "aisle": "Thịt & Hải sản"},
        {"name": "Rau B", "quantity": 1, "unit": "bó", "aisle": "Rau củ quả"}
      ],
      "cooking_steps": [
        "Bước 1...",
        "Bước 2...",
        "Bước 3...",
        "Bước 4..."
      ],
      "local_tip": "Mẹo mua sắm tại siêu thị địa phương"
    }
  ],
  "total_estimated_cost": ${budget * 0.85},
  "advice": "Lời khuyên chi tiêu từ trợ lý AI"
}`;

  const pantryStr = items.length > 0
    ? items.map((i) => `- ${i.name}: ${i.quantity} ${i.unit}`).join("\n")
    : "Tủ lạnh trống.";

  const priceStr = prices.length > 0
    ? prices.map((p) => `- ${p.name}: ${p.price} ${currency}/${p.unit}`).join("\n")
    : "Chưa có lịch sử giá.";

  const prompt = `Hãy lập thực đơn 7 ngày cuốn chiếu tính từ ${startDateStr} cho gia đình ${memberCount} người tại ${location}.
Ngân sách: ${budget} ${currency}. (Mức tối thiểu khuyến nghị: ${minRecommendedWeeklyBudget} ${currency}).
Phong cách ẩm thực yêu cầu: ${cuisineList}.
Mức độ nấu nướng: ${complexity}.

Nguyên liệu có sẵn trong tủ lạnh:
${pantryStr}

Lịch sử giá thực tế người dùng đã mua gần đây:
${priceStr}

Tạo thực đơn 21 bữa hoàn chỉnh theo chuẩn JSON.`;

  const aiResult = await callGeminiFlash(prompt, systemPrompt);
  if (aiResult) {
    const parsed = parseJsonFromText(aiResult);
    if (parsed) {
      return res.json(parsed);
    }
  }

  return res.status(500).json({ error: "Không thể nhận phản hồi từ AI. Vui lòng thử lại." });
};

// ------------------------------------------------------------------------------
// API 2: /parse-recipe & /api/v1/ai/parse-recipe
// ------------------------------------------------------------------------------
const parseRecipeHandler = async (req: Request, res: Response) => {
  const { recipe_title, location = "FI", currency = "EUR" } = req.body || {};
  const title = String(recipe_title || "Món ăn gia đình");

  const systemPrompt = `Bạn là Đầu bếp AI chuyên nghiệp. Hãy cung cấp công thức chi tiết cho món ăn được yêu cầu tại quốc gia ${location}.
Trả về JSON duy nhất theo cấu trúc:

{
  "recipe_title": "${title}",
  "estimated_cost": 3.5,
  "currency": "${currency}",
  "ingredients": [
    {"name": "Tên nguyên liệu", "quantity": 150, "unit": "g", "aisle": "Phân loại gian hàng"}
  ],
  "cooking_steps": [
    "Bước 1...",
    "Bước 2...",
    "Bước 3...",
    "Bước 4..."
  ],
  "local_tip": "Mẹo siêu thị địa phương tại ${location}"
}`;

  const prompt = `Cung cấp chi tiết nguyên liệu và các bước nấu cho món ăn: ${title} tại ${location}.`;

  const aiResult = await callGeminiFlash(prompt, systemPrompt);
  if (aiResult) {
    const parsed = parseJsonFromText(aiResult);
    if (parsed) {
      return res.json(parsed);
    }
  }

  return res.status(500).json({ error: "Không thể lấy chi tiết công thức từ AI." });
};

// Routing
app.post("/suggest-menu", suggestMenuHandler);
app.post("/api/v1/ai/suggest-menu", suggestMenuHandler);
app.post("/parse-recipe", parseRecipeHandler);
app.post("/api/v1/ai/parse-recipe", parseRecipeHandler);

app.get("/", (req: Request, res: Response) => {
  res.json({ status: "healthy", service: "Firebase FMBP AI Gateway", version: "2.2.0" });
});

export const aiGateway = functions.https.onRequest(app);
