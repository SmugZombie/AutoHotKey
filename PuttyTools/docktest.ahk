Run notepad,,,nPID
   WinWait ahk_pid %nPID%
   Dock_HostID := WinExist("ahk_pid " . nPID)

   Gui +LastFound -Caption +ToolWindow +Border
   Gui Add, Text,,Docked Window
   Gui Show

   Dock(WinExist(), "0,0,0,    0,-1,-5,    0,120,   0,30")      ; above, left, fixed width
return
#include dock.ahk