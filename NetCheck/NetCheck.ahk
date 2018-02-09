; ######################################
;       NetCheck
;       Smug Dev
;       http://smugzombie.com
;		2013
; ######################################
#NoEnv
#Persistent
#SingleInstance Force
SendMode Input
SetWorkingDir %A_ScriptDir%

app_name = NetCheck
version = v0.2

Menu, tray, NoStandard

Menu, Logs, Add, View Logs, ViewLogs
Menu, Logs, Add, Rotate Logs, RotateLogs

Menu, tray, add, %app_name% %version%, AboutMe
Menu, tray, add, Reload, Reloadit
Menu, tray, add,
Menu, tray, add, Logging, :Logs
Menu, tray, add,
Menu, tray, add, Shutdown, terminate


url = http://digdns.com/ip/
externalIp =
prevExternalIp =
configuration = %A_ScriptDir%\config.ini
output = %A_ScriptDir%\netcheck.log
IniRead, prevExternalIp, %configuration%, Latest, external_ip, ""


main()
return

main() {
	global

	; Get the freshest external IP address
	getExternalIp()

	; Check for changes in IP address
	if(prevExternalIp != externalIp)
	{
		TrayTip, External IP Changed, Prev: %prevExternalIp% `nNew: %externalIp%
		SetTimer, RemoveTrayTip, 4000
	}

	; Set Prev as Current
	prevExternalIp := externalIP

	; Save to ini file for persistance
	IniWrite, %externalIp%, %configuration%, Latest, external_ip

	; Format Timestamp
	FormatTime, TimeString, T12, dddd MMMM d, yyyy hh:mm:ss tt
	; Write to log file
	FileAppend, %TimeString% - %externalIp%`n, %output%

	; Wait 60 seconds to try again
	sleep 60000
	main()
}

getExternalIp() {
	global
	externalIP := UrlGet(url,"")
}

terminate:
{
   ExitApp
}
Reloadit:
{
	Reload
	return
}

AboutMe:
{
	goSub About_Dialog
	return
}

ViewLogs:
{
	Run C:\Windows\Notepad.exe %output%
	return
}

RotateLogs:
{
	IfExist, %output%.1
	{
		FileDelete, %output%.1
	}
	FileMove, %output%, %output%.1
	FileAppend, , %output%
	return
}

About_Dialog:
	QUESTION = This application was created quickly to keep a log of a change to external IP.
	MESSAGE_BODY = This app checks the current external IP every 60 seconds and alerts upon changes. `nIncluding logging when changes occur.
	LINK_TEXT = <A>Visit Developers Other Projects</A>

	Gui, 99:Color, White
	Gui, 99:Font, s12 c0x003399, Segoe UI
	Gui, 99:Add, Text, x18 y9 w557 h45, %QUESTION%
	Gui, 99:Font
	Gui, 99:Add, Text, x26 y50 w525 h30, %MESSAGE_BODY%
	Gui, 99:Font, s9, Segoe UI
	Gui, 99:Add, Link, x18 y125 w319 h15 gDialog_Link, %LINK_TEXT%
	Gui, 99:Add, Text, x18 y153 w557 h17 Disabled, _____________________________________________________________________________________________________________________________________________
	Gui, 99:Add, Button, x487 y176 w88 h26 Default gDialog_submit hWndhSaveBtn, Ok
	Gui, 99:Show, w593 h210, About - NetCheck

	QUESTION = , YES_RADIO = , NO_RADIO = ,
	Return

Dialog_Submit:
	Gui, 99:Destroy
return

Dialog_link:
run https://www.github.com/smugzombie/
return

RemoveTrayTip:
SetTimer, RemoveTrayTip, Off
TrayTip
return

UrlGet(url,data) {
	WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	WebRequest.open("GET",URL, false)
	WebRequest.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
	WebRequest.send(data)
	Return WebRequest.ResponseText
}
