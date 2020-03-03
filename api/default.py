#默认值
clashweb = 'http://127.0.0.1:10086'                        #默认控制台地址
dashboard = 'http://127.0.0.1:9090/ui/#/proxies'           #默认面板地址。 当你修改后，记得修改Profile/notchangeme.yaml 的 external-controller
subconverter = 'http://127.0.0.1:25500'                    #本地订阅转换地址。 当你修改后，记得修改App/subconverter/pref.ini的port
openweb = True                                             #启动时是否打开浏览器控制台
opensysafterstartclash = True                             #点击启动Clash时是否打开系统代理。设置为True即打开系统代理，False 即保持不变   


#For 节点分组                                              #您修改subconverter/snippets/rulets的默认rulset后，节点分组将不可用，您需要修改下面的proxygroup。
proxygroup= '@🔰 节点选择`select{groupname}[]DIRECT'\
            '@📲 电报吹水`select`[]🔰 节点选择{groupname}[]DIRECT'\
            '@📹 YouTube`select`[]🔰 节点选择{groupname}[]DIRECT'\
            '@🎥 NETFLIX`select`[]🔰 节点选择{groupname}[]DIRECT'\
            '@📺 巴哈姆特`select`[]🔰 节点选择{groupname}[]DIRECT'\
            '@🌍 国外媒体`select`[]🔰 节点选择{groupname}[]DIRECT'\
            '@Ⓜ️ 微软服务`select`[]DIRECT`[]🔰 节点选择{groupname}'\
            '@🍎 苹果服务`select`[]DIRECT`[]🔰 节点选择{groupname}'\
            '@🛑 全球拦截`select`[]REJECT`[]DIRECT'\
            '@🐟 漏网之鱼`select`[]🔰 节点选择`[]DIRECT{groupname}'