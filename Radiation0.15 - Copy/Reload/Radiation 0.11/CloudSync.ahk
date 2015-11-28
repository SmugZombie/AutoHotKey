;Cloud
Gui,+AlwaysOnTop -SysMenu +LastFound
Gui,Add, Text, x10 y13 ,Email:
Gui,Add, Edit, x75 y10 vEmail
Gui,Add, Text, x10 y38 ,Password:
Gui,Add, Edit, x75 y35 password vPassword
Gui,Add, Button, default x50 y+10 w100, OK

Gui, 2:+AlwaysOnTop -SysMenu +LastFound -Caption
Gui, 2: Add, Text,, Please Wait. Validating
Gui,Show, Center h100 w200, CloudSync

return
ButtonOK:
Gui, Submit
Gui, 2:Show, Center h100 w200, CloudSync
gEmail = %Email%
Email = %Email%&pass=%Password%
MyResponse := UrlGet("http://werq.us/radiation/mycreds.php?email="Email, null)
if(MyResponse = "auth")
	{
		Gui, 2: Add, Text, x+10, - Success!
		Gui, 2: Add, Text, x10 y+0, Gathering Data...
		GatherData(gEmail)
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

GatherData(Email)
{
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
	ExitApp
}

getLinks(links)
{
	MyResponse := UrlGet("http://werq.us/radiation/account.php?e="links, null)
	StringReplace, MyResponse2, MyResponse, </br>, $, All
	if(MyResponse2 = "")
		{
			Gui, 2: Add, Text, x+10, - Retrying
			getLinks(links)
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
			Gui, 2: Add, Text, x+10, - Retrying
			getConfig(config)
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
	if(MyResponse2 = "")
		{
			Gui, 2: Add, Text, x+10, - Retrying
			getApps(apps)
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

UrlGet(url,data) {
	WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	WebRequest.open("GET",URL, false)
	WebRequest.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
	WebRequest.send(data)
	Return WebRequest.ResponseText
}