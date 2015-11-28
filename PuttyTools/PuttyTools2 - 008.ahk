#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force
AppName = PuTTYTools
Version = 0.08
INI = PTools.ini
LOG = PTools_log.txt
inipath = %A_ScriptDir%\%INI%
logpath = %A_ScriptDir%\%LOG%
Enabled = disabled
Defaults = export HISTFILE=~/.support_history; echo "%A_UserName% - Professional Hosting Services"||history|su -|grep MemTotal /proc/meminfo|free -m|netstat -anp --udp --tcp #PIPE# grep LISTEN
gosub, ReadINI
OldPutty = 
OldPuttyWindowsCount =
ReloadCount = 

Menu, tray, NoStandard
Menu, tray, add, Reload, Reload
Menu, tray, add
Menu, tray, add, Quit, terminate

Menu, Logs, add, Open History Log, OpenHistoryLog
Menu, Logs, add, Clear History Log, ClearHistoryLog

Menu, Context, add, Settings, Settings
Menu, Context, add, Clear Action History, ClearHistory
Menu, Context, add, Logs, :Logs
Menu, Context, add,
Menu, Context, add, Reload, Reload
Menu, Context, add, Quit, Terminate

if(GuiChoice = 1){
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
}
else if(GuiChoice = 2){
Gui, +OwnDialogs +owner -MaximizeBox -MinimizeBox +LastFound +AlwaysOnTop
Gui, Color, 424242
Gui, Font, c01DF01
Gui, Add, Text, x10 y9, Active:
Gui, Add, DDL, y6 x50 w220 gSticky vPuttyWindows,
;Gui, Add, Button, y5 x275 w50 gClearOpenPutty, Fetch
Gui, Add, Text, x280 y9, Action: 
Gui, Add, ComboBox, x320 y6 w260 vActions, %History%
Gui, Add, Button, y5 x590 w60 vRunButton Default gRun, Run
Gui, Add, StatusBar, vstatusbar,
}
;Gui, Add, Button, x10 vHistory gHistory, History
;Gui, Add, Button, vSupport_History gSupport_History, Support History
;Gui, Add, Button, vReload gGetWindowCount, GetWindowCount

Gui, 2: -MaximizeBox -MinimizeBox +LastFound +AlwaysOnTop
Gui, 2: Add, Text, x10 y10, User: 
Gui, 2: Add, Edit, x45 y7 w100 readonly, %UserName%
Gui, 2: Add, Text, x10, Gui Choice:
Gui, 2: Add, DDL, disabled x10 vGuiChooser, 2||1| 
Gui, 2: Add, Checkbox, x10 disabled checked vFollowActive ,Follow Active Window?
Gui, 2: Add, Checkbox, disabled checked x10,Always On Top?
Gui, 2: Add, Button, gGui2Close,Ok

Gui, Show, w660, %AppName% %version%
GuiControl,Choose,Actions, 1 
;GoSub, ClearOpenPutty
;GoSub, GetOpenPutty
GoSub, GetWindowCount
return

Settings:
Gui,2: Show,, %AppName% %version% Settings
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
MESSAGE = %UserName% ran %Actions% on %PuttyWindows% at %A_Hour%:%A_Min%:%A_Sec% %A_DD%/%A_MM%/%A_YYYY%
FileAppend, %MESSAGE%`n`r ,%LogPath%

StringReplace, actions, actions, |, #PIPE#, All
StringGetPos, pos, History, %actions%
if pos <= 0
{
	History = %History%|%actions%
	Iniwrite, %History%, %inipath%, Preferences, History
	GuiControl,, Actions, %actions%
}
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
IniRead, AOT, %inipath%, Preferences, AOT
if(AOT = "?" || AOT == "ERROR"){
	AOT = 1
	Iniwrite, %AOT%, %inipath%, Preferences, AOT
	IniRead, AOT, %inipath%, Preferences, AOT
}
IniRead, GuiChoice, %inipath%, Preferences, GuiChoice
if(GuiChoice = "?" || GuiChoice == "ERROR"){
	GuiChoice = 2
	Iniwrite, %GuiChoice%, %inipath%, Preferences, GuiChoice
	IniRead, GuiChoice, %inipath%, Preferences, GuiChoice
}
return

ClearHistory:
MsgBox, 4100, , Are You Sure? This Clears your Action History, 5  ; 5-second timeout.
IfMsgBox, No
    Return  ; User pressed the "No" button.
IfMsgBox, Timeout
    Return ; Timed out.
Iniwrite, %Defaults%, %inipath%, Preferences, History
GuiControl,, Actions, |%Defaults%
return

ClearHistoryLog:
MsgBox, 4100, , Are you sure?, 5  ; 5-second timeout.
IfMsgBox, No
    Return  ; User pressed the "No" button.
IfMsgBox, Timeout
    Return ; Timed out.
FileDelete, %LogPath%
return

OpenHistoryLog:
try{
	run %LogPath%
}
catch e{
	ToolTip, No Logs Yet!
	SetTimer, RemoveToolTip, 3000
}
return

Reload:
Reload
return

RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
return

Gui2Close:
gui, 2: Submit
return

Terminate:
GuiClose:
ExitApp
return