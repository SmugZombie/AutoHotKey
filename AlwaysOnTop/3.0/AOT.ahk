; ######################################
;       Always On Top 2.13
;       Smug Dev
;       http://smugzombie.com
;		2013
; ######################################
#NoEnv
#Persistent
#SingleInstance Force
SendMode Input
#InstallKeybdHook

/*
Hotkeys:
Alt-A: make window always on top
Alt-W: make window less transparent
Alt-S: make window more transparent
Alt-X: make window click though
Alt-Z: make window under mouse not click through
Alt-F: make window full screen
Caps+LeftClick: Drag Any Window
*/

;Variables
myHeight = %A_ScreenHeight%
myWidth = %A_ScreenWidth%
version = 3.1
hints = Alt-A: make window always on top `nAlt-W: make window less transparent `nAlt-S: make window more transparent `nAlt-X: make window under mouse clickthough `nAlt-Z: make window under mouse un-clickthrough`nCaps-LeftClick: to move windows`nAlt-F: make current window full screen
about = Developed by SmugDev (ron@smugzombie.com) `nWith Help from the AHK Community`nVersion: %version%
;Menu Items
Menu, tray, NoStandard
Menu, tray, add, Reload, Reloadit  ; Creates a new menu item.
Menu, tray, add  ; Creates a separator line.
;Menu, tray, add, Configuration, ConfigIt ; Creates a new menu item.
Menu, tray, add, Hints, HintIt ; Creates a new menu item.
Menu, tray, add  ; Creates a separator line.
Menu, tray, add, Report Bug/Comment, Submit
Menu, tray, add, Exit, terminate  ; Creates a new menu item.

checkVersion(version)

;GUI
Gui, -Caption
Gui,+AlwaysOnTop
Gui, Add, Tab2,, Config|Hints|About  ; Tab2 vs. Tab requires v1.0.47.05.
Gui, Add, Text,, Start With Windows
Gui, Add, Checkbox, vMyCheckbox, Run On Startup
Gui, Add, Text,, This mode currently useless
Gui, Tab, 2
Gui, Add, Text,, %hints%
Gui, Tab, 3
Gui, Add, Text,, %about%
Gui, Add, Text,, Submit Your Comments
Gui, Add, Edit, vMyEdit r5  ; r5 means 5 rows tall.
Gui, Add, Button, Default, Submit
Gui, Tab  ; i.e. subsequently-added controls will not belong to the tab control.
Gui, Add, Button, default xm, OK  ; xm puts it at the bottom left corner.
return

ButtonOK:
GuiClose:
GuiEscape:
Gui, Submit  ; Save each control's contents to its associated variable.
Return

!a::
WinGet, currentWindow, ID, A
WinGet, ExStyle, ExStyle, ahk_id %currentWindow%
if (ExStyle & 0x8)  ; 0x8 is WS_EX_TOPMOST.
{
	Winset, AlwaysOnTop, off, ahk_id %currentWindow%
	;SplashImage,, x0 y0 b fs12, OFF always on top.
	;Sleep, 1500
	;SplashImage, Off
	TrayTip, , AlwaysOnTop OFF
	SetTimer, RemoveTrayTip, 1500
}
else
{
	WinSet, AlwaysOnTop, on, ahk_id %currentWindow%
	;SplashImage,,x0 y0 b fs12, ON always on top.
	;Sleep, 1500
	;SplashImage, Off
	TrayTip, , AlwaysOnTop ON
	SetTimer, RemoveTrayTip, 1500
}
return

!w::
WinGet, currentWindow, ID, A
if not (%currentWindow%)
{
	%currentWindow% := 255
}
if (%currentWindow% != 255)
{
	%currentWindow% += 5
	WinSet, Transparent, % %currentWindow%, ahk_id %currentWindow%
}
;SplashImage,,w100 x0 y0 b fs12, % %currentWindow%
;SetTimer, TurnOffSI, 1000, On
TrayTip, , % %currentWindow%
SetTimer, RemoveTrayTip, 1000
Return

!s::
SplashImage, Off
WinGet, currentWindow, ID, A
if not (%currentWindow%)
{
	%currentWindow% := 255
}
if (%currentWindow% != 5)
{
	%currentWindow% -= 5
	WinSet, Transparent, % %currentWindow%, ahk_id %currentWindow%
}
;SplashImage,, w100 x0 y0 b fs12, % %currentWindow%
;SetTimer, TurnOffSI, 1000, On
TrayTip, , % %currentWindow%
SetTimer, RemoveTrayTip, 1000
Return

!x::
WinGet, currentWindow, ID, A
WinSet, ExStyle, +0x80020, ahk_id %currentWindow%
TrayTip, , Click Through
SetTimer, RemoveTrayTip, 1000
return

!z::
MouseGetPos,,, MouseWin ; Gets the unique ID of the window under the mouse
WinSet, ExStyle, -0x80020, ahk_id %currentWindow%
TrayTip, , Solid
SetTimer, RemoveTrayTip, 1000
Return

!f::
;msgbox %myWidth%, %myHeight%
;myHeight = myHeight - 30
WinMove,A,,0,0,%myWidth%,%myHeight%
Return

Reloadit:
{
	TrayTip, , Reloading...
	SetTimer, RemoveTrayTip, 1000
	Reload
	return
}

HintIt:
{
MsgBox, 0, Hints, %hints% `n`n%about% 
    return
}

ConfigIt:
{
Gui, Show, ,Config
return
}

RemoveTrayTip:
SetTimer, RemoveTrayTip, Off
TrayTip
return

terminate:
{
   TrayTip, , GoodBye!
   SetTimer, RemoveTrayTip, 1000
   ;Gui, Destroy
   ObjRelease(pipa)
   ExitApp
}

;--------------------------------------------------------------------------
;   THIS ALLOWS YOU TO MOVE WINDOWS USING THE CAPS LOCK AND LEFT MOUSE                                      
;--------------------------------------------------------------------------

CapsLock & LButton::
CoordMode, Mouse  ; Switch to screen/absolute coordinates.
MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, ahk_id %EWD_MouseWin%
WinGet, EWD_WinState, MinMax, ahk_id %EWD_MouseWin% 
if EWD_WinState = 0  ; Only if the window isn't maximized 
    SetTimer, EWD_WatchMouse, 10 ; Track the mouse as the user drags it.
return

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
WinGetPos, EWD_WinX, EWD_WinY,,, ahk_id %EWD_MouseWin%
SetWinDelay, -1   ; Makes the below move faster/smoother.
WinMove, ahk_id %EWD_MouseWin%,, EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY
EWD_MouseStartX := EWD_MouseX  ; Update for the next timer-call to this subroutine.
EWD_MouseStartY := EWD_MouseY
return
;--------------------------------------------------------------------------
;   END RELOCATION SCRIPT                                     
;--------------------------------------------------------------------------

#Include includes/HTTPRequest.ahk
#Include includes/version.ahk
#Include includes/comments.ahk
