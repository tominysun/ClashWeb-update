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
Menu, Submenu, Add, 启动, startclash
Menu, Submenu, Add, 关闭, stopclash
Menu, tray, add, 普通模式, :Submenu  
Menu, Submenu4, Add, 启动, tapstart
Menu, Submenu4, Add, 关闭, tapstop
Menu, Submenu4, Add  ; 创建分隔线.
Menu, Submenu4, Add  ; 创建分隔线.
Menu, Submenu4, Add, 安装网卡, installtap
Menu, Submenu4, Add, 卸载网卡, unstalltap
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
Menu, Submenu5, Add, 打开控制台, clashweb 
Menu, Submenu5, Add, 关闭控制台, MenuHandlerstoppython  
Menu, tray, add, 控制后台, :Submenu5
Menu, Submenu6, Add, 默认系统代理, defautlsys
Menu, Submenu6, Add, 默认面板, defaultdashboard 
Menu, Submenu6, Add, 默认内核, defautlcore 
Menu, tray, add, 默认选项, :Submenu6
 
Menu, Tray, Add  ; 创建分隔线.
Menu, Tray, Click, OnClick 
Menu, Tray, Add, 检查状态, OnClick
Menu, Tray, Add, 帮助/捐赠, help
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
Goto, savenode
return

defaultdashboard:
MsgBox, 4, , 选择默认面板？是代表Razord,否代表yacd
IfMsgBox, No
    IniWrite, yacd, %A_ScriptDir%\api\default.ini, SET, defaultdashboard 
IfMsgBox, Yes
    IniWrite, Razord, %A_ScriptDir%\api\default.ini, SET, defaultdashboard 
return

defautlsys:
MsgBox, 4, , 普通模式下启动Clash是否自动开启系统代理?
IfMsgBox, No
    IniWrite, False, %A_ScriptDir%\api\default.ini, SET, opensysafterstartclash 
IfMsgBox, Yes
    IniWrite, True, %A_ScriptDir%\api\default.ini, SET, opensysafterstartclash  
return

defautlcore:
MsgBox, 4, , 选择内核版本？是代表64位，否代表32位
IfMsgBox, Yes
{
    RunWait, %A_ScriptDir%\bat\stop.bat,,Hide
    FileDelete, %A_ScriptDir%\App\clash-win64.exe
    FileCopy, %A_ScriptDir%\App\clash64.exe, %A_ScriptDir%\App\clash-win64.exe
}
IfMsgBox, No
{
    RunWait, %A_ScriptDir%\bat\stop.bat,,Hide
    FileDelete, %A_ScriptDir%\App\clash-win64.exe
    FileCopy, %A_ScriptDir%\App\clash32.exe, %A_ScriptDir%\App\clash-win64.exe
}
return

help:
Run, %A_ScriptDir%\App\help.png
return

nothing:
return

savenode:
RunWait, ahksave.bat,,Hide
TrayTip % Format("📢通知📢"),保存节点成功
return

installtap:
RunWait, %A_ScriptDir%\App\tap\installtab.bat
return

unstalltap:
FileGetSize, UninstallSize, C:\Program Files\TAP-Windows\Uninstall.exe, K
If UninstallSize
    RunWait, C:\Program Files\TAP-Windows\Uninstall.exe,,Hide
return

tapstart:
RunWait, ahkstopclashtap.bat,,Hide
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


stopclash:
MsgBox, 4,, 确定要关闭Clash、关闭系统代理吗？
IfMsgBox, No
    return  ; 如果选择 No, 脚本将会终止.
RunWait, ahkstopclash.bat,,Hide
TrayTip % Format("📢通知📢"),普通模式关闭操作完成
return

startclash:
RunWait, ahkrestartclash.bat,,Hide
Process,Exist, clash-win64.exe ; 
if ErrorLevel
{
    ClashVar := "开-✅"
}
else
{
    TrayTip % Format("📢启动失败📢"),请用控制台重启，查看报错信息。
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
TrayTip % Format("📢启动成功📢"),运行  模式：%ModeVar%`nClash状态：%ClashVar%`n系统  代理：%ProxyVar%
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
    IniRead, Dash, %A_ScriptDir%\api\default.ini, SET, defaultdashboard
    if (Dash = "Razord")
    {
        RunWait, ahkopendashboard.bat,,Hide
    }
    else
    {
        Run, %A_ScriptDir%\Profile\dashboard_%Dash%\index.html
    }
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