#SingleInstance Force
#Persistent
SetBatchLines,-1
HookProcAdr := RegisterCallback( "HookProc", "F" )
hWinEventHook := SetWinEventHook( 0x9, 0x9, 0, HookProcAdr, 0, 0, 0 )
OnExit, HandleExit
Return

HookProc( hWinEventHook, Event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime )
{
	if Event ; EVENT_SYSTEM_FOREGROUND = 0x3
	{	
		WinGetClass, class, ahk_id %hWnd%
		If class = PuTTY
		{
			WinGetPos, X, Y, Width, Height, PuTTY (inactive)
			Newx = %X%
			Newy := y + Height
			WinMove, Untitled - Notepad,, %NewX%, %NewY%
		}
		else If class = AutoHotkeyGUI
		{
			WinGetPos, X, Y, Width, Height, PuTTY (inactive)
			WinGetPos, X2, Y2, Width2, Height2, Untitled - Notepad
			Newx = %X2%
			Newy := y2 - Height
			WinMove, PuTTY (inactive),, %NewX%, %NewY%
		}
			;WinClose, ahk_class Notepad	
			;MsgBox Test	
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
}

HandleExit:
UnhookWinEvent()
ExitApp
Return