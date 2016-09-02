#NoEnv
#SingleInstance off
Menu, Tray, NoStandard
Menu, Tray, Add, Exit, ExitA
Gui, 1: Add, Text, x5 y5 w300 h20, Keys:
Gui, 1: Add, Text, x45 y5 -wrap h20, 1.
temp := Random(Random(Random(1,25),Random(26,50)),Random(Random(51,75),Random(76,99)))
Gui, 1: Add, Edit, Number limit2 x60 y5 w25 h20 vKey1, %temp%
Gui, 1: Add, Text, y5 x90 -wrap h20, 2.
temp := Random(Random(Random(1,25),Random(26,50)),Random(Random(51,75),Random(76,99)))
Gui, 1: Add, Edit, Number limit2 x100 y5 w25 h20 vKey2, %temp%
Gui, 1: Add, Text, y5 x130 -wrap h20, 3.
temp := Random(Random(Random(1,25),Random(26,50)),Random(Random(51,75),Random(76,99)))
Gui, 1: Add, Edit, Number limit2 x140 y5 w25 h20 vKey3, %temp%
Gui, 1: Add, Text, y5 x170 -wrap h20, 4.
temp := Random(Random(Random(1,25),Random(26,50)),Random(Random(51,75),Random(76,99)))
Gui, 1: Add, Edit, Number limit2 x180 y5 w25 h20 vKey4, %temp%


Gui, 1: Add, Edit, x5 y25 w305 h280 vEditBox, 
Gui, 1: Add, Button, x5 y310 w150 gEncode, &Encode
Gui, 1: Add, Button, x160 y310 w150 gDecode, &Decode
Gui, 1: Add, Button, x215 y5 w95 h20 gRandomizeKeys, &Randomize Keys
Gui, 1: Show, Center, Encryptor
Return

ExitA:
   ExitApp
Return

Encode:
   Gui, 1: Submit, NoHide
   temp := Code(EditBox,1,Key1,Key2,Key3,Key4)
   GuiControl, 1:, Editbox, %temp%
   temp := ""
Return

Decode:
   Gui, 1: Submit, NoHide
   temp := Code(EditBox,-1,Key1,Key2,Key3,Key4)
   GuiControl, 1:, Editbox, %temp%
   temp := ""
Return

RandomizeKeys:
   temp := Random(Random(Random(1,25),Random(26,50)),Random(Random(51,75),Random(76,99)))
   GuiControl, 1:, Key1, %temp%
   temp := Random(Random(Random(1,25),Random(26,50)),Random(Random(51,75),Random(76,99)))
   GuiControl, 1:, Key2, %temp%
   temp := Random(Random(Random(1,25),Random(26,50)),Random(Random(51,75),Random(76,99)))
   GuiControl, 1:, Key3, %temp%
   temp := Random(Random(Random(1,25),Random(26,50)),Random(Random(51,75),Random(76,99)))
   GuiControl, 1:, Key4, %temp%
Return

Code(x,E,K1=0,K2=1,K3=2,K4=3) { ; x: data string, E=1|-1: encode|decode, K1..4: 32 bit unsigned keys
   Static S:="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890 -=~!@#$%^&*()_+[\]{|};:'"",./<?>"
   Loop % StrLen(x)
      D%A_Index% := 0
   Loop 4 {
      Random,,K%A_Index%
      Loop % StrLen(x) {
         Random D, 0, 93
         D%A_Index% := mod(D+D%A_Index%,94)
      }
   }
   Loop Parse, x
      C .= SubStr(S, mod(InStr(S,A_LoopField,1)+93+E*D%A_Index%,94)+1, 1)
   Return C
}

Random(min=1,max=6) {
   Random, x, Min, Max
   Return, x
}

f12::reload