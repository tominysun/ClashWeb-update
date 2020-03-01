@echo off
CD /D %~DP0\..\
SET PATH="%~dp0";"%~dp0App";%PATH%
taskkill /IM clash-win64.exe >NUL 2>NUL
wscript ".\App\tmp.vbs" 
cd ./App
sysproxy global 127.0.0.1:7890 localhost;127.*;10.*
cls
cd ../
ClashWeb.bat