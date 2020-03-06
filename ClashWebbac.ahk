SetWorkingDir %A_ScriptDir%
Menu, Tray, Icon, clash-logo.ico,1,1
Menu, Tray, NoStandard
#Persistent  ; 让脚本持续运行, 直到用户退出.
Menu, Tray, Add  ; 创建分隔线.
Menu, Tray, Add, 切换  节点, MenuHandlerdashboard  ; 创建新菜单项.
Menu, Tray, Add, 启动 Clash, MenuHandlerstartclash  ; 创建新菜单项.
Menu, Tray, Add, 关闭 Clash, MenuHandlerstopclash  ; 创建新菜单项.
Menu, Tray, Add, 更新  配置, MenuHandlerupdateconfig  ; 创建新菜单项.
Menu, Tray, Add  ; 创建分隔线.
Menu, Tray, Add, 打开控制台, MenuHandlerstartpython  ; 创建新菜单项.
Menu, Tray, Add, 关闭控制台, MenuHandlerstoppython  ; 创建新菜单项.
Menu, Tray, Add  ; 创建分隔线.
Menu, Tray, Add, 检查  状态, MenuHandlercheck  ; 创建新菜单项.
Menu, Tray, Add, 一键  关闭, MenuHandlerexit  ; 创建新菜单项.
Menu, Tray, Add, 退出, MenuHandlerexit1  ; 创建新菜单项.
Menu, Tray, Add  ; 创建分隔线.
return

MenuHandlercheck:
RegRead, proxy,HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyEnable
if ( proxy > 0 )
{ 
    ProxyVar := "开-✅"
}
else 
{
    ProxyVar := "关-❌"
}

Process,Exist, clash-win64.exe ; 
if ErrorLevel
{
    ClashVar := "开-✅"
}
else
{
    ClashVar := "关-❌"
}

Process,Exist, python.exe ; 
if ErrorLevel   
{
    PythonVar := "开-✅"
}
else
{ 
    PythonVar := "关-❌"
}

TrayTip % Format("📢运行状态📢"), Clash状态：%ClashVar%`n系统  代理：%ProxyVar%`n控制  后台：%PythonVar%
return

MenuHandlerstartclash:
Run, ahkstartclash.vbs
sleep, 4000 
TrayTip % Format("Clash"),启动成功
return

MenuHandlerstopclash:
MsgBox, 4,, 确定要关闭Clash、关闭系统代理吗？
IfMsgBox, No
    return  ; 如果选择 No, 脚本将会终止.
Run, ahkstopclash.vbs
TrayTip % Format("Clash"),关闭成功
return

MenuHandlerupdateconfig:
Run, ahkupdateconfig.vbs
return

MenuHandlerstartpython:
Run, ahkstartclashweb.vbs
return

MenuHandlerstoppython:
MsgBox, 4,, 确定要关闭Python控制台吗 ? 关闭后网页控制台不可用 ！
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
return

MenuHandlerexit1:
MsgBox, 4,, 确定只关闭本程序，不改变Clash、Python控制台、系统代理状态?
IfMsgBox, No
    return  ; 如果选择 No, 脚本将会终止.
Exit:
ExitApp


