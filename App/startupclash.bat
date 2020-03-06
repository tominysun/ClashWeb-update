@echo off
CD /D %~DP0\..\
SET PATH="%~dp0";"%~dp0App";%PATH%
taskkill /IM clash-win64.exe >NUL 2>NUL
cls
cd ./App
sysproxy set 1
cls
cd ../
start ClashWeb.exe
echo success!!
pause