;DimScreen.ahk
; Dim the screen via the tray icon

#SingleInstance,Force
#NoEnv
SetWinDelay,0

applicationname=Dimmer

Gosub,INIREAD
Gosub,MENU
Gosub,GUI

LOOP:
WinGet,id,Id,A
WinSet,AlwaysOnTop,On,ahk_id %guiid%
WinWaitNotActive,ahk_id %id%
IfWinNotExist,ahk_id %guiid%
  Gosub,GUI
Goto,LOOP


CHANGE:
Menu,Tray,UnCheck,% "&" dimming*10 "%"
If A_ThisMenuItem<>
  dimming:=A_ThisMenuItemPos-3
Menu,Tray,Check,% "&" dimming*10 "%"
WinSet,Transparent,% dimming*255/10,ahk_id %guiid%
Return


DECREASE:
Menu,Tray,UnCheck,% "&" dimming*10 "%"
dimming-=1
If dimming<0
  dimming=0
Menu,Tray,Check,% "&" dimming*10 "%"
WinSet,Transparent,% dimming*255/10,ahk_id %guiid%
Return


GUI:
Gui,+ToolWindow -Disabled -SysMenu -Caption +E0x20 +AlwaysOnTop 
Gui,Color,000000
Width := A_ScreenWidth x 3
x := 0 - A_ScreenWidth
Gui,Show, X%x% Y0 W%Width% H%A_ScreenHeight% ,%applicationname% Screen
Gui,+LastFound
WinGet,guiid,Id,A
Gosub,CHANGE
Return


MENU:
Menu,Tray,DeleteAll
Menu,Tray,NoStandard
Menu,Tray,Add,
Loop,10
  Menu,Tray,Add,% "&" A_Index*10-10 "%",CHANGE
Menu,Tray,Add,
Menu,Tray,Add,&Settings...,SETTINGS
Menu,Tray,Add,&Exit,EXIT
Menu,Tray,Tip,%applicationname%
Return


INCREASE:
Menu,Tray,UnCheck,% "&" dimming*10 "%"
dimming+=1
If dimming>9
  dimming=9
Menu,Tray,Check,% "&" dimming*10 "%"
WinSet,Transparent,% dimming*255/10,ahk_id %guiid%
Return


SETTINGS:
Hotkey,%hotkey1%,Off
Hotkey,%hotkey2%,Off
Gui,2:Destroy
Gui,2:Add,GroupBox,xm y+20 w175,&Startup dimming (0-90 `%)
Gui,2:Add,Edit,xp+10 yp+20 w155 vvdimming,% dimming*10
Gui,2:Add,GroupBox,xm y+20 w175 h70,&Increase dimming hotkey
Gui,2:Add,Hotkey,xp+10 yp+20 w155 vvhotkey1,% hotkey1
Gui,2:Add,Text,,Current: %hotkey1%
Gui,2:Add,GroupBox,xm y+20 w175 h70,&Decrease dimming hotkey
Gui,2:Add,Hotkey,xp+10 yp+20 w155 vvhotkey2,% hotkey2
Gui,2:Add,Text,,Current: %hotkey2%
Gui,2:Add,Button,xm y+20 w75 Default gSETTINGSOK,&OK
Gui,2:Add,Button,x+5 yp w75 gSETTINGSCANCEL,&CANCEL
Gui,2:Show,,%applicationname% Settings
Return


SETTINGSOK:
Gui,2:Submit
vdimming:=Floor(vdimming/10)
If (vdimming>=0 And vdimming<=9)
{
  IniWrite,%vdimming%,%applicationname%.ini,Settings,dimming
}
If vhotkey1<>
{
  hotkey1:=vhotkey1
  IniWrite,%hotkey1%,%applicationname%.ini,Settings,hotkey1
}
If vhotkey2<>
{
  hotkey2:=vhotkey2
  IniWrite,%hotkey2%,%applicationname%.ini,Settings,hotkey2
}

SETTINGSCANCEL:
Gui,2:Destroy
Hotkey,%hotkey1%,INCREASE
Hotkey,%hotkey2%,DECREASE
Return


INIREAD:
IniRead,dimming,%applicationname%.ini,Settings,dimming
If dimming=Error
  dimming=5
IniRead,hotkey1,%applicationname%.ini,Settings,hotkey1
If hotkey1=Error
  hotkey1=^+
IniRead,hotkey2,%applicationname%.ini,Settings,hotkey2
If hotkey2=Error
  hotkey2=^-
Hotkey,%hotkey1%,INCREASE
Hotkey,%hotkey2%,DECREASE
Return


hCurs:=DllCall("LoadCursor","UInt",NULL,"Int",32649,"UInt") ;IDC_HAND
OnMessage(0x200,"WM_MOUSEMOVE") 
Return

WM_MOUSEMOVE(wParam,lParam)
{
  Global hCurs
  MouseGetPos,,,,ctrl
  If ctrl in Static11,Static15,Static19
    DllCall("SetCursor","UInt",hCurs)
  Return
}


EXIT:
ExitApp
