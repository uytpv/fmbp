@echo off
echo Starting Firebase Emulator Suite...
cd /d "%~dp0..\firebase"
call firebase emulators:start
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Failed to start Firebase Emulators.
    echo Make sure Node.js, Java JDK, and Firebase CLI (npm install -g firebase-tools) are installed.
)
pause
