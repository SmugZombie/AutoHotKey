;################################################
;##  SRTAware - SmugDev
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
;##			   AutoFind FileZilla (if in default location) / Locate FileZilla
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
;##
;################################################
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
OnMessage(0x204, "WM_RBUTTONDOWN")
;##################################
;######## Global Vars #############
;##################################
version = 0.54
If Not A_IsCompiled
	version = 0.54dev
inipath = SRTAware.ini
nothing = 
GuiHide = 0
GoSub, ReadINI
;##################################
;########  Tray Menu  #############
;##################################
Menu, tray, NoStandard
Menu, tray, add, SRTAware v%version%, Launchit
;Menu, tray, add, Port Checker, Ports
;Menu, tray, add, Settings, Settings
;Menu, tray, add
;Menu, tray, add, Always On Top, AOT
Menu, tray, add
Menu, tray, add, Quit, terminate

Menu, Context, add, Port Checker, Ports
Menu, Context, add
Menu, Context, add, Settings, Settings
Menu, Context, add, Always On Top, AOT
Menu, Context, add
Menu, Context, add, Reload, Reload
Menu, Context, add, Quit, Terminate

;##################################
;########### GUI ##################
;##################################
ConnectionTypes = SSH||RDP|FTP|SFTP
ConnectionTypes2 = SSH|RDP||FTP|SFTP
PortList = 80||22|25|110|143|21|443|3389
Gui, -MaximizeBox -MinimizeBox +OwnDialogs +LastFound
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

if(GuiAOT = 1){
	Gui, 1: +AlwaysOnTop
	Menu, Context, Check, Always On Top
}

Gui, Show,, SRTAware %version%

;########### GUI2 #################
Gui, 2: +owner +AlwaysOnTop
Gui, 2: Add, Text, w40, Host:
Gui, 2: Add, Text, w40, Port:
Gui, 2: Add, Button, default w75 gCheck, Check
Gui, 2: Add, Edit, vHost2 w100 ym y0
Gui, 2: Add, ComboBox, vPort w50, %PortList%
Gui, 2: Add, Edit, center vResult disabled w100


;########### GUI3 #################
Gui, 3: +owner +AlwaysOnTop
Gui, 3: Add, Checkbox, vEnableHotkey gToggleHotkey disabled, Hotkey? (Ctrl+Shft+S)
Gui, 3: Add, Checkbox, vEnableAutoSearch gToggleAutoSearch,  Auto Connect?
Gui, 3: Add, Checkbox, VEnableThemes gToggleThemes, Windows Theme?
Gui, 3: Add, Button, gCloseSettings, Close

WM_RBUTTONDOWN(wParam, lParam){
Menu, Context, Show
}

^+s::
Gui, Submit, NoHide
IfWinNotActive, SRTAware %version%
	WinActivate, SRTAware %version%
ClipHost = %clipboard%
if(Host != ClipHost)
	GuiControl,, Host, %ClipHost%
Else

if(AutoSearchEnabled = "Checked")
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
else if(Types = "FTP"){
if(FTP != 0){
	if(User != "" && Pass = "")
		host = %user%@%host%
	else if(Pass != "" && User != "")
		host = %user%:%pass%@%host%
	Run %filezillapath% ftp://%host%
}
else{
	msgbox FileZilla could not be found. Reload App to search again.
	}
}
else if(Types = "SFTP"){
if(FTP != 0)
{
	if(User != "" && Pass = "")
		host = %user%@%host%
	else if(Pass != "" && User != "")
		host = %user%:%pass%@%host%
	Run %filezillapath% sftp://%host%
}
else{
	msgbox FileZilla could not be found. Reload App to search again.
	}
}
else{
	msgbox This function is not supported.
}
GuiControl, Enable, Pass
return
;##################################
;######## Type Choice #############
;##################################
TypeChooser:
Gui, Submit, Nohide
if(Types = "SSH")
	GuiControl, Enable, Pass
else if(Types = "RDP")
	GuiControl, Disable, Pass
else if(Types = "FTP")
	GuiControl, Enable, Pass
else if(Types = "SFTP")
	GuiControl, Enable, Pass
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
Gui, 2: Show,, SRTAware Ports
GuiControl, 2: Focus, Host2
return
;##################################
;########### Dev Link #############
;##################################
LaunchDev:
run http://ronegli.com
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
Menu, Context, ToggleCheck, Always On Top
return

Settings:
GuiControl,3: , EnableThemes, %ThemesEnabled%
GuiControl,3: , EnableHotkey, %HotkeyEnabled%
GuiControl,3: , EnableAutoSearch, %AutoSearchEnabled%
Gui,3: Show,, SRTAware Settings
return

CloseSettings:
Gui,3: Hide
return

ToggleHotkey:
Gui, 3: submit, nohide
if(HotkeyEnabled = 1){
	HotkeyEnabled = 
	}
else{
	HotkeyEnabled = 0
	}
IniWrite, %HotkeyEnabled%, %inipath%, Preferences, HotkeyEnabled
return

ToggleAutoSearch:
Gui, 3: submit, nohide
if(EnableAutoSearch = 1){
	AutoSearchEnabled = 1
	}
else{
	AutoSearchEnabled = 0
	}
return

ToggleThemes:
Gui, Submit, NoHide
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

;##################################
;######## INI #############
;##################################

ReadINI:
;Fixed 
FileZillaPath = C:\Program Files (x86)\FileZilla FTP Client\filezilla.exe
PuttyPath = putty.exe

IniRead, GuiAOT, %inipath%, Preferences, GuiAOT, ?
if(GuiAOT = "?"){
	IniWrite, 1, %inipath%, Preferences, GuiAOT
	IniRead, GuiAOT, %inipath%, Preferences, GuiAOT
}

IniRead, ThemesEnabled, %inipath%, Preferences, ThemesEnabled, ?
if(ThemesEnabled = "?"){
	IniWrite, 1, %inipath%, Preferences, ThemesEnabled
	IniRead, ThemesEnabled, %inipath%, Preferences, ThemesEnabled
}

IniRead, HotkeyEnabled, %inipath%, Preferences, HotKeyEnabled, ?
if(HotkeyEnabled = "?"){
	IniWrite, 1, %inipath%, Preferences, HotkeyEnabled
	IniRead, HotkeyEnabled, %inipath%, Preferences, HotKeyEnabled
}

IniRead, AutoSearchEnabled, %inipath%, Preferences, AutoSearchEnabled, ?
if(AutoSearchEnabled = "?"){
	IniWrite, 0, %inipath%, Preferences, AutoSearchEnabled
	IniRead, AutoSearchEnabled, %inipath%, Preferences, AutoSearchEnabled
}

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

return

;##################################
;######## Global Functions ########
;##################################
Launchit:
IfWinNotActive, SRTAware %version%
WinActivate, SRTAware %version%
return

GuiClose:
GuiHide = 1
Gui, Hide
return

terminate:
ExitApp
return

Reload:
Reload
return

UrlGet(url,data) {
	WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	WebRequest.open("GET",URL, false)
	WebRequest.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
	WebRequest.send(data)
	Return WebRequest.ResponseText
}