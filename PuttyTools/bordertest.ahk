;BorderThickness:=3, BorderColor:="ffffff",  TW:=100, TH:=100

Gui +LastFound 
Gui, Color, ffffff
;Gui, Margin, %BorderThickness%, %BorderThickness%
;Gui, Color, %BorderColor%
;Gui, Add, Text, w%TW% h%TH% 0x444 ; Draw a white static control
Gui, Add, Button, , Hello
Gui, Add, Button, , World
;WinSet, TransColor, FFFFFF
Gui -Caption +AlwaysOnTop +ToolWindow
Return

~Control::
  MouseGetPos, xpos, ypos 
  xpos := xpos - 50
  ypos := ypos - 50 
  Gui, Show, NoActivate x%xpos% y%ypos% h100 w100
  Loop {
        If Not GetKeyState( "Control", "P" )
        Break
        Sleep 50
       } 
  Gui, Hide
Return 