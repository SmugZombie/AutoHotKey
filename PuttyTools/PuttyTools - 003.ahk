#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force
AppName = PuttyTools
Version = 0.03
INI = PTools.ini
inipath = %A_ScriptDir%\%INI%
Enabled = disabled
OldPutty = 

gosub, ReadINI

Menu, Context, add, Reload, Reload

Gui, +OwnDialogs +owner -MaximizeBox -MinimizeBox +LastFound +AlwaysOnTop
Gui, Add, Text, x10 y9, Active:
Gui, Add, DDL, y6 x50 w220 vPuttyWindows,
Gui, Add, Button, y5 x275 w50 gClearOpenPutty, Fetch
Gui, Add, Text, x10 y35, Action: 
Gui, Add, ComboBox, x50 y32 w220 vActions, %History%
Gui, Add, Button, y31 x275 w50 vRunButton  gRun, Run
;Gui, Add, Button, x10 vHistory gHistory, History
;Gui, Add, Button, vSupport_History gSupport_History, Support History
;Gui, Add, Button, vReload gReload, Reload
Gui, Show,, %AppName% %version%
GuiControl,Choose,Actions, 1 
GoSub, ClearOpenPutty
return

ClearOpenPutty:
GuiControl,, PuttyWindows, |
OpenPutty :=
goSub, GetOpenPutty
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
	SetTimer, ClearOpenPutty, 5000
}
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
	History = Support Stamp||history|su -|grep MemTotal /proc/meminfo|free -m|netstat -anp --udp --tcp #PIPE# grep LISTEN
	Iniwrite, %History%, %inipath%, Preferences, History
	IniRead, History, %inipath%, Preferences, History
}
return


Reload:
Reload
return