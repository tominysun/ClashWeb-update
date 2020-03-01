taskkill /IM subconverter.exe >NUL 2>NUL
taskkill /IM clash-win64.exe >NUL 2>NUL
cd ./App
sysproxy set 1
echo success!!!
pause