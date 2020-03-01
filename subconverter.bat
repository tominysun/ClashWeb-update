taskkill /IM subconverter.exe >NUL 2>NUL
cd ".\App\subconverter"
wscript start-subconverter.vbs
CD /D %~DP0