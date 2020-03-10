@echo off
CD /D %~DP0\..\
SET PATH="%~dp0";"%~dp0App";%PATH%
taskkill /IM clash-win64.exe >NUL 2>NUL
cd ./App
sysproxy set 1
cd ../
start ClashWeb.exe
SET PATH="%~dp0";"%~dp0App";"%~dp0Python";"%~dp0Python\Scripts";"%~dp0Python\Lib\distutils\command";"%~dp0Python\Lib\site-packages\pip\_vendor\distlib";"%~dp0Python\Lib\site-packages\setuptools";%PATH%
python node.py startandset