;################################################
;##  SmugDNS - SmugDev
;################################################
; blacklist.php dig.php dns4.php header.php httpstatus.php ping.php trace.php whohost.php

;### Global Variables
version = 0.047
domain =
inchead = 1
incprop = 1
inchost = 1
Menu, tray, NoStandard
Menu, tray, add, Reload
Menu, tray, add, SmugDNS v%version%b, Reload
Menu, tray, add
Menu, tray, add, Exit, terminate
Menu, Tray, Icon, %A_ScriptDir%/data/smug.ico

;################################################
;##  Build The Gui
;################################################
SplashImage,%A_WorkingDir%/data/smugbig.png, w, v%version%,,SmugDNS
Gui, Add, Text, x262 y11 w50 h20, Domain:
Gui, Add, Edit, x310 y8 w200 h20 vMyDomain,
Gui, Add, Button, x515 y6 w50 Default, Fetch
;### Domain Details
Gui, Add, Text, x12 y47 w50 h20, Domain:
Gui, Add, Edit, x60 y43 w200 h20 vMyDomain2 readonly,
Gui, Add, Text, x265 y47 w50 h20, IP:
Gui, Add, Edit, x280 y43 w100 h20 vMyIP readonly,
Gui, Add, Text, x385 y47 w50 h20, Status:
Gui, Add, Edit, x420 y43 w100 h20 vMyStatus readonly,
Gui, Add, Text, x525 y47 w50 h20, Host:
Gui, Add, Edit, x552 y43 w204 h20 vwhohostsit readonly,
;Gui, Add, Button, x720 y42 w40 gwhohost, Get
;### DIG
Gui, Add, Text, x12 y70 w50 h20, Dig:
Gui, Add, Edit, x60 y70 w700 r5 vMyDig readonly,
;### Whois
Gui, Add, Text, x12 y150 w50 h20, Whois:
Gui, Add, Edit, x60 y150 w700 r10 vMyWhois readonly,
;### WorldWide Stuff
Gui, Add, GroupBox, x12 y300 w500 h100, WorldWide Propagation
Gui, Add, Text, x50 y320 w150, US Propagation:
Gui, Add, Text, x20 y340 w50, IP:
Gui, Add, Edit, x75 y340 w100 h20 vHost2IP readonly,
Gui, Add, Text, x20 y360 w50, Response:
Gui, Add, Edit, x75 y360 w100 h20 vHost2Status readonly,
;### EU Stuff
Gui, Add, Text, x215 y320 w150, EU Propagation:
Gui, Add, Text, x185 y340 w50, IP:
Gui, Add, Edit, x240 y340 w100 h20 vHost3IP readonly,
Gui, Add, Text, x185 y360 w50, Response:
Gui, Add, Edit, x240 y360 w100 h20 vHost3Status readonly,
;### AP Stuff
Gui, Add, Text, x380 y320 w150, AP Propagation:
Gui, Add, Text, x350 y340 w50, IP:
Gui, Add, Edit, x405 y340 w100 h20 vHost4IP readonly,
Gui, Add, Text, x350 y360 w50, Response:
Gui, Add, Edit, x405 y360 w100 h20 vHost4Status readonly,
;### Tools
Gui, Add, GroupBox, x12 y410 w500 h100, Tools

Gui, Add, DropDownList, x20 y425 w100 vToolChoice gToolChoice Choose1, Open Domain In..|Browser|ToolZilla|Reggie|DZA|Email Tool
Gui, Add, GroupBox, x125 y420 w2 h80,
Gui, Font, cBlue
;Gui, Add, Text, x20 y440 gtrace vtrace, Trace Path (local)
;Gui, Font, cGray
Gui, Add, Text, x20 y455 gtrace vtrace, Trace Path
Gui, Font, cBlue
Gui, Add, Text, x20 y470 gping vping, Ping Address
Gui, Add, Text, x20 y485 gIPWho, IP Whois
Gui, Font, cGray

Gui, Add, GroupBox, x235 y420 w2 h80,
;Gui, Add, Text, x240 y485, Save To Disk

Gui, Add, GroupBox, x345 y420 w2 h80,
Gui, Font, cBlue
Gui, Add, Text, x350 y425 ghostinc vhostinc, Exclude Host
Gui, Add, Text, x350 y440 gpropinc vpropinc, Exclude Propagation
Gui, Add, Text, x350 y455 gheaderinc vheaderinc, Exclude Header
Gui, Font, cGray
Gui, Add, Text, x350 y485, Save To Disk

Gui, Font, cBlack
Gui, Add, Button, x465 y485 w45, Refresh
;### Headers
;Gui, Add, GroupBox, x525 y300 w237 h210, Header Details:
Gui, Add, Text, x525 y300, Header Details
Gui, Add, Edit, x525 y315 w236 h195 vMyHeader readonly
;### Cleanup
Gui, Add, Button, x650 y570 w45, Demo
Gui, Add, Button, x750 y570 w45, Reload
Gui, Add, Button, x700 y570 w45, Reset
Gui, Add, Text, x5 y585, Status:
Gui, Add, Text, x40 y585 w250 vAppStatus, Ready...
SetTimer, HideSplash, 1500
return

LoadGui:
Gui, Show, w800 h600, SmugDNS v%version%
return

GuiClose:
GuiEscape:
ExitApp

ButtonReset:
GoSub, ResetApp
return

ButtonDemo:
GuiControl,, MyDomain, http://smugdns.com
Gosub, ButtonFetch
return

Reload:
ButtonReload:
reload
return

ButtonRefresh:
GuiControl,, MyDomain, http://%domain%
Gosub, ButtonFetch
return

propinc:
if(incprop = 1)
	{
	incprop = 0
	GuiControl,, propinc, Include Propagation
	}
else
	{
	incprop = 1
	GuiControl,, propinc, Exclude Propagation
	if(domain != "")
		GoSub, GetGlobal
	}
return

headerinc:
if(inchead = 1)
	{
	inchead = 0
	GuiControl,, headerinc, Include Header
	}
else
	{
	inchead = 1
	GuiControl,, headerinc, Exclude Header
	if(domain != "")
		GoSub, GetHeader
	}
return

hostinc:
if(inchost = 1)
	{
	inchost = 0
	GuiControl,, hostinc, Include Host
	}
else
	{
	inchost = 1
	GuiControl,, hostinc, Exclude Host
	if(domain != "")
		GoSub, WhoHost
	}
return
return

ToolChoice:
;Open Domain In..|Browser|ToolZilla|Reggie|DZA|Email Tool
Gui, Submit, nohide
if(ToolChoice = "Open Domain In.."){
		;do nothing
	}
else if(ToolChoice = "Browser"){
		GoSub, link
		}
else if(ToolChoice = "ToolZilla"){
		GoSub, TZlink
		}
else if(ToolChoice = "Reggie"){
		GoSub, REGlink
		}
else if(ToolChoice = "DZA"){
		GoSub, DZAlink
		}
else if(ToolChoice = "Email Tool"){
		GoSub, Elink
		}
return


;################################################
;##  Fetch DNS
;################################################

ButtonFetch:
Gui, Submit, nohide
query = %MyDomain%
GoSub, ClearAll
;Clean the domain for best results
StringReplace, query, query, http://,, All
StringReplace, query, query, https://,, All
StringGetPos, pos, query, /
pos++
StringTrimRight, query, query,%pos%
if(query == "")
	return
domain = %query%
FileDelete, data/settings.ini
IniWrite, %domain%, data/settings.ini, Options, Domain
run %A_ScriptDir%/data/getip.ahk
run %A_ScriptDir%/data/getstatus.ahk
run %A_ScriptDir%/data/gethost.ahk
run %A_ScriptDir%/data/getprop.ahk
GuiControl,, MyDomain2, http://%domain%

;Update Gui
GuiControl,, AppStatus, Gathering Data ...
GuiControl,, MyIP, Fetching...
GuiControl,, MyStatus, Fetching...
GoSub, GetIP
; Run Other DNS Functions
GuiControl,, AppStatus, Digging ...
GoSub, GetDig
GuiControl,, AppStatus, Requesting Whois ...
GoSub, GetWhois
GuiControl,, AppStatus, Getting Headers ...
if(inchead = 1)
	GoSub, GetHeader
GuiControl,, AppStatus, Propagating ...
if(incprop = 1)
	GoSub, GetGlobal
if(inchost = 1)
	GoSub, whohost
IniRead, host1http, data/settings.ini, Options, Status
GuiControl,, MyStatus, %host1http%
GuiControl,, AppStatus, Ready...
return

;###WhoHost
whohost:
IniRead, WhoHost, data/settings.ini, Options, WhoHost
if(WhoHost = "ERROR")
	{
		sleep 100
		GoSub, WhoHost
	}
GuiControl,, whohostsit, %WhoHost%
return

GetIP:
IniRead, MyQueryIP, data/settings.ini, Options, IP
if(MyQueryIP = "ERROR")
	{
		sleep 100
		GoSub, GetIP
	}
GuiControl,, MyIP, %MyQueryIP%
return

;### Dig
GetDig:
GuiControl,, MyDig, Fetching...
dig := UrlGet("http://smugdns.com/files/dns3.php?query="query,null)
GuiControl,, MyDig, %dig%
return

;### WHOIS
GetWhois:
GuiControl,, MyWhois, Fetching...
whois := UrlGet("http://smugdns.com/files/who.php?query="query,null)
GuiControl,, MyWhois, %whois%
return

;### Global Propagation
GetGlobal:
GuiControl,, Host2IP, Fetching...
GuiControl,, Host2Status, Fetching...
GuiControl,, Host3IP, Fetching...
GuiControl,, Host3Status, Fetching...
GuiControl,, Host4IP, Fetching...
GuiControl,, Host4Status, Fetching...
IniRead, usip, data/settings.ini, Options, USIP
IniRead, usstatus, data/settings.ini, Options, USSTATUS
IniRead, euip, data/settings.ini, Options, EUIP
IniRead, eustatus, data/settings.ini, Options, EUSTATUS
IniRead, apip, data/settings.ini, Options, APIP
IniRead, apstatus, data/settings.ini, Options, APSTATUS
if(usip = "ERROR")
	{
		sleep 100
		GoSub, GetGlobal
	}
GuiControl,, Host2IP, %usip%
GuiControl,, Host2Status, %usstatus%
GuiControl,, Host3IP, %usip%
GuiControl,, Host3Status, %usstatus%
GuiControl,, Host4IP, %usip%
GuiControl,, Host4Status, %usstatus%
return

;### Header
GetHeader:
GuiControl,, MyHeader, Fetching...
header := UrlGet("http://smugdns.com/files/header.php?type=5&query="query,null)
StringReplace, header, header, <pre>,, All ;Cleaning Up Output
StringReplace, header, header, </pre>,, All ;Cleaning Up Output
GuiControl,, MyHeader, %header%
return

;################################################
;##  Open In - Links
;################################################
link:
	if(checkDomain(domain))
		{
			run http://%domain%
		}
return
TZlink:
	if(checkDomain(domain))
		{
			run https://toolzilla.intranet.gdg/index.php/AccountSearch/OneSearch/%domain%
		}
return

REGlink:
	if(checkDomain(domain))
		{
			run https://reggie.int.godaddy.com/Details.aspx?domain=%domain%
		}
return

DZAlink:
	if(checkDomain(domain))
		{
			run https://dza.int.secureserver.net/index.php?domain=%domain%
		}	
return

Elink:
	if(checkDomain(domain))
		{
		
			run https://emailmanager.intranet.gdg/user_info.php?infolevel=20&email_address=%domain%&page_action=user_info
		}
return

trace:
	if(checkDomain(domain))
		{
			run cmd /k tracert %domain%
		}
return

trace2:
	if(checkDomain(domain))
		{
			GoSub, TraceGui
		}
return

ping:
	if(checkDomain(domain))
		{
			run cmd /k ping %domain%
		}
return

IPWho:
	if(checkDomain(domain))
		{
			GoSub, WhoIP
		}
return

TraceGui:
Gui,2: +AlwaysOnTop
Gui,2: Add, Text, x20 y5 w300 h20, Traceroute to: %domain%
Gui,2: Add, Edit, x10 y20 w380 h375 Readonly vMyTrace,
Gui,2: Show, w400 h400, SmugDNS v%version% - TraceRoute
GuiControl,2:, MyTrace, Fetching...
;traced := UrlGet("http://smugdns.com/files/trace.php?smug=true&submit=Traceroute%21&host="domain,null)
GuiControl,2:, MyTrace, Maybe Soon...
return

2GuiClose:
Gui, 2: Destroy
return

WhoIP:
Gui,3: +AlwaysOnTop
Gui,3: Add, Text, x20 y5 w300 h20, IP Whois for %MyQueryIP%
Gui,3: Add, Edit, x10 y20 w380 h375 Readonly vMyIpWho, Fetching...
Gui,3: Show, w400 h400, SmugDNS v%version% - IP Whois
whois2 := UrlGet("http://smugdns.com/files/who.php?query="MyQueryIP,null)
GuiControl,3:, MyIpWho, %whois2%
return

3GuiClose:
Gui, 3: Destroy
return

;################################################
;## Cleanup & Other Functions
;################################################

ResetApp:
query = 
domain =
GoSub, ClearAll
return

ClearAll:
GuiControl,, MyDomain2,
GuiControl,, MyDomain, 
GuiControl,, MyIP, 
GuiControl,, MyDig,  
GuiControl,, MyStatus,  
GuiControl,, MyWhois,  
GuiControl,, Host2IP,  
GuiControl,, Host2Status,  
GuiControl,, Host3IP,  
GuiControl,, Host3Status, 
GuiControl,, whohostsit, 
GuiControl,, Host4IP, 
GuiControl,, MyHeader, 
GuiControl,, Host4Status, 
return

UrlGet(url,data) {
	WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	WebRequest.open("GET",URL, false)
	WebRequest.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
	WebRequest.send(data)
	Return WebRequest.ResponseText
}

checkDomain(Domain){
	if(Domain == "")
	{
		return false
	}
	else
	{
		return true
	}
}

terminate:
ExitApp
return

HideSplash:
	SplashImage, Off
	SetTimer, HideSplash, Off
	GoSub, LoadGui
Return