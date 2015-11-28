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
;##     0.5 - Hotkey Added / Settings
;##     0.51- BugFix
;##		0.52- BugFix
;##		0.53- Code Cleanup / AutoLoad Options	
;##
;################################################
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
OnMessage(0x204, "WM_RBUTTONDOWN")
;##################################
;######## Global Vars #############
;##################################
version = 0.53
nothing = 
GuiHide = 0
HotkeyEnabled = Checked
AutoSearchEnabled = 
;##################################
;########  Tray Menu  #############
;##################################
Menu, tray, NoStandard
Menu, tray, add, SRTAware v%version%, Launchit
Menu, tray, add, Port Checker, Ports
Menu, tray, add, Settings, Settings
;Menu, tray, add
;Menu, tray, add, Always On Top, AOT
Menu, tray, add
Menu, tray, add, Exit, terminate

Menu, Context, add, Always On Top, AOT
Menu, Context, add
Menu, Context, add, Reload, Reload
Menu, Context, add, Quit, Terminate
;##################################
;######## INI #############
;##################################
FileZillaPath = C:\Program Files (x86)\FileZilla FTP Client\filezilla.exe
PuttyPath = putty.exe
IfNotExist, %FileZillaPath%
{
	IniRead, FileZillaPath, SRTAware.ini, Paths, FileZillaPath
	if(FileZillaPath == "" || FileZillaPath == "ERROR"){
		msgbox, FileZilla could not automatically be found, Please use the next dialog to locate it for us.
		FileSelectFile, SelectedFile, 3, , Open a file, FileZilla (*.exe*)
	if SelectedFile = 
		{
		MsgBox, FileZilla Not Found - FTP/SFTP Functions will not work.
		FTP = 0
		}
	else
		IniWrite, %SelectedFile%, SRTAware.ini, Paths, FileZillaPath
		FileZillaPath = %SelectedFile%
	}	
}
IfNotExist, %PuttyPath%
{
	IniRead, PuttyPath, SRTAware.ini, Paths, PuttyPath
	if(PuttyPath == "" || PuttyPath == "ERROR"){
		msgbox, Putty could not automatically be found, Please use the next dialog to locate it for us.
		FileSelectFile, SelectedFile, 3, , Open a file, Putty (*.exe*)
	if SelectedFile = 
		{
		MsgBox, Putty Not Found - SSH Function will not work.
		SSH = 0
		}
	else
		IniWrite, %SelectedFile%, SRTAware.ini, Paths, PuttyPath
		PuttyPath = %SelectedFile%
	}	
}
;##################################
;########### GUI ##################
;##################################
ConnectionTypes = SSH||RDP|FTP|SFTP
ConnectionTypes2 = SSH|RDP||FTP|SFTP
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

;########### GUI2 #################
Gui, 2: +owner +AlwaysOnTop
Gui, 2: Add, Text, w40, Host:
Gui, 2: Add, Text, w40, Port:
Gui, 2: Add, Button, default w75 gCheck, Check
Gui, 2: Add, Edit, vHost2 w100 ym y0
Gui, 2: Add, ComboBox, vPort w50, 80|22|25|110|143|21|443|3389
Gui, 2: Add, Edit, center vResult disabled w100
Gui, Show,, SRTAware %version%

;########### GUI3 #################
Gui, 3: +owner +AlwaysOnTop
Gui, 3: Add, Checkbox, vEnableHotkey gToggleHotkey %HotkeyEnabled% disabled, Hotkey? (Ctrl+Shft+S)
Gui, 3: Add, Checkbox, vEnableAutoSearch gToggleAutoSearch %AutoSearchEnabled%, Auto Connect?
Gui, 3: Add, Button, gCloseSettings, Close

WM_RBUTTONDOWN(wParam, lParam){
Menu, Context, Show
}

^+s::
Gui, Submit, NoHide
ClipHost = %clipboard%
GuiControl,, Host, %ClipHost%
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
;########### /GUI ##################
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
;######## Always On Top #############
;##################################
AOT:
if(GuiAOT != 2){
	Gui, 1: +AlwaysOnTop
	GuiAOT = 2
	}
else{
	Gui, 1: -AlwaysOnTop
	GuiAOT = 1
	}
Menu, Context, ToggleCheck, Always On Top
return

Settings:
Gui,3: Show,, SRTAware Settings
return

CloseSettings:
Gui,3: Hide
return

ToggleHotkey:
;HotkeyEnabled
Gui, 3: submit, nohide
if(HotkeyEnabled = Checked){
	HotkeyEnabled = 
}
else
{
	HotkeyEnabled = Checked
}
return

ToggleAutoSearch:
Gui, 3: submit, nohide
if(EnableAutoSearch = 1){
	AutoSearchEnabled = Checked
}
else
{
	AutoSearchEnabled = 
}
return

;##################################
;######## Global Functions ########
;##################################
Launchit:
if(GuiHide = 1){
		GuiHide = 0
		Gui, Show
	}
else{
		Reload
	}
return

GuiClose:
GuiAOT = 1
Menu, Context, UnCheck, Always On Top
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