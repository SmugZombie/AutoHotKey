;
;
;
return

ResetApp:
MsgBox, 4, , This Will Reset to Default Setting`nDo you want to continue? (Press YES or NO)
IfMsgBox No
    return
else
	{
	FileDelete, parts/links.smug
	FileDelete, parts/settings.ini
	FileDelete, parts/apps.smug
	Sleep 1000
	Reload
	}
return