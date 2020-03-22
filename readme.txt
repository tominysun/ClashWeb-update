1. 下载Release，解压
   如果不是便携版，需要自行安装Python（Add to Path）并进入bat文件夹，双击pipinstall.bat安装依赖

2. 然后就可以启动了！！ 
    双击ClashWeb.exe
    
   【首次使用】：
    任务栏图标-》控制后台-》打开控制台-》弹出网页-》配置托管-》输入托管并下载配置
   【更新当前配置】：
    任务栏图标-》Clash-》更新配置
   【注意事项】
     如果你网络较差，可能会更新失败！！！推荐在网页更新配置并检查配置是否正确。
    
3. 32位系统怎么用？
   打开App文件夹，
   删除clash-win64.exe
   将clash-win64-32.exe重命名为clash-win64.exe即可

5. 如何快速更新ClashWeb软件？
   S1.下载release，解压。
   S2.删除Profile文件夹下的.yaml格式配置文件
   S3.将原Profile文件夹下的.yaml配置文件复制到新文件夹
   
   注意，不要删除Profile文件夹defaultconfig里面的内容
   然后进入控制台，选中你的配置文件，点击重启！
   
其他，小白不要修改：
1. api/defauly.py
    修改默认网页控制台地址以防止10086端口占用
    修改默认面板地址。您可以改成线上的。 
    修改subconverter后台地址。 与App/subconverter/pref.ini 中参数强相关
    修改启动控制台时是否打开网页控制台  openweb
    修改启动Clash是否打开系统代理      opensysafterstartclash
    修改subconverter/pref.ini的默认rulset后，节点分组将不可用，您需要修改proxygroup
    修改自己的geoip key 
    

