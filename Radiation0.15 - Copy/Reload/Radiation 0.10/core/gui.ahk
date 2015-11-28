Gui,+AlwaysOnTop +ToolWindow -SysMenu -Caption +LastFound
Gui, Add, Picture,x0 y0, parts/radiation3.png
Gui, Color, 424242
WinSet, TransColor, 1C1C1C
Gui,2: -Caption +0x800000 +AlwaysOnTop +ToolWindow
Gui,2: Color, FFFFE7
Gui,2: Margin, 0,0
Gui,2: Font, s9 , Verdana
Gui,2: Add, Text, x0 y0 +0x4   w400 h19
Gui,2: Add, Text, x0 y0 +0x200 w400 h19 cFFFF80 Backgroundtrans vCaption
   , % A_Space " About"
Gui, 3: Add, Text, Hello World!
Gui, Show, x%MyWidth% y%MyHeight% h20 w20