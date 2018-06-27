#Persistent
#SingleInstance, force
#NoEnv

; Ron Egli - Github.com
; mediacontrols.ahk - A Media Gui for the Pianobar Binary for Windows / Or Windows In General
; Version 1.3

MyDimensions := 20
SysGet, Mon2, Monitor, 1 
MyHeight := (A_ScreenHeight - 10 - 50)
MyWidth := (Mon2Right - MyDimensions - 10)
IniRead, MyHeight, mediacontrolsettings.ini, Options, MyHeight, %MyHeight%
IniRead, MyWidth, mediacontrolsettings.ini, Options, MyWidth, %MyWidth%
Gui -Resize -MaximizeBox -MaximizeBox -Caption +AlwaysOnTop +ToolWindow -SysMenu +LastFound

Gui, Color, 232528
WinSet, Transparent, 150
;Gui, Add, Button, x0 y0 h20 w10 disabled, 
Gui, Add, Picture, x1 y0 h20 w20,  ico\move.png
;Gui, Add, Button, x12 y0 w20 h20 gback, <<
Gui, Add, Picture, x23 y0 w20 h20 gback, ico\previous.png
;Gui, Add, Button, x32 y0 w90 h20 gplay, Pause/Play
Gui, Add, Picture, x44 y0 w20 h20 gplay, ico\play.png
;Gui, Add, Picture, x52 y0 w20 h20 gplay, ico\pause.png
;Gui, Add, Button, x122 y0 w20 h20 gskip, >>
Gui, Add, Picture, x65 y0 w20 h20 gskip, ico\skip.png
;Gui, Add, Button, x92 y0 w15 h20 gmenu, ^
Gui, Add, Picture, x86 y0 w20 h20 gmenu, ico\eject.png
Gui, Show, h20 w106 x%MyWidth% y%MyHeight%, MediaController
hwnd:=winexist()

;OnMessage(0x201, "WM_LBUTTONDOWN")
OnMessage(0x203, "WM_LBUTTONDBLCLK")
;OnMessage(0x204, "WM_RBUTTONDOWN")
;OnMessage(0x207, "WM_MBUTTONDOWN")

Menu, MainMenu, add, &Reload, ReloadScript
Menu, MainMenu, add,
Menu, MainMenu, add, &Start Pianobar, TogglePianobar
Menu, MainMenu, add, &Quit Pianobar, TogglePianobar
Menu, MainMenu, add,
Menu, MainMenu, add, &Show Pianobar, showpianobar
Menu, MainMenu, add, &Hide Pianobar, hidepianobar
Menu, MainMenu, add,
Menu, MainMenu, add, &Quit, Quit

; Capture LeftDoubleClick
WM_LBUTTONDBLCLK(wParam, lParam)
{
    X := lParam & 0xFFFF
    Y := lParam >> 16
    ; Ensure within proper range to allow dragging window
	if (x>0 and x<20 and y>0 and y<20){
		PostMessage, 0xA1, 2,,, A 
		sleep 500
		WinGetPos,x,y,w,h,a
		; Save to ini to autoload here next time
		SaveCoords(x,y)
	}
}

; Start Pianobar if not already running
If !WinExist("Pianobar"){
	run, """%A_ScriptDir%\pianobar.exe"""
}

; Do routines
gosub subprocess
Return


subprocess:
gosub checkpianobar
gosub checkontop
settimer,subprocess,5000 ; Do it all over again
return

checkontop:
; Force us to be ontop, even of the taskbar!
winset,alwaysontop,off,ahk_id %hwnd%
winset,alwaysontop,on,ahk_id %hwnd%
return 

checkpianobar:
If !WinExist("Pianobar"){
	;Menu, MainMenu, Rename, &Quit Pianobar, &Start Pianobar
	;Menu, MainMenu, Rename, &Pianobar, &Start Pianobar
	Menu, MainMenu, Disable, &Quit Pianobar
	Menu, MainMenu, Enable, &Start Pianobar
}else{
	;Menu, MainMenu, Rename, &Start Pianobar, &Quit Pianobar
	;Menu, MainMenu, Rename, &Pianobar, &Quit Pianobar
	Menu, MainMenu, Enable, &Quit Pianobar
	Menu, MainMenu, Disable, &Start Pianobar
}

return

TogglePianobar:
If !WinExist("Pianobar"){
	run, """%A_ScriptDir%\pianobar.exe"""
}else{
	WinActivate, Pianobar
	Send q
}
return

menu:
Menu, MainMenu, Show
return

quit:
ExitApp, 0
return

showpianobar:
WinActivate, Pianobar
return

hidepianobar:
WinMinimize, Pianobar
return

ReloadScript:
Reload
return

back:
If !WinExist("Pianobar"){
	Send {Media_Prev}
}
return

play:
If !WinExist("Pianobar"){
	Send {Media_Play_Pause}
}
else{
	
	WinActivate, Pianobar
	Send p
	WinMinimize, Pianobar
}
Return

skip:
If !WinExist("Pianobar"){
	Send {Media_Next}
}
else{
	WinActivate, Pianobar
	Send n
	WinMinimize, Pianobar
}
return

GuiClose:
ExitApp

SaveCoords(myx,myy)
{
	IniWrite, %myy%, mediacontrolsettings.ini, Options, MyHeight
	IniWrite, %myx%, mediacontrolsettings.ini, Options, MyWidth
}
