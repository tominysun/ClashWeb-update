@echo off
CD /D %~DP0\..\
SET PATH="%~dp0";"%~dp0App";%PATH%
taskkill /IM clash-win64.exe >NUL 2>NUL
cd ./App
sysproxy set 1
cd ../
start ClashWeb.exe
echo success!! Please check the taskbar in the lower right corner.
pauseping -n 5 127.0.0.1 > nul