; Developed By: Ron Egli (github.com/smugzombie)
; Keeps you connected to wifi even if you have a solid ethernet connection
; Version 1.0

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance, force
#Include WinRun.ahk ; Can be found here: https://github.com/SmugZombie/AutoHotKey/tree/master/WinRun
#NoTrayIcon

; Locate ini file, if not available then create with null values
IfNotExist, %A_ScriptDir%\wifiwatcher.ini
{
	IniWrite, Ron Egli, %A_ScriptDir%\wifiwatcher.ini, About, Developer
	IniWrite, github.com/smugzombie , %A_ScriptDir%\wifiwatcher.ini, About, Github
	IniWrite, 1.0 , %A_ScriptDir%\wifiwatcher.ini, About, Version
	IniWrite, null , %A_ScriptDir%\wifiwatcher.ini, Connection, SSID
	IniWrite, null , %A_ScriptDir%\wifiwatcher.ini, Connection, PROFILE
	IniWrite, null , %A_ScriptDir%\wifiwatcher.ini, Connection, INTERFACE
	IniWrite, 60000 , %A_ScriptDir%\wifiwatcher.ini, Connection, INTERVAL_MS
}

; Read from ini file
IniRead, SSID, %A_ScriptDir%\wifiwatcher.ini, Connection, SSID
IniRead, PROFILE, %A_ScriptDir%\wifiwatcher.ini, Connection, PROFILE
IniRead, INTERFACE, %A_ScriptDir%\wifiwatcher.ini, Connection, INTERFACE
IniRead, INTERVAL_MS, %A_ScriptDir%\wifiwatcher.ini, Connection, INTERVAL_MS

; If the ini file has not been properly configured, ask to configure
if(SSID == "null")
{
	Logthis("ERROR: Invalid Configuration Present - Please Update Your Config Here: %A_ScriptDir%\wifiwatcher.ini then relaunch the service`n")
	;msgbox Please Update Your Config Here: %A_ScriptDir%\wifiwatcher.ini then relaunch the service
	ExitApp, 1
}
Logthis("Service Started")

if INTERVAL_MS is not integer
{
	INTERVAL_MS = 60000
	Logthis("WARN: INTERVAL_MS not properly configured, Failing back to " INTERVAL_MS)
	IniWrite, 60000 , %A_ScriptDir%\wifiwatcher.ini, Connection, INTERVAL_MS
}

doWork()
Return

doWork(){
	status := getStatus()
	if(status == 1){
		cleanup()
	}else{
		checkArea()
	}	
	sleep %INTERVAL_MS%
	doWork()
}

getStatus(){
	global
	current_status := CMDRun("NETSH WLAN SHOW INTERFACE")
	IfInString, current_status, disconnected
	{
		Logthis("Wifi State: Disconnected")
		return 0
	}
	Else
	{
		return 1
	}
}

checkArea(){
	global
	command = netsh wlan show networks
	available_networks := CMDRun(command)
	IfInString, available_networks, %SSID%
	{
		Logthis("Wifi State: In Range of " SSID)
		connect()
	}
	return
}

connect(){
	global
	Logthis("Wifi State: Connecting")
	command = netsh wlan connect ssid="%SSID%" interface="%INTERFACE%" name="%PROFILE%"
	result := CMDRun(command)
	Logthis("Wifi State: " result)
	;msgbox % result
}

disconnect(){

}

cleanup(){
	global
	status = 
	current_status = 
	result = 
}

LogThis(string){
	global
	StringReplace,string,string,`r`n,,A
	FormatTime, Time,, MM/dd/yy hh:mm:ss tt
	logline = %Time% - %string%
	FileAppend, %logline%`n, %A_ScriptDir%\wifiwatcher.log
}
