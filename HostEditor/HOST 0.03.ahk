;################################################
;##  HOSTSUpdater - SmugDev 2013
;##  A Division of SmugDNS
;##
;################################################
#SingleInstance Force ; Only one instance of the script will run, multiple attempts will be ignored
OnMessage(0x204, "WM_RBUTTONDOWN")

If not A_IsAdmin { ; Runs script as Administrator for UAC in Windows Vista and 7+
    Run *RunAs "%A_ScriptFullPath%"
	;msgbox Run this as an ADMINISTRATOR!
	;gosub, terminate
  }

;## Global Variables ##
version=0.03
appname=Hostfile Editor %version%
hostsdir=C:\WINDOWS\SYSTEM32\DRIVERS\ETC\HOSTS
defaults= # Copyright (c) 1993-2009 Microsoft Corp.`n#`n# This is a sample HOSTS file used by Microsoft TCP/IP for Windows.`n#`n# This file contains the mappings of IP addresses to host names. Each`n# entry should be kept on an individual line. The IP address should`n# be placed in the first column followed by the corresponding host name.`n# The IP address and the host name should be separated by at least one`n# space.`n#`n# Additionally, comments (such as these) may be inserted on individual`n# lines or following the machine name denoted by a '#' symbol.`n#`n# For example:`n#`n#      102.54.94.97     rhino.acme.com          # source server`n#       38.25.63.10     x.acme.com              # x client host`n`n# localhost name resolution is handled within DNS itself.`n#	127.0.0.1       localhost`n#	::1             localhost`n
site=
Website = http://ronegli.com
Saved=1

;## Context Menu ##
Menu, Context, add, Open Directory, Launch
Menu, Context, add
Menu, Context, add, Reload, Reload
Menu, Context, add, Quit, Terminate

;## Tray Menu ##
Menu, tray, NoStandard
Menu, tray, add, Reload, Reload
Menu, tray, add
Menu, tray, add, Quit, terminate

;## Right Mouse Click ##
WM_RBUTTONDOWN(wParam, lParam){
Menu, Context, Show
}

; backup hosts file before editing
filedelete, %hostsdir%.bak
FileCopy, %hostsdir%, %hostsdir%.bak

gosub, readfile
;## Create GUI ##
Gui, Add, Text,x11 y5 w300 h20,Enter IP address and Domain name (hostname only):
Gui, Add, Edit, vIP x11 y20 w90 h20, 127.0.0.1
Gui, Add, Edit, vAllowsite x105 y20 w190 h20, website.com
Gui, Add, Button, gAdd x300 y20 w60 h20 default, Add
Gui, Add, Button, gBlock x364 y20 w60 h20, Block
Gui, Add, ListBox, x11 y43 w410 h190 AltSubmit vhostfile sort,%site%
Gui, Add, Button, x11 y235 w60 h20 gDelete, Delete
Gui, Add, Button, x76 y235 w60 h20 gRemove_all, Delete all
;Gui, Add, Button, x300 y250 w60 h20 gRestore, Restore
Gui, Font, cBlue
Gui, Add, Text, y238 x172 gLaunchDev, SmugDev (c)2014
Gui, Font, cBlack
Gui, Add, Button, x295 y235 w60 h20 gBackup, Backup
Gui, Add, Button, x360 y235 w60 h20 gwritefile, Save
Gui, Show, x404 y320 h260 w432, %AppName%
return

;## Read Hosts File ##
readfile:
Loop, read, %hostsdir%
{
	Loop, parse, A_LoopReadLine, `n
	{
		if A_LoopField <>
		ifnotinstring, A_LoopField, #
		ifnotinstring, A_LoopField, localhost
		site=%A_LoopField%|%site%
	}
} 
Return

;## Delete Single Line Item ##
Delete:
ControlGet, todelete, Choice, , ListBox1, %AppName%
Loop, read, %hostsdir%
{
line=%A_LoopReadLine%
IfInString, line, %todelete%
StringReplace, line, line,%line%,,All
file=%file%`n%line%
}
GuiControlGet, Number, , ListBox1
control, Delete, %Number%, ListBox1, %AppName%
Saved=0
return

;## Add Blocked Domain ##
Block:
ControlGetText, AllowSite, Edit2, %AppName%
if AllowSite=
msgbox, No website was entered., return
stringreplace, AllowSite, AllowSite, http://,
StringRight, Slash, AllowSite, 1
if Slash=/
StringTrimRight, AllowSite, AllowSite, 1
control, Add, 127.0.0.1 		%AllowSite%, ListBox1, %AppName%
Saved=0
return

;## Add Custom Domain ##
Add:
Gui, Submit, NoHide
if AllowSite=
	{
		return
	}
if(ip = ){
		ip = 127.0.0.1
	}
stringreplace, AllowSite, AllowSite, http://,
StringRight, Slash, AllowSite, 1
if Slash=/
StringTrimRight, AllowSite, AllowSite, 1
GuiControl,, HostFile, %ip% 		%AllowSite%
Saved=0
return

;## Restore Hosts file from earlier created backup ##
Restore:
filedelete, %hostsdir%
Loop, read, %hostsdir%.bak, %hostsdir%
	{
	FileAppend, %A_LoopReadLine%`n
	siterestore=%A_LoopField%|%site%
	}
GuiControl,, ListBox1, %siterestore%
msgbox, All changes since last edit have been removed.
Saved=0
return

;## Backup File On Demand ##
Backup:
FileSelectFile, SelectedFile, S 16, %A_ScriptDir%\HOSTS.bak, Choose Backup location, BAK (*.bak)
if SelectedFile =
    return
else
    FileCopy, %hostsdir%, %SelectedFile%
return

;## Launch Hosts File Location ##
Launch:
run C:\WINDOWS\SYSTEM32\DRIVERS\ETC\
return

;## Save File To Disk / Hosts Directory ##
writefile:
gui, submit, nohide
filedelete, %hostsdir%
fileappend, %Defaults%, %hostsdir%
ControlGet, info, List,, ListBox1
fileappend, `n%info%, %hostsdir%
Saved=1
msgbox,,Yey!, File Saved!
return

;## Empty The Listbox ##
Remove_all:
GuiControl,, ListBox1, |
Saved=0
return

;## Delete Key ##
#IfWinActive, Hosts Editor
Delete::
GuiControlGet, Number, , ListBox1
if(Number = )
	{
		;Do Nothign
	}
Else{
		control, Delete, %Number%, ListBox1, %AppName%
		Saved=0
}
return

;## Cleanup SubRoutines ##
GuiClose:
if(Saved=0)
	gosub, writefile
ExitApp
return

LaunchDev:
run %Website%
return

terminate:
ExitApp
return

Reload:
Reload
return