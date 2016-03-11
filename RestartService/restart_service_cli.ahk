; restartService.ahk / .exe 
; Restarts windows service on command
; Accepts 1 argument - The service name

service = %1%

if(service == "")
{
	FileAppend No Argument Provided. Requires 1 argument.`n, *
	return
}

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

RunWait,sc stop %service% ;Stop AdobeARM service.
If (ErrorLevel != 0){
	FileAppend Unable to Stop %service%`n, *
	return
}
RunWait,sc start %service% ;Start AdobeARM service.
If (ErrorLevel != 0){
	FileAppend Unable to Start %service%`n, *
}
return
