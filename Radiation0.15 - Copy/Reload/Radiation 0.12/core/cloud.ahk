;
;
;
return

ResetApp:
MsgBox, 4, , This Will Destroy ALL Links`nDo you want to continue? (Press YES or NO)
IfMsgBox No
    return
else
	{
	FileDelete, parts/links.smug
	FileDelete, parts/config.smug
	FileDelete, parts/apps.smug
	Sleep 1000
	Reload
	}
	
return