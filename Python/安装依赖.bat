@echo off
cd /d %~dp0

SET PATH="%~dp0";"%~dp0Scripts";"%~dp0\Lib\distutils\command";"%~dp0Lib\site-packages\pip\_vendor\distlib";"%~dp0Lib\site-packages\setuptools";%PATH%

python -m pip3 install -I -r requirements.txt
pause