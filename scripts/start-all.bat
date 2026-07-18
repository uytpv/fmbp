@echo off
echo Launching FMBP Local Services...
start "Firebase Emulator" cmd /c "%~dp0start-firebase.bat"
start "AI Gateway" cmd /c "%~dp0start-ai.bat"
echo Services launched in separate windows!
timeout /t 5
