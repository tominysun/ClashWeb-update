SetWorkingDir %A_ScriptDir%
#Persistent  ; 让脚本持续运行, 直到用户退出.
Menu, Tray, Add  ; 创建分隔线.
Menu, Tray, Add, 打开控制台, MenuHandler  ; 创建新菜单项.
Menu, Tray, Add, 关闭控制台, MenuHandler1  ; 创建新菜单项.
Menu, Tray, Add, 打开面板, MenuHandler2  ; 创建新菜单项.
Menu, Tray, Add, 打开subconverter, MenuHandler3  ; 创建新菜单项.
Menu, Tray, Add, 退出ClashWeb, MenuHandler4  ; 创建新菜单项.
return

MenuHandler:
Run, ahkstartclashweb.vbs
return

MenuHandler1:
MsgBox, 4,, 确定要关闭Python后台吗?关闭后网页控制台不可用
IfMsgBox, No
    return  ; 如果选择 No, 脚本将会终止.
Run, ahkstopclashweb.vbs
return

MenuHandler2:
Run, http://127.0.0.1:9090/ui/#/proxies
return

MenuHandler3:
Run, ahksubconverter.bat
return

MenuHandler4:
MsgBox, 4,, 确定要关闭Clash，Python后台，系统代理吗?
IfMsgBox, No
    return  ; 如果选择 No, 脚本将会终止.
Run, ahkexit.vbs
exit
