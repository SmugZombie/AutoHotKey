#SingleInstance Force
#Persistent
WindowToFollow = LivePerson 51516811 [regli - Logged On]
Version = 0.01
ThisWindow = LivePersonFollower %Version%
SetBatchLines,-1
HookProcAdr := RegisterCallback( "HookProc", "F" )
hWinEventHook := SetWinEventHook( 0x3, 0x3, 0, HookProcAdr, 0, 0, 0 )
HookProcAdr2 := RegisterCallback( "HookProc2", "F" )
hWinEventHook2 := SetWinEventHook( 0x9, 0x9, 0, HookProcAdr, 0, 0, 0 )
OnExit, HandleExit

Gui, +AlwaysOnTop -Caption +OwnDialogs +ToolWindow
Gui, Color, EEAA99
Gui, Font, S5 ;CDefault, Verdana
;Gui, Add, Button, x5 y5 , Hello World
Gui, Add, DDL, vMyActions x5 y5 w150, Hello||World|How|Are|You?
Gui, Add, Button, x160 y5 w30 -wrap, ABC
Gui, Add, Button, x192 y5 w30 -wrap, DEF
Gui, Add, Button, x224 y5 w30 -wrap, GHI
Gui, Add, Button, x256 y5 w30 -wrap, JKL
Gui, Font, S12
Gui, Add, Text, y25 x43 BackgroundTrans vT1, 00:00:00
Gui, Font, S5
Gui, Add, Button, x160 y25 w30 -wrap, MNO
Gui, Add, Button, x192 y25 w30 -wrap, PQR
Gui, Add, Button, x224 y25 w30 -wrap, STU
Gui, Add, Button, x256 y25 w30 -wrap, VWX
Gui, +LastFound
WinSet, TransColor, EEAA99
SetTimer, Update, 1000
Return

Update:
 GuiControl,, T1, % A_Hour ":" A_Min ":" A_Sec
 ;GuiControl,, T2, % A_Hour ":" A_Min ":" A_Sec
Return

HookProc( hWinEventHook, Event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime )
{
	if Event ; EVENT_SYSTEM_FOREGROUND = 0x3
	{	
		WinGetClass, class, ahk_id %hWnd%
		WinGetTitle, Title, ahk_id %hwnd%
		If class = SunAwtFrame
		{
			;x := A_ScreenWidth - 300
			x = 1
			y = 1
			WinGetPos, X, Y, Width, Height, %Title%
			Newx := X + Width - 300
			Newy := y + 54
			;WinMove, %ThisWindow%,, %NewX%, %NewY%
			Gui, Show, NoActivate w290 x%NewX% y%NewY%, %ThisWindow%
			Gui, +AlwaysOnTop
			;Gui, -AlwaysOnTop
		}
		else{
			;Gui, Hide
			Gui, -AlwaysOnTop
		}
		/*
		else If class = AutoHotkeyGUI
		{
			WinGetPos, X, Y, Width, Height, %WindowToFollow%
			WinGetPos, X2, Y2, Width2, Height2, %ThisWindow%
			Newx = %X2%
			Newy := y2 - Height
			WinMove, %WindowToFollow%,, %NewX%, %NewY%
		}
		*/
	}
}

HookProc2( hWinEventHook2, Event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime )
{
	Global
	if Event ; EVENT_SYSTEM_FOREGROUND = 0x9
	{	
		WinGetClass, class, ahk_id %hWnd%
		WinGetTitle, Title, ahk_id %hwnd%
		If class = SunAwtFrame
		{
			;x := A_ScreenWidth - 300
			x = 1
			y = 1
			WinGetPos, X, Y, Width, Height, %Title%
			Newx := X + Width - 300
			Newy := y + 54
			;WinMove, %ThisWindow%,, %NewX%, %NewY%
			Gui, Show, NoActivate w290 x%NewX% y%NewY%, %ThisWindow%
			Gui, +AlwaysOnTop
			;Gui, -AlwaysOnTop
		}
		else{
			;Gui, Hide
			;Gui, -AlwaysOnTop
		}
	}
}

SetWinEventHook(eventMin, eventMax, hmodWinEventProc, lpfnWinEventProc, idProcess, idThread, dwFlags)
{
	DllCall("CoInitialize", Uint, 0)
	return DllCall("SetWinEventHook"
	, Uint,eventMin	
	, Uint,eventMax	
	, Uint,hmodWinEventProc
	, Uint,lpfnWinEventProc
	, Uint,idProcess
	, Uint,idThread
	, Uint,dwFlags)	
}

UnhookWinEvent()
{
	Global
	DllCall( "UnhookWinEvent", Uint,hWinEventHook )
	DllCall( "GlobalFree", UInt,&HookProcAdr ) ; free up allocated memory for RegisterCallback
	DllCall( "UnhookWinEvent", Uint,hWinEventHook2 )
	DllCall( "GlobalFree", UInt,&HookProcAdr2 ) ; free up allocated memory for RegisterCallback
}

HandleExit:
UnhookWinEvent()
ExitApp
Return