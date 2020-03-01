#默认值
clashweb = 'http://127.0.0.1:10086'                        #默认控制台地址
dashboard = 'http://127.0.0.1:9090/ui/#/proxies'           #默认面板地址
subconverter = 'http://127.0.0.1:25500'                    #本地订阅转换地址。


#For 节点分组                                              #您修改subconverter/pref.ini的默认rulset后，节点分组将不可用，您需要修改下面的proxygroup。
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