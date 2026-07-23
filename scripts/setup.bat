@echo off
echo ===================================================
echo   MealSave (FMBP) - Local Environment Setup
echo ===================================================
echo.

set SCRIPT_DIR=%~dp0
set ROOT_DIR=%SCRIPT_DIR%..

echo [1/3] Setting up AI Gateway Python Environment...
cd /d "%ROOT_DIR%\ai-server"
if not exist "venv" (
    echo   Creating new virtualenv at ai-server/venv...
    python -m venv venv
)
call venv\Scripts\activate.bat
echo   Installing Python dependencies (FastAPI, uvicorn, pydantic, httpx, python-dotenv)...
pip install -r requirements.txt
if not exist ".env" (
    copy .env.example .env
    echo   Created default .env file from .env.example
)

echo.
echo [2/3] Bootstrapping Monorepo Packages with Melos...
cd /d "%ROOT_DIR%"
call melos bootstrap

echo.
echo [3/3] Checking Ollama AI Service...
where ollama >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo   Ollama CLI detected.
    echo   Tip: Run 'ollama pull glm4' or 'ollama pull gemma2' if model is not downloaded yet.
) else (
    echo   [WARNING] Ollama CLI not found. You can install it from https://ollama.com
)

echo.
echo ===================================================
echo   SETUP COMPLETED SUCCESSFULLY!
echo   Next step: Run scripts\start-all.bat
echo ===================================================
pause
