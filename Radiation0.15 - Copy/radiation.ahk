;#############################################################
;############## Radiation Application Manager ################
;#############################################################
;#                          #######                        #
;#                     # ############# #                   #    
;#                  #     ###########     #                #       
;#                 #       #########        #              # 
;#               #          #######          #             #  
;#              #            #####            #            #
;#             #              ###              #           #
;#             #               #               #           # 
;#             ###############   ###############           #
;#              #############     #############            #
;#               ###########       ###########             #
;#                #########         #########              #  
;#                  ######           ######                #
;#                    ###             ###                  #         
;#                        #         #                      #           
;#                             #                           #
;#############################################################
;################ http://8ill.com/radiation ##################
;#############################################################
;############# Copyright Ron Egli - SmugDev 2015 #############
;#############################################################
;ToDo - Login / store variables on server / user:computer - computer stored in config signin for restore, save to cloud as option in menu
#NoTrayIcon
#SingleInstance force
#Persistent
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
settingspath := A_WorkingDir . "/parts/settings.ini"
OnMessage(0x201, "WM_LBUTTONDOWN")
OnMessage(0x203, "WM_LBUTTONDBLCLK")
OnMessage(0x204, "WM_RBUTTONDOWN")
OnMessage(0x207, "WM_MBUTTONDOWN")
;OnMessage(0x06 , "WM_ACTIVATE")
version = 0.15

;#############################################################
;CORE STUFF
;#############################################################
MyDimensions := 20
SysGet, Mon2, Monitor, 2 
MyHeight := (A_ScreenHeight - 10 - 30)
MyWidth := (Mon2Right - MyDimensions - 10)
if MyWidth is not integer
	{
		MyWidth = 200
	}
	
IniRead, MyHeight, %settingspath%, Options, MyHeight, %MyHeight%
IniRead, MyWidth, %settingspath%, Options, MyWidth, %MyWidth%
IniRead, Secondary, %settingspath%, Options, Secondary, 0
IniRead, Email, %settingspath%, Options, Email, null
IniRead, KEY, %settingspath%, Options, KEY, null	
IniRead, Fresh, %settingspath%,Options, Fresh, true
IfNotExist, %settingspath%
	{													; create settings file if it doesn't exist
		FileAppend, , %settingspath%
		IniWrite, %MyHeight%, %settingspath%, Options, MyHeight
		IniWrite, %MyWidth%, %settingspath%, Options, MyWidth
		IniWrite, %Secondary%, %settingspath%, Options, Secondary
		IniWrite, %Email%, %settingspath%, Options, Email
		IniWrite, %Key%, %settingspath%, Options, KEY
		IniWrite, %Fresh%, %settingspath%, Options, Fresh
	}
If(Fresh = "true")
	{
		MsgBox, 4,, Would you like to sync with your cloud account? (press Yes or No)
		IfMsgBox Yes
			{
			IfExist, CloudSync.exe
				run %A_ScriptDir%/CloudSync.exe
			else IfExist, CloudSync.ahk
				run %A_ScriptDir%/CloudSync.ahk
			else
				msgbox Required Files Not Found! Reload App
			Sleep 2000
			ExitApp
			}
		else
			{
				IniWrite, false, %settingspath%, Options, Fresh
			}
	}

myip := UrlGet("http://werq.us/radiation/myip.php", null)
#Include core/gui.ahk
#Include core/menus.ahk

;#############################################################
;Check Current Version
;#############################################################
checkVersion(version)

;#############################################################
;Show Radiation
;#############################################################
Gui, Show, x%MyWidth% y%MyHeight% h20 w20

;#############################################################
;Define Mouse Options
;#############################################################
WM_LBUTTONDOWN(wParam, lParam)
{
    X := lParam & 0xFFFF
    Y := lParam >> 16
if (x>0 and x<20 and y>0 and y<20)
PostMessage, 0xA1, 2,,, A 
sleep 1500
WinGetPos,x,y,w,h,a
SaveCoords(x,y)
}

WM_LBUTTONDBLCLK(wParam, lParam)
{
    X := lParam & 0xFFFF
    Y := lParam >> 16
if (x>0 and x<20 and y>0 and y<20)
ifExist %A_ScriptDir%/apps/launcher.exe
	run %A_ScriptDir%/apps/launcher.exe
else ifExist %A_ScriptDir%/apps/launcher.ahk
	run %A_ScriptDir%/apps/launcher.ahk
else
	msgbox Missing Required Files!
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
IniWrite, %myy%, parts/settings.ini, Options, MyHeight
IniWrite, %myx%, parts/settings.ini, Options, MyWidth
;Tooltip, Saved
;SetTimer, RemoveToolTip, 1000
}

Applications:
ifExist %A_ScriptDir%/apps/launcher.exe
	run %A_ScriptDir%/apps/launcher.exe
else ifExist %A_ScriptDir%/apps/launcher.ahk
	run %A_ScriptDir%/apps/launcher.ahk
else
	msgbox Missing Required Files!
return

addlink:
InputBox, UserInput, URL:
if(UserInput == "")
{

}
else
{
FileAppend, `n%UserInput%, parts/links.smug
menu, LinkMenu, add, %UserInput%, loadlink
ToolTip, %UserInput%`nAdded Successfully!`nReload The Application
SetTimer, RemoveToolTip, 4000
}
return

clearlink:
MsgBox, 4, , This Will Destroy ALL Links`nDo you want to continue? (Press YES or NO)
IfMsgBox No
    return
else
FileDelete, parts/links.smug
ToolTip, Links Purged!`nReload To See Changes
SetTimer, RemoveToolTip, 4000
return

loadlink:
run %A_ThisMenuItem%
return

Reload:
Reload
Sleep 2000 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.
Reload
return

About:
Gui, 2: Show, Center h200 w350, About Radiation
return

2GuiEscape:
Gui,2:submit
return

Settings:
return

3GuiEscape:
Gui,3:submit
return

4GuiEscape:
Gui,4:submit
return

Launch(file)
{
run %file%
}

;#############################################################
; Work Scripts
;#############################################################
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

;#############################################################
;Dead Queue Script
;#############################################################
#MaxThreadsPerHotkey 2
ScrollLock:: ;repeatedly click in a square until the mouse is moved ;clicks at 65 clicks a minute
;xpos_close = 1259 ;location of "queue is empty" pop-up's close [X]
;ypos_close = 927
;OR xpos_current == xpos_close
;OR ypos_current == ypos_close
MouseGetPos, xpos_start, ypos_start ;find where the mouse is to start with
xpos_left := xpos_start ;establish boundaries
xpos_right := xpos_start + 5
ypos_up := ypos_start
ypos_down := ypos_start + 5
Toggle := on
While (Toggle == on){
MouseGetPos, xpos_current, ypos_current
if (ypos_current == ypos_up OR ypos_current == ypos_down){ ;while the mouse hasn't moved vertically
if(xpos_current == xpos_left OR xpos_current == xpos_right){ ;while the mouse hasn't moved horizontally
MouseGetPos, xpos_current, ypos_current
ToolTip, Clicking Away...
Click %xpos_left%, %ypos_up%
Sleep 5
Click %xpos_right%, %ypos_up%
Sleep 5
Click %xpos_right%, %ypos_down%
Sleep 5
Click %xpos_left%, %ypos_down%
Sleep 250
;Click %xpos_close%, %ypos_close%
;Sleep 50
}
}
else{
Toggle := off
ToolTip
return
}
}
return


;#############################################################
; Home Scripts
;#############################################################

Wifi:
InputBox, ssid, Enter SSID, , 
Run netsh wlan connect=%ssid%
return

;#############################################################
;Dev Scripts
;#############################################################

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

DirGet:
mydir := UrlGet("http://werq.us/radiation/dirscan.php", null)
StringReplace, mydir, mydir, </br>, `n, All
FileAppend, %mydir%, parts/dirlist.smug
Sleep 1000
Loop, read, %A_ScriptDir%/parts/dirlist.smug
{
	menu, LinkMenu, add, %A_LoopReadLine%, loadlink
}
Sleep 1000
FileDelete, parts/dirlist.smug
return

;#############################################################
;SyncApp - Launches Cloudsync.exe
;#############################################################
SyncApp:
ifExist %A_ScriptDir%/CloudSync.exe
	run %A_ScriptDir%/CloudSync.exe
else ifExist %A_ScriptDir%/CloudSync.ahk
	run %A_ScriptDir%/CloudSync.ahk
else
	msgbox Missing Required Files!
return

;#############################################################
;Win Scripts
;#############################################################

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

StartupDir:
run shell:startup
return

;#############################################################
; Cleanup
;#############################################################
#Include core/version.ahk
#Include core/cloud.ahk

Quit:
ExitApp
return

Random(min=1,max=6) {
   Random, x, Min, Max
   Return, x
}

UrlGet(url,data) {
	WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	WebRequest.open("GET",URL, false)
	WebRequest.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
	WebRequest.send(data)
	Return WebRequest.ResponseText
}

RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
return

GuiClose:
GuiEscape:
ExitApp
return

;#############################################################
;Notes
;#############################################################
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