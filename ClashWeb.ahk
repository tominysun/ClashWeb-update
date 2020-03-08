SetWorkingDir %A_ScriptDir%
Menu, Tray, Icon, clash-logo.ico,1,1
Menu, Tray, NoStandard
#Persistent  ; 让脚本持续运行, 直到用户退出.
Menu, Tray, Add  ; 创建分隔线.'
Menu, tray, Add, 切换节点, MenuHandlerdashboard 
Menu, Submenu, Add, 启动Clash, MenuHandlerstartclash
Menu, Submenu, Add, 关闭Clash, MenuHandlerstopclash
Menu, Submenu, Add
Menu, Submenu, Add, 重启Clash, MenuHandlerrestartclash
Menu, Submenu, Add, 更新  配置, MenuHandlerupdateconfig
Menu, Submenu, Add
Menu, tray, add, Clash, :Submenu  
Menu, Submenu2, Add, 开启系统代理, setsys  
Menu, Submenu2, Add, 关闭系统代理, dissys
Menu, tray, add, 系统代理, :Submenu2 
Menu, Submenu1, Add, 打开控制台, clashweb 
Menu, Submenu1, Add, 关闭控制台, MenuHandlerstoppython   
Menu, tray, add, 控制后台, :Submenu1 
Menu, Tray, Add  ; 创建分隔线.
Menu, Tray, Add, 检查状态, MenuHandlercheck  
Menu, Tray, Add, 一键关闭, MenuHandlerexit  
Menu, Tray, Add, 退出, MenuHandlerexit1  
Menu, Tray, Add  ; 创建分隔线.
return

nothing:
return

admin:
RunWait, ahkopenadmin.bat,,Hide
return

clashweb:
Run, ahkopenclashweb.bat,,Hide
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
RegRead, proxy,HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyEnable
if ( proxy > 0 )
{ 
    ProxyVar := "开-✅"
}
else 
{
    ProxyVar := "关-❌"
}
TrayTip % Format("📢运行状态📢"),Clash状态：%ClashVar%`n系统  代理：%ProxyVar%
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
TrayTip % Format("📢运行状态📢"), Clash状态：%ClashVar%`n系统  代理：%ProxyVar%`n控制  后台：%PythonVar%`n推荐  状态：开-开-关
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
Process,Exist, clash-win64.exe ; 
if ErrorLevel
{
    ClashVar := "开-✅"
}
else
{
    TrayTip % Format("📢重启失败📢"),请用控制台重启，查看报错信息。
    return
}
RegRead, proxy,HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyEnable
if ( proxy > 0 )
{ 
    ProxyVar := "开-✅"
}
else 
{
    ProxyVar := "关-❌"
}
TrayTip % Format("📢重启成功📢"),Clash状态：%ClashVar%`n系统  代理：%ProxyVar%
return


MenuHandlerupdateconfig:
RunWait, ahkupdateconfig.bat,,Hide
RunWait, ahkrestartclash.bat,,Hide
Process,Exist, clash-win64.exe ; 
if ErrorLevel
{
    ClashVar := "开-✅"
}
else
{
    TrayTip % Format("📢重启失败📢"),请用控制台重启，查看报错信息。
    return
}
RegRead, proxy,HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyEnable
if ( proxy > 0 )
{ 
    ProxyVar := "开-✅"
}
else 
{
    ProxyVar := "关-❌"
}
TrayTip % Format("📢更新并重启成功📢"),Clash状态：%ClashVar%`n系统  代理：%ProxyVar%
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
    TrayTip % Format("📢打开失败📢"),Clash：%ClashVar%`n请先启动Clash
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


