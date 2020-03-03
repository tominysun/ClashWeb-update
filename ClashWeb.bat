@echo off &title Clash Bat
::CODER BY pcysanji 2020-02-24
SET PATH="%~dp0";"%~dp0App";"%~dp0Python";"%~dp0Python\Scripts";"%~dp0Python\Lib\distutils\command";"%~dp0Python\Lib\site-packages\pip\_vendor\distlib";"%~dp0Python\Lib\site-packages\setuptools";%PATH%
python api.py
pause