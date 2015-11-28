Gui,+AlwaysOnTop +ToolWindow -SysMenu -Caption
Gui, Add, Text,, Pick an Application to launch from the list below
Gui, Add, ListBox, vMyListBox gMyListBox w280 r8
Gui, Add, Button, Default, Launch
Gui, Add, Button, ym+133 x+5, Add
Loop, read, %A_WorkingDir%\parts\apps.smug
{
	GuiControl,, MyListBox, %A_LoopReadLine%
}
Loop, %A_WorkingDir%\apps\*.ahk
{
    GuiControl,, MyListBox, %A_LoopFileFullPath% 
	;%A_LoopFilePath%
}
Loop, %A_WorkingDir%\apps\*.exe
{
    GuiControl,, MyListBox, %A_LoopFileFullPath%
}
Gui, Show
return

ButtonAdd:
FileSelectFile, SelectedFile, 3, , Open a file,
FileAppend, `n%SelectedFile%, parts/apps.smug
GuiControl,, MyListBox, %SelectedFile% 
return

MyListBox:
if A_GuiEvent <> DoubleClick
    return
ButtonLaunch:
GuiControlGet, MyListBox  ; Retrieve the ListBox's current selection.
;Run, %A_WorkingDir%\apps\%MyListBox%,, UseErrorLevel
Run, %MyListBox%,, UseErrorLevel
if ErrorLevel = ERROR
    MsgBox Could not launch the specified file.  Perhaps it is not associated with anything.
ExitApp
return
GuiClose:
GuiEscape:
ExitApp
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