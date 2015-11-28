;Test Follower
Appname = Follower
Version = 0.01
exists = 0
WindowToFollow = Test 0.01
Gui, +OwnDialogs +owner -MaximizeBox -MinimizeBox +LastFound +AlwaysOnTop -caption
Gui, Color, 424242
Gui, Font, c01DF01
Gui, Add, Text, x10 y9, Following: Test 0.01

WinGet, id, list,,, Program Manager
Loop, %id%
{
    this_id := id%A_Index%
    WinGetClass, this_class, ahk_id %this_id%
    WinGetTitle, this_title, ahk_id %this_id%
    if(this_title = WindowToFollow){
    	exists = 1
    }
}

if(exists != 1){
	run testgui.ahk
	sleep 250
}


MoveWithMe:
WinGetPos, X, Y, Width, Height, %WindowToFollow%
Newx = %X%
Newy := y + Height
;Gui, Show, w100 h50 x%NewX% y%NewY%, %AppName% %version%
WinMove, %AppName% %Version%,, %NewX%, %NewY%
setTimer, MoveWithMe, 300
return