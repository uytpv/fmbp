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
    functions.logger.warn("GEMINI_API_KEY không được cấu hình. Sử dụng Fallback Rule Engine.");
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
}

interface PantryItem {
  name: string;
  quantity: number;
  unit: string;
}

// ------------------------------------------------------------------------------
// API 1: /suggest-menu & /api/v1/ai/suggest-menu
// ------------------------------------------------------------------------------
const suggestMenuHandler = async (req: Request, res: Response) => {
  const { weekly_budget, pantry_items } = req.body || {};
  const budget = Number(weekly_budget) || 1000000;
  const items: PantryItem[] = Array.isArray(pantry_items) ? pantry_items : [];

  const systemPrompt = `Bạn là một trợ lý dinh dưỡng và tài chính gia đình thông minh. Nhiệm vụ của bạn là lập kế hoạch thực đơn ăn uống trong tuần dựa trên hạn mức ngân sách chi tiêu và các nguyên liệu hiện có trong tủ lạnh. Hãy đảm bảo tổng chi phí thực phẩm không vượt quá ngân sách tuần được cấp và ưu tiên sử dụng nguyên liệu trong tủ lạnh trước để tránh lãng phí. Bạn PHẢI trả về kết quả dưới dạng một JSON object duy nhất, tuân thủ chính xác cấu trúc sau:

{
  "menu": [
    {"day": "Thứ Hai", "meal_type": "BREAKFAST", "recipe_title": "Phở gà", "estimated_cost": 30000, "reason": "Tiết kiệm chi phí"},
    {"day": "Thứ Hai", "meal_type": "LUNCH", "recipe_title": "Thịt kho trứng", "estimated_cost": 50000, "reason": "Tận dụng tủ lạnh"},
    {"day": "Thứ Hai", "meal_type": "DINNER", "recipe_title": "Canh rau muống", "estimated_cost": 20000, "reason": "Cân bằng dinh dưỡng"}
  ],
  "total_estimated_cost": 450000,
  "advice": "Lời khuyên chi tiêu tuần từ trợ lý AI"
}

Hãy tạo đầy đủ cho cả 7 ngày (từ Thứ Hai đến Chủ Nhật) với 3 bữa/ngày (BREAKFAST, LUNCH, DINNER).`;

  const pantryStr = items.length > 0
    ? items.map((i) => `- ${i.name}: ${i.quantity} ${i.unit}`).join("\n")
    : "Tủ lạnh trống.";

  const prompt = `Ngân sách ăn uống tuần này: ${budget} VNĐ.\nNguyên liệu trong tủ lạnh:\n${pantryStr}\n\nHãy gợi ý thực đơn tuần tối ưu nhất.`;

  const aiResult = await callGeminiFlash(prompt, systemPrompt);
  if (aiResult) {
    const parsed = parseJsonFromText(aiResult);
    if (parsed) {
      return res.json(parsed);
    }
  }

  // Fallback Rule-based Menu nếu AI không phản hồi
  const days = ["Thứ Hai", "Thứ Ba", "Thứ Tư", "Thứ Năm", "Thứ Sáu", "Thứ Bảy", "Chủ Nhật"];
  const sampleMeals = [
    { title: "Bún bò Huế / Bún riêu", cost: 35000, type: "BREAKFAST" },
    { title: "Thịt kho tàu & Canh cải", cost: 60000, type: "LUNCH" },
    { title: "Cá sốt cà chua & Rau luộc", cost: 50000, type: "DINNER" },
  ];

  const generatedMenu = days.flatMap((day) =>
    sampleMeals.map((m) => ({
      day,
      meal_type: m.type,
      recipe_title: `${m.title} (${day})`,
      estimated_cost: m.cost,
      reason: items.length > 0 ? "Tận dụng nguyên liệu sẵn có trong tủ lạnh" : "Thực đơn dinh dưỡng cân bằng",
    }))
  );

  return res.json({
    menu: generatedMenu,
    total_estimated_cost: Math.min(budget, 1015000),
    advice: "Đã tạo thực đơn tuần cân bằng chi phí và dinh dưỡng cho gia đình bạn.",
  });
};

// ------------------------------------------------------------------------------
// API 2: /estimate-cost & /api/v1/ai/estimate-cost
// ------------------------------------------------------------------------------
const estimateCostHandler = async (req: Request, res: Response) => {
  const { recipe_title, ingredients } = req.body || {};
  const title = String(recipe_title || "Món ăn gia đình");
  const ingList: IngredientItem[] = Array.isArray(ingredients) ? ingredients : [];

  const systemPrompt = `Bạn là chuyên gia định giá thực phẩm tại Việt Nam. Hãy phân tích các nguyên liệu trong công thức và đưa ra ước tính chi phí thực tế cho từng nguyên liệu và tổng chi phí món ăn bằng VNĐ. Trả về kết quả dưới dạng JSON object duy nhất theo cấu trúc sau:

{
  "estimated_cost": 120000,
  "breakdown": [
    {"ingredient_name": "Thịt ba chỉ", "estimated_price": 70000},
    {"ingredient_name": "Gia vị", "estimated_price": 10000}
  ]
}`;

  const ingStr = ingList.map((i) => `- ${i.name}: ${i.quantity} ${i.unit}`).join("\n");
  const prompt = `Món ăn: ${title}\nNguyên liệu:\n${ingStr || "Nguyên liệu cơ bản"}`;

  const aiResult = await callGeminiFlash(prompt, systemPrompt);
  if (aiResult) {
    const parsed = parseJsonFromText(aiResult);
    if (parsed) {
      return res.json(parsed);
    }
  }

  // Fallback Rule-based Cost
  const defaultCostPerItem = 25000;
  const breakdown = ingList.map((i) => ({
    ingredient_name: i.name,
    estimated_price: defaultCostPerItem,
  }));
  const totalCost = breakdown.reduce((sum, b) => sum + b.estimated_price, 30000);

  return res.json({
    estimated_cost: totalCost,
    breakdown: breakdown.length > 0 ? breakdown : [{ ingredient_name: title, estimated_price: totalCost }],
  });
};

// ------------------------------------------------------------------------------
// API 3: /parse-recipe & /api/v1/ai/parse-recipe
// ------------------------------------------------------------------------------
const parseRecipeHandler = async (req: Request, res: Response) => {
  const { url_or_text } = req.body || {};
  const text = String(url_or_text || "");

  const systemPrompt = `Bạn là trợ lý nấu nướng thông minh. Hãy bóc tách và phân loại thông tin từ tài liệu/đường dẫn công thức nấu ăn được cung cấp. Lấy tiêu đề, thời gian chuẩn bị (phút), thời gian nấu (phút), số phần ăn, danh sách nguyên liệu và các bước thực hiện. Trả về JSON duy nhất:

{
  "title": "Tên món ăn",
  "instructions": ["Bước 1...", "Bước 2..."],
  "servings": 4,
  "prep_time": 15,
  "cook_time": 30,
  "ingredients": [
    {"name": "Thịt ba chỉ", "quantity": 0.5, "unit": "kg"}
  ]
}`;

  const prompt = `Nội dung/URL công thức:\n${text}`;

  const aiResult = await callGeminiFlash(prompt, systemPrompt);
  if (aiResult) {
    const parsed = parseJsonFromText(aiResult);
    if (parsed) {
      return res.json(parsed);
    }
  }

  // Fallback Rule
  return res.json({
    title: text.length < 30 ? text : "Món ăn bóc tách từ văn bản",
    instructions: ["Chuẩn bị các nguyên liệu sạch sẽ", "Ướp gia vị trong 15 phút", "Nấu chín và thưởng thức khi còn nóng"],
    servings: 4,
    prep_time: 15,
    cook_time: 25,
    ingredients: [
      { name: "Nguyên liệu chính", quantity: 0.5, unit: "kg" },
      { name: "Gia vị nêm nếm", quantity: 1, unit: "gói" },
    ],
  });
};

// Routing hỗ trợ cả đường dẫn ngắn và đường dẫn /api/v1/ai/...
app.post("/suggest-menu", suggestMenuHandler);
app.post("/api/v1/ai/suggest-menu", suggestMenuHandler);

app.post("/estimate-cost", estimateCostHandler);
app.post("/api/v1/ai/estimate-cost", estimateCostHandler);

app.post("/parse-recipe", parseRecipeHandler);
app.post("/api/v1/ai/parse-recipe", parseRecipeHandler);

app.get("/", (req: Request, res: Response) => {
  res.json({ status: "healthy", service: "Firebase FMBP AI Gateway", version: "1.0.0" });
});

export const aiGateway = functions.https.onRequest(app);
