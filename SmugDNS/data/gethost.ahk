#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

IniRead, Domain, settings.ini, Options, Domain
whohost := UrlGet("http://smugdns.com/files/whohost.php?query="Domain,null)
sleep 200
IniWrite, %whohost%, settings.ini, Options, WhoHost

return
UrlGet(url,data) {
	WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	WebRequest.open("GET",URL, false)
	WebRequest.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
	WebRequest.send(data)
	Return WebRequest.ResponseText
}