# Opens a given file in Notepad as administrator to allow for direct editing of protected files.
# To be used in conjunction with a registry modification to add this to the right click context menu
# Ron Egli - github.com/smugzombie

#NoEnv 
SendMode Input
input = %1%

If not A_IsAdmin {
    Run *RunAs Notepad.exe %input%
}
else {
	Run Notepad.exe %input%
}
