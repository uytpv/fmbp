@echo off
echo ===================================================
echo   MealSave (FMBP) - Starting Local Services
echo ===================================================
echo.

set SCRIPT_DIR=%~dp0

where adb >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [ADB] Forwarding ports for real Android devices via USB...
    adb reverse tcp:8080 tcp:8080 >nul 2>&1
    adb reverse tcp:9099 tcp:9099 >nul 2>&1
    adb reverse tcp:8000 tcp:8000 >nul 2>&1
    adb reverse tcp:11434 tcp:11434 >nul 2>&1
    echo [ADB] Ports forwarded: 8080 Firestore, 9099 Auth, 8000 AI Gateway, 11434 Ollama
)

echo.
echo Launching FMBP Local Services in separate windows...
start "Firebase Emulator" cmd /k "%SCRIPT_DIR%start-firebase.bat"
start "AI Gateway" cmd /k "%SCRIPT_DIR%start-ai.bat"

echo.
echo [!] Services launched in separate windows!
echo     - Firebase Auth Emulator:  http://localhost:9099
echo     - Firestore Emulator:     http://localhost:8080
echo     - Emulator UI:            http://localhost:4000
echo     - AI Gateway API:         http://localhost:8000 (Docs: http://localhost:8000/docs)
echo.
echo Run Flutter App on your device:
echo   cd mobile
echo   flutter run
echo.
pause
