@echo off
echo Starting AI Gateway (FastAPI server)...
cd /d "%~dp0..\ai-server"
if exist "venv\Scripts\activate.bat" (
    call venv\Scripts\activate.bat
)
python main.py
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Failed to start AI Gateway Server.
    echo Make sure Python and dependencies are installed by running scripts\setup.bat first.
)
pause
