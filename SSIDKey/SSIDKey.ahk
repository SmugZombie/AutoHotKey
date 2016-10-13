#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance, force
#Include WinRun.ahk

APP_NAME := "SSIDKey"
VERSION := "1.2"
TAG_LINE := "Key Viewer"

Menu, tray, NoStandard
Menu, tray, add, %APP_NAME% %VERSION%,DoNothing
Menu, tray, add,
Menu, tray, add, About, About
Menu, tray, add, Reload, ButtonRefresh
Menu, tray, add,
Menu, tray, add, Exit
getCurrentProfile()

Menu, FileMenu, Add, About, About
Menu, FileMenu, Add,
Menu, FileMenu, Add, Exit, Exit

Menu, MyMenuBar, Add, File, :FileMenu
Gui, Menu, MyMenuBar

Gui, Add, Text, x22 y9 w40 h20 , SSID
Gui, Add, Edit, x62 y9 w250 h20 +center +readonly, %SSID%

Gui, Add, Text, x22 y39 w40 h20 , Key
Gui, Add, Edit, x62 y39 w250 h20 +center +readonly, %KEY%

Gui, Add, Button, x160 y65 w50 h20 +default gExit, Close
Gui, Show, x516 y294 h90 w350, %APP_NAME% %VERSION% - %TAG_LINE%

about_message := "This application is simply designed to easily return your current SSID and Auth Key used to connect initially if you forgot. `n`r`n`rMore information about this script and others can be found at: `n`r`n`r    https://github.com/smugzombie `n`r`n`ror by contacting us at: scripts@digdns.com."

Gui 2: Add, GroupBox, x6 y6 w340 h180 , Copyright (C) 2016 Ron Egli
Gui 2: Add, Edit, x16 y25 w320 h150 disabled, %about_message%

Return


Exit:
GuiClose:
ExitApp

DoNothing:
return

ButtonRefresh:
reload
return

About:



Gui 2: -Resize -MinimizeBox -MaximizeBox
Gui 2: Show, h190 w350, %APP_NAME% %VERSION% - About

return

getStatus(){
	global
	current_status := CMDRun("NETSH WLAN SHOW INTERFACE")
	IfInString, current_status, disconnected
	{
		return 0
	}
	Else IfInString, current_status, connected
	{
		return 1
	}
	Else
	{
		return 0
	}
}

getCurrentProfile(){
	global
	if(getStatus() == 1){
		Loop, parse, current_status, `n, `r
		{
			removethis := "    SSID                   : "
			IfInString, A_LoopField, %removethis%
			{
				output :=  A_LoopField
				
				StringReplace, output, output, %removethis%, , All
			}
		}
		SSID := output
		Loop, parse, current_status, `n, `r
		{
			removethis := "    Profile                :"
			IfInString, A_LoopField, %removethis%
			{
				output :=  A_LoopField
				
				StringReplace, output, output, %removethis%, , All
			}
		}
		PROFILE := output

		getKey()
	}
	else{
		SSID := "Not Connected To Wifi"
		KEY := ""
	}
	return
}

getKey(){
	global
	command = netsh.exe wlan show profiles name="%SSID%" key=clear
	result := CMDRun(command)

	Loop, parse, result, `n, `r
	{
		IfInString, A_LoopField, Key Content
		{
			output :=  A_LoopField
		}
	}

	removethis := "    Key Content            : "
	StringReplace, output, output, %removethis%, , All
	KEY := output
}