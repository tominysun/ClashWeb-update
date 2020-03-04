1. 便携版不需要安装pytHon。

2. 然后就可以启动了！！ （网页内也有使用说明）
    双击ClashWeb.exe
    输入1进入网页控制台
    输入2进入Dashboard
    输入3关闭网页控制台
    输入其他，退出

3. ClashWeb.exe 几乎不占用后台，可以右键最小化到任务栏。
    当不需要开/关 Clash 更新配置文件等操作时
    可以关闭控制台。
    然后通过输入2进入Dashboard

5. 双击stop.bat 可以一键关闭Clash，关闭系统代理，关闭subconverter。

6. 如果无法启动，请查看Profile/Country.mmdb文件是否正常


其他，小白不要修改：
1. Profile/key.txt
    填入自己的geoip key 

2. api/defauly.py
    修改默认网页控制台地址以防止10086端口占用
    修改默认面板地址。您可以改成线上的。 
    修改subconverter后台地址。 与App/subconverter/pref.ini 中参数强相关
    修改启动时是否打开网页控制台
    修改subconverter/pref.ini的默认rulset后，节点分组将不可用，您需要修改proxygroup

