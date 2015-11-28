#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Include JSON.ahk

j = {"MESSAGE":"Hello World!","PCI":"THISISIT","PAN":"THISISNTIT","OSSEC_HOST":"192.168.1.1","OSSEC_KEY":"1615fas1df1asdf15asdf"}

message := json(j, "MESSAGE")
pcikey := json(j, "PCI")
pankey := json(j, "PAN")
ossechost := json(j, "OSSEC_HOST")
osseckey := json(j, "OSSEC_KEY")

msgbox, 1 , Key Response, 
(LTrim
	Message   : %message%
	PCIKey     : %pcikey%
	PANKey    : %pankey%
	OssecHost : %ossechost%
	OssecKey  : %osseckey%
)
