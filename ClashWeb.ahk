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
Menu, Tray, Add, 退出, MenuHandlerexit1  ; 创建新菜单项.
Menu, Tray, Add  ; 创建分隔线.
return

MenuHandlercheck:
Process,Exist, clash-win64.exe ; 
if ErrorLevel   ; 即既不是空值, 也不是零.
{
    Process,Exist, python.exe ; 
    if ErrorLevel   ; 即既不是空值, 也不是零
        TrayTip % Format("Clash：正在运行"),控制台：在运行
    else
        TrayTip % Format("Clash：正在运行"),控制台：未运行
}
else
{
    Process,Exist, python.exe ; 
    if ErrorLevel   ; 即既不是空值, 也不是零
        TrayTip % Format("Clash：没有运行"),控制台：在运行
    else
        TrayTip % Format("Clash：没有运行"),控制台：未运行
}
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


MenuHandlerexit1:
MsgBox, 4,, 确定只关闭本程序，不改变Clash、Python控制台、系统代理状态?
IfMsgBox, No
    return  ; 如果选择 No, 脚本将会终止.
Exit:
ExitApp


