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
;##
;##
;################################################
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;##################################
;######## Global Vars #############
;##################################
version = 0.46
nothing = 
GuiHide = 0
;##################################
;########  Tray Menu  #############
;##################################
Menu, tray, NoStandard
Menu, tray, add, SRTAware v%version%, Launchit
Menu, tray, add, Port Checker, Ports
Menu, tray, add
Menu, tray, add, Always On Top, AOT
Menu, tray, add
Menu, tray, add, Exit, terminate
;##################################
;######## INI #############
;##################################
IniRead, FileZillaPath, SRTAware.ini, Paths, FileZillaPath
IniRead, PuttyPath, SRTAware.ini, Paths, PuttyPath, putty.exe
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
;##################################
;########### GUI ##################
;##################################
Gui, -MaximizeBox -MinimizeBox +OwnDialogs
Gui, Add, Text, vHostBox, Host:
Gui, Add, Text, vUserBox, User:
Gui, Add, Text, vPassBox, Pass:
Gui, Add, Edit, vHost ym  ; The ym option starts a new column of controls.
Gui, Add, Edit, vUser
Gui, Add, Edit, disabled Password vPass
Gui, Add, DropDownList, w75 Choose1 gTypeChooser vTypes ys, SSH|RDP|FTP|SFTP
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
GuiControl, Focus, Host
if(Types = "SSH")
{
if(User != "")
	host = %user%@%host%
Run %PuttyPath% "-ssh" "%host%"
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
return
;##################################
;######## Type Choice #############
;##################################
TypeChooser:
Gui, Submit, Nohide
if(Types = "SSH")
	GuiControl, Disable, Pass
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
else
	{
	Gui, 1: -AlwaysOnTop
	GuiAOT = 1
	}
	Menu, tray, ToggleCheck, Always On Top
return
;##################################
;######## Global Functions ########
;##################################
Launchit:
if(GuiHide = 1)
	{
		GuiHide = 0
		Gui, Show
	}
else
	{
		Reload
	}
return

GuiClose:
GuiAOT = 1
Menu, tray, UnCheck, Always On Top
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