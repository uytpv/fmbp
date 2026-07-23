import os
import json
import logging
from typing import List, Optional
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
import httpx
from dotenv import load_dotenv

# Thiết lập logger
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("fmbp-ai-gateway")

# Tải cấu hình
load_dotenv()
OLLAMA_URL = os.getenv("OLLAMA_URL", "http://localhost:11434")
OLLAMA_MODEL = os.getenv("OLLAMA_MODEL", "glm4")

app = FastAPI(
    title="FMBP AI Gateway",
    description="Cổng kết nối AI phục vụ dự án Family Meal Budget Planner",
    version="1.0.0"
)

# ----------------- PYDANTIC MODELS -----------------

class IngredientItem(BaseModel):
    name: str = Field(..., description="Tên nguyên liệu")
    quantity: float = Field(..., description="Số lượng")
    unit: str = Field(..., description="Đơn vị")

class PantryItemModel(BaseModel):
    name: str
    quantity: float
    unit: str

class SuggestMenuRequest(BaseModel):
    weekly_budget: int = Field(..., description="Hạn mức ngân sách tuần (VNĐ)")
    pantry_items: List[PantryItemModel] = Field(default=[], description="Danh sách nguyên liệu hiện có trong tủ lạnh")

class MealPlanSuggestion(BaseModel):
    day: str = Field(..., description="Ngày trong tuần (Thứ Hai, Thứ Ba...)")
    meal_type: str = Field(..., description="Sáng, Trưa, Tối")
    recipe_title: str = Field(..., description="Tên món ăn gợi ý")
    estimated_cost: int = Field(..., description="Chi phí ước tính (VNĐ)")
    reason: str = Field(..., description="Lý do gợi ý (tận dụng tủ lạnh/tiết kiệm chi phí)")

class SuggestMenuResponse(BaseModel):
    menu: List[MealPlanSuggestion]
    total_estimated_cost: int
    advice: str = Field(..., description="Lời khuyên chi tiêu tuần từ trợ lý AI")

class EstimateCostRequest(BaseModel):
    recipe_title: str
    ingredients: List[IngredientItem]

class EstimateCostResponse(BaseModel):
    estimated_cost: int
    breakdown: List[dict] = Field(default=[], description="Chi tiết giá từng nguyên liệu")

class ParseRecipeRequest(BaseModel):
    url_or_text: str = Field(..., description="Đường dẫn công thức hoặc nội dung văn bản thô")

class ParseRecipeResponse(BaseModel):
    title: str
    instructions: List[str]
    servings: int
    prep_time: int  # Phút
    cook_time: int  # Phút
    ingredients: List[IngredientItem]

# ----------------- UTILITY FUNCTIONS -----------------

async def call_ollama(prompt: str, system_prompt: Optional[str] = None) -> str:
    """Gọi mô hình AI Ollama chạy cục bộ"""
    url = f"{OLLAMA_URL}/api/generate"
    
    payload = {
        "model": OLLAMA_MODEL,
        "prompt": prompt,
        "stream": False,
    }
    
    if system_prompt:
        payload["system"] = system_prompt
        
    logger.info(f"Đang gửi yêu cầu đến Ollama ({OLLAMA_MODEL})...")
    try:
        async with httpx.AsyncClient(timeout=60.0) as client:
            response = await client.post(url, json=payload)
            if response.status_code != 200:
                logger.error(f"Lỗi phản hồi từ Ollama: {response.text}")
                raise HTTPException(status_code=502, detail="Lỗi kết nối dịch vụ AI Ollama")
            
            result = response.json()
            return result.get("response", "")
    except httpx.RequestError as e:
        logger.error(f"Không thể kết nối đến Ollama tại {OLLAMA_URL}: {str(e)}")
        raise HTTPException(status_code=503, detail="Không tìm thấy dịch vụ Ollama cục bộ. Hãy chắc chắn Ollama đang chạy.")

# ----------------- API ENDPOINTS -----------------

@app.get("/")
def read_root():
    return {"status": "healthy", "service": "FMBP AI Gateway", "ollama_model": OLLAMA_MODEL}

@app.post("/api/v1/ai/suggest-menu", response_model=SuggestMenuResponse)
async def suggest_menu(request: SuggestMenuRequest):
    """
    Gợi ý thực đơn tuần tối ưu chi phí và tận dụng tủ lạnh.
    """
    system_prompt = (
        "Bạn là một trợ lý dinh dưỡng và tài chính gia đình thông minh. Nhiệm vụ của bạn là lập kế hoạch thực đơn ăn uống trong tuần "
        "dựa trên hạn mức ngân sách chi tiêu và các nguyên liệu hiện có trong tủ lạnh. Hãy đảm bảo tổng chi phí thực phẩm không vượt "
        "quá ngân sách tuần được cấp và ưu tiên sử dụng nguyên liệu trong tủ lạnh trước để tránh lãng phí. Bạn PHẢI trả về kết quả dưới "
        "dạng một JSON object duy nhất, tuân thủ chính xác cấu trúc định nghĩa sau và KHÔNG ĐƯỢC kèm theo bất kỳ văn bản giải thích nào khác ngoài JSON:\n\n"
        "Cấu trúc JSON yêu cầu:\n"
        "{\n"
        '  "menu": [\n'
        '    {"day": "Thứ Hai", "meal_type": "BREAKFAST", "recipe_title": "...", "estimated_cost": 25000, "reason": "..."},\n'
        '    ...\n'
        '  ],\n'
        '  "total_estimated_cost": 450000,\n'
        '  "advice": "Lời khuyên tổng thể..."\n'
        "}"
    )
    
    pantry_str = "\n".join([f"- {item.name}: {item.quantity} {item.unit}" for item in request.pantry_items]) if request.pantry_items else "Tủ lạnh trống."
    prompt = (
        f"Ngân sách ăn uống tuần này: {request.weekly_budget} VNĐ.\n"
        f"Nguyên liệu hiện có trong tủ lạnh:\n{pantry_str}\n\n"
        "Hãy gợi ý thực đơn tuần gồm 3 bữa mỗi ngày (Sáng, Trưa, Tối) từ Thứ Hai đến Chủ Nhật. "
        "Hãy tính toán ước lượng chi phí hợp lý bằng tiền VNĐ. Đảm bảo tổng chi phí ước tính nhỏ hơn hoặc bằng ngân sách tuần."
    )
    
    response_text = await call_ollama(prompt, system_prompt)
    
    # Bóc tách JSON từ phản hồi của LLM
    try:
        # Tìm vị trí bắt đầu và kết thúc của JSON
        start_idx = response_text.find('{')
        end_idx = response_text.rfind('}') + 1
        if start_idx == -1 or end_idx == 0:
            raise ValueError("Không tìm thấy cấu trúc JSON hợp lệ trong phản hồi AI")
            
        json_data = json.loads(response_text[start_idx:end_idx])
        return json_data
    except Exception as e:
        logger.error(f"Lỗi phân tích JSON từ AI: {str(e)}\nPhản hồi thô: {response_text}")
        raise HTTPException(
            status_code=500, 
            detail="AI trả về dữ liệu không đúng định dạng JSON yêu cầu. Vui lòng thử lại."
        )

@app.post("/api/v1/ai/estimate-cost", response_model=EstimateCostResponse)
async def estimate_cost(request: EstimateCostRequest):
    """
    Ước tính chi phí thực tế cho một công thức nấu ăn dựa trên giá thị trường trung bình của nguyên liệu.
    """
    system_prompt = (
        "Bạn là chuyên gia định giá thực phẩm tại Việt Nam. Hãy phân tích các nguyên liệu trong công thức và đưa ra ước tính chi phí thực tế "
        "cho từng nguyên liệu và tổng chi phí món ăn bằng VNĐ. Trả về kết quả dưới dạng JSON object duy nhất theo cấu trúc sau:\n\n"
        "{\n"
        '  "estimated_cost": 120000,\n'
        '  "breakdown": [\n'
        '    {"ingredient_name": "...", "estimated_price": 40000}\n'
        '  ]\n'
        "}"
    )
    
    ing_str = "\n".join([f"- {item.name}: {item.quantity} {item.unit}" for item in request.ingredients])
    prompt = f"Món ăn: {request.recipe_title}\nNguyên liệu:\n{ing_str}"
    
    response_text = await call_ollama(prompt, system_prompt)
    
    try:
        start_idx = response_text.find('{')
        end_idx = response_text.rfind('}') + 1
        json_data = json.loads(response_text[start_idx:end_idx])
        return json_data
    except Exception as e:
        logger.error(f"Lỗi phân tích JSON từ AI: {str(e)}\nPhản hồi thô: {response_text}")
        raise HTTPException(status_code=500, detail="Lỗi xử lý định giá của AI")

@app.post("/api/v1/ai/parse-recipe", response_model=ParseRecipeResponse)
async def parse_recipe(request: ParseRecipeRequest):
    """
    Bóc tách công thức nấu ăn từ liên kết web hoặc nội dung văn bản thô.
    """
    system_prompt = (
        "Bạn là trợ lý nấu nướng thông minh. Hãy bóc tách và phân loại thông tin từ tài liệu/đường dẫn công thức nấu ăn được cung cấp. "
        "Bạn cần lấy thông tin tiêu đề, thời gian chuẩn bị (phút), thời gian nấu (phút), số phần ăn (servings), danh sách nguyên liệu với số lượng, "
        "đơn vị chuẩn, và các bước thực hiện. Trả về JSON object duy nhất theo định dạng:\n\n"
        "{\n"
        '  "title": "...",\n'
        '  "instructions": ["Bước 1...", "Bước 2..."],\n'
        '  "servings": 4,\n'
        '  "prep_time": 15,\n'
        '  "cook_time": 30,\n'
        '  "ingredients": [\n'
        '    {"name": "Thịt ba chỉ", "quantity": 0.5, "unit": "kg"}\n'
        '  ]\n'
        "}"
    )
    
    response_text = await call_ollama(request.url_or_text, system_prompt)
    
    try:
        start_idx = response_text.find('{')
        end_idx = response_text.rfind('}') + 1
        json_data = json.loads(response_text[start_idx:end_idx])
        return json_data
    except Exception as e:
        logger.error(f"Lỗi phân tích JSON từ AI: {str(e)}\nPhản hồi thô: {response_text}")
        raise HTTPException(status_code=500, detail="Lỗi bóc tách công thức nấu ăn")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
