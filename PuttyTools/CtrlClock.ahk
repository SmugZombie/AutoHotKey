/*
Gui +LastFound 
Gui, Color, ffffff
Gui, Add, Button, , Hello
Gui, Add, Button, , World
Gui -Caption +AlwaysOnTop +ToolWindow
Return
*/
AppName = PuTTYTools
Version = 0.34
INI = PTools.ini
LOG = PTools_log.txt
inipath = %A_ScriptDir%\%INI%
logpath = %A_ScriptDir%\%LOG%

#Singleinstance, Force
GoSub, ReadINI
Gui, Color, EEAA99
Gui, Font, S24, Arial Black
Gui, Add, Text, BackgroundTrans vT1, 00:00:00
Gui, Add, Text, xp-3 yp-3 cDF3A01 BackgroundTrans vT2, 00:00:00
Gui, Font, S6 CDefault, Verdana
Gui, Add, Button, y60 x25 w35 -wrap gDoStuff vButton1, %Button1Name%
Gui, Add, Button, y60 x+5 w35 -wrap gDoStuff vButton2, %Button2Name%
Gui, Add, Button, y60 x+5 w35 -wrap gDoStuff vButton3, %Button3Name%
Gui, Add, Button, y60 x+5 w35 -wrap gDoStuff vButton4, %Button4Name%
Gui +LastFound +AlwaysOnTop +ToolWindow
WinSet, TransColor, EEAA99
Gui -Caption
;Gui, Show

Update:
 GuiControl,, T1, % A_Hour ":" A_Min ":" A_Sec
 GuiControl,, T2, % A_Hour ":" A_Min ":" A_Sec
Return

~Control::
  MouseGetPos, xpos, ypos 
  ;xpos := xpos - 140
  ;ypos := ypos - 70 
  Gui, Show, NoActivate x30 y30
  SetTimer, Update, 1000
  Loop {
        If Not GetKeyState( "Control", "P" )
        Break
        Sleep 50
       } 
  Gui, Hide
Return 

Reload:
Reload
return

DoStuff:
Gui, Submit, NoHide
ButtonAction = %A_GUIControl%
if(ButtonAction = "Button1"){
	run %Button1Action%
}
else if(ButtonAction = "Button2"){
	run %Button2Action%	
}
else if(ButtonAction = "Button3"){
	run %Button3Action%	
}
else if(ButtonAction = "Button4"){
	run %Button4Action%	
}
return

Time:
run http://faultipro.com
return

Dig:
run http://digdns.com
return

Imgur:
run http://imgur.com
return

ReadINI:
IniRead, Button1Name, %inipath%, Preferences, Button1Name
if(Button1Name = "?" || Button1Name == "ERROR"){
	Button1Name = Ulti
	Iniwrite, %Button1Name%, %inipath%, Preferences, Button1Name
	IniRead, Button1Name, %inipath%, Preferences, Button1Name
}
IniRead, Button1Action, %inipath%, Preferences, Button1Action
if(Button1Action = "?" || Button1Action == "ERROR"){
	Button1Action = http://faultipro.com
	Iniwrite, %Button1Action%, %inipath%, Preferences, Button1Action
	IniRead, Button1Action, %inipath%, Preferences, Button1Action
}

IniRead, Button2Name, %inipath%, Preferences, Button2Name
if(Button2Name = "?" || Button2Name == "ERROR"){
	Button2Name = Dig
	Iniwrite, %Button2Name%, %inipath%, Preferences, Button2Name
	IniRead, Button2Name, %inipath%, Preferences, Button2Name
}
IniRead, Button2Action, %inipath%, Preferences, Button2Action
if(Button2Action = "?" || Button2Action == "ERROR"){
	Button2Action = http://digdns.com
	Iniwrite, %Button2Action%, %inipath%, Preferences, Button2Action
	IniRead, Button2Action, %inipath%, Preferences, Button2Action
}

IniRead, Button3Name, %inipath%, Preferences, Button3Name
if(Button3Name = "?" || Button3Name == "ERROR"){
	Button3Name = Imgur
	Iniwrite, %Button3Name%, %inipath%, Preferences, Button3Name
	IniRead, Button3Name, %inipath%, Preferences, Button3Name
}
IniRead, Button3Action, %inipath%, Preferences, Button3Action
if(Button3Action = "?" || Button3Action == "ERROR"){
	Button3Action = http://imgur.com
	Iniwrite, %Button3Action%, %inipath%, Preferences, Button3Action
	IniRead, Button3Action, %inipath%, Preferences, Button3Action
}

IniRead, Button4Name, %inipath%, Preferences, Button4Name
if(Button4Name = "?" || Button4Name == "ERROR"){
	Button4Name = Reload
	Iniwrite, %Button4Name%, %inipath%, Preferences, Button4Name
	IniRead, Button4Name, %inipath%, Preferences, Button4Name
}
IniRead, Button4Action, %inipath%, Preferences, Button4Action
if(Button4Action = "?" || Button4Action == "ERROR"){
	Button4Action = Reload
	Iniwrite, %Button4Action%, %inipath%, Preferences, Button4Action
	IniRead, Button4Action, %inipath%, Preferences, Button4Action
}

return