#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CustomColor = EEAA99  ; Can be any RGB color (it will be made transparent below).
OnMessage(0x204, "WM_RBUTTONDOWN")
OnMessage(0x201, "WM_LBUTTONDOWN") ; for click dragging
MyPic = ask-jeeves2.png
Snooze = 0
ClickThrough = 0
Appname=Ask Jeeves
Version = 0.01
inipath = %A_Temp%\Jeeves.ini

Menu, Settings, Add, Preferences, Preferences
Menu, Settings, Add, ClickThru, ClickThru

Menu, Context, Add, Settings, :Settings
Menu, Context, Add, Snooze, Snooze
Menu, Context, Add,
Menu, Context, Add, Reload, Reload
Menu, Context, Add, Exit, terminate

Menu, tray, NoStandard
Menu, tray, add, Settings, :Settings
Menu, tray, add,
Menu, tray, add, Reload
Menu, tray, add, Exit, terminate

Gui +LastFound +AlwaysOnTop -Caption +ToolWindow  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
Gui, Color, %CustomColor%
GUI, Add, Picture, xm ym, %MyPic%
Gui -Border
WinSet, TransColor, %CustomColor% 200
Gui, Font, s20  ; Set a large font size (32-point).
Gui, Add, Text, x60 y20 vMyText cLime, XXXXX YYYYY  ; XX & YY serve to auto-size the window.
Gui, Font, s12 
Gui, Add, Text, vMessage1 right x105 y45 cRed, XXXXXXXX
Gui, Add, Text, vMessage2 right x105 y65 cYellow, XXXXXXXX
Gui, Add, Text, vMessage3 right x105 y85 cRed, XXXXXXXX
Gui, Add, Text, vMessage4 right x105 y105 cRed, XXXXXXXX
Gui, Add, Text, vMessage5 right x105 y125 cRed, XXXXXXXX
Gui, Add, Text, vMessage6 right x105 y145 cBlack, XXXXXXXX

Gui, 2: Add, Text,, Alarms
Gui, 2: Add, Checkbox, vA1 x10 y25, Alarm 1
Gui, 2: Add, DDL, vA1H w40 x10 y40, 01|02|03|04|05|06|07|08|09|10|11|12||
Gui, 2: Add, DDL,vA1M w40 x50 y40, 00||01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|47|48|49|50|51|52|53|54|55|56|57|58|59
Gui, 2: Add, DDL, vA1S w40 x90 y40, AM||PM
Gui, 2: Add, Checkbox, vA2 x10 y65, Alarm 2
Gui, 2: Add, DDL,vA2H w40 x10 y80 ,01|02|03|04|05|06|07|08|09|10|11|12||
Gui, 2: Add, DDL,vA2M w40 x50 y80 , 00||01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|47|48|49|50|51|52|53|54|55|56|57|58|59
Gui, 2: Add, DDL, vA2S w40 x90 y80, AM||PM
Gui, 2: Add, Checkbox, x10, Startup with Windows

Gui, 2: Add, Button, x20 y155 gCancelGui2, Cancel
Gui, 2: Add, Button, x70 y155 Default gSaveSettings, Save

SetTimer, UpdateOSD, 200
Gosub, UpdateOSD  ; Make the first update immediate rather than waiting for the timer.

GuiControl,,Message1,
GuiControl,,Message2,
GuiControl,,Message3,
GuiControl,,Message4,
GuiControl,,Message5,
GuiControl,,Message6,

IniRead, MyX, %inipath%, Preferences, MyX
IniRead, MyY, %inipath%, Preferences, MyY
IniRead, A1, %inipath%, Preferences, A1
IniRead, mA1T, %inipath%, Preferences, A1T
IniRead, mA1S, %inipath%, Preferences, A1S
IniRead, mA2, %inipath%, Preferences, A2
IniRead, mA2T, %inipath%, Preferences, A2T
IniRead, mA2S, %inipath%, Preferences, A2S

GuiControl,2:, A1, %A1%
if(A1 = 1){
StringSplit, time_array, mA1T, :
GuiControl,,Message1,!
GuiControl,2:, A1H, %time_array1%||
GuiControl,2:, A1M, %time_array2%||
GuiControl,2:, A1S, %mA1S%||
}
GuiControl,2:, A2, %mA2%
if(mA2 = 1){
GuiControlGet,Message1,1:, xMessage1
GuiControl,,Message1, %xMessage1% ! 
StringSplit, time_array, mA2T, :
GuiControl,2:, A2H, %time_array1%||
GuiControl,2:, A2M, %time_array2%||
GuiControl,2:, A2S, %mA2S%||	
}
;MyY := A_ScreenHeight - 500
if(MyX = ){
	MyX = 50
}
if(MyY = ){
	MyY := A_ScreenHeight - 200
}
Gui, Show, x%MyX% y%MyY% NoActivate,%AppName% %version%  ; NoActivate avoids deactivating the currently active window.

f12::reload

return

UpdateOSD:
if(A_HOUR = 0){
	Hour := 12
	M = AM
}
else if(A_HOUR > 12){
	Hour := A_HOUR - 12
	M = PM
	if(Hour < 10){
		Hour = 0%Hour%
	}
}
else{
	Hour = %A_HOUR%
	M = AM
}
if(A_Min = 00){
	Snooze = 0
	GuiControl,1:,Message2,
	GuiControl,1:,Message3,
}

Now := Hour ":" A_Min "" M
IniRead, A1, %inipath%, Preferences, A1
IniRead, A2, %inipath%, Preferences, A2
GuiControl,, MyText, %Hour%:%A_Min%:%A_Sec% %M%
StringReplace, NOW, NOW, %A_SPACE%, , All
StringReplace, NOW, NOW, :, , All
;GuiControlGet,2: A1,, xA1
;ToolTIp, Hello %A1% %NOW%
if(A1 = 1){
	IniRead, A1T, %inipath%, Preferences, A1T
	IniRead, A1S, %inipath%, Preferences, A1S
	Alarm := A1T "" A1S
	StringReplace, Alarm, Alarm, %A_SPACE%, , All
	StringReplace, Alarm, Alarm, :, , All
	;ToolTIp, %Alarm% %NOW%
	If(Now = Alarm)
	{
		if(Snooze != 1){
			;Msgbox ALARM!
			ToolTip, Alarm 1 is going off!
			soundplay, Alarm1.mp3
			GuiControl,1:,Message3,ALARM!
			Snooze = 1
			GuiControl,1:,Message2,SNOOZE
			SetTimer, RemoveToolTip, 5000
		}
	}
}
if(A2 = 1){
	IniRead, A2T, %inipath%, Preferences, A2T
	IniRead, A2S, %inipath%, Preferences, A2S
	Alarm := A2T "" A2S
	StringReplace, Alarm, Alarm, %A_SPACE%, , All
	StringReplace, Alarm, Alarm, :, , All
	;ToolTIp, %Alarm% %NOW%
	If(Now = Alarm)
	{
		if(Snooze != 1){
			;Msgbox ALARM!
			ToolTip, Alarm 2 is going off!
			soundplay, Alarm2.mp3
			GuiControl,1:,Message3,ALARM!
			Snooze = 1
			GuiControl,1:,Message2,SNOOZE
			SetTimer, RemoveToolTip, 5000
		}
	}
}



return

reload:
Reload
return


WM_LBUTTONDOWN() {
   PostMessage, 0xA1, 2
   SetTimer, WatchMouse, 1000
   Return
}


EWD_WatchMouse:
GetKeyState, EWD_LButtonState, LButton, P
if EWD_LButtonState = U  ; Button has been released, so drag is complete.
{
    SetTimer, EWD_WatchMouse, off
    return
}
GetKeyState, EWD_EscapeState, Escape, P
if EWD_EscapeState = D  ; Escape has been pressed, so drag is cancelled.
{
    SetTimer, EWD_WatchMouse, off
    WinMove, ahk_id %EWD_MouseWin%,, %EWD_OriginalPosX%, %EWD_OriginalPosY%
    return
}
; Otherwise, reposition the window to match the change in mouse coordinates
; caused by the user having dragged the mouse:
CoordMode, Mouse
MouseGetPos, EWD_MouseX, EWD_MouseY
WinGetPos, EWD_WinX, EWD_WinY,,, %AppName% %Version%
SetWinDelay, -1   ; Makes the below move faster/smoother.
WinMove, ahk_id %EWD_MouseWin%,, EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY
EWD_MouseStartX := EWD_MouseX  ; Update for the next timer-call to this subroutine.
EWD_MouseStartY := EWD_MouseY
WinGetPos, EWD_WinX, EWD_WinY,,, %AppName% %Version%
    IniWrite, %EWD_WinX%, %inipath%, Preferences, MyX
    IniWrite, %EWD_WinY%, %inipath%, Preferences, MyY
return

WatchMouse:
WinGetPos, EWD_WinX, EWD_WinY,,, %AppName% %Version%
    IniWrite, %EWD_WinX%, %inipath%, Preferences, MyX
    IniWrite, %EWD_WinY%, %inipath%, Preferences, MyY
    SetTimer, EWD_WatchMouse, off
return

Hello:
msgbox Hello!
return

WM_RBUTTONDOWN(wParam, lParam){
Menu, Context, Show
}

terminate:
ExitApp
return

preferences:
Gui,2:show, w140
return

ClickThru:
If(ClickThrough = 0){
	WinSet, ExStyle, +0x80020, %AppName% %Version%
	ClickThrough = 1
}
else if(ClickThrough = 1){
	;WinSet, ExStyle, -0x80020, %AppName% %Version%
	;Gui, Submit
	ClickThrough = 0
	;Gui, Show, x%MyX% y%MyY% NoActivate,%AppName% %version%  ; NoActivate avoids deactivating the currently active window.
	;WinSet, TransColor, %CustomColor% 200
	Reload
}

return

cancelgui2:
gui, 2: hide
return

savesettings:
gui, 2: submit

if(A1 = 1){
	IniWrite, %A1%, %inipath%, Preferences, A1
	IniWrite, %A1H%:%A1M%, %inipath%, Preferences, A1T
	IniWrite, %A1S%, %inipath%, Preferences, A1S
	GuiControl,1:,Message1, !
	}
else{
	IniWrite, 0, %inipath%, Preferences, A1
	IniWrite, 12:00, %inipath%, Preferences, A1T
	IniWrite, AM, %inipath%, Preferences, A1S
}
if(A2 = 1){
	IniWrite, %A2%, %inipath%, Preferences, A2
	IniWrite, %A2H%:%A2M%, %inipath%, Preferences, A2T
	IniWrite, %A2S%, %inipath%, Preferences, A2S
	GuiControl,1:,Message1, !
	}
else{
	IniWrite, 0, %inipath%, Preferences, A2
	IniWrite, 12:00, %inipath%, Preferences, A2T
	IniWrite, AM, %inipath%, Preferences, A2S
	If(A1 = 0){
	GuiControl,1:,Message1,
	}
}


return

RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
return

Snooze:
Snooze = 1
SoundPlay, stop.wav
GuiControl,1:,Message2,
GuiControl,1:,Message3,
gosub, RemoveToolTip
return