#NoEnv

WinGet, AllWinsHwnd, List

DetectHiddenWindows, On
Gui,+LastFound
GuiHwnd := WinExist()

GroupAdd, MyGui, ahk_id %GuiHwnd%  ; to use with ifwinactive directive

Gui, Font, s13, Courier New
Gui, Add, ListView, Grid R15 w900, Hwnd|Class|Title|Process|Folder

Loop, % AllWinsHwnd
{
	if not IsWindow(AllWinsHwnd%A_Index%)
		continue
	
	WinGetTitle, CurrentWinTitle, % "ahk_id " AllWinsHwnd%A_Index%
	WinGet, CurrentWinProc, ProcessName, % "ahk_id " AllWinsHwnd%A_Index%
	
	WinGetClass, CurrentWinClass, % "ahk_id " AllWinsHwnd%A_Index%
	CurrentWinPath := (CurrentWinClass = "CabinetWClass") ? GetFolder(AllWinsHwnd%A_Index%) : ""
	
	LV_Add("AutoHdr", AllWinsHwnd%A_Index%, CurrentWinClass, CurrentWinTitle, CurrentWinProc, CurrentWinPath)
}

LV_ModifyCol(1, 0)
LV_ModifyCol(2, 0)
LV_ModifyCol(3, 300)
LV_ModifyCol(4, 150)
LV_ModifyCol(5, "AutoHdr")

LV_ModifyCol(2, "Sort")

Gui, Show
WinSet, Redraw,, ahk_id %GuiHwnd% ; sometimes the window will not show its controls. this seems to help
return

; end of autoexec ------------------------------------------------

; gui subroutines ------------------------------------------------

#IfWinActive, ahk_group MyGui
	Del::GoSub, CloseSelectedWins
	Enter::GoSub, ActivateFirstSelectedWin

	p::SortBy(4)
	c::SortBy(2)

	+p::SelectSame(4)
	+c::SelectSame(2)
	
	^a::LV_Modify(0, "Select")
	
	F1::ShowHelp()
	F5::Reload
#IfWinActive


GuiClose:
GuiEscape:
ExitApp


CloseSelectedWins:
	Gui, +LastFound
	CurrentRow := 0  ; This causes the first loop iteration to start the search at the top of the list.
	Loop
	{
		CurrentRow := LV_GetNext(CurrentRow)  ; Resume the search at the row after that found by the previous iteration.
		if not CurrentRow  ; The above returned zero, so there are no more selected rows.
			break
		LV_GetText(CurrentWinHwnd, CurrentRow, 1)
		WinClose, ahk_id %CurrentWinHwnd%
	}
ExitApp


ActivateFirstSelectedWin:
	CurrentRow := LV_GetNext(0)
	if not CurrentRow  ; The above returned zero, so there are no more selected rows.
		ExitApp
	LV_GetText(CurrentWinHwnd, CurrentRow, 1)
	WinActivate, ahk_id %CurrentWinHwnd%
ExitApp


SortBy(col) {
	global
	LV_ModifyCol(col, "Sort")
}


SelectAllBy(col, value) {
	global
	local CurrentRow, CurrentValue
	
	Loop, % LV_GetCount()
	{
		CurrentRow := A_Index
		
		LV_GetText(CurrentValue, CurrentRow, col)
		
		if (CurrentValue = value)
			LV_Modify(CurrentRow, "Select")
	}		
}


SelectSame(col) {  ; searches based on first selected item
	global
	local CurrentValue
	
	LV_GetText(CurrentValue, LV_GetNext(), col)

	SelectAllBy(col, CurrentValue)
}


ShowHelp() {
	helpText = 
	(
Del	Close selected windows
Enter	Activate first selected window

p	Sort by process
c	Sort by class
		
Shift+p	Select all matching selected window's process
Shift+c	Select all matching selected window's class
	
Ctrl+a	Select all
		
F1	Show this help
F5	Reload
	)
	
	MsgBox % helpText
}

; end of gui subroutines -----------------------------------------

; helper functions -----------------------------------------------

GetFolder(Hwnd) {	; working on win7 starter. FIXME: works on XP?
	WinGetText, CurrentWinText, ahk_id %Hwnd%
	Loop, Parse, CurrentWinText, `n, `r
	{
		CurrentWinPath := A_LoopField
		StringReplace, CurrentWinPath, CurrentWinPath, % "Address: "
		break
	}

	return CurrentWinPath
}


IsWindow(hwnd) ; ManaUser's, http://www.autohotkey.com/forum/viewtopic.php?t=27797
{
	WinGet, s, Style, ahk_id %hwnd% 
	return s & 0xC00000 ? (s & 0x80000000 ? 0 : 1) : 0
	;WS_CAPTION AND !WS_POPUP(for tooltips etc) 
}