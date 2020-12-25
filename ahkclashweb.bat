SET PATH="%~dp0";"%~dp0App\tap";"%~dp0App";"%~dp0Python";"%~dp0Python\Scripts";"%~dp0Python\Lib\distutils\command";"%~dp0Python\Lib\site-packages\pip\_vendor\distlib";"%~dp0Python\Lib\site-packages\setuptools";%PATH%

goto %1

:addconfig
python node.py addconfig
exit

:direct
python node.py directmode
exit

:myexit
taskkill /F /IM python.exe
python node.py closeclashweb
ahktapstop.bat
taskkill /F /IM python.exe
exit

:geoip
python node.py geoipupdate
python node.py restart
exit

:global
python node.py globalmode
exit

:ipip
python node.py ipipupdate
python node.py restart
exit

:openclashweb
taskkill /F /IM python.exe
python api.py
exit

:opendashboard
python node.py opendashboard
exit

:restartclash
python node.py saveandclose
python node.py startandset
exit

:restartconfig
python node.py restart
exit

:rule
python node.py rulemode
exit

:save
python node.py save
exit

:start
python node.py startclashweb
exit

:startclashtap
python node.py tapstart
ahktapstart.vbs
exit

:stopclash
python node.py saveandclose
exit

:stopclashtap
python node.py tapstop
ahktapstop.vbs
exit

:stopclashweb
taskkill /F /IM python.exe
exit

:updateconfig
python node.py updateconfig
exit

:restarttun
python node.py saveandclose
python node.py tunstart
exit

:stoptun
python node.py saveandclose
exit






