; Author: Ron Egli - ron@r-egli.com - github.com/smugzombie
; Purpose: This file shows a simple splash screen for installation / launch
; ScriptName: Splash.exe
; Version: 1.0

SplashImage = Splash.jpg
SplashImageGUI(SplashImage, "Center", "Center", 3000, true)

SplashImageGUI(Picture, X, Y, Duration, Transparent = false)
{
Gui, XPT99:Margin , 0, 0
Gui, XPT99:Add, Picture,, %Picture%
Gui, XPT99:Color, ECE9D8
Gui, XPT99:+LastFound -Caption +AlwaysOnTop +ToolWindow -Border
If Transparent
{
Winset, TransColor, ECE9D8
}
Gui, XPT99:Show, x%X% y%Y% NoActivate
SetTimer, DestroySplashGUI, -%Duration%
return

DestroySplashGUI:
Gui, XPT99:Destroy
ExitApp
return
}
