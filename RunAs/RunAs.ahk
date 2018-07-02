#NoTrayIcon
#SingleInstance force
#Persistent
#NoEnv

; Ron Egli - Github.com
; Run As - Just a simple applet that allows me to quickly launch administrative tools

SetWorkingDir %A_ScriptDir%
CONFIGFILE := "runas_config.ini"
version = 1.2

If not A_IsAdmin { ; Runs script as Administrator for UAC in Windows Vista and 7+
    try {
    	Run *RunAs "%A_ScriptFullPath%"
    	ExitApp
    }
    catch e
    {
    	ExitApp
    }
}

OnMessage(0x201, "WM_LBUTTONDOWN")
OnMessage(0x204, "WM_RBUTTONDOWN")

WM_LBUTTONDOWN(wParam, lParam)
{
    X := lParam & 0xFFFF
    Y := lParam >> 16
	if (x>0 and x<20 and y>0 and y<20){
		PostMessage, 0xA1, 2,,, A 
		sleep 1500
		WinGetPos,x,y,w,h,a
		SaveCoords(x,y)
	}
}

WM_RBUTTONDOWN(wParam, lParam)
{
	Menu, MainMenu, Show
}

; Define Menus - Rough, will add user configurable later
menu, AppMenu, add, Notepad (Blank), Notepad
menu, AppMenu, add, Notepad (Copied Path), Notepad2
menu, AppMenu, add, Notepad (Chooser), Notepad3
menu, AppMenu, add, CMD, Cmd
menu, AppMenu, add, Powershell
menu, AppMenu, add, Edit Hosts, Hosts
menu, AppMenu, add,
menu, AppMenu, add, RunAs Clipboard, RunAsClipboard
menu, AppMenu, add, Pick a File, chooser

menu, MainMenu, add, RunAs, :AppMenu
menu, MainMenu, add,
menu, MainMenu, add, Reload, Reload

; App is no larger than 20x20, place it somewhere that can be found, if ini not yet set
MyDimensions := 20
SysGet, Mon2, Monitor, 2 
MyHeight := (A_ScreenHeight - 10 - 30)
MyWidth := (Mon2Right - MyDimensions - 10)
if MyWidth is not integer
	{
		MyWidth = 200
	}
	
; Read the ini to find out the appropriate place for the icon, if not place in default spot
IniRead, MyHeight, %CONFIGFILE%, Options, MyHeight, %MyHeight%
IniRead, MyWidth, %CONFIGFILE%, Options, MyWidth, %MyWidth%

; Create the Gui
Gui, -Resize -MaximizeBox -MaximizeBox -Caption +AlwaysOnTop +ToolWindow -SysMenu +LastFound
Gui, Add, Picture,x3 y2, shield2.ico
Gui, Color, 424242
WinSet, TransColor, 1C1C1C
Gui, Show, x%MyWidth% y%MyHeight% h20 w20
hwnd:=winexist()

; Allow app to consistently do stuff.
goSub SubProcess

return

SubProcess:
	gosub checkontop
	settimer,subprocess,500
return

; Force us to be ontop, even of the taskbar!
checkontop:
	winset,alwaysontop,off,ahk_id %hwnd%
	winset,alwaysontop,on,ahk_id %hwnd%
return 

Reload:
Reload	
return

Notepad:
Run, Notepad.exe
return

Notepad2:
Run, Notepad.exe %Clipboard%
return

Notepad3:
FileSelectFile, SelectedFile, 3, , Open a file
if SelectedFile =
    return
else
    Run, Notepad.exe %SelectedFile%
return

Hosts:
Run, Notepad.exe C:\Windows\System32\drivers\etc\hosts
return

Cmd:
Run, Cmd.exe
return

Powershell:
Run, Powershell.exe
return

RunAsClipboard:
Run, %Clipboard%
return

chooser:
FileSelectFile, SelectedFile, 3, , Open a file
if SelectedFile =
    return
else
    Run, %SelectedFile%
return


; Save the current placement to appropriate ini file
SaveCoords(myx,myy)
{
	global
	IniWrite, %myy%, %CONFIGFILE%, Options, MyHeight
	IniWrite, %myx%, %CONFIGFILE%, Options, MyWidth
}
