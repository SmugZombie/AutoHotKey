; SmugDev getIP2.ahk
; github.com/SmugZombie

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

ips = %A_IPAddress1%,%A_IPAddress2%,%A_IPAddress3%,%A_IPAddress4%
 
Loop, parse, ips, `,
{
	currentIP = %A_LoopField%
	if (currentIP != "0.0.0.0"){
		MsgBox, %currentIP%
	}
}
