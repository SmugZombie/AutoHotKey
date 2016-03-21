;--------------------------------------------------------
; SmugBrowser by Smug Dev    
; github.com/smugzombie
;--------------------------------------------------------

#Persistent
#SingleInstance Force
Menu, tray, NoStandard
Menu, tray, add, Reload, Reloadit  ; Creates a new menu item.
Menu, tray, add  ; Creates a separator line.
Menu, Submenu1, Add, Save Settings, SaveConfig
Menu, Submenu1, Add, Change Domain, Configit
Menu, Submenu1, Add, ConfigCheck, CheckConfig
Menu, Submenu1, Add, Reset to Defaults, Defaultit
Menu, tray, Add, Config, :Submenu1
Menu, Submenu2, Add, Top Most, ToggleOnTop
Menu, Submenu2, Add, Show Title, ToggleCaption
Menu, Submenu2, Add, Show Scroll, ToggleScroll
Menu, Submenu2, Add, Full Screen, ToggleFullsize
Menu, tray, Add, Toggles, :Submenu2
Menu, tray, add  ; Creates a separator line.
Menu, tray, add, About, AboutMe ; Creates a new menu item.
Menu, tray, add, Exit, terminate  ; Creates a new menu item.

global DisplayTitle := 0
global DisplayScroll := 1
global AlwaysOnTop := 0
global DisplayFull := 0
global OkToReload := 0
global MyHeight := "h600"
global MyWidth := "w1024"
global URL = "http://app1.smug.tk"
global Version = 1.1
global clickok = 0

IfExist, config.ini
	FileReadLine, url, config.ini, 1
	FileReadLine, DisplayTitle, config.ini, 2
	FileReadLine, AlwaysOnTop, config.ini, 3
	FileReadLine, DisplayScroll, config.ini, 4
	FileReadLine, DisplayFull, config.ini, 5
	FileReadLine, MyWidth, config.ini, 6
	FileReadLine, MyHeight, config.ini, 7
IfNotExist, config.ini
    {
	TrayTip, Loading.., We Appreciate Your Patience.
	SetTimer, RemoveTrayTip, 5000
	Sleep 2000
	SetTimer, WriteConfig, 0
	return
	}
	
if(global DisplayTitle == 1)
		{
			Menu, Submenu2, ToggleCheck, Show Title
		}
if(global DisplayScroll == 1)
		{
			Menu, Submenu2, ToggleCheck, Show Scroll
		}
if(global DisplayFull == 1)
		{
			Menu, Submenu2, ToggleCheck, Full Screen
		}
if(global AlwaysOnTop == 1)
		{
			Menu, Submenu2, ToggleCheck, Top Most
		}


IfWinExist, SmugBrowser %Version%
{
	SetTimer, terminate, 0
    return
}
	
main:
{
   Gosub,init
   if(global DisplayTitle == 0)
	{
		Gui, -Caption
	}
   ;if(url == "")
	;{
	;	url=http://app1.smug.tk
	;}
   WB.Navigate(url)
   loop
   If !WB.busy
   break
   return
}
init:
{
   ;; housekeeping routines
   ;; set the tear down procedure
   OnExit,terminate
   ;; Create a gui
   Gui, +LastFound +Resize +OwnDialogs
   ;; create an instance of Internet Explorer_Server
   ;; store the iwebbrowser2 interface pointer as *WB* & the hwnd as *ATLWinHWND*
   Gui, Add, ActiveX, w510 h600 x0 y0 vWB hwndATLWinHWND, Shell.Explorer
   ;; disable annoying script errors from the page
   WB.silent := true
   if(global DisplayScroll == 0)
		{
			WB.Document.Body.Style.Overflow := "hidden"
		}
   ;; necesary to accept enter and accelorator keys
   ;http://msdn.microsoft.com/en-us/library/microsoft.visualstudio.ole.interop.ioleinplaceactiveobject(VS.80).aspx
   IOleInPlaceActiveObject_Interface:="{00000117-0000-0000-C000-000000000046}"
   ;; necesary to accept enter and accelorator keys
   ;; get the in place interface pointer
   pipa := ComObjQuery(WB, IOleInPlaceActiveObject_Interface)
   ;; necesary to accept enter and accelorator keys
   ;; capture key messages
   OnMessage(WM_KEYDOWN:=0x0100, "WM_KEYDOWN")
   OnMessage(WM_KEYUP:=0x0101, "WM_KEYDOWN")
   ;;Display the GUI
   gui,show, %MyWidth% %MyHeight% ,SmugBrowser %Version%
   ;; return and allow the program
   WinMove, % "ahk_id " . ATLWinHWND, , 0,0, A_GuiWidth, A_GuiHeight
   if(global AlwaysOnTop == 1)
		{
		Gui,+AlwaysOnTop
		}
   return
}
;; capture the gui resize event
GuiSize:
{
   ;; if there is a resize event lets resize the browser
   WinMove, % "ahk_id " . ATLWinHWND, , 0,0, A_GuiWidth, A_GuiHeight
	MyWidth = w%A_GuiWidth%
	MyHeight = h%A_GuiHeight%
   return
}
GuiClose:
terminate:
{
   Gui, Destroy
   ObjRelease(pipa)
   ExitApp
}
WM_KEYDOWN(wParam, lParam, nMsg, hWnd)
{
   global pipa
   static keys:={9:"tab", 13:"enter", 46:"delete", 38:"up", 40:"down"}
   if keys.HasKey(wParam)
   {
   WinGetClass, ClassName, ahk_id %hWnd%
   if  (ClassName = "Internet Explorer_Server")
   {
   ; Build MSG Structure
   VarSetCapacity(Msg, 7*A_PtrSize)
   for i,val in [hWnd, nMsg, wParam, lParam, A_EventInfo, A_GuiX, A_GuiY]
   NumPut(val, Msg, (i-1)*A_PtrSize)
   ; Call Translate Accelerator Method
   TranslateAccelerator := NumGet(NumGet(1*pipa)+5*A_PtrSize)
   DllCall(TranslateAccelerator, "Ptr",pipa, "Ptr",&Msg)
   return, 0
   }
   }
}

Reloadit:
{
	Reload
	return
}
Defaultit:
{
	FileDelete, config.ini
	Reload
	return
}
Configit:
{	
	InputBox, UserInput, Web Location, Please enter a Url (Begin with http://)., , 480,200
	URL = %UserInput%
	SetTimer, WriteConfig, 100
	return
}
AboutMe:
{
MsgBox, 0, About, Developed by SmugBrowser (ron@smugzombie.com)
IfMsgBox No
    return
}

ToggleCaption:
{
	if(global DisplayTitle == 0)
		{
		Gui, +Caption
		global DisplayTitle = 1
		;ToolTip, %DisplayTitle%
		WinMove, % "ahk_id " . ATLWinHWND, , 0,0, A_GuiWidth, A_GuiHeight
		Menu, Submenu2, ToggleCheck, Show Title
		return
		}
	if(global DisplayTitle == 1)
		{
		Gui, -Caption
		global DisplayTitle = 0
		;ToolTip, %DisplayTitle%
		WinMove, % "ahk_id " . ATLWinHWND, , 0,0, A_GuiWidth, A_GuiHeight
		Menu, Submenu2, ToggleCheck, Show Title
		return
		}
}
ToggleOnTop:
{
	if(global AlwaysOnTop == 0)
		{
		Gui,+AlwaysOnTop
		global AlwaysOnTop = 1
		WinMove, % "ahk_id " . ATLWinHWND, , 0,0, A_GuiWidth, A_GuiHeight
		Menu, Submenu2, ToggleCheck, Top Most
		return
		}
	if(global AlwaysOnTop == 1)
		{
		Gui,-AlwaysOnTop
		global AlwaysOnTop = 0
		WinMove, % "ahk_id " . ATLWinHWND, , 0,0, A_GuiWidth, A_GuiHeight
		Menu, Submenu2, ToggleCheck, Top Most
		return
		}	
}
ToggleScroll:
{
	if(global DisplayScroll == 0)
		{
		WB.Document.Body.Style.Overflow := "auto"
		global DisplayScroll = 1
		WinMove, % "ahk_id " . ATLWinHWND, , 0,0, A_GuiWidth, A_GuiHeight
		Menu, Submenu2, ToggleCheck, Show Scroll
		return
		}
	if(global DisplayScroll == 1)
		{
		WB.Document.Body.Style.Overflow := "hidden"
		global DisplayScroll = 0
		WinMove, % "ahk_id " . ATLWinHWND, , 0,0, A_GuiWidth, A_GuiHeight
		Menu, Submenu2, ToggleCheck, Show Scroll
		return
		}	
}
ToggleFullsize:
{
	if(global DisplayFull == 0)
		{
			Gui, Maximize
			global DisplayFull == 1
			Menu, Submenu2, ToggleCheck, Full Screen
		}
	if(global DisplayFull == 1)
		{
			Gui, +Resize
			global DisplayFull == 0
			Menu, Submenu2, ToggleCheck, Full Screen
		}
   return
}
SaveConfig:
{
	SetTimer, WriteConfig, 0
}
WriteConfig:
{
	IfExist, config.ini
		TrayTip, Saving.., We Appreciate Your Patience.
		SetTimer, RemoveTrayTip, 150
		FileDelete, config.ini
		FileAppend, %URL%`n%DisplayTitle%`n%AlwaysOnTop%`n%DisplayScroll%`n%DisplayFull%`n%MyWidth%`n%MyHeight%`n%Version%`nCOMPLETE, config.ini
		FileReadLine, TEST, config.ini, 9
		;TrayTip, TEST, %TEST%
		if(TEST == "")
			{
				TrayTip, %TEST%, Thanks for Waiting!
				SetTimer, RemoveTrayTip, 150
				SetTimer, WriteConfig, 160
				return
			}
		TrayTip, Saving.., %TEST%
		SetTimer, RemoveTrayTip, 2000
		Sleep 1200
		Reload
}

CheckConfig:
	{
	FileReadLine, my1, config.ini, 1
	FileReadLine, my2, config.ini, 2
	FileReadLine, my3, config.ini, 3
	FileReadLine, my4, config.ini, 4
	FileReadLine, my5, config.ini, 5
	FileReadLine, my6, config.ini, 6
	FileReadLine, my7, config.ini, 7
	FileReadLine, my8, config.ini, 8
	FileReadLine, my9, config.ini, 9
	FileReadLine, my0, config.ini, 10
	
	MsgBox, 0, Config.ini, ID:Value`n1: %my1%`n2: %my2%`n3: %my3%`n4: %my4%`n5: %my5%`n6: %my6%`n7: %my7%`n8: %my8%`n9: %my9%`n0: %my0%
	return
	}
	
Clickit:
{
	if(clickok == 1)
	{
		;MouseMove, 20, 20
		;click
		Send {Click 20, 20, right}
		;SendEvent {Click, 100, 200, right}
		;sleep 10
		MouseMove, 18, 18
		click
		click up
		clickok = 0
	}
	return
}

!.::
;TrayTip, FullSize, %DisplayFull%
;SetTimer, RemoveTrayTip, 5000
SetTimer, ToggleFullsize, 1
return

!,::
clickok = 1
SetTimer, Clickit, 0
return

RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
return

RemoveTrayTip:
SetTimer, RemoveTrayTip, Off
TrayTip
return

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
