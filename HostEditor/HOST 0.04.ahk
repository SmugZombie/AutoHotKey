﻿;################################################
;##  HOSTSUpdater - SmugDev 2013
;##  A Division of SmugDNS
;##
;################################################
#SingleInstance Force ; Only one instance of the script will run, multiple attempts will be ignored
OnMessage(0x204, "WM_RBUTTONDOWN")

If not A_IsAdmin { ; Runs script as Administrator for UAC in Windows Vista and 7+
    Run RunAs "%A_ScriptFullPath%"
	;msgbox Run this as an ADMINISTRATOR!
	;gosub, terminate
  }

;## Global Variables ##
version=0.04
appname=Hostfile Editor %version%
hostsdir=C:\WINDOWS\SYSTEM32\DRIVERS\ETC\HOSTS
defaults= # Copyright (c) 1993-2009 Microsoft Corp.`n#`n# This is a generated HOSTS file used by Microsoft TCP/IP for Windows using HostEditor by SmugDev.`n#`n# This file contains the mappings of IP addresses to host names. Each`n# entry should be kept on an individual line. The IP address should`n# be placed in the first column followed by the corresponding host name.`n# The IP address and the host name should be separated by at least one`n# space.`n#`n# Additionally, comments (such as these) may be inserted on individual`n# lines or following the machine name denoted by a '#' symbol.`n#`n# For example:`n#`n#      102.54.94.97     rhino.acme.com          # source server`n#       38.25.63.10     x.acme.com              # x client host`n`n# localhost name resolution is handled within DNS itself.`n#	127.0.0.1       localhost`n#	::1             localhost`n
site=
Website = http://ronegli.com
Saved=1

;## Context Menu ##
Menu, Context, add, Open Directory, Launch
Menu, Context, add
Menu, Context, add, Restore Size, RestoreGui
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


;## Create GUI ##
Gui, +Resize
Gui, Add, Text,x11 y5 w300 h20,Enter IP address and Domain name (hostname only):
Gui, Add, Edit, vIP x11 y20 w90 h20, 127.0.0.1
Gui, Add, Edit, vAllowsite x105 y20 w190 h20, website.com
Gui, Add, Button, gAdd x300 y20 w60 h20 default, Add
Gui, Add, Button, gBlock x364 y20 w60 h20, Block
; Gui, Add, ListBox, x11 y43 w410 h190 AltSubmit vhostfile sort,%site%
Gui, Add, ListView, x11 y43 w410 r9 vhostfile sort, IP|Associated HostName(s)
;Gui, Add, ListView, r20 w700, Name|Size (KB)
Gui, Add, Button, x11 y230 w60 h20 gDelete, Delete
Gui, Add, Button, x76 y230 w60 h20 gRemove_all, Delete all
;Gui, Add, Button, x300 y250 w60 h20 gRestore, Restore
Gui, Font, cBlue
Gui, Add, Text, y233 x172 gLaunchDev, SmugDev (c)2014
Gui, Font, cBlack
Gui, Add, Button, x295 y230 w60 h20 gBackup, Backup
Gui, Add, Button, x360 y230 w60 h20 gwritefile, Save
Gui, Show, x404 y320 h255 w432, %AppName%
gosub, readfile
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
		{
			StringSplit, field_array, A_LoopField, %A_Space%
			StringLen,Cutoff,field_array1
			Cutoff := Cutoff + 1
			StringTrimLeft, Hostnames, A_LoopField, Cutoff
			LV_Add("",field_array1,Hostnames)
		}
		

		;site=%A_LoopField%|%site%

	}
} 
goSub, FixFormat
Return

FixFormat:
LV_ModifyCol(1,90)
LV_ModifyCol(2,290)
return

;## Delete Single Line Item ##
Delete:
FocusedRowNumber := LV_GetNext(0, "F")
LV_GetText(RowText, FocusedRowNumber, 1) 
if(RowText != ""){
	LV_Delete(FocusedRowNumber)
}
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
;control, Add, 127.0.0.1 		%AllowSite%, ListBox1, %AppName%
LV_Add("","127.0.0.1",AllowSite)
goSub, FixFormat
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
;GuiControl,, HostFile, %ip% 		%AllowSite%
LV_Add("",ip,AllowSite)
goSub, FixFormat
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
;ControlGet, info, List,, ListBox1

Loop % LV_GetCount()
{
    LV_GetText(IP, A_Index, 1)
    LV_GetText(HOSTNAMES, A_Index, 2)
    info = %info%`n%IP% %HOSTNAMES%
}
fileappend, `n%info%, %hostsdir%
Saved=1
info = 
msgbox,,Hostfile Editor, File Saved!
return

;## Empty The Listbox ##
Remove_all:
LV_Delete()
Saved=0
return

;## Delete Key ##
;#IfWinActive appname version
#IfWinActive Hostfile Editor 0.04 ahk_class AutoHotkeyGUI
Delete::
gosub, Delete
return

;## Cleanup SubRoutines ##
GuiClose:
if(Saved=0)
	gosub, writefile
ExitApp
return

RestoreGui:
reload
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