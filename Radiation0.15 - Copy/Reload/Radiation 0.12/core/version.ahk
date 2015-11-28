;
;
;
return
checkVersion(ver)
{
;MsgBox %ver%
version = %ver%
post := UrlGet("http://werq.us/radiation/latest.php", null)
post = %post%
StringTrimRight, post, post, 1
;StringReplace, post, post, '.', '', All
;StringReplace, version, version, '.', '', All
	if(version == post)
		{
		ToolTip, Current Version %version%
		SetTimer, RemoveToolTip, 4000
		}
	if(version < post)
		{
		ToolTip, Version %post% is now Available!
		SetTimer, RemoveToolTip, 4000
		}
	if(version > post)
		{
		ToolTip, Your version is newer than available.
		SetTimer, RemoveToolTip, 4000
		}
return 
}