﻿;Cloud
#NoTrayIcon
#SingleInstance force
#Persistent
#NoEnv
Gui,+AlwaysOnTop -SysMenu +LastFound
Gui,Add, Text, x10 y13 ,Email:
Gui,Add, Edit, x75 y10 vEmail
Gui,Add, Text, x10 y38 ,Password:
Gui,Add, Edit, x75 y35 password vPassword
Gui,Add, Button, default x50 y+10 w100, OK

Gui, 2:+AlwaysOnTop -SysMenu +LastFound -Caption
;Gui, 2:Add, ListBox, vProgress w180 r13
;GuiControl,, Progress, Loading..
Gui, 2: Add, Text,, Please Wait. Validating

Gui, 3:+AlwaysOnTop -SysMenu +LastFound -Caption
Gui, 3: Add, Text,, Backup or Restore?
Gui, 3: Add, Button, default gButtonBackup, Backup
Gui, 3: Add, Button,x+10 gButtonRestore, Restore

IfNotExist, %A_ScriptDir%/parts/smug.config
	GuiControl, Disable, ButtonBackup
	
IfNotExist, %A_ScriptDir%/radiation.exe
	IfNotExist, %A_ScriptDir%/Radiation.exe
		IfNotExist, %A_ScriptDir%/radiation.ahk
			IfNotExist, %A_ScriptDir%/Radiation.ahk
				{
					msgbox Required Files Not Found!
					ExitApp
				}

Gui,Show, Center h100 w200, CloudSync

localBackup = true

return
ButtonOK:
Gui, Submit
gEmail = %Email%
Email = %Email%&p=%Password%
MyResponse := UrlGet("http://werq.us/radiation/mycreds.php?e="Email, null)
if(MyResponse = "auth")
	{
		Gui, 3:Show, Center h65 w125, Backup/Restore
		;Gui, 2: Add, Text, x10 y+0, Gathering Data...
	}
else
	{
		Gui, 2: Submit
		MsgBox Try Again!
		Gui,Show, Center h100 w200, CloudSync
	}
return

GuiClose:
GuiEscape:
Gui2Escape:
ExitApp

ButtonRestore:
GatherData(gEmail)
return

ButtonBackup:
SendData(gEmail)
return

GatherData(Email)
{
	Gui, 2:Show, Center h100 w200, CloudSync
	;Gui, 2: Add, Text, x+10, - Success!
	FileDelete, parts/links.smug
	FileDelete, parts/config.smug
	FileDelete, parts/apps.smug
	links = %Email%&t=links
	apps = %Email%&t=apps
	config = %Email%&t=config
	Gui, 2: Add, Text, x10 y+0, Links
	getLinks(links)
	Gui, 2: Add, Text, x10 y+0, Apps
	getApps(apps)
	Gui, 2: Add, Text, x10 y+0, Config
	getConfig(config)
	Gui, 2: Add, Text, x10 y+0, Success - Reload Radiation
	Sleep 2000
	IfExist, radiation.exe
		run %A_ScriptDir%/radiation.exe
	else IfExist, radiation.ahk
		run %A_ScriptDir%/radiation.ahk
	ExitApp
}

SendData(Email)
{
	links = %Email%&t=links
	apps = %Email%&t=apps
	config = %Email%&t=config
	Gui, 2:Show, Center h100 w200, CloudSync
	Gui, 2: Add, Text, x10 y+0, Links
	sendLinks(links)
	Gui, 2: Add, Text, x10 y+0, Apps
	sendApps(apps)
	Gui, 2: Add, Text, x10 y+0, Config
	sendConfig(config)
	Gui, 2: Add, Text, x10 y+0, Success - Reload Radiation
	IfExist, radiation.exe
		run %A_ScriptDir%/radiation.exe
	else IfExist, radiation.ahk
		run %A_ScriptDir%/radiation.ahk
	ExitApp
}

getLinks(links)
{
	MyResponse := UrlGet("http://werq.us/radiation/account.php?e="links, null)
	StringReplace, MyResponse2, MyResponse, </br>, $, All
	StringReplace, MyResponse2, MyResponse2, !, /, All
	if(MyResponse2 = "")
		{
			Gui, 2: Add, Text, x+10, - Empty
			;getLinks(links)
		}
	else
		{
			Loop, parse, MyResponse2, $
			{
				FileAppend, %A_LoopField%`n, parts/links.smug
			}
			Gui, 2: Add, Text, x+10, - Passed
		}
}

getConfig(config)
{
	MyResponse := UrlGet("http://werq.us/radiation/account.php?e="config, null)
	StringReplace, MyResponse2, MyResponse, </br>, $, All
	if(MyResponse2 = "")
		{
			Gui, 2: Add, Text, x+10, - Empty
			;getConfig(config)
		}
	else
		{
			Loop, parse, MyResponse2, $
			{
				FileAppend, %A_LoopField%`n, parts/config.smug
			}
			Gui, 2: Add, Text, x+10, - Passed
		}
}

getApps(apps)
{
	MyResponse := UrlGet("http://werq.us/radiation/account.php?e="apps, null)
	StringReplace, MyResponse2, MyResponse, </br>, $, All
	StringReplace, MyResponse2, MyResponse2, !, \, All
	if(MyResponse2 = "")
		{
			Gui, 2: Add, Text, x+10, - Empty
			;getApps(apps)
		}
	else
		{
			Loop, parse, MyResponse2, $
			{
				FileAppend, %A_LoopField%`n, parts/apps.smug
			}
			Gui, 2: Add, Text, x+10, - Passed
		}
}

sendLinks(links)
{
	links2 = 
	Loop, read, %A_ScriptDir%/parts/links.smug
	{	
		if(links2 = "")
			{
				links2 = %A_LoopReadLine%
			}
		else
			{
				links2 = %links2%$%A_LoopReadLine%
			}
	}
	StringReplace, links2, links2, /, !, All
	links = %links%&d=%links2%
	sleep 1200
	if(localBackup = "true")
		{
			FileDelete, parts/links.smug.bak
			FileAppend, %links2%, parts/links.smug.bak
			Gui, 2: Add, Text, x+10, - Local
		}
	else
		{
			MyResponse := UrlGet("http://werq.us/radiation/sub_account.php?e="links, null)
			Gui, 2: Add, Text, x+10, - %MyResponse%
		}
}
sendApps(apps)
{
	apps2 = 
	Loop, read, %A_ScriptDir%/parts/apps.smug
	{	
		if(A_LoopReadLine == "")
			{
			
			}
		else
			{
				if(apps2 = "")
					{
						apps2 = %A_LoopReadLine%
					}
				else
					{
						apps2 = %apps2%$%A_LoopReadLine%
					}
			}
	}
	StringReplace, apps2, apps2, \, !, All
	apps = %apps%&d=%apps2%
	sleep 1200
	if(localBackup = "true")
		{
			FileDelete, parts/apps.smug.bak
			FileAppend, %apps2%, parts/apps.smug.bak
			Gui, 2: Add, Text, x+10, - Local
		}
	else
		{
			MyResponse := UrlGet("http://werq.us/radiation/sub_account.php?e="apps, null)
			Gui, 2: Add, Text, x+10, - %MyResponse%
		}
}
sendConfig(config)
{
	config2 = 
	Loop, read, %A_ScriptDir%/parts/config.smug
	{	
		if(config2 = "")
			{
				config2 = %A_LoopReadLine%
			}
		else
			{
				config2 = %config2%$%A_LoopReadLine%
			}
	}
	config = %config%&d=%config2%
	sleep 1200
	if(localBackup = "true")
		{
				FileDelete, parts/config.smug.bak
				FileAppend, %config2%, parts/config.smug.bak
				Gui, 2: Add, Text, x+10, - Local
		}
	else
		{
			MyResponse := UrlGet("http://werq.us/radiation/sub_account.php?e="config, null)
			Gui, 2: Add, Text, x+10, - %MyResponse%
		}
}

UrlGet(url,data) {
	WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	WebRequest.open("GET",URL, false)
	WebRequest.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
	WebRequest.send(data)
	Return WebRequest.ResponseText
}