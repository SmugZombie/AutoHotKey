; restartService.ahk / .exe 
; Restarts windows service on command
; Accepts 1 argument - The service name

if(1 == "")
{
	msgbox, "No Arguments Passed, Exiting!"
}
Else
{
	service = %1%
}

#NoEnv
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

RunWait,sc stop %service%
If (ErrorLevel != 0){
	MsgBox Unable to stop %service%
	return
}
RunWait,sc start %service%
If (ErrorLevel != 0){
	MsgBox Unable to start %service%
}
return
