;################################################
;##  SRTAware - SmugDev 2013
;##  A Division of SmugDNS
;##
;##	 ChangeLog:
;##		0.1  - Initial Release
;##     0.2  - Bug Fixes, RDP Ability Working
;##     0.35 - Port Checker Added, FTP/SFTP Ability Added, INI Added
;##     0.4  - Cleaned Up Code, AOT Added
;##     0.45 - Removed Control Box, Cleaned Up Code
;##     0.46 - AOT Fixes / Gui Reload Fixes
;##		0.47 - Code Cleanup / Context Menu Added
;##			   		AutoFind FileZilla (if in default location) / Locate FileZilla
;##		0.471- Quit Added to Context Menu
;##		0.48 - Added Password enabled ssh autologin
;##		0.481- AutoFind Putty (if in default location) / Locate Putty
;##     0.5  - Hotkey Added / Settings
;##     0.51 - BugFix
;##		0.52 - BugFix
;##		0.53 - Code Cleanup / AutoLoad Options	
;##     0.531- Hotkey Focus's application
;##     0.532- Fixed Multiple Hotkey --> Update Protocol
;##		0.533- AOT Fix / Toggle Windows Themes/ Cleanup / Removed Reload from Tray
;##     0.54 - Moved Settings and Ports to Context Menu
;##     0.541- AutoSearch BugFix
;##     0.542- GuiClose BugFix
;##		0.6 - Doubleclick tray to show gui if closed/hidden.
;##					Overrite old INI file.
;##					Checks for Updates.
;##					Toggle Hotkey Function
;##     0.61 - Input Formatting, Converts full URL's into just Host Data
;##		0.62 - Added CheckForUpdates Toggle / Save Coordinates / Settings Restructure
;##		0.621- Bugfix causing hostname to not be parsed correctly
;##		0.63 - Location set on gui close / WHen Gui is hidden Hotkey Now brings to front and does its thing
;##		0.631- Bugfix on hotkey / Bugfix on AutoConnect
;##     0.64 - Readme Builtin
;##		0.641- FTP/SFTP wont nag without a host		
;##		0.642- Run on startup.
;##		0.643- RDP Fix, removes user choice		
;##		0.644- Autorun Location --> Ini file for verification, Updated to Users start directory instead of common
;##		0.65 - Addition of VNCViewer.exe
;##		0.651- Download vncviewer.exe if not installed via context menu
;##		0.652- Automatically Downloads putty.exe if not found
;##     0.653- HOST Version
;##			To Do:
;##				- Automatic Updates
;##				
;##
;################################################
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance Force
OnMessage(0x204, "WM_RBUTTONDOWN")
;##################################
;######## Global Vars #############
;##################################
version = 0.653
If Not A_IsCompiled
	version = %version%dev
inipath = SRTAware.ini
nothing = 
GuiHide = 0
TypeToggle = 0
AppName = SRTAware
Developer = SmugDev (c) 2013
Website = http://ronegli.com
Purpose = Quick access to servers for testing of responsiveness or general access purposes
Usage = Once you open the application it will stay live until you choose Quit from either the context menu or tray. Its pretty self explanitory as you can simply enter a host (user and pass if applicable), choose your protocol, and click Connect launching the application required and resetting the gui. You can also throw host names into it automatcially with the key combo Ctrl-Shft-S using the contents of your clipboard. Always On Top is enabled by defualt but can be switched off via the Right Click context menu.
GoSub, ReadINI
;##################################
;########  Tray Menu  #############
;##################################
If A_IsCompiled
	Menu, tray, NoStandard
Menu, tray, add, %AppName% v%version%, Launchit
If Not A_IsCompiled
	Menu, tray, add, Reload, Reload
Menu, tray, add
Menu, tray, add, Quit, terminate
Menu, tray, default, %AppName% v%version%

Menu, Context2, add, Settings, Settings
Menu, Context2, add, Pin Location, SaveCoords
Menu, Context2, add, Always On Top, AOT

Menu, Context, add, Port Checker, Ports
Menu, Context, add
Menu, Context, add, Preferences, :Context2
Menu, Context, add
Menu, Context, add, Reload, Reload
Menu, Context, add, Quit, Terminate

;##################################
;########### GUI ##################
;##################################
if(VNC = 1){
	ifVNC = VNC
}
ConnectionTypes = SSH||RDP|FTP|SFTP|%ifVNC%
ConnectionTypes2 = SSH|RDP||FTP|SFTP|%ifVNC%
PortList = 80||22|25|110|143|21|443|3389
if(HOST = 0){
Gui, +OwnDialogs +owner -MaximizeBox -MinimizeBox +OwnDialogs +LastFound
Gui, Add, Text, vHostBox, Host:
Gui, Add, Text, vUserBox, User:
Gui, Add, Text, vPassBox, Pass:
Gui, Add, Edit, vHost ym  ; The ym option starts a new column of controls.
Gui, Add, Edit, vUser
Gui, Add, Edit, Password vPass
Gui, Add, DropDownList, w75 gTypeChooser vTypes ys, %ConnectionTypes%
Gui, Add, Button, default w75, Connect
Gui, Font, cBlue
Gui, Add, Text, gLaunchDev,SmugDev 2013
Gui, Font, cBlack
}
else{
Gui, +OwnDialogs +owner -MaximizeBox -MinimizeBox +OwnDialogs +LastFound
Gui, Add, Text, vHostBox ym y10, Host:
Gui, Add, Edit, vHost ym  ; The ym option starts a new column of controls.
Gui, Add, DropDownList, w75 gTypeChooser vTypes ym, %ConnectionTypes%
Gui, Add, Button, default w75 y7 ym, Connect
Gui, Font, cBlue
Gui, Add, Text, gLaunchDev ym y5,SmugDev 2013
Gui, Add, Text, x348 y20, HOST Version
Gui, Font, cBlack

}

if(GuiAOT = 1){
	Gui, 1: +AlwaysOnTop
	Menu, Context2, Check, Always On Top
}
Gui, Show, x%xloc% y%yloc%, %AppName% %version%

;########### GUI2 #################
Gui, 2: +owner1 +AlwaysOnTop -MaximizeBox -MinimizeBox
Gui, 2: Add, Text, w40, Host:
Gui, 2: Add, Text, w40, Port:
Gui, 2: Add, Button, default w75 gCheck, Check
Gui, 2: Add, Edit, vHost2 w100 ym y0
Gui, 2: Add, ComboBox, vPort w50, %PortList%
Gui, 2: Add, Edit, center vResult disabled w100

;########### GUI3 #################
Gui, 3: +owner1 +AlwaysOnTop -MaximizeBox -MinimizeBox
Gui, 3: Add, Checkbox, vEnableHotkey gToggleHotkey, Hotkey? (Ctrl+Shft+S)
Gui, 3: Add, Checkbox, vEnableAutoSearch gToggleAutoSearch,  Auto Connect?
Gui, 3: Add, Checkbox, VEnableThemes gToggleThemes, Windows Theme?
Gui, 3: Add, Checkbox, VEnableUpdate gToggleUpdate, Check For Updates?
Gui, 3: Add, Checkbox, VEnableStartup gToggleStartup, Startup With Windows?
Gui, 3: Add, Button, gCloseSettings, Close

WM_RBUTTONDOWN(wParam, lParam){
Menu, Context, Show
}

If(HotkeyEnabled = 1){
	Hotkey, ^+s, Keyin
}
return

Keyin:
Gui, Submit, NoHide
IfWinNotActive, %AppName% %version%
	WinActivate, %AppName% %version%
IfWinNotActive, %Appname% %version%
	Gui, Show
GuiHide = 0
ClipHost = %clipboard%
if(Host != ClipHost)
	GuiControl,, Host, %ClipHost%
if(AutoSearchEnabled = 1)
	GoSub, ButtonConnect
else
	{
		if(Host = Clipboard)
			if(TypeToggle = 1){
				TypeToggle = 0
				GuiControl,, Types, |%ConnectionTypes%
				GuiControl, enable, Pass
			}
			else{
				TypeToggle = 1
				GuiControl,, Types, |%ConnectionTypes2%
				GuiControl, Disable, Pass
				}
	}
return
;##################################
;########### /GUI #################
;##################################

;##################################
;######## Connect Button ##########
;##################################
ButtonConnect:
Gui, Submit, Nohide
GuiControl,, Host, %nothing%
GuiControl,, User, %nothing%
GuiControl,, Pass, %nothing%
GuiControl,, Types, |%ConnectionTypes%
GuiControl, Focus, Host
GoSub, FormatHost
if(Types = "SSH"){
if(SSH != 0)
	{
	if(User != "" && Pass = "")
		host = %user%@%host%
	else if(Pass != "" && User != "")
			host = "%host% -l %user% -pw %pass%"
	Run %PuttyPath% "-ssh" "%host%"
	}
else{
	msgbox Putty could not be found. Reload App to search again.
	}
}

else if(Types = "RDP"){
Run mstsc /v:%host%
}
else if(Types = "VNC"){
if(VNC != 0){
	if(host != ""){
		run %vncviewerpath% -connect %host%
	}
	else{
		run %vncviewerpath% 
	}	
}
}
else if(Types = "FTP"){
if(FTP != 0){
	if(Host !=""){
	if(User != "" && Pass = "")
		host = %user%@%host%
	else if(Pass != "" && User != "")
		host = %user%:%pass%@%host%
	Run %filezillapath% ftp://%host%
}
else{
	Run %filezillapath%
}
}
else{
	msgbox FileZilla could not be found. Reload App to search again.
	}
}
else if(Types = "SFTP"){
if(FTP != 0)
{
	if(Host != ""){
	if(User != "" && Pass = "")
		host = %user%@%host%
	else if(Pass != "" && User != "")
		host = %user%:%pass%@%host%
	Run %filezillapath% sftp://%host%
}
else{
	Run %filezillapath%
}
}
else{
	msgbox FileZilla could not be found. Reload App to search again.
	}
}
else{
	msgbox This function is not supported.
}

GuiControl, Enable, User
GuiControl, Enable, Pass
return

FormatHost:
StringReplace, Host, Host, %A_Space%, , All
StringReplace, Host, Host, http://, , All
StringReplace, Host, Host, https://, , All
StringGetPos, pos, Host, /
if(pos = -1){
}
Else{
	StringLeft, Host, Host, %pos%
}
return

;##################################
;######## Type Choice #############
;##################################
TypeChooser:
Gui, Submit, Nohide
if(Types = "SSH"){
	GuiControl, Enable, User
	GuiControl, Enable, Pass
}
else if(Types = "RDP"){
	GuiControl, Disable, User
	GuiControl, Disable, Pass
	}
else if(Types = "FTP"){
	GuiControl, Enable, User
	GuiControl, Enable, Pass
}
else if(Types = "SFTP"){
	GuiControl, Enable, User
	GuiControl, Enable, Pass
}
else if(Types = "VNC"){
	GuiControl, Disable, User
	GuiControl, Enable, Pass
}
return
;##################################
;######### Check Ports ############
;##################################
Check:
Gui, 2: Submit, Nohide
if(Host2 != "" && Port != "")
{
	GuiControl, 2:, Result, Checking
	Domain = port=%Port%&query=%Host2%
	MyPortCheck := UrlGet("http://smugdns.com/ports.php?"Domain,null)
	sleep 200
	GuiControl, 2:, Result, %MyPortCheck%
}
else{
}
return
;##################################
;######## Port Checkr #############
;##################################
Ports:
Gui, Submit, Nohide
GuiControl, 2:, Host2, %Host%
WinGetPos,x,y,w,h, %Appname% %version%
Gui, 2: Show, x%x% y%y%, %AppName% Ports
GuiControl, 2: Focus, Host2
return
;##################################
;########### Dev Link #############
;##################################
LaunchDev:
run %Website%
return
;##################################
;######## Always On Top ###########
;##################################
AOT:
if(GuiAOT = 1){
	Gui, 1: -AlwaysOnTop
	GuiAOT = 0
	}
else{
	Gui, 1: +AlwaysOnTop
	GuiAOT = 1
	}
IniWrite, %GuiAOT%, %inipath%, Preferences, GuiAOT
Menu, Context2, ToggleCheck, Always On Top
return

;##################################
;######## Settings Gui     ########
;##################################

Settings:
GuiControl,3: , EnableThemes, %ThemesEnabled%
GuiControl,3: , EnableHotkey, %HotkeyEnabled%
GuiControl,3: , EnableAutoSearch, %AutoSearchEnabled%
GuiControl,3: , EnableUpdate, %CheckForUpdates%
GuiControl,3: , EnableStartup, %Startup%
WinGetPos,x,y,w,h, %Appname% %version%
Gui,3: Show,x%x% y%y%, %AppName% Settings
return

CloseSettings:
if(RequireReload = 1)
	Reload
Gui,3: Hide
return

ToggleHotkey:
Gui, 3: submit, nohide
if(HotkeyEnabled = 0){
	HotkeyEnabled = 1
	}
else{
	HotkeyEnabled = 0
	}
RequireReload = 1
IniWrite, %HotkeyEnabled%, %inipath%, Preferences, HotkeyEnabled
return

ToggleStartup:
Gui, 3: submit, NoHide
SplitPath, A_Scriptname, , , , OutNameNoExt 
LinkFile=%A_Startup%\%OutNameNoExt%.lnk 
If(EnableStartup = 0){
IfExist, %LinkFile%
	FileDelete, %LinkFile% 
	IniWrite, %nothing%, %inipath%, Preferences, Startup_Location
}
else{
IfNotExist, %LinkFile% 
 	 FileCreateShortcut, %A_ScriptFullPath%, %LinkFile% 
 	 IniWrite, %LinkFile%, %inipath%, Preferences, Startup_Location
}
Iniwrite, %EnableStartup%, %inipath%, Preferences, Startup
SetWorkingDir, %A_ScriptDir%
return

ToggleAutoSearch:
Gui, 3: submit, nohide
if(EnableAutoSearch = 1){
	AutoSearchEnabled = 1
	}
else{
	AutoSearchEnabled = 0
	}
;msgbox %AutoSearchEnabled%
IniWrite, %AutoSearchEnabled%, %inipath%, Preferences, AutoSearchEnabled
return

ToggleThemes:
Gui, 3: Submit, NoHide
if(EnableThemes = 1){
		ThemesEnabled = 1
		Gui,1: +Theme
		Gui,2: +Theme
		Gui,3: +Theme
		;msgbox Themes Enabled
	}
Else{
		ThemesEnabled = 0
		Gui,1: -Theme
		Gui,2: -Theme
		Gui,3: -Theme
		;msgbox Themes Disabled
	}
IniWrite, %ThemesEnabled%, %inipath%, Preferences, ThemesEnabled
return

ToggleUpdate:
Gui, 3: Submit, NoHide
if(EnableUpdate = 1){
	CheckForUpdates = 1
}
Else{
	CheckForUpdates = 0
}
IniWrite, %CheckForUpdates%, %inipath%, Preferences, CheckForUpdates
return

;##################################
;######## INI #############
;##################################
ReadINI:
;Fixed 
FileZillaPath = C:\Program Files (x86)\FileZilla FTP Client\filezilla.exe
PuttyPath = putty.exe
vncviewerpath = vncviewer.exe

;#Gui Location
IniRead, xloc, %inipath%, Preferences, xloc, ?
if(xloc = "?"){
	newloc := A_ScreenWidth - 350
	Iniwrite, %newloc%, %inipath%, Preferences, xloc
	IniRead, xloc, %inipath%, Preferences, xloc
}
IniRead, yloc, %inipath%, Preferences, yloc, ?
if(yloc = "?"){
	newloc := A_ScreenHeight - 150
	Iniwrite, %newloc%, %inipath%, Preferences, yloc
	IniRead, yloc, %inipath%, Preferences, yloc
}

;#Ini Version
IniRead, IniVersion, %inipath%, Preferences, IniVersion, ?
if(IniVersion < version || IniVersion = "?"){
	Iniwrite, %version%, %inipath%, Preferences, IniVersion
}

;#Ini Version
IniRead, ReadMe, %inipath%, Preferences, ReadMe, ?
if(ReadMe = "?"){
	Iniwrite, 1, %inipath%, Preferences, ReadMe
	IniRead, ReadMe, %inipath%, Preferences, ReadMe
	IfNotExist, readme.txt
	{
	Msgbox, 36, %AppName%, Did you want me to create you a Readme file?
	IfMsgBox Yes
    	GoSub, CreateReadMe
    }
}

;#Is Host
IniRead, HOST, %inipath%, Preferences, HOST, 0

;#Always On Top
IniRead, GuiAOT, %inipath%, Preferences, GuiAOT, ?
if(GuiAOT = "?"){
	IniWrite, 1, %inipath%, Preferences, GuiAOT
	IniRead, GuiAOT, %inipath%, Preferences, GuiAOT
}

;#Themes
IniRead, ThemesEnabled, %inipath%, Preferences, ThemesEnabled, ?
if(ThemesEnabled = "?"){
	IniWrite, 1, %inipath%, Preferences, ThemesEnabled
	IniRead, ThemesEnabled, %inipath%, Preferences, ThemesEnabled
}

;#Hotkey
IniRead, HotkeyEnabled, %inipath%, Preferences, HotKeyEnabled, ?
if(HotkeyEnabled = "?"){
	IniWrite, 1, %inipath%, Preferences, HotkeyEnabled
	IniRead, HotkeyEnabled, %inipath%, Preferences, HotKeyEnabled
}

;#Auto Search
IniRead, AutoSearchEnabled, %inipath%, Preferences, AutoSearchEnabled, ?
if(AutoSearchEnabled = "?"){
	IniWrite, 0, %inipath%, Preferences, AutoSearchEnabled
	IniRead, AutoSearchEnabled, %inipath%, Preferences, AutoSearchEnabled
}

;#Startup
SplitPath, A_Scriptname, , , , OutNameNoExt 
LinkFile=%A_Startup%\%OutNameNoExt%.lnk 
IfExist, %LinkFile%
	{
	IniWrite, 1, %inipath%, Preferences, Startup
	IniRead, Startup, %inipath%, Preferences, Startup
	}
Else{
	IniRead, Startup, %inipath%, Preferences, Startup, 0
}

;#Check For Updates
IniRead, CheckForUpdates, %inipath%, Preferences, CheckForUpdates, ?
if(CheckForUpdates = "?"){
	IniWrite, 1, %inipath%, Preferences, CheckForUpdates
	IniRead, CheckForUpdates, %inipath%, Preferences, CheckForUpdates
}

;#Filezilla Path
IfNotExist, %FileZillaPath%
{
	IniRead, FileZillaPath, %inipath%, Paths, FileZillaPath
	if(FileZillaPath == "" || FileZillaPath == "ERROR"){
		msgbox, FileZilla could not automatically be found, Please use the next dialog to locate it for us.
		FileSelectFile, SelectedFile, 3, , Open a file, FileZilla (*.exe*)
	if SelectedFile = 
		{
		MsgBox, FileZilla Not Found - FTP/SFTP Functions will not work.
		FTP = 0
		}
	else{
		IniWrite, %SelectedFile%, %inipath%, Paths, FileZillaPath
		FileZillaPath = %SelectedFile%
		}
	}	
}

;#Putty Path
/*
IfNotExist, %PuttyPath%
{
	IniRead, PuttyPath, %inipath%, Paths, PuttyPath
	if(PuttyPath == "" || PuttyPath == "ERROR"){
		msgbox, Putty could not automatically be found, Please use the next dialog to locate it for us.
		FileSelectFile, SelectedFile, 3, , Open a file, Putty (*.exe*)
	if SelectedFile = 
		{
		MsgBox, Putty Not Found - SSH Function will not work.
		SSH = 0
		}
	else{
		IniWrite, %SelectedFile%, %inipath%, Paths, PuttyPath
		PuttyPath = %SelectedFile%
		}
	}	
}
*/
IfNotExist, %PuttyPath%
	GoSub, dputty

IfExist, %vncviewerpath%
	{
		VNC = 1
	}
Else{
		Menu, Context2, add, Download VNCViewer, dvnc
}

;#Check For Updates if g2g
if(CheckForUpdates = 1)
	GoSub, CheckVersion
return ;/INI

;##################################
;##########  Updates! #############
;##################################

CheckVersion:
if not A_IsCompiled
	return
currVersion := UrlGet("http://srt.egli.me/version.txt",null)
if(currversion is Number){
	if(currVersion = version){

	}
	else if(currVersion > version){
		TrayTip, Update Available!, Visit srt.egli.me for more details!
	}
	Else{
		TrayTip, DevMode, Your current version is newer than released!
	}
}
return

;#Readme
CreateReadMe:
ifNotExist, readme.txt
{
	;IniWrite, %AppName% %version%, readme.txt, Welcome, AppName
	;IniWrite, %Developer%, readme.txt, Welcome, Developer
	;IniWrite, %Website%, readme.txt, Welcome, Website
	;IniWrite, %purpose%, readme.txt, Welcome, Purpose
	;FileAppend, `nUsage:`n%Usage%, readme.txt
	;IniWrite, %Usage%, readme.txt, Welcome, Usage
FileAppend, 
(
Welcome to the %Appname% %version% Readme!

Application: %Appname% %Version%
Developer: %Developer%
Website: %Website%

Purpose:
%Purpose%

Usage:
%Usage%
), readme.txt
}
return

;#Open/Locate Gui after Initial Show
Launchit:
IfWinNotExist, %Appname% %version%
	Gui, Show
IfWinNotActive, %Appname% %version%
	WinActivate, %Appname% %version%
ifWinNotActive, %Appname% %version%
	Gui, Show
GuiHide = 0
return

dvnc:
Menu, Context2, Delete, Download VNCViewer
UrlDownloadToFile, http://srt.egli.me/downloads/dep/vncviewer.exe, vncviewer.exe
sleep 200
reload
return

dputty:
UrlDownloadToFile, http://srt.egli.me/downloads/dep/putty.exe, putty.exe
sleep 200
return

;#Coordinates
SaveCoords:
WinGetPos,x,y,w,h, %Appname% %version%
Iniwrite, %x%, %inipath%, Preferences, xloc
Iniwrite, %y%, %inipath%, Preferences, yloc
return

;##################################
;######## Global Functions ########
;##################################

GuiEscape:
GuiClose:
GuiHide = 1
GoSub, SaveCoords
Gui, Hide
return

terminate:
ExitApp
return

Reload:
Reload
return

RemoveTrayTip:
SetTimer, RemoveTrayTip, Off
TrayTip
return

UrlGet(url,data) {
	WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	WebRequest.open("GET",URL, false)
	WebRequest.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
	WebRequest.send(data)
	Return WebRequest.ResponseText
}