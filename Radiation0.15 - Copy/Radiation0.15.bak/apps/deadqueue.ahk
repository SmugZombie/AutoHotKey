;<Zero Queue>------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;for times when the Iris queue is zero
;made by Jeffrey Reeves
Toggle = off
#MaxThreadsPerHotkey 2
ScrollLock:: ;repeatedly click in a square until the mouse is moved ;clicks at 65 clicks a minute
;xpos_close = 1259 ;location of "queue is empty" pop-up's close [X]
;ypos_close = 927
;OR xpos_current == xpos_close
;OR ypos_current == ypos_close
MouseGetPos, xpos_start, ypos_start ;find where the mouse is to start with
xpos_left := xpos_start ;establish boundaries
xpos_right := xpos_start + 5
ypos_up := ypos_start
ypos_down := ypos_start + 5
Toggle := on
While (Toggle == on){
MouseGetPos, xpos_current, ypos_current
if (ypos_current == ypos_up OR ypos_current == ypos_down){ ;while the mouse hasn't moved vertically
if(xpos_current == xpos_left OR xpos_current == xpos_right){ ;while the mouse hasn't moved horizontally
MouseGetPos, xpos_current, ypos_current
ToolTip, Clicking Away...
Click %xpos_left%, %ypos_up%
Sleep 5
Click %xpos_right%, %ypos_up%
Sleep 5
Click %xpos_right%, %ypos_down%
Sleep 5
Click %xpos_left%, %ypos_down%
Sleep 250
;Click %xpos_close%, %ypos_close%
;Sleep 50
}
}
else{
Toggle := off
ToolTip
return
}
}
return
