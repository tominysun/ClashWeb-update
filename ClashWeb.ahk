SetWorkingDir %A_ScriptDir%
Menu, Tray, Icon, clash-logo.ico,1,1
;Menu, Tray, NoStandard
#Persistent  ; 让脚本持续运行, 直到用户退出.
Menu, Tray, Add  ; 创建分隔线.'
Menu, Submenu, Add, 启动Clash, MenuHandlerstartclash
Menu, Submenu, Add, 关闭Clash, MenuHandlerstopclash
Menu, Submenu, Add, 重启Clash, MenuHandlerrestartclash
Menu, Submenu, Add, 更新配置, MenuHandlerupdateconfig
Menu, tray, add, Clash🔰, :Submenu 
Menu, tray, Add, 切换节点, MenuHandlerdashboard  ; 创建新菜单项.
Menu, Tray, Add  ; 创建分隔线.'
Menu, Submenu1, Add, 配置托管, profiles  ; 创建新菜单项.
Menu, Submenu1, Add, 高级设置, admin  ; 创建新菜单项.
Menu, Submenu1, Add, 关闭控制台, MenuHandlerstoppython  ; 创建新菜单项.
Menu, tray, add, 控制后台, :Submenu1 
Menu, Submenu2, Add, 开启系统代理, setsys  ; 创建新菜单项.
Menu, Submenu2, Add, 关闭系统代理, dissys
Menu, tray, add, 系统代理, :Submenu2 
Menu, Tray, Add  ; 创建分隔线.
Menu, Tray, Add, 检查状态, MenuHandlercheck  ; 创建新菜单项.
Menu, Tray, Add, 一键关闭, MenuHandlerexit  ; 创建新菜单项.
Menu, Tray, Add, 退出, MenuHandlerexit1  ; 创建新菜单项.
Menu, Tray, Add  ; 创建分隔线.
return

admin:
RunWait, ahkopenadmin.bat,,Hide
return

profiles:
RunWait, ahkopenprofiles.bat,,Hide
return

setsys:
RunWait, %A_ScriptDir%\bat\setsys.bat,,Hide
Goto, checksys
return

dissys:
RunWait, %A_ScriptDir%\bat\dissys.bat,,Hide
Goto, checksys
return

checksys:
RegRead, proxy,HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyEnable
if ( proxy > 0 )
{ 
    ProxyVar := "开-✅"
}
else 
{
    ProxyVar := "关-❌"
}
TrayTip % Format("📢运行状态📢"),系统代理：%ProxyVar%
return

checkclash:
Process,Exist, clash-win64.exe ; 
if ErrorLevel
{
    ClashVar := "开-✅"
}
else
{
    ClashVar := "关-❌"
}
TrayTip % Format("📢运行状态📢"),Clash：%ClashVar%
return

checkpython:
Process,Exist, python.exe ; 
if ErrorLevel   
{
    PythonVar := "开-✅"
}
else
{ 
    PythonVar := "关-❌"
}

TrayTip % Format("📢运行状态📢"), 控制台：%PythonVar%
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
RunWait, ahkstartclash.bat,,Hide
Goto, checkclash
return

MenuHandlerstopclash:
MsgBox, 4,, 确定要关闭Clash、关闭系统代理吗？
IfMsgBox, No
    return  ; 如果选择 No, 脚本将会终止.
RunWait, ahkstopclash.bat,,Hide
Goto, checkclash
return

MenuHandlerrestartclash:
RunWait, ahkrestartclash.bat,,Hide
Goto, checkclash
return

MenuHandlerupdateconfig:
RunWait, ahkupdateconfig.bat,,Hide
TrayTip % Format("📢运行状态📢"), 操作成功，如果启动失败请再次尝试。
return


MenuHandlerstoppython:
MsgBox, 4,, 确定要关闭Python控制台吗 ? 关闭后网页控制台不可用 ！
IfMsgBox, No
    return  ; 如果选择 No, 脚本将会终止.
RunWait, ahkstopclashweb.bat,,Hide
Goto, checkpython
return


MenuHandlerdashboard:
Process,Exist, clash-win64.exe ; 
if ErrorLevel
{
    Run, ahkopendashboard.bat,,Hide
}
else
{
    ClashVar := "关-❌"
    TrayTip % Format("📢运行状态📢"),Clash：%ClashVar%，请先启动Clash。
}
return

MenuHandlerexit:
MsgBox, 4,, 确定要关闭Clash，Python后台，系统代理吗?
IfMsgBox, No
    return  ; 如果选择 No, 脚本将会终止.
RunWait, ahkexit.bat,,Hide
Goto, MenuHandlercheck
return

MenuHandlerexit1:
MsgBox, 4,, 确定只关闭本程序，不改变Clash、Python控制台、系统代理状态?
IfMsgBox, No
    return  ; 如果选择 No, 脚本将会终止.
Exit:
ExitApp


