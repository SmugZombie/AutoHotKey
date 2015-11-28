;################################################
;##  Launcher - SmugDev 2013
;##  A Division of SmugDNS
;################################################
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance Force
OnMessage(0x204, "WM_RBUTTONDOWN")
version = 0.01
appname = Launcher
developer = SmugDev
startup = startup.ini

gosub, Startup

ifExist, %startup%
{
	Loop, read, %startup%
	{
	    Loop, parse, A_LoopReadLine, %A_Tab%
	    {
	        Run %A_LoopField%
	    }
	}
}
else{
	FileAppend, , %Startup%
	MsgBox We've just created a %startup% file in the script directory. Each line needs to have a absolute path to what you are expecting to launch. `nFor Example: C:\hello.exe
}

gosub, Terminate
return

terminate:
ExitApp
return

Startup:
SplitPath, A_Scriptname, , , , OutNameNoExt 
LinkFile=%A_Startup%\%OutNameNoExt%.lnk 
IfExist, %LinkFile%
	{
	
	}
Else{
	FileCreateShortcut, %A_ScriptFullPath%, %LinkFile% 
	FileCreateShortcut, %A_Startup% , startup.lnk
}
return