return

checkVersion(ver)
{
url := "http://alwaysontop.tk/latest.php"
post = 
Options =
(
Method: POST
+NO_COOKIES
+NO_AUTO_REDIRECT
charset=utf-8
)
HTTPRequest(url, post, "", Options)
StartPosText = ""
EndPosText := ""
StartPos := InStr(post,StartPosText)
StringGetPos , EndPos , post , </font><br/><center><script type='text/javascript'>
Length := EndPos - StartPos + 1
Output := SubStr(post,StartPos,Length)
StringReplace, post, post, </br>, `n, All
	if(version < post)
		{
		TrayTip, Version Difference!, Current: %ver% Available: %post% `nVisit QuickDns.tk for details!
		SetTimer, RemoveTrayTip, 4000
		;Menu, tray, Rename, QuickDns v%ver%b, Curr: v%ver% Avail: v%post%
		}
	if(post == ver)
		{
		TrayTip, Current Version, %ver%
		SetTimer, RemoveTrayTip, 4000
		}
return
}
