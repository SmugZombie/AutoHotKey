; Keri Report Generator
; Used to generate access control grants / denies over a period of time. Creates a csv file
; Ron Egli - github.com/smugzombie

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, force
#Include, WinRun.ahk

IfNotExist, %A_ScriptDir%\settings.ini
	CreateINI()
Else
	ReadINI()

Gui, Font, s20
Gui, Add, Text, x10 y20, Doors.NET Report Generator
Gui, Add, MonthCal, x10 y60 vStartDate,
Gui, Add, MonthCal, x250 y60 vEndDate,
Gui, Font, s12
gui, add, button, x400 w75 y235 gReload, Refresh
gui, add, button, x200 w60 y235, Generate
Gui, Show, h285 w485,Site Monitor

return

ButtonGenerate:
Gui, Submit
FormatTime, StartDate, %StartDate%, yyyy-MM-dd
FormatTime, EndDate, %EndDate%, yyyy-MM-dd
GetResults()
return

GetResults(){
	global
	;output_dir := "D:\Access Control Reports\"
	output_file := output_dir . report_name . " " . StartDate . "-" . EndDate . report_extension
	SQL=sqlcmd -S ACCESSCONTROLSE\ECLIPSE -d DHS_MAIN -E -Q "SELECT Message.TimeStamp_Server as TimeStamp,Message.SPMDescription as Controller,Message.Description as Location,Message.MessageDescription as Message,CardHolder.First_Name as First,CardHolder.Last_Name as Last,Credential.Cardnumber as 'Card Number',Credential.Imprint as CardID FROM Message INNER JOIN CardHolder ON Message.CardHolderID=CardHolder.CardHolderID INNER JOIN Credential ON Message.CardHolderID=Credential.CardHolderID WHERE Message.TimeStamp_Server BETWEEN '%StartDate% 00:00:00' AND '%EndDate% 23:59:59' AND MessageDescription LIKE '`%`%Access`%`%'" -o "%output_file%" -W -w 999 -s","
	action := CMDRun(SQL)
	Run Notepad "%output_file%"
	ExitApp
}

ReadINI(){
	global
	IniRead, output_dir, %A_ScriptDir%\settings.ini, Output, output_dir
	IniRead, report_name, %A_ScriptDir%\settings.ini, Output, report_name
	IniRead, report_extension, %A_ScriptDir%\settings.ini, Output, report_extension
}

CreateINI(){
	global
	output_dir := "D:\Access Control Reports\"
	report_name := "Access Control"
	report_extension := ".csv"
	IniWrite, %output_dir%, %A_ScriptDir%\settings.ini, Output, output_dir
	IniWrite, %report_name%, %A_ScriptDir%\settings.ini, Output, report_name
	IniWrite, %report_extension%, %A_ScriptDir%\settings.ini, Output, report_extension
}

Reload:
Reload
return
