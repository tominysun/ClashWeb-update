;获取管理员权限
full_command_line := DllCall("GetCommandLine", "str")
if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
    try
    {
        if A_IsCompiled
            Run *RunAs "%A_ScriptFullPath%" /restart
        else
            Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
    }
    ExitApp
}
;获取结束

;设置文件目录
SetWorkingDir %A_ScriptDir%

;托盘目录
programName:="ClashWeb By Nico"
Menu, Tray, NoStandard
Menu, Tray, Icon, clash-logo.ico,1,1
#Persistent  ; 让脚本持续运行, 直到用户退出.
Menu, Tray, Add  ; 创建分隔线.'
Menu, tray, Add, 切换节点, MenuHandlerdashboard
Menu, tray, Add, 更新配置, updateconfigmanually
Menu, tray, Add, 配置管理, SetConfig
Menu, tray, Add, 定时更新, autoupdate

Menu, Tray, Add  ; 创建分隔线.
Menu, Submenu, Add, 启动, startclash
Menu, Submenu, Add, 关闭, stopclash
Menu, tray, add, 普通模式, :Submenu  
Menu, tunmenu, Add, 启动, tunstart
Menu, tunmenu, Add, 关闭, tunstop
Menu, tunmenu, Add, 配置, tunconfig
Menu, tray, add, Tun模式, :tunmenu  

Menu, Tray, Add  ; 创建分隔线.
Menu, Submenu3, Add, 规则, rulemode  
Menu, Submenu3, Add, 全局, globalmode
Menu, Submenu3, Add, 直连, directmode
Menu, tray, add, 代理模式, :Submenu3 
Menu, Submenu2, Add, 开启系统代理, setsys  
Menu, Submenu2, Add, 关闭系统代理, dissys
Menu, Submenu2, Add, 检查系统代理, checksys
Menu, tray, add, 系统代理, :Submenu2

Menu, Tray, Add  ; 创建分隔线.
Menu, Submenu6, Add  ; 
Menu, Submenu5, Add, 打开控制台, clashweb 
Menu, Submenu5, Add, 关闭控制台, MenuHandlerstoppython  
Menu, Submenu6, add, 控制后台, :Submenu5
Menu, Submenu6, Add, 面板设置, defaultdashboard 
Menu, Submenu6, Add, 内核设置, defautlcore 
Menu, Submenu6, Add, Geoip设置, defaultgeoip
Menu, Submenu6, Add  ; 
Menu, Submenu6, Add, 控制后台端口, defautlclashwebpoart
Menu, Submenu6, Add, 默认系统代理, defautlsys
Menu, Submenu6, Add, 开机自启设置, bootset
Menu, Submenu6, Add  ; 
Menu, Submenu6, Add, UWP回环, uwp
Menu, Submenu6, Add, 帮助/捐赠, help
Menu, Submenu6, Add  ; 
Menu, tray, add, 其他设置, :Submenu6
Menu, Tray, Click, OnClick 
Menu, Tray, Add, 检查状态, OnClick
Menu, Tray, Add, 退出, MenuHandlerexit  
Menu, Tray, Default, 检查状态
Menu, Tray, Add  ; 创建分隔线.
Menu,Tray,Tip,%programName% 

;启动时选择普通或者tun模式
Process,Exist, clash-win64.exe ;                         
if ErrorLevel
{   
}
else
{
    FileReadLine, oUrl, %A_ScriptDir%\api\currentmode.py, 1
    Needle := "tun"
    If InStr(oUrl, Needle)
    {
        Menu, tray, Check,Tun模式
        Menu, tunmenu, Check,启动
    }
    else
    {
        Menu, tray, Check,普通模式
        Menu, Submenu, Check,启动
    }
    RunWait, ahkclashweb.bat restartconfig,,Hide
    FileAppend, `n%A_Now%-startup clash , %A_ScriptDir%\log.log
}

;启动时设置代理模式
Menu, tray, Check,代理模式
IniRead, Dash, %A_ScriptDir%\api\default.ini, SET, rulemode
if (Dash = "Rule")
{
    goto, rulemode
}
if (Dash = "Direct")
{
    goto, directmode
}
if (Dash = "Global")
{
    goto, globalmode
}

;设置图标与Check
goto, seticon

;启动时启动自动更新
Menu, tray, Check,定时更新
IniRead, Dash, %A_ScriptDir%\api\default.ini, SET, autoupdate
;启动时启动自动更新
if (Dash = "none")
{
    Menu, tray, UnCheck,定时更新
}
else
{
    Process,Close,autoupdate.exe
    Run, autoupdate.exe
}

;任务栏图标双击单击效果
Sleep, 100
OnClick:
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
;启动结束

;设置图标与Check
seticon:
FileReadLine, oUrl, %A_ScriptDir%\api\currentmode.py, 1
Needle := "tun"
If InStr(oUrl, Needle)
{
    Menu, Tray, Icon, %A_ScriptDir%\static\icon\tun.ico,1,1
}
else
{
    RegRead, proxy,HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyEnable
    if ( proxy > 0 )
    { 
        Menu, tray, Check,系统代理
        Menu, Submenu2, Check,开启系统代理
        Menu, Submenu2, UnCheck,关闭系统代理
        Menu, Tray, Icon, %A_ScriptDir%\static\icon\enable.ico,1,1
    }
    else
    {
        Menu, tray, unCheck,系统代理
        Menu, Submenu2, Check,关闭系统代理
        Menu, Submenu2, UnCheck,开启系统代理
        Menu, Tray, Icon, %A_ScriptDir%\static\icon\disable.ico,1,1
    }
}
;检测代理模式
Menu, tray, Check,代理模式
IniRead, Dash, %A_ScriptDir%\api\default.ini, SET, rulemode
if (Dash = "Rule")
{
    Menu, Submenu3, Check,规则
    Menu, Submenu3, UnCheck,直连
    Menu, Submenu3, UnCheck,全局
}
if (Dash = "Direct")
{
    Menu, Submenu3, UnCheck,规则
    Menu, Submenu3, Check,直连
    Menu, Submenu3, UnCheck,全局
}
if (Dash = "Global")
{
    Menu, Submenu3, UnCheck,规则
    Menu, Submenu3, UnCheck,直连
    Menu, Submenu3, Check,全局
    Menu, Tray, Icon, %A_ScriptDir%\static\icon\global.ico,1,1
}
return

;单击检测状态
SingleClickEvent:
LastClick := 0
Goto, MenuHandlercheck 
return

;双击打开面板
DoubleClickEvent:
LastClick := 0
Goto, MenuHandlerdashboard
return

;三击保存节点
TripleClickEvent:
LastClick := 0
Goto, savenode
return

;手动更新设置
updateconfigmanually:
    FileReadLine, oUrl, %A_ScriptDir%\App\tmp.vbs, 1
    config := StrSplit(oUrl, "Profile\")
    config := config[2]
    config := StrSplit(config, "yaml")
    config := config[1]  
    Needle := "provider"
    ;MsgBox %config%
    If InStr(config, Needle)
    {
        IniRead, temp, %A_ScriptDir%\api\default.ini, SET, autoupdate
        IniRead, temp1, %A_ScriptDir%\api\default.ini, SET, providerupdatetime
        IniRead, temp2, %A_ScriptDir%\api\default.ini, SET, providerlastupdatetime
        StringMid, yearmodi, temp2, 1, 4
        StringMid, monthmodi, temp2, 5, 2
        StringMid, datemodi, temp2, 7, 2
        StringMid, hourmodi, temp2, 9, 2
        StringMid, minmodi, temp2, 11, 2
        TimeModi = %yearmodi%/%monthmodi%/%datemodi% %hourmodi%:%minmodi%
        Gui, Destroy
        Gui, Add, Text,, `n`n当前配置：%config%yaml`n
        Gui, Add, Text,, 定时更新模式状态：%temp%`n
        Gui, Add, Text,, Provider定时更新间隔：%temp1%s`n
        Gui, Add, Text,, Provider上次更新时间：%TimeModi%`n
        Gui, Add, Button, Default w300, 手动更新Provider
        Gui, Add, Button, xp+310 yp w300, 手动更新配置文件
        Gui, Show
    }
    Else
    {
        goto, updateconfig
    }
return

updateconfigmanuallybac:
    FileReadLine, oUrl, %A_ScriptDir%\App\tmp.vbs, 1
    config := StrSplit(oUrl, "Profile\")
    config := config[2]
    config := StrSplit(config, "yaml")
    config := config[1]  
    Needle := "provider"
    ;MsgBox %config%
    If InStr(config, Needle)
    {
        FileReadLine, oUrl, %A_ScriptDir%\Profile\%config%yaml, 1
        cUrl := StrSplit(oUrl, ":http")
        cUrl := cUrl[2]
        cUrl := StrSplit(cUrl, "NicoNewBeee")
        cUrl := cUrl[1]
        cUrl =  http%cUrl%
        if ( cUrl = "http")
            cUrl = "未检测到订阅地址，手动更新配置文件无效，"
        ;MsgBox %cUrl%
        IniRead, temp, %A_ScriptDir%\api\default.ini, SET, autoupdate
        IniRead, temp1, %A_ScriptDir%\api\default.ini, SET, providerupdatetime
        IniRead, temp2, %A_ScriptDir%\api\default.ini, SET, providerlastupdatetime
        Gui, Destroy
        Gui, Add, Text,, `n`n当前配置：%config%yaml`n`n`n当前订阅：`n
        Gui, Add,Edit, w620va,%cUrl%
        Gui, Add, Text,, `n定时更新模式状态：%temp%`n
        Gui, Add, Text,, Provider定时更新间隔：%temp1%s`n
        Gui, Add, Text,, Provider上次更新时间：%temp2%`n
        Gui, Add, Button, Default w300, 手动更新Provider
        Gui, Add, Button, xp+310 yp w300, 手动更新配置文件
        Gui, Show
    }
    Else
    {
        goto, updateconfig
    }
return

;手动更新配置文件
Button手动更新配置文件:
Gui,Destroy
goto, updateconfig
return


;手动更新provider
Button手动更新Provider:
Gui,Destroy
RunWait, ahkclashweb.bat updateruleprovider,,Hide
RunWait, ahkclashweb.bat updateproxyprovider,,Hide
RunWait, ahkclashweb.bat restartconfig,,Hide
IniWrite, %A_Now%, %A_ScriptDir%\api\default.ini, SET, providerlastupdatetime 
FileAppend, `n%A_Now%-update provider manually, %A_ScriptDir%\log.log
Process,Close,autoupdate.exe
Run, autoupdate.exe
TrayTip % Format("📢通知📢"),手动更新Provider
Return

;定时更新设置
autoupdate:
    FileReadLine, oUrl, %A_ScriptDir%\App\tmp.vbs, 1
    config := StrSplit(oUrl, "Profile\")
    config := config[2]
    config := StrSplit(config, "yaml")
    config := config[1]  
    Needle := "provider"
    If InStr(config, Needle)
    {
        IniRead, temp, %A_ScriptDir%\api\default.ini, SET, autoupdate
        IniRead, temp1, %A_ScriptDir%\api\default.ini, SET, providerupdatetime
        Gui, Destroy
        Gui, Add, Text,, `n`n定时更新模式状态：%temp%
        Gui, Add, Text,, 修改Provider自动更新时间，单位：s`n
        Gui, Add,Edit, w490 va,%temp1%
        Gui, Add, Text,, 
        Gui, Add, Button, Default w150, Provider定时更新
        Gui, Add, Button, xp+170 yp w150, 关闭定时更新
        Gui, Show
    }
    Else
    {
        IniRead, temp, %A_ScriptDir%\api\default.ini, SET, autoupdate
        IniRead, temp3, %A_ScriptDir%\api\default.ini, SET, configupdatetime
        Gui, Destroy
        Gui, Add, Text,, `n`n定时更新状态：%temp%
        Gui, Add, Text,, 修改普通文件（非Provider）自动更新时间，单位：s`n
        Gui, Add,Edit, w490 va,%temp3%
        Gui, Add, Text,, 
        Gui, Add, Button, Default w150, 普通配置定时更新
        Gui, Add, Button, xp+170 yp w150, 关闭定时更新
        Gui, Show
    }
return

Button普通配置定时更新:
Gui,Submit
    IniWrite, nomal, %A_ScriptDir%\api\default.ini, SET, autoupdate
    IniWrite, %a%, %A_ScriptDir%\api\default.ini, SET, configupdatetime
    Process,Close,autoupdate.exe
    Run, autoupdate.exe
    Menu, tray, Check,定时更新
    FileAppend, `n%A_Now%-change nomal update period, %A_ScriptDir%\log.log
Return

ButtonProvider定时更新:
Gui,Submit
    IniWrite, provider, %A_ScriptDir%\api\default.ini, SET, autoupdate
    IniWrite, %a%, %A_ScriptDir%\api\default.ini, SET, providerupdatetime
    Process,Close,autoupdate.exe
    Run, autoupdate.exe
    Menu, tray, Check,定时更新
    FileAppend, `n%A_Now%-change provider update period, %A_ScriptDir%\log.log
Return

Button关闭定时更新:
Gui,Submit
    IniRead, mode, %A_ScriptDir%\api\default.ini, SET, autoupdate
    if ( mode = "nomal")
    {
        MsgBox, 0, , 关闭普通模式自动更新 ,5
        IniWrite, none, %A_ScriptDir%\api\default.ini, SET, autoupdate
    }
    if （ mode = "provider"）
    {
        MsgBox, 0, , 关闭Provider自动更新,3
        IniWrite, none, %A_ScriptDir%\api\default.ini, SET, autoupdate
    }
    if （ mode = "none"）
    {
        MsgBox, 0, , 已经是关闭状态 ,3
        IniWrite, none, %A_ScriptDir%\api\default.ini, SET, autoupdate
    }
    Process,Close,autoupdate.exe
    Menu, tray, UnCheck,定时更新
    FileAppend, `n%A_Now%-disable autoupdate, %A_ScriptDir%\log.log
Return


;开机自启设置
bootset:
RunWait,  %A_ScriptDir%\App\startup1.bat
return

;普通模式uwp循环代理
uwp:
RunWait,  %A_ScriptDir%\bat\uwp.bat,,Hide
return

;选择geoip并更新
defaultgeoip:
MsgBox, 3,, "是"：原版geoip`n"否"：ipip版geoip
IfMsgBox, No
    Goto, ipipgeoip
IfMsgBox, Yes
    Goto, geoip
return

;选择面板
defaultdashboard:
MsgBox, 3,, "是"：Razord面板`n"否"：Yacd面板
IfMsgBox, No
    IniWrite, yacd, %A_ScriptDir%\api\default.ini, SET, defaultdashboard 
IfMsgBox, Yes
    IniWrite, Razord, %A_ScriptDir%\api\default.ini, SET, defaultdashboard 
return

;启动时是否开启系统代理
defautlsys:
MsgBox, 3,, "是"：普通模式启动Clash时开启系统代理`n"否"：普通模式启动Clash时不开启系统代理
IfMsgBox, No
    IniWrite, False, %A_ScriptDir%\api\default.ini, SET, opensysafterstartclash 
IfMsgBox, Yes
    IniWrite, True, %A_ScriptDir%\api\default.ini, SET, opensysafterstartclash  
return

;设置ClashWeb控制后台端口号
defautlclashwebpoart:
InputBox, OutputVar2, 请输入控制后台端口号, , 140, 480
if ErrorLevel
    return
else
    IniWrite, %OutputVar2%, %A_ScriptDir%\api\default.ini, SET, clashweb
    TrayTip % Format("📢通知📢"),修改控制台端口成功，请重新打开控制台
    return

;更新当前配置
updateconfig:
RunWait, ahkclashweb.bat save,,Hide
FileDelete, %A_ScriptDir%\App\tmptmp.vbs
FileCopy, %A_ScriptDir%\App\tmp.vbs, %A_ScriptDir%\App\tmptmp.vbs
RunWait, ahkclashweb.bat updateconfig,,Hide
IniRead, ifsuccess, %A_ScriptDir%\api\default.ini, SET, configdownload
if (ifsuccess = "success")
{
    RunWait, ahkclashweb.bat restartconfig,,Hide
    TrayTip % Format("📢通知📢"),更新当前配置并重启操作完成！ 
}
else
{
    TrayTip % Format("📢通知📢"),下载失败
}
FileAppend, `n%A_Now%-update config manually, %A_ScriptDir%\log.log
Return

;选择32/64内核
defautlcore:
MsgBox, 3,, "是"：切换为64位内核`n"否"：切换为32位内核`ntun模式默认64位，32位系统需替换Profile\wintun.dll（可在App\wintun里找到源文件）
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
Run, %A_ScriptDir%\App\donate.jpg
Run, https://lzdnico.github.io/niconewbeee.github.io/document/2021/03/13/ClashWeb.html
return

nothing:
return

;配置管理添加订阅   
Button添加:
Goto,Url
return

;配置管理添加订阅 
Url:
    Gui, Destroy
    Gui, Add, Text,, 订阅链接:
    Gui, Add, Edit,w500 vsubUrl
    Gui, Add, Text,, 配置名称，不支持中文(例如：nico):
    Gui, Add, Edit,w500 vsubName
    Gui, Add, Button, Default, 保存
    Gui, Show
return

;配置管理保存订阅
Button保存:
    Gui, Submit
    If (subUrl <> "" And subName <> ""){
        Needle := ".yaml"
        IfInString, subName, %Needle%
        {

        }
        else
        {
            subName := subName ".yaml"
        }
        FileDelete, %A_ScriptDir%\Profile\%subName%  
        FileAppend, #托管地址: , %A_ScriptDir%\Profile\%subName% , UTF-8  
        FileAppend, %subUrl% , %A_ScriptDir%\Profile\%subName%  
        FileAppend, NicoNewBeee的Clash控制台 , %A_ScriptDir%\Profile\%subName% 
        Gui, Destroy
        goto, SetConfig
    }
return

Button订阅转换:
Run, %A_ScriptDir%\Profile\sub-web\index.html
goto,SetConfig
return

Button打开目录:
Run, %A_ScriptDir%\Profile
return

Button查看:
Gui, Submit
Run, open "%A_ScriptDir%\Profile\%NameText%"
goto,SetConfig
return

Button修改:
    Gui, Submit
    Gui, Destroy
    Gui, Add, Text,, 所选配置
    Gui, Add,Edit, w500 va,%NameText%
    Gui, Add, Text,, 订阅地址
    Gui, Add,Edit, w500 vb,%Urltext%
    Gui, Add, Button, Default w80, 确认修改
    Gui, Add, Button, xp+90 yp w80, 订阅/转换
    Gui, Add, Button, xp+90 yp w80, 取消
    Gui, Show
return

Button确认修改:
Gui, Submit
    Needle := ".yaml"
    IfInString, a, %Needle%
    {

    }
    else
    {
        a := a ".yaml"
    }
    FileDelete, %A_ScriptDir%\Profile\%a%  
    FileAppend, #托管地址: , %A_ScriptDir%\Profile\%a% , UTF-8  
    FileAppend, %b% , %A_ScriptDir%\Profile\%a%  
    FileAppend, NicoNewBeee的Clash控制台 , %A_ScriptDir%\Profile\%a% 
    Gui, Destroy
    goto, SetConfig
return

Button订阅/转换:
Run, %A_ScriptDir%\Profile\sub-web\index.html
goto,Button修改
return

Button更新:
Gui, Submit
RunWait, ahkclashweb.bat save,,Hide
FileDelete, %A_ScriptDir%\App\tmptmp.vbs  
var := "CreateObject(""WScript.Shell"").Run ""clash-win64 -d .\Profile -f .\Profile\"
FileAppend, %var% , %A_ScriptDir%\App\tmptmp.vbs 
FileAppend, %NameText% , %A_ScriptDir%\App\tmptmp.vbs 
var := """,0"
FileAppend, %var% , %A_ScriptDir%\App\tmptmp.vbs  
RunWait, ahkclashweb.bat updateconfig,,Hide
IniRead, ifsuccess, %A_ScriptDir%\api\default.ini, SET, configdownload
if (ifsuccess = "success")
{
    TrayTip % Format("📢通知📢"),更新成功 
    MsgBox, 4,,%NameText%更新成功，是否重启？
    IfMsgBox, Yes
    {
        FileDelete, %A_ScriptDir%\App\tmp.vbs  
        var := "CreateObject(""WScript.Shell"").Run ""clash-win64 -d .\Profile -f .\Profile\"
        FileAppend, %var% , %A_ScriptDir%\App\tmp.vbs 
        FileAppend, %NameText% , %A_ScriptDir%\App\tmp.vbs 
        var := """,0"
        FileAppend, %var% , %A_ScriptDir%\App\tmp.vbs   
        Gui, Destroy
        RunWait, ahkclashweb.bat restartconfig,,Hide
        TrayTip % Format("📢通知📢"),重启操作成功

        ;切换配置文件时配置自动更新
        IniRead, temp, %A_ScriptDir%\api\default.ini, SET, autoupdate
        if ( temp = "none" ) ;检测到没有设置自动
        {           
            Process,Close,autoupdate.exe      
        }
        else  ;根据所选配置文件名称，选择自动更新模式
        {
            FileReadLine, oUrl, %A_ScriptDir%\App\tmp.vbs, 1
            config := StrSplit(oUrl, "Profile\")
            config := config[2]
            config := StrSplit(config, "yaml")
            config := config[1] 
            Needle := "provider"
            If InStr(config, Needle) ;Provider定时更新
                IniWrite, provider, %A_ScriptDir%\api\default.ini, SET, autoupdate 
            else
                IniWrite, nomal, %A_ScriptDir%\api\default.ini, SET, autoupdate 
            Process,Close,autoupdate.exe
            Run, autoupdate.exe
        }

        return
    }         
    goto,SetConfig    
}
else
{
    TrayTip % Format("📢通知📢"),下载失败
    goto,SetConfig
}

return

Button启动:
RunWait, ahkclashweb.bat save,,Hide
Gui, Submit
FileDelete, %A_ScriptDir%\App\tmp.vbs  
var := "CreateObject(""WScript.Shell"").Run ""clash-win64 -d .\Profile -f .\Profile\"
FileAppend, %var% , %A_ScriptDir%\App\tmp.vbs 
FileAppend, %NameText% , %A_ScriptDir%\App\tmp.vbs 
var := """,0"
FileAppend, %var% , %A_ScriptDir%\App\tmp.vbs   
Gui, Destroy
RunWait, ahkclashweb.bat restartconfig,,Hide
FileAppend, `n%A_Now%-restart config from selected , %A_ScriptDir%\log.log
TrayTip % Format("📢通知📢"),启动操作成功

;切换配置文件时配置自动更新
IniRead, temp, %A_ScriptDir%\api\default.ini, SET, autoupdate
if ( temp = "none" ) ;检测到没有设置自动
{    
    Process,Close,autoupdate.exe             
}
else  ;根据所选配置文件名称，选择自动更新模式
{
    FileReadLine, oUrl, %A_ScriptDir%\App\tmp.vbs, 1
    config := StrSplit(oUrl, "Profile\")
    config := config[2]
    config := StrSplit(config, "yaml")
    config := config[1] 
    Needle := "provider"
    If InStr(config, Needle) ;Provider定时更新
        IniWrite, provider, %A_ScriptDir%\api\default.ini, SET, autoupdate 
    else
        IniWrite, nomal, %A_ScriptDir%\api\default.ini, SET, autoupdate 
    Process,Close,autoupdate.exe
    Run, autoupdate.exe
}
return

Button删除:
Gui, Submit
MsgBox, 4,, 所选配置:%NameText%，是否删除
IfMsgBox, Yes
{
    NewStr := StrReplace(NameText, "yaml", "txt")
    FileDelete, %A_ScriptDir%\Profile\%NameText%
    FileDelete, %A_ScriptDir%\Profile\tunconfig\%NameText%
    FileDelete, %A_ScriptDir%\Profile\save\%NewStr%
} 
Gui, Destroy
goto, SetConfig
return

Button取消:
goto, SetConfig
return

;配置文件管理
SetConfig:
    FileReadLine, oUrl, %A_ScriptDir%\App\tmp.vbs, 1
    config := StrSplit(oUrl, "Profile\")
    config := config[2]
    config := StrSplit(config, "yaml")
    config := config[1]  
    config = %config%yaml 
    Gui, Destroy
    Gui, Add, Text,, 当前配置：%config%
    Gui, Add, Text,, 双击配置文件进行下一步操作
    Gui, Add, ListView,r10 w800 Multi AltSubmit gSelectConfigs, 名称|更新日期|大小|订阅地址
    Gui, Add, Button, Default w80, 添加
    Gui, Add, Button, xp+100 yp w80, 订阅转换
    Gui, Add, Button, xp+100 yp w80, 打开目录
    Loop, Profile\*.yaml
    {
        FileReadLine, oUrl, %A_ScriptDir%\Profile\%A_LoopFileName%, 1
        cUrl := StrSplit(oUrl, ":http")
        cUrl := cUrl[2]
        cUrl := StrSplit(cUrl, "NicoNewBeee")
        cUrl := cUrl[1]
        cUrl =  http%cUrl%
        StringMid, monthmodi, A_LoopFileTimeModified, 5, 2
        StringMid, datemodi, A_LoopFileTimeModified, 7, 2
        StringMid, hourmodi, A_LoopFileTimeModified, 9, 2
        StringMid, minmodi, A_LoopFileTimeModified, 11, 2
        TimeModi = %monthmodi%/%datemodi% %hourmodi%:%minmodi%
        LV_Add("", A_LoopFileName, TimeModi, A_LoopFileSizeKB, cUrl) 
    } 
    LV_ModifyCol() ; 根据内容自动调整每列的大小.
    LV_ModifyCol(2,"100 Integer") ; 为了进行排序, 指出列 2 是整数.
    ; 显示窗口并返回. 每当用户点击一行时脚本会发出通知.
    Gui, Show
return

SelectConfigs:
    if A_GuiEvent = DoubleClick
    {
        LV_GetText(NameText, A_EventInfo) ; 从行的第一个字段中获取文本.
        LV_GetText(Urltext, A_EventInfo, 4)
        If (%A_EventInfo%<>0){
            Gui, Destroy
            Gui, Add, Text,, 
            Gui, Add, Text,, 
            Gui, Add, Text,, 所选文件：%NameText% 
            Gui, Add, Text,, 
            Gui, Add, Text,, 
            Gui, Add, Button, Default w80, 启动
            Gui, Add, Button, xp+90 yp w80, 更新
            Gui, Add, Button, xp+90 yp w80, 修改
            Gui, Add, Button, xp+90 yp w80, 查看
            Gui, Add, Button, xp+90 yp w80, 删除
            Gui, Add, Button, xp+90 yp w80, 取消
            Gui, Show
        }
    }
return

geoip:
RunWait, ahkclashweb.bat geoip,,Hide
TrayTip % Format("📢通知📢"),更新切换成Geoip
return

ipipgeoip:
RunWait, ahkclashweb.bat ipip,,Hide
TrayTip % Format("📢通知📢"),更新切换成IPIPgeoip
return

savenode:
RunWait, ahkclashweb.bat save,,Hide
TrayTip % Format("📢通知📢"),保存节点成功
return

admin:
RunWait, ahkopenadmin.bat,,Hide
return

clashweb:
RunWait, ahkclashweb.bat openclashweb,,Hide
return

setsys:
RunWait, %A_ScriptDir%\bat\setsys.bat,,Hide
FileAppend, `n%A_Now%-set sys, %A_ScriptDir%\log.log
gosub, seticon
return

dissys:
RunWait, %A_ScriptDir%\bat\dissys.bat,,Hide
FileAppend, `n%A_Now%-dis sys, %A_ScriptDir%\log.log
gosub, seticon
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
IniRead, Dash, %A_ScriptDir%\api\default.ini, SET, rulemode
FileReadLine, oUrl, %A_ScriptDir%\App\tmp.vbs, 1
config := StrSplit(oUrl, "Profile\")
config := config[2]
config := StrSplit(config, "yaml")
config := config[1]  
config = %config%yaml 
FileReadLine, oUrl, %A_ScriptDir%\api\currentmode.py, 1
    Needle := "tun"
    If InStr(oUrl, Needle)
    {
        Mode := "TUN"
    }
    Else
    {
        Mode := "普通"
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
;MsgBox 当前  配置：%config%`n运行  模式：%Mode%`nClash状态：%ClashVar%`n系统  代理：%ProxyVar%`n代理  模式：%Dash%`n控制  后台：%PythonVar%
TrayTip % Format("📢运行状态📢"), `n运行  模式：%Mode%        %config%`nClash状态：%ClashVar%      %Dash%`n系统  代理：%ProxyVar%`n控制  后台：%PythonVar%
return

tunstart:
Menu, tray, Check, Tun模式
Menu, tray, UnCheck,普通模式
Menu, %A_ThisMenu%, Check, 启动
Menu, %A_ThisMenu%, UnCheck,关闭
Menu, Submenu, UnCheck,启动
Menu, Submenu, UnCheck,关闭
RunWait *RunAs ahkclashweb.bat restarttun,,Hide
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
RegRead, proxy,HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyEnable
if ( proxy > 0 )
{ 
    ProxyVar := "开-✅"
}
else 
{
    ProxyVar := "关-❌"
}
TrayTip % Format("📢启动成功📢"),Clash状态：%ClashVar%`n系统  代理：%ProxyVar%
FileAppend, `n%A_Now%-start tun config manually, %A_ScriptDir%\log.log
gosub, seticon
return

tunstop:
Menu, tray, Check, Tun模式
Menu, tray, UnCheck,普通模式
Menu, %A_ThisMenu%, Check, 关闭
Menu, %A_ThisMenu%, UnCheck,启动
Menu, Submenu, UnCheck,启动
Menu, Submenu, UnCheck,关闭
RunWait, ahkclashweb.bat stoptun,,Hide
FileAppend, `n%A_Now%-stop tun config manually, %A_ScriptDir%\log.log
return

tunconfig:
Run, %A_ScriptDir%\Profile\defaultconfig\tunconfig.yaml
return

stopclash:
MsgBox, 4,, 确定要关闭Clash、关闭系统代理吗？
IfMsgBox, No
    return  ; 如果选择 No, 脚本将会终止.
RunWait, ahkclashweb.bat stopclash,,Hide
Menu, tray, Check, 普通模式
Menu, tray, UnCheck,Tun模式
Menu, %A_ThisMenu%, Check, 关闭
Menu, %A_ThisMenu%, UnCheck,启动
Menu, tunmenu, UnCheck,启动
Menu, tunmenu, UnCheck,关闭
TrayTip % Format("📢通知📢"),普通模式关闭操作完成
FileAppend, `n%A_Now%-stop current config manually, %A_ScriptDir%\log.log
return

startclash:
Menu, tray, Check, 普通模式
Menu, tray, UnCheck,Tun模式
Menu, %A_ThisMenu%, Check, 启动
Menu, %A_ThisMenu%, UnCheck,关闭
Menu, tunmenu, UnCheck,启动
Menu, tunmenu, UnCheck,关闭
RunWait, ahkclashweb.bat restartclash,,Hide
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
RegRead, proxy,HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyEnable
if ( proxy > 0 )
{ 
    ProxyVar := "开-✅"
}
else 
{
    ProxyVar := "关-❌"
}
TrayTip % Format("📢启动成功📢"),Clash状态：%ClashVar%`n系统  代理：%ProxyVar%
FileAppend, `n%A_Now%-start current config manually, %A_ScriptDir%\log.log
gosub, seticon
return

rulemode:
RunWait, ahkclashweb.bat rule,,Hide
IniWrite, Rule, %A_ScriptDir%\api\default.ini, SET, rulemode
FileAppend, `n%A_Now%-set rule mode, %A_ScriptDir%\log.log
gosub, seticon
return

directmode:
RunWait, ahkclashweb.bat direct,,Hide
IniWrite, Direct, %A_ScriptDir%\api\default.ini, SET, rulemode
FileAppend, `n%A_Now%-set direct mode, %A_ScriptDir%\log.log
gosub, seticon
return

globalmode:
RunWait, ahkclashweb.bat global,,Hide
IniWrite, Global, %A_ScriptDir%\api\default.ini, SET, rulemode
FileAppend, `n%A_Now%-set global mode, %A_ScriptDir%\log.log
gosub, seticon
return

MenuHandlerstoppython:
MsgBox, 4,, 确定要关闭Python控制台吗 ? 关闭后网页控制台不可用 ！
IfMsgBox, No
    return  ; 如果选择 No, 脚本将会终止.
RunWait, ahkclashweb.bat stopclashweb,,Hide
Goto, checkpython
return

MenuHandlerdashboard:
Process,Exist, clash-win64.exe ; 
if ErrorLevel
{
    IniRead, Dash, %A_ScriptDir%\api\default.ini, SET, defaultdashboard
    if (Dash = "Razord")
    {
        RunWait, ahkclashweb.bat opendashboard,,Hide
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
Process,Close,autoupdate.exe
RunWait, ahkclashweb.bat myexit,,Hide
FileAppend, `n%A_Now%-quit clashweb, %A_ScriptDir%\log.log
ExitApp