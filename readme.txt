1. 便携版不需要安装pytHon。
3. 双击Clashweb.bat 开始使用吧！！！ 
    首先进入【配置文件】
    下载地址输入框输入你的托管地址。

4. 然后就可以启动了！！ （网页内也有使用说明）
    当不需要切换配置文件，更新geoip，开关系统代理时 可以关闭Clashweb.bat。
    关闭Clashweb.bat 后可以通过Dashboard 查看日志，切换节点
    关闭Clashweb.bat 后只有Clash内核占用内存！！！

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

