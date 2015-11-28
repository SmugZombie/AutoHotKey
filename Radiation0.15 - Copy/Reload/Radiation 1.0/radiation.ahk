#NoTrayIcon
#SingleInstance force
#Persistent
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%/parts  ; Ensures a consistent starting directory.
OnMessage(0x201, "WM_LBUTTONDOWN")
OnMessage(0x203, "WM_LBUTTONDBLCLK")
OnMessage(0x204, "WM_RBUTTONDOWN")
OnMessage(0x207, "WM_MBUTTONDOWN")
;OnMessage(0x06 , "WM_ACTIVATE")

;########CCCCOOOORRRREEEE############
;########CCCCOOOORRRREEEE############
;########CCCCOOOORRRREEEE############
MyDimensions := 20
SysGet, Mon2, Monitor, 2 
MyHeight := (A_ScreenHeight - 10 - 30)
MyWidth := (Mon2Right - MyDimensions - 10)


IfExist, config.smug
	FileReadLine, MyHeight, config.smug, 3
	FileReadLine, MyWidth, config.smug, 4
IfNotExist, config.smug
    {
	FileAppend, SmugScripts`nCopyright SmugDev`n%MyHeight%`n%MyWidth%,config.smug
	}

Gui,+AlwaysOnTop +ToolWindow -SysMenu -Caption +LastFound
Gui, Add, Picture,x0 y0, radiation3.png
Gui, Color, 424242
WinSet, TransColor, 1C1C1C
Gui,2: -Caption +0x800000 +AlwaysOnTop +ToolWindow
Gui,2: Color, FFFFE7
Gui,2: Margin, 0,0
Gui,2: Font, s9 , Verdana
Gui,2: Add, Text, x0 y0 +0x4   w400 h19
Gui,2: Add, Text, x0 y0 +0x200 w400 h19 cFFFF80 Backgroundtrans vCaption
   , % A_Space " About"
Gui, 3: Add, Text, Hello World!
Gui, Show, x%MyWidth% y%MyHeight% h20 w20


menu, MainMenu, add, Applications
menu, SysMenu, add, About
menu, SysMenu, add, Settings
menu, SysMenu, add, SetLocation
menu, SysMenu, add,
menu, SysMenu, add, Reload
menu, SysMenu, add, Quit
;menu, ScriptMenu, add, Stats
menu, HomeScripts, add, Wifi
menu, DevScripts, add, MonGet
menu, DevScripts, add, ProgramGet
menu, WorkScripts, add, Stats
menu, WinScripts, add, cmd
menu, WinScripts, add, msconfig
menu, WinScripts, add, rdp
menu, WinScripts, add, ipconfig
menu, WinScripts, add, run
menu, WinScripts, add, hostname
menu, WinScripts, add, Sleeper
menu, ScriptMenu, add, Home, :HomeScripts
menu, ScriptMenu, add, Dev, :DevScripts
menu, ScriptMenu, add, Work, :WorkScripts
menu, ScriptMenu, add, WIN, :WinScripts
menu, MainMenu, add, Scripts, :ScriptMenu
menu, MainMenu, add,
menu, MainMenu, add, System, :SysMenu

WM_LBUTTONDOWN(wParam, lParam)
{
    X := lParam & 0xFFFF
    Y := lParam >> 16
if (x>0 and x<20 and y>0 and y<20)
PostMessage, 0xA1, 2,,, A 
}

WM_LBUTTONDBLCLK(wParam, lParam)
{
    X := lParam & 0xFFFF
    Y := lParam >> 16
if (x>0 and x<20 and y>0 and y<20)
Gui, 3: Show, Center, Radiation
}

WM_RBUTTONDOWN(wParam, lParam)
{
;    X := lParam & 0xFFFF
;    Y := lParam >> 16
;if (x>0 and x<20 and y>0 and y<20)
Menu, MainMenu, Show
}
return

SetLocation:
WinGetPos,x,y,w,h,a
SaveCoords(x,y)
return

SaveCoords(myx,myy)
{
FileDelete, config.smug
FileAppend, SmugScripts`nCopyright SmugDev`n%myy%`n%myx%,config.smug
Tooltip, Saved
SetTimer, RemoveToolTip, 1000
}

Applications:
run launcher.ahk
return

Reload:
Reload
Sleep 2000 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.
Reload
return

About:
Gui,2: Show, h300
return

Settings:

return

Launch(file)
{
run %file%
}
;########WWWOOORRRKKK SSSCCCRRRIIIPPPTTTSSS############
Stats:
Run iexplore.exe http://c3reports-v01.prod.mesa1.gdg/Reports/Pages/Report.aspx?ItemPath=/IRIS/PUBLIC/Daily+Stats+by+Employees
WinWaitActive, Daily Stats By Employees, , 5
Sleep 100
IfWinExist, Daily Stats By Employees
    WinActivate
WinMaximize
MouseMove, 184,216
MouseClick, left
Send {Space} 10:00PM
MouseMove, 560,216
MouseClick, left
Sleep 2500
MouseClick, left
Send {BS 11} {Space} 10:00 PM
Sleep 200
Send {Tab 2}{Down}{Tab}{Down}{Tab}
Send {Enter}
Sleep 6000
MouseMove, 100,340
MouseClick, left
Send ^a
Send ^c
Run iexplore.exe https://hoclinux.intranet.gdg/paulm/iris_inc/ 
return

;########HHHOOOMMMEEE SSSCCCRRRIIIPPPTTTSSS############

Wifi:
InputBox, ssid, Enter SSID, , 
Run netsh wlan connect=%ssid%
return

;########DDDEEEVVV SSSCCCRRRIIIPPPTTTSSS############

MonGet:
; Example #1:
SysGet, MouseButtonCount, 43
SysGet, VirtualScreenWidth, 78
SysGet, VirtualScreenHeight, 79

; Example #2: This is a working script that displays info about each monitor:
SysGet, MonitorCount, MonitorCount
SysGet, MonitorPrimary, MonitorPrimary
MsgBox, Monitor Count:`t%MonitorCount%`nPrimary Monitor:`t%MonitorPrimary%
Loop, %MonitorCount%
{
    SysGet, MonitorName, MonitorName, %A_Index%
    SysGet, Monitor, Monitor, %A_Index%
    SysGet, MonitorWorkArea, MonitorWorkArea, %A_Index%
    MsgBox, Monitor:`t#%A_Index%`nName:`t%MonitorName%`nLeft:`t%MonitorLeft% (%MonitorWorkAreaLeft% work)`nTop:`t%MonitorTop% (%MonitorWorkAreaTop% work)`nRight:`t%MonitorRight% (%MonitorWorkAreaRight% work)`nBottom:`t%MonitorBottom% (%MonitorWorkAreaBottom% work)
}
return

ProgramGet:
WinGet, id, list,,, Program Manager
Loop, %id%
{
    this_id := id%A_Index%
    WinActivate, ahk_id %this_id%
    WinGetClass, this_class, ahk_id %this_id%
    WinGetTitle, this_title, ahk_id %this_id%
    MsgBox, 4, , Visiting All Windows`n%a_index% of %id%`nahk_id %this_id%`nahk_class %this_class%`n%this_title%`n`nContinue?
    IfMsgBox, NO, break
}
return

;########WWWIIINNN SSSCCCRRRIIIPPPTTTSSS############

cmd:
Run cmd
return

msconfig:
Run msconfig
return

rdp:
run mstsc
return

run:
InputBox, UserInput, Run Command, , , , 
if ErrorLevel
    return
run %UserInput%
return

hostname:
run cmd /k hostname
return

ipconfig:
InputBox, UserInput, Ipconfig /command, You can use these Commands: `nall`ndisplaydns`nflushdns`nrelease, , , 
if ErrorLevel
    return
run cmd /k ipconfig /%UserInput%
return

Sleeper:
run rundll32.exe powrprof.dll,SetSuspendState 0,1,0
return

;########CLEANUP############

Quit:
ExitApp
return

Random(min=1,max=6) {
   Random, x, Min, Max
   Return, x
}

RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
return

GuiClose:
GuiEscape:
ExitApp
return
/*
WM_MOUSEMOVE	= 0x0200
WM_LBUTTONDOWN	= 0x0201
WM_LBUTTONUP	= 0x0202
WM_LBUTTONDBLCLK= 0x0203
WM_RBUTTONDOWN	= 0x0204
WM_RBUTTONUP	= 0x0205
WM_RBUTTONDBLCLK= 0x0206
WM_MBUTTONDOWN	= 0x0207
WM_MBUTTONUP	= 0x0208
WM_MBUTTONDBLCLK= 0x0209
*/
