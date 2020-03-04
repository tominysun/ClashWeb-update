::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAjk
::fBw5plQjdCuDJHqI9VE4Hx5WSw2WAEqqFokf5Ono56eLrUoSGus8d+8=
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSDk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCuDJHqI9VE4Hx5WSw2WAEi2B6YU3+35oe+fpy0=
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off &title Clash Bat
::CODER BY pcysanji 2020-02-24
taskkill /IM RBTray.exe >NUL 2>NUL
ping -n 1 127.0.0.1 > nul
cd ./App
start /min RBTray.exe
cd ../

:menu
echo.&echo.
echo -------------------------------------
echo.
echo  ClashWeb控制台   【右键】最小化，窗口自动缩放到任务栏
echo.
echo.  [1]   打开控制台
echo.
echo.  [2]   打开面板  
echo.
echo.  [3]   关闭控制台  
echo.
echo.  [X]   退出 
echo.
echo -------------------------------------
choice /C:123X /N /M "请输入你的选项 ："

if errorlevel 4 goto :exit
if errorlevel 3 goto :stopclashweb
if errorlevel 2 goto :startdasoboard
if errorlevel 1 goto :openclahweb

:openclahweb
wscript "start.vbs"  &cls
goto menu

:stopclashweb
taskkill /F /IM python.exe &cls
goto menu

:startdasoboard
start http://127.0.0.1:9090/ui/#/proxies &cls
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
