SetWorkingDir %A_ScriptDir%
Menu, Tray, Icon, clash-logo.ico,1,1

#Persistent  ; 让脚本持续运行, 直到用户退出.
Menu, Tray, Add  ; 创建分隔线.
Menu, Tray, Add  ; 创建分隔线.
Menu, Tray, Add, 打开  面板, MenuHandlerdashboard  ; 创建新菜单项.
Menu, Tray, Add, 一键  关闭, MenuHandlerexit  ; 创建新菜单项.
Menu, Tray, Add  ; 创建分隔线.
Menu, Tray, Add  ; 创建分隔线.
Menu, Tray, Add, 启动 Clash, MenuHandlerstartclash  ; 创建新菜单项.
Menu, Tray, Add, 关闭 Clash, MenuHandlerstopclash  ; 创建新菜单项.
Menu, Tray, Add, 更新  配置, MenuHandlerupdateconfig  ; 创建新菜单项.
Menu, Tray, Add  ; 创建分隔线.
Menu, Tray, Add  ; 创建分隔线.
Menu, Tray, Add, 打开控制台, MenuHandlerstartpython  ; 创建新菜单项.
Menu, Tray, Add, 关闭控制台, MenuHandlerstoppython  ; 创建新菜单项.
return

MenuHandlerstartclash:
Run, ahkstartclash.vbs
return

MenuHandlerstopclash:
MsgBox, 4,, 确定要关闭Clash吗？
IfMsgBox, No
    return  ; 如果选择 No, 脚本将会终止.
Run, ahkstopclash.vbs
return

MenuHandlerupdateconfig:
Run, ahkupdateconfig.vbs
return

MenuHandlerstartpython:
Run, ahkstartclashweb.vbs
return

MenuHandlerstoppython:
MsgBox, 4,, 确定要关闭Python后台吗 ? 关闭后网页控制台不可用!
IfMsgBox, No
    return  ; 如果选择 No, 脚本将会终止.
Run, ahkstopclashweb.vbs
return


MenuHandlerdashboard:
Run, ahkopendashboard.vbs
return

MenuHandlerexit:
MsgBox, 4,, 确定要关闭Clash，Python后台，系统代理吗?
IfMsgBox, No
    return  ; 如果选择 No, 脚本将会终止.
Run, ahkexit.vbs
exit
