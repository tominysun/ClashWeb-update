1. 下载Release，解压

2. 然后就可以启动了！！ 
    双击ClashWeb.exe
    在任务栏找到图标，首次使用需要进入控制台-》配置文件，按照说明下载配置文件

    当你不打算切换配置文件和其他高级操作时，您完全不需要打开控制台！

    任务栏点击更新配置后需要手动启动Clash才会应用。

3. 如果无法启动，请查看Profile/Country.mmdb文件是否正常

4. 32位系统怎么用？
   打开App文件夹，
   删除clash-win64.exe
   将clash-win64-32.exe重命名为clash-win64.exe即可

5. 如何快速更新？
   下载release，解压。
   删除Profile文件夹下的.yaml格式配置文件
   将原Profile文件夹下的.yaml配置文件复制到新文件夹
   注意，不要改变notchangeme.yaml的内容！！！！！！

   然后进入控制台，选中你的配置文件，点击重启！
   
其他，小白不要修改：
1. Profile/key.txt
    填入自己的geoip key 

2. api/defauly.py
    修改默认网页控制台地址以防止10086端口占用
    修改默认面板地址。您可以改成线上的。 
    修改subconverter后台地址。 与App/subconverter/pref.ini 中参数强相关
    修改启动控制台时是否打开网页控制台  openweb
    修改启动Clash是否打开系统代理      opensysafterstartclash
    修改subconverter/pref.ini的默认rulset后，节点分组将不可用，您需要修改proxygroup
    

