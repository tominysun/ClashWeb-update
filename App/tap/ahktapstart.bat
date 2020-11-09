@echo off
setlocal
set DEVICE_NAME=clash-tap
set PATH=%PATH%;"%~dp0App";"%~dp0App\tap";%SystemRoot%\system32;%SystemRoot%\system32\wbem;%SystemRoot%\system32\WindowsPowerShell/v1.0
cd ./App
cd ./tap
tun2socks.vbs
ipconfig /flushdns