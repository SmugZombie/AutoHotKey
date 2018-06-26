#Persistent
#SingleInstance, force

; Ron Egli - Github.com
; mediacontrols.ahk - A Media Gui for the Pianobar Binary for Windows
; Version 1.0

MyDimensions := 20
SysGet, Mon2, Monitor, 1 
MyHeight := (A_ScreenHeight - 10 - 50)
MyWidth := (Mon2Right - MyDimensions - 10)
IniRead, MyHeight, mediacontrolsettings.ini, Options, MyHeight, %MyHeight%
IniRead, MyWidth, mediacontrolsettings.ini, Options, MyWidth, %MyWidth%
Gui -Resize -MaximizeBox -MaximizeBox -Caption +AlwaysOnTop
WinSet, TransColor, EEAA99
Gui, Add, Button, x0 y0 h20 w10 disabled, 
Gui, Add, Button, x32 y0 w90 h20 gplay, Pause/Play
Gui, Add, Button, x12 y0 w20 h20 gback, <<
Gui, Add, Button, x122 y0 w20 h20 gskip, >>
Gui, Add, Button, x142 y0 w15 h20 gmenu, ^
Gui, Show, h20 w156 x%MyWidth% y%MyHeight%, MediaController

; Grab left mouse button double click
OnMessage(0x203, "WM_LBUTTONDBLCLK")

; Build Context Menu
Menu, MainMenu, add, &Reload, ReloadScript
Menu, MainMenu, add,
Menu, MainMenu, add, &Show Pianobar, showpianobar
Menu, MainMenu, add, &Hide Pianobar, hidepianobar
Menu, MainMenu, add,
Menu, MainMenu, add, &Quit, Quit

; If the gui is doubleclicked in a particular region, allow moving of the gui
WM_LBUTTONDBLCLK(wParam, lParam)
{
    X := lParam & 0xFFFF
    Y := lParam >> 16
	if (x>0 and x<10 and y>0 and y<20){
		PostMessage, 0xA1, 2,,, A 
		sleep 500
		WinGetPos,x,y,w,h,a
		SaveCoords(x,y) ; Save to ini file
	}
}

Return

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
; Nothing Yet
return

play:
WinActivate, Pianobar
Send p
WinMinimize, Pianobar
Return

skip:
WinActivate, Pianobar
Send n
WinMinimize, Pianobar
return

GuiClose:
ExitApp

SaveCoords(myx,myy)
{
	IniWrite, %myy%, mediacontrolsettings.ini, Options, MyHeight
	IniWrite, %myx%, mediacontrolsettings.ini, Options, MyWidth
}
