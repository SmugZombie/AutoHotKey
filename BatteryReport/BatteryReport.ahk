#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force
#Include WinRun.ahk

If not A_IsAdmin { ; Runs script as Administrator for UAC in Windows Vista and 7+
    try {
    	Run *RunAs "%A_ScriptFullPath%"
    	ExitApp
    }
    catch e
    {
    	ExitApp
    }
}

command = powercfg /batteryreport /output "C:\battery_report.html"
result := CMDRun(command)
;msgbox % result
Run C:\battery_report.html