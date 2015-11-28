#Singleinstance, Force
Gui, Color, EEAA99
Gui, Font, S72, Arial Black
Gui, Add, Text, BackgroundTrans vT1, 00:00:00
Gui, Add, Text, xp-3 yp-3 cFFB10F BackgroundTrans vT2, 00:00:00
Gui +LastFound +AlwaysOnTop +ToolWindow
WinSet, TransColor, EEAA99
Gui -Caption
Gui, Show
SetTimer, Update, 1000
Update:
 GuiControl,, T1, % A_Hour ":" A_Min ":" A_Sec
 GuiControl,, T2, % A_Hour ":" A_Min ":" A_Sec
Return