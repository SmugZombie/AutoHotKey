return

Submit:
InputBox, UserInput, Comment, Please enter a Comment. Be as informative as possible as to the steps you took to see the issue occur. If you wish a follow up please also include your email address in your message., , 480,175
submitComment(UserInput)
return

submitComment(record)
{
version = 3.0
url := "http://dns.quickdns.tk/submit/submit.php?a="
url = %url%AlwaysOnTopv
url = %url%%version%
url2 = &c=
url = %url%%url2%%record%
nada = 
post = 
Options =
(
Method: POST
+NO_COOKIES
+NO_AUTO_REDIRECT
charset=utf-8
)
HTTPRequest(url, post, nada, Options)
StartPosText = ""
EndPosText := ""
StartPos := InStr(post,StartPosText)
StringGetPos , EndPos , post , </font><br/><center><script type='text/javascript'>
Length := EndPos - StartPos + 1
Output := SubStr(post,StartPos,Length)
MsgBox Thanks for letting us know!
return 
}
