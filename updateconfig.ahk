programName:="ClashWeb By Nico"
SetWorkingDir %A_ScriptDir%
RunWait, ahkclashweb.bat save,,Hide
FileDelete, %A_ScriptDir%\App\tmptmp.vbs
FileCopy, %A_ScriptDir%\App\tmp.vbs, %A_ScriptDir%\App\tmptmp.vbs
Run, %A_ScriptDir%\bat\subconverter.bat,,Hide 
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
Return