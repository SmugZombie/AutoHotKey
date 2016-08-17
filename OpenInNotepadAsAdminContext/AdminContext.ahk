;# Opens a given file in Notepad as administrator to allow for direct editing of protected files.
;# To be used in conjunction with a registry modification to add this to the right click context menu
;# Ron Egli - github.com/smugzombie

#NoEnv 
SendMode Input

Loop %0%  ; For each parameter (or file dropped onto a script):
{
    GivenPath := %A_Index%  ; Fetch the contents of the variable whose name is contained in A_Index.
    Loop %GivenPath%, 1
        LongPath = %A_LoopFileLongPath%
}

If not A_IsAdmin {
    Run *RunAs Notepad.exe "%GivenPath%"
}
else {
	Run Notepad.exe "%GivenPath%"
}
