;Gui1 = Main
;Gui2 = About
;Gui3 = Settings

;MAIN
Gui,+AlwaysOnTop +ToolWindow -SysMenu -Caption +LastFound
Gui, Add, Picture,x0 y0, parts/radiation3.png
Gui, Color, 424242
WinSet, TransColor, 1C1C1C

;About
Gui, 2: +AlwaysOnTop +ToolWindow -SysMenu +LastFound
Gui, 2: Add, Text,x10 y5 , AppName: Radiation
Gui, 2: Add, Text,x10 y+0 , Developer: Ron Egli
Gui, 2: Add, Text,x10 y+0 , Developed: October 2013
Gui, 2: Add, Text,x10 y+10 , Summary:
Gui, 2: Add, Text,x10 y+0, A Simple AlwaysOnTop Application/Script Launcher Customizable
Gui, 2: Add, Text,x10 y+0 ,  to your needs.
Gui, 2: Add, Text,x10 y+10 ,  More Info: http://8ill.com/radiation/
Gui, 2: Add, Text,x10 y+0 ,  Version: %version%
Gui, 2: Add, Text,x10 y+10, IP: %myip%
Gui, 2: Add, Text,x10 y+10, KEY: %mykey%

;Settings
Gui, 3: +AlwaysOnTop +ToolWindow -SysMenu +LastFound
Gui, 3: Add, Text, Hello World!

;Cloud
Gui, 4: +AlwaysOnTop +ToolWindow -SysMenu +LastFound
Gui, 4: Add, Text, x10 y13 ,Email:
Gui, 4: Add, Edit, x75 y10 vEmail
Gui, 4: Add, Text, x10 y38 ,Password:
Gui, 4: Add, Edit, x75 y35 vPassword
Gui, 4: Add, Button, default x50 y+10 w100, SyncApp


