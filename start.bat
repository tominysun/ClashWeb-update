SET PATH="%~dp0";"%~dp0App";%PATH%
CD /D %~DP0
taskkill /IM clash-win64.exe >NUL 2>NUL
wscript ".\App\tmp.vbs" 