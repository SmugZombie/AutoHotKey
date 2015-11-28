;Test Gui
Appname = Test
Version = 0.01
Gui, +OwnDialogs +owner -MaximizeBox -MinimizeBox +LastFound +AlwaysOnTop
Gui, Color, 424242
Gui, Font, c01DF01
Gui, Add, Text, x10 y9, Active:
Gui, Show, w100 h100, %AppName% %version%