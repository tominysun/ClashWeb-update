SET PATH="%~dp0";"%~dp0App";%PATH%
cd "%~DP0Profile\" 
for /f %%i in (.\key.txt) do wget -O GeoLite2-Country.tar.gz "https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-Country&license_key=%%i&suffix=tar.gz"
7za.exe e GeoLite2-Country.tar.gz
7za e GeoLite2-Country.tar "GeoLite2-Country*\GeoLite2-Country.mmdb" -aoa
del "Country.mmdb" /f /q
del "GeoLite2-Country.tar*" /f /q
ren GeoLite2-Country.mmdb Country.mmdb
cls
echo.&echo.
echo -------------------------------------
echo.
echo success
ping -n 3 127.0.0.1 > nul