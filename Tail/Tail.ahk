If not A_IsAdmin { ; Runs script as Administrator for UAC in Windows Vista and 7+
    Run *RunAs "%A_ScriptFullPath%"
}

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force

IniRead, File, %A_ScriptDir%\tailer.ini, CONFIG, File, C:\Windows\win.ini
IniRead, NumOfLines, %A_ScriptDir%\tailer.ini, CONFIG, NumOfLines, 20
IniRead, BlankLines, %A_ScriptDir%\tailer.ini, CONFIG, BlankLines, 0

Menu, FileMenu, Add, Change &File, ChangeFile
Menu, FileMenu, Add,
Menu, FileMenu, Add, E&xit, FileExit
Menu, MyMenuBar, Add, &File, :FileMenu
Gui, Menu, MyMenuBar
Gui, +Resize  ; Make the window resizable.
Gui, Add, Edit, vMainEdit WantTab W600 R20 readonly
Gui, Show,, Ossec Tail

Tail(k,file)   ; Return the last k lines of file
{
   Loop Read, %file%
   {
      i := Mod(A_Index,k)
      L%i% = %A_LoopReadLine%
   }
   L := L%i%
   Loop % k-1
   {
      IfLess i,1, SetEnv i,%k%
      i--      ; Mod does not work here
      L := L%i% "`n" L
   }
   Return L
}

Loop
{
   last_line := Tail(NumOfLines, File) ;last line of text
   if (BlankLines == 0){
      last_line := RegExReplace(last_line, "(^|\R)\K\s+")
   }
   GuiControl,, MainEdit, %last_line%
   sleep 1000
}

FileExit:     ; User chose "Exit" from the File menu.
GuiClose:  ; User closed the window.
ExitApp

ChangeFile:
InputBox, File, Tailer, What filename do you wish to tail?, , , , , , ,
IniWrite, %File%, %A_ScriptDir%\tailer.ini, CONFIG, File
return
