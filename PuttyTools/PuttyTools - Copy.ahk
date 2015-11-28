#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force
AppName = PuttyTools
Version = 0.01
Enabled = disabled

Gui, +OwnDialogs +owner -MaximizeBox -MinimizeBox +LastFound +AlwaysOnTop
Gui, Add, Text, x10 y10, Active:
Gui, Add, DDL, y7 x50 vPuttyWindows,
Gui, Add, Button, y6 x175 gClearOpenPutty, (?)
Gui, Add, Text, x10 y35, Action: 
Gui, Add, ComboBox, x50 y32 vActions %Enabled%, Support Stamp||History|su -
Gui, Add, Button, y31 x175 vRunButton %Enabled% gRun, Run
;Gui, Add, Button, x10 vHistory gHistory, History
;Gui, Add, Button, vSupport_History gSupport_History, Support History
Gui, Add, Button, vReload gReload, Reload
Gui, Show,, %AppName% %version%
GuiControl,Choose,Actions, 1 
GoSub, ClearOpenPutty
return

ClearOpenPutty:
;GuiControl,, PuttyWindows, 
OpenPutty :=
goSub, GetOpenPutty
return

GetOpenPutty:
WinGet, id, list,,, Program Manager
Loop, %id%
{
    this_id := id%A_Index%
    ;WinActivate, ahk_id %this_id%
    WinGetClass, this_class, ahk_id %this_id%
    WinGetTitle, this_title, ahk_id %this_id%
	if(this_class = "PuTTY"){
		;MsgBox, 4,, %this_class% - %this_title%
		;WinActivate, ahk_id %this_id% 
		OpenPutty = %OpenPutty%%this_title%
	}
	;ControlGet, MyVar, Enabled,,Button2, %AppName% %version%
	if(OpenPutty = ""){
	
	
	/*
	if(Enabled != "enabled"){
	;msgbox %MyVar%
	GuiControl, Disable, Actions
	GuiControl, Disable, RunButton
	Enabled = disabled
	}
	else{ ;if(Enabled = "disabled"){
	GuiControl, Enable, Actions
	GuiControl, Enable, RunButton
	Enabled = enabled
	}
	}/*
	
	}
	}
    ;MsgBox, 4, , Visiting All Windows`n%a_index% of %id%`nahk_id %this_id%`nahk_class %this_class%`n%this_title%`n`nContinue?
    ;IfMsgBox, NO, break
	if(OldOpenPutty = "OpenPutty"){
	
	}
	else{
	GuiControl,, PuttyWindows, |%OpenPutty%
	GuiControl,Choose,PuttyWindows, 1 
	}
	OldOpenPutty = %OpenPutty%
	SetTimer, ClearOpenPutty, 2500
}
return

Run:
Gui, Submit, NoHide
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
GuiControl,Choose,Actions, 1 
return

History:
Gui, Submit, NoHide
WinActivate, %PuttyWindows%
Send history {return}
return

Support_History:
Gui, Submit, NoHide
WinActivate, %PuttyWindows%
Send export HISTFILE=~/.support_history; echo "%A_UserName% - Professional Hosting Services"
Send {return}
return

Reload:
Reload
return