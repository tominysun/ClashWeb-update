mode con cols=44 lines=24
color f1
@echo off &title ClashWeb
taskkill /F /IM python.exe
wscript "startclashweb.vbs"  &cls

:menu
cls
echo.
echo.
echo -------------------------------------
echo.
echo  ClashWeb控制台
echo.
echo.  [1]   打开控制台
echo.
echo.  [2]   关闭控制台 
echo.
echo.  [3]   打开面板 
echo.
echo.  [4]   打开subconverter 
echo.
echo.  [X]   退出 
echo.
echo -------------------------------------
echo.
choice /C:1234X /N /M "请输入你的选项 ："

if errorlevel 5 goto :exit
if errorlevel 4 goto :startsubconverter
if errorlevel 3 goto :startdasoboard
if errorlevel 2 goto :stopclashweb
if errorlevel 1 goto :openclahweb

:startsubconverter
taskkill /IM subconverter.exe >NUL 2>NUL
cd ./App/subconverter
wscript start-subconverter.vbs
cd ../
cd ../
echo.
echo -------------------------------------
echo.
echo  开启subconverter成功！
echo.
echo -------------------------------------
echo.
ping -n 3 127.0.0.1 > nul
goto menu

:openclahweb
wscript "startclashweb.vbs"  &cls
echo.
echo -------------------------------------
echo.
echo  开启python控制台成功！
echo.
echo -------------------------------------
echo.
ping -n 3 127.0.0.1 > nul
goto menu

:stopclashweb
taskkill /F /IM python.exe &cls
echo.
echo -------------------------------------
echo.
echo  关闭python控制台成功！
echo.
echo -------------------------------------
echo.
ping -n 3 127.0.0.1 > nul
goto menu

:startdasoboard
start http://127.0.0.1:9090/ui/#/proxies &cls
echo.
echo -------------------------------------
echo.
echo  打开面板成功
echo.
echo -------------------------------------
echo.
ping -n 3 127.0.0.1 > nul
goto menu

:exit
taskkill /F /IM python.exe  &cls
echo.
echo -------------------------------------
echo.
echo 退出不会关闭Clash内核，要关闭Clash内核请在网页中关闭。
echo.
echo -------------------------------------
echo.
echo 按任意键退出 &pause >NUL 2>NUL
exit
