@echo off
echo Starting AI Gateway (FastAPI server)...
cd %~dp0..\ai-server
python main.py
pause
