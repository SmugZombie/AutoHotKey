Gui, Add, Text,, Pick an Application to launch from the list below
Gui, Add, ListBox, vMyListBox gMyListBox w280 r8
Gui, Add, Button, Default, Launch
Loop, %A_WorkingDir%\*.ahk
{
    GuiControl,, MyListBox, %A_LoopFileName%
}
Loop, %A_WorkingDir%\*.exe
{
    GuiControl,, MyListBox, %A_LoopFileName%
}
Gui, Show
return

MyListBox:
if A_GuiEvent <> DoubleClick
    return
ButtonLaunch:
GuiControlGet, MyListBox  ; Retrieve the ListBox's current selection.
Run, %MyListBox%,, UseErrorLevel
if ErrorLevel = ERROR
    MsgBox Could not launch the specified file.  Perhaps it is not associated with anything.
ExitApp
return
GuiClose:
GuiEscape:
ExitApp