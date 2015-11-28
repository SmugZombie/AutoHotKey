; ######################################
;       ScreenSafe
;       Smug Dev
;       http://smugzombie.com
;		2013
; ######################################
#NoEnv
#Persistent
#SingleInstance Force
SendMode Input
#InstallKeybdHook
Menu, tray, NoStandard
Menu, tray, add, Exit, terminate  ; Creates a new menu item.
Menu, tray, add, Reload, Reloadit  ; Creates a new menu item.

IfExist, safe.ini
	FileReadLine, SelectedFile, safe.ini, 1
IfNotExist, safe.ini
	FileSelectFile, SelectedFile, 3, , Open a file, 
	WriteConfig(SelectedFile)

Run, TASKKILL /F /IM explorer.exe
TrayTip, NoExplorer.., 
SetTimer, RemoveTrayTip, 1500
Run, %SelectedFile%
sleep 15000
ExitApp
return

terminate:
{
   ExitApp
}

F8::
Winset, AlwaysOnTop, off, ahk_id %currentWindow%
TrayTip, , AlwaysOnTop OFF
SetTimer, RemoveTrayTip, 1500
FileSelectFile, SelectedFile, 3, , Open a file, 
Run, %SelectedFile%
return

WriteConfig(SelectedFile)
{
	IfExist, safe.ini
		FileDelete, safe.ini
	FileAppend, %SelectedFile%, safe.ini
}

RemoveTrayTip:
SetTimer, RemoveTrayTip, Off
TrayTip
return

Reloadit:
{
	Reload
	return
}