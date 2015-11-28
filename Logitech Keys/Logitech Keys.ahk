#Persistent
#SingleInstance Force
SendMode Input
#InstallKeybdHook ; Better for keys

applicationname="Logitech k750 Keys"
inipath = %A_Temp%\Logitech.ini

Menu, tray, NoStandard
Menu, Settings, add, Key History, KeyHook
Menu, Settings, add, Run On Startup, ROS
;Menu, Settings, add, INI, findini

Menu, tray, add, Settings, :Settings
Menu, tray, add,
Menu, tray, add, Reload
Menu, tray, add, Exit, Quit

GoSub, LoadSettings
; sc02b = Pipe key next to return
; sc056 = Pipe key next to l-shift
;+sc02b:: send \
;^sc02b:: send |
Hotkey, +sc02b, SendSlash
Hotkey, ^sc02b, SendPipe
sc02b::Enter
sc056::Shift

return

SendSlash:
send \
return

SendPipe:
send |
return

quit:
ExitApp
return

reload:
reload
return

settings:

return

keyhook:
KeyHistory
return

LoadSettings:
SplitPath, A_Scriptname, , , , OutNameNoExt 
LinkFile=%A_Startup%\%OutNameNoExt%.lnk 
IfExist, %LinkFile%
	{
	IniWrite, 1, %inipath%, Preferences, Startup
	IniRead, Startup, %inipath%, Preferences, Startup
	Menu, Settings, Check, Run On Startup
	}
Else{
	IniRead, Startup, %inipath%, Preferences, Startup, 0
	IniWrite, 0, %inipath%, Preferences, Startup
}
return

findini:
run %inipath%
return

ROS:
SplitPath, A_Scriptname, , , , OutNameNoExt 
LinkFile=%A_Startup%\%OutNameNoExt%.lnk 
If(Startup = 1){
IfExist, %LinkFile%
	FileDelete, %LinkFile% 
	IniWrite, %nothing%, %inipath%, Preferences, Startup_Location
	Menu, Settings, UnCheck, Run On Startup
	Startup = 0
}
else{
IfNotExist, %LinkFile% 
 	 FileCreateShortcut, %A_ScriptFullPath%, %LinkFile% 
 	 IniWrite, %LinkFile%, %inipath%, Preferences, Startup_Location
 	 Menu, Settings, Check, Run On Startup
 	 Startup = 1
}
Iniwrite, %Startup%, %inipath%, Preferences, Startup
return