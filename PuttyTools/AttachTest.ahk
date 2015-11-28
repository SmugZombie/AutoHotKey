#include %A_ScriptDir%\AttachToolWindow.ahk
#a::
hParent := WinExist("A")
GuiNum := GetFreeGuiNum(1)
Gui, %GuiNum%:Add, Text,,blup blup blup
Gui, %GuiNum%:Show, AutoSize, tool window
AttachToolWindow(hParent, GuiNum, 1)
return

;This will only deattach the first gui window. If you don't like this, write a better example!
#d::DeAttachToolWindow(1)

GetFreeGuiNum(start){
	loop {
		Gui %start%:+LastFoundExist
		IfWinNotExist
			return start
		start++
		if(start = 100)
			return 0
	}
	return 0
}