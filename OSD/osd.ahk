; Example: On-screen display (OSD) via transparent window:

CustomColor = EEAA99  ; Can be any RGB color (it will be made transparent below).
Gui +LastFound +AlwaysOnTop -Caption +ToolWindow  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
Gui, Color, %CustomColor%
Gui, Font, s28  ; Set a large font size (32-point).
Gui, Add, Text, vMyText cLime, XXXXX YYYYY  ; XX & YY serve to auto-size the window.
; Make all pixels of this color transparent and make the text itself translucent (150):
WinSet, TransColor, %CustomColor% 150
SetTimer, UpdateOSD, 200
Gosub, UpdateOSD  ; Make the first update immediate rather than waiting for the timer.
MyY := A_ScreenHeight - 100
Gui, Show, x0 y%MyY% NoActivate  ; NoActivate avoids deactivating the currently active window.
return

UpdateOSD:
if(A_HOUR = 0){
	Hour := 12
	M = AM
}
else if(A_HOUR > 12){
	Hour := A_HOUR - 12
	M = PM
}
else{
	Hour = %A_HOUR%
	M = AM
}
GuiControl,, MyText, %Hour%:%A_Min%:%A_Sec% %M%
return