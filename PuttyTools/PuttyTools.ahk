#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force
AppName = PuttyTools
Version = 0.05
INI = PTools.ini
LOG = PTools_log.txt
inipath = %A_ScriptDir%\%INI%
logpath = %A_ScriptDir%\%LOG%
Enabled = disabled
Defaults = Support Stamp||history|su -|grep MemTotal /proc/meminfo|free -m|netstat -anp --udp --tcp #PIPE# grep LISTEN

OldPutty = 
OldPuttyWindowsCount =
ReloadCount = 

gosub, ReadINI

Menu, Context, add, Clear Action History, ClearHistory
Menu, Context, add, Clear History Log, ClearHistoryLog
Menu, Context, add, Reload, Reload

Gui, +OwnDialogs +owner -MaximizeBox -MinimizeBox +LastFound +AlwaysOnTop
Gui, Color, 424242
Gui, Font, c01DF01
Gui, Add, Text, x10 y9, Active:
Gui, Add, DDL, y6 x50 w220 gSticky vPuttyWindows,
Gui, Add, Button, y5 x275 w50 gClearOpenPutty, Fetch
Gui, Add, Text, x10 y35, Action: 
Gui, Add, ComboBox, x50 y32 w220 vActions, %History%
Gui, Add, Button, y31 x275 w50 vRunButton Default gRun, Run
Gui, Add, StatusBar, vstatusbar, 
;Gui, Add, Button, x10 vHistory gHistory, History
;Gui, Add, Button, vSupport_History gSupport_History, Support History
;Gui, Add, Button, vReload gGetWindowCount, GetWindowCount
Gui, Show,, %AppName% %version%
GuiControl,Choose,Actions, 1 
;GoSub, ClearOpenPutty
;GoSub, GetOpenPutty
GoSub, GetWindowCount
return

ClearOpenPutty:
GuiControl,, PuttyWindows, |
OpenPutty :=
goSub, GetOpenPutty
return

Sticky:
if(Follow != 1){
	return
}
Gui, Submit, NoHide
WinActivate, %PuttyWindows%
WinGetPos, X, Y, Width, Height, %PuttyWindows%
Newx = %X%
Newy := y + Height
;WinMove,%AppName% %version%,%newx%,%newy%,,,
Gui, Hide
Gui, Show, y%NewY% x%NewX%, %AppName% %version%
WinActivate, %PuttyWindows%
WinGet, id, list,,, %PuttyWindows%
Loop, %id%
{
    this_id := id%A_Index%
}
;Gui, +parent%this_id%
return

GetOpenPutty:
Gui, Submit, Nohide
WinGet, id, list,,, Program Manager
Loop, %id%
{
    this_id := id%A_Index%
    ;WinActivate, ahk_id %this_id%
    WinGetClass, this_class, ahk_id %this_id%
    WinGetTitle, this_title, ahk_id %this_id%
	if(this_class = "PuTTY"){
		StringGetPos, pos, OpenPutty, %this_title%|
			if(pos <= 0){
			OpenPutty = %OpenPutty%|%this_title%
			GuiControl,, PuttyWindows, %this_title%|
			otherwindows = %otherwindows%|%this_title%
			}
			else{
			GuiControl,, PuttyWindows, %this_title%||
			OpenPutty = %this_title%||
			topwindow = %this_title%
			}
	}
	NewPutty = %topwindow%%otherwindows%
	if(OpenPutty != OldOpenPutty){
		;GuiControl,, PuttyWindows, |%topwindow%%otherwidnows%
		;tooltip %NewPutty%`n%OldPutty%
	}


	Gui, Submit, Nohide
	If(PuttyWindows = null){
			GuiControl, Disable, RunButton
	}
	else{
			GuiControl, Enable, RunButton
	}

	GuiControl,Choose,PuttyWindows, 1 
	OldOpenPutty = %OpenPutty%
	;GuiControl,, PuttyWindows, %OpenPutty%
	If(Autofind = 1){
		;SetTimer, ClearOpenPutty, 5000
	}
}
return

GetWindowCount:
PuttyWindowsCount = 0
TotalWindowsCount = 0
WinGet, id, list,,, Program Manager
Loop, %id%
{
    this_id := id%A_Index%
    ;WinActivate, ahk_id %this_id%
    WinGetClass, this_class, ahk_id %this_id%
    WinGetTitle, this_title, ahk_id %this_id%
	if(this_class = "PuTTY"){
		puttywindowscount ++
		totalwindowscount ++
	}
	else{
		totalwindowscount ++
	}
}
if(puttywindowscount != %oldputtywindowscount%)
	{
		;ReloadCount ++
		GoSub, ClearOpenPutty
	}
	else{
	}
;GuiControl,,StatusBar, %puttywindowscount% / %totalwindowscount% (%Puttywindowscount% %oldputtywindowscount% %ReloadCount%)
GuiControl,,StatusBar, %puttywindowscount% Active SSH Sessions - %totalwindowscount% Open Windows
OldTotalWindowsCount = %TotalWindowsCount%
OldPuttyWindowsCount = %PuttyWindowsCount%
SetTimer, GetWindowCount, 2500
return

Run:
Gui, Submit, NoHide
StringReplace, actions, actions, #PIPE#, |, All

if(actions = "Support Stamp"){
gosub, Support_History
}
else if(actions = "History"){
gosub, History
}
else if(actions = "su -"){
WinActivate, %PuttyWindows%
Send su - {return}
}
else{
WinActivate, %PuttyWindows%
Send %Actions% {return}
}
;GuiControl,Choose,Actions, 1 
StringReplace, actions, actions, |, #PIPE#, All
StringGetPos, pos, History, %actions%
if pos <= 0
{
	History = %History%|%actions%
	Iniwrite, %History%, %inipath%, Preferences, History
	GuiControl,, Actions, %actions%
}
MESSAGE = %UserName% ran %Action% on %PuttyWindows%
FileAppend, %MESSAGE%`n`r ,%LogFile%
return

GuiContextMenu:
Menu, Context, Show
return

History:
Gui, Submit, NoHide
WinActivate, %PuttyWindows%
Send history {return}
return

Support_History:
Gui, Submit, NoHide
WinActivate, %PuttyWindows%
Send export HISTFILE=~/.support_history; echo "%UserName% - Professional Hosting Services"
Send {return}
return


ReadINI:
IniRead, UserName, %inipath%, Preferences, UserName
if(UserName = "?" || UserName == "ERROR"){
	UserName = %A_UserName%
	Iniwrite, %UserName%, %inipath%, Preferences, UserName
	IniRead, UserName, %inipath%, Preferences, UserName
}
IniRead, History, %inipath%, Preferences, History
if(History = "?" || History == "ERROR"){
	History = %Defaults%
	Iniwrite, %History%, %inipath%, Preferences, History
	IniRead, History, %inipath%, Preferences, History
}
IniRead, AutoFind, %inipath%, Preferences, AutoFind
if(AutoFind = "?" || AutoFind == "ERROR"){
	AutoFind = 0
	Iniwrite, %AutoFind%, %inipath%, Preferences, AutoFind
	IniRead, AutoFind, %inipath%, Preferences, AutoFind
}
IniRead, Follow, %inipath%, Preferences, Follow
if(Follow = "?" || Follow == "ERROR"){
	Follow = 1
	Iniwrite, %Follow%, %inipath%, Preferences, Follow
	IniRead, Follow, %inipath%, Preferences, Follow
}
return

ClearHistory:
Iniwrite, %Defaults%, %inipath%, Preferences, History
GuiControl,, Actions, |%Defaults%
return

ClearHistoryLog
FileDelete, %LogFile%
return

Reload:
Reload
return