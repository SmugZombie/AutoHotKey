;
;
;
return
checkVersion(ver)
{
;MsgBox %ver%
post := UrlGet("http://werq.us/radiation/latest.php", null)
StringReplace, post, post, </br>, `n, All
StringReplace, ver, ver, ' ', '', All
	if(ver < post)
		{
		ToolTip, Version Difference!`nCurr: %ver% - Avail: %post%
		SetTimer, RemoveToolTip, 4000
		;Menu, tray, Rename, Radiation v%ver%b, Curr: v%ver% Avail: v%post%
		}
	else
		{
		ToolTip, Current Version %ver%
		SetTimer, RemoveToolTip, 4000
		}
return 
}