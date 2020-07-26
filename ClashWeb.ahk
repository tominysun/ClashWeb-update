SetWorkingDir %A_ScriptDir%
Process,Exist, clash-win64.exe ;                         
if ErrorLevel
{   
}
else
{
    RunWait, ahkstart.bat,,Hide
}
programName:="ClashWeb By Nico"
Menu, Tray, Icon, clash-logo.ico,1,1
Menu, Tray, NoStandard
#Persistent  ; 让脚本持续运行, 直到用户退出.
Menu, Tray, Add  ; 创建分隔线.'
Menu, tray, Add, 切换节点, MenuHandlerdashboard 
Menu, tray, Add, 更新配置, MenuHandlerupdateconfig

Menu, Tray, Add  ; 创建分隔线.
Menu, Submenu, Add, 启动, MenuHandlerstartclash
Menu, Submenu, Add, 关闭, MenuHandlerstopclash
Menu, Submenu, Add, 重启, MenuHandlerrestartclash
Menu, tray, add, 普通模式, :Submenu  
Menu, Submenu4, Add, 启动, tapstart
Menu, Submenu4, Add, 关闭, tapstop
Menu, Submenu4, Add, 重启, taprestart
Menu, tray, add, Tap模式, :Submenu4  

Menu, Tray, Add  ; 创建分隔线.
Menu, Submenu3, Add, 规则, rulemode  
Menu, Submenu3, Add, 全局, globalmode
Menu, Submenu3, Add, 直连, directmode
Menu, tray, add, 代理模式, :Submenu3 
Menu, Submenu2, Add, 开启系统代理, setsys  
Menu, Submenu2, Add, 关闭系统代理, dissys
Menu, tray, add, 系统代理, :Submenu2

Menu, Tray, Add  ; 创建分隔线.
Menu, Tray, Add, 打开控制台, clashweb 
Menu, Tray, Add, 关闭控制台, MenuHandlerstoppython  
 
Menu, Tray, Add  ; 创建分隔线.
Menu, Tray, Click, OnClick 
Menu, Tray, Add, 检查状态, OnClick
Menu, Tray, Add, 帮助, help
Menu, Tray, Add, 退出, MenuHandlerexit  
Menu, Tray, Default, 检查状态
Menu, Tray, Add  ; 创建分隔线.
Menu,Tray,Tip,%programName% 
OnClick:                                      ;任务栏图标双击单击效果
if !LastClick 
{
        LastClick := 1
        SetTimer,SingleClickEvent,-200
}
else if (LastClick = 1 )
{
        SetTimer,SingleClickEvent,off
        LastClick := 2
        SetTimer,DoubleClickEvent,-500
}
else if (LastClick = 2 )
{
        SetTimer,DoubleClickEvent,off
        gosub,TripleClickEvent
}
return

SingleClickEvent:
LastClick := 0
Goto, MenuHandlercheck 
return

DoubleClickEvent:
LastClick := 0
Goto, MenuHandlerdashboard
return

TripleClickEvent:
LastClick := 0
Goto, MenuHandlerupdateconfig
return

help:
Run, %A_ScriptDir%\App\help.png
return

nothing:
return

taprestart:
RunWait, ahkstopclashtap.bat,,Hide
RunWait, ahkstartclashtap.bat,,Hide
TrayTip % Format("📢通知📢"),Tap模式重启操作完成
return

tapstart:
RunWait, ahkstartclashtap.bat,,Hide
TrayTip % Format("📢通知📢"),Tap模式启动操作完成
return

tapstop:
RunWait, ahkstopclashtap.bat,,Hide
TrayTip % Format("📢通知📢"),Tap模式关闭操作完成
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
Process,Exist, tun2socks.exe ; 
if ErrorLevel
{
    ModeVar := "TAP"
}
else
{
    ModeVar := "普  通"
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
RegRead, proxy,HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyEnable
if ( proxy > 0 )
{ 
    ProxyVar := "开-✅"
}
else 
{
    ProxyVar := "关-❌"
}
TrayTip % Format("📢运行状态📢"),运行  模式：%ModeVar%`nClash状态：%ClashVar%`n系统  代理：%ProxyVar%
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

Process,Exist, tun2socks.exe ; 
if ErrorLevel
{
    ModeVar := "TAP"
}
else
{
    ModeVar := "普  通"
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
TrayTip % Format("📢运行状态📢"), 运行  模式：%ModeVar%`nClash状态：%ClashVar%`n系统  代理：%ProxyVar%`n控制  后台：%PythonVar%
return

MenuHandlerstartclash:
RunWait, ahkstartclash.bat,,Hide
TrayTip % Format("📢通知📢"),普通模式启动操作完成
return

MenuHandlerstopclash:
MsgBox, 4,, 确定要关闭Clash、关闭系统代理吗？
IfMsgBox, No
    return  ; 如果选择 No, 脚本将会终止.
RunWait, ahkstopclash.bat,,Hide
TrayTip % Format("📢通知📢"),普通模式关闭操作完成
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
Process,Exist, tun2socks.exe ; 
if ErrorLevel
{
    ModeVar := "TAP"
}
else
{
    ModeVar := "普  通"
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
TrayTip % Format("📢重启成功📢"),运行  模式：%ModeVar%`nClash状态：%ClashVar%`n系统  代理：%ProxyVar%
return

rulemode:
RunWait, ahkrule.bat,,Hide
TrayTip % Format("📢通知📢"),规则模式
return

directmode:
RunWait, ahkdirect.bat,,Hide
TrayTip % Format("📢通知📢"),直连模式
return

globalmode:
RunWait, ahkglobal.bat,,Hide
TrayTip % Format("📢通知📢"),全局模式
return

MenuHandlerupdateconfig:
RunWait, ahkupdateconfig.bat,,Hide
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
Process,Exist, tun2socks.exe ; 
if ErrorLevel
{
    ModeVar := "TAP"
}
else
{
    ModeVar := "普  通"
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
TrayTip % Format("📢更新并重启成功📢"),运行  模式：%ModeVar%`nClash状态：%ClashVar%`n系统  代理：%ProxyVar%
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
RunWait, ahkexit.bat,,Hide
ExitApp