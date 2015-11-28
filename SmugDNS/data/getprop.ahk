#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

IniRead, Domain, settings.ini, Options, Domain
usip := UrlGet("http://smugdns.com/files/external.php?test=ip&host=1&query="Domain,null)
usstatus := UrlGet("http://smugdns.com/files/external.php?test=http&host=1&query="Domain,null)
euip := UrlGet("http://smugdns.com/files/external.php?test=ip&host=2&query="Domain,null)
eustatus := UrlGet("http://smugdns.com/files/external.php?test=http&host=2&query="Domain,null)
apip := UrlGet("http://smugdns.com/files/external.php?test=ip&host=3&query="Domain,null)
apstatus := UrlGet("http://smugdns.com/files/external.php?test=http&host=3&query="Domain,null)
IniWrite, %usip%, settings.ini, Options, USIP
IniWrite, %usstatus%, settings.ini, Options, USSTATUS
IniWrite, %euip%, settings.ini, Options, EUIP
IniWrite, %eustatus%, settings.ini, Options, EUSTATUS
IniWrite, %apip%, settings.ini, Options, APIP
IniWrite, %apstatus%, settings.ini, Options, APSTATUS

return
UrlGet(url,data) {
	WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	WebRequest.open("GET",URL, false)
	WebRequest.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
	WebRequest.send(data)
	Return WebRequest.ResponseText
}