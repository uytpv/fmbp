@echo off
echo Starting Firebase Emulator Suite...
cd %~dp0..\firebase
cmd /c "firebase emulators:start"
pause
