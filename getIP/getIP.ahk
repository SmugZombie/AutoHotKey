; Smugdev getIP.ahk
; github.com/SmugZombie

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

MsgBox % GetLocalIPByAdaptor("Ethernet") ;Display the local IP of the adaptor named "Ethernet"

For AdaptorName, IP in GetLocalIPs() { ;Display the IPs of all adaptors that have one
    MsgBox, %AdaptorName%: %IP%
}

GetPublicIP() {
    HttpObj := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    HttpObj.Open("GET","https://www.google.com/search?q=what+is+my+ip&num=1")
    HttpObj.Send()
    RegexMatch(HttpObj.ResponseText,"Client IP address: ([\d\.]+)",match)
    Return match1
}

GetLocalIPByAdaptor(adaptorName) {
    objWMIService := ComObjGet("winmgmts:{impersonationLevel = impersonate}!\\.\root\cimv2")
    colItems := objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapter WHERE NetConnectionID = '" adaptorName "'")._NewEnum, colItems[objItem]
    colItems := objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration WHERE InterfaceIndex = '" objItem.InterfaceIndex "'")._NewEnum, colItems[objItem]
    Return objItem.IPAddress[0]
}

GetLocalIPs() {
    adaptors := Object()
    ips := Object()
    objWMIService := ComObjGet("winmgmts:{impersonationLevel = impersonate}!\\.\root\cimv2")
    colItems := objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapter")._NewEnum, colItems[objItem]
    While (colItems[objItem])
        adaptors.Insert(objItem.InterfaceIndex,objItem.NetConnectionID)
    For index, name in adaptors {
        colItems := objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration WHERE InterfaceIndex = '" index "'")._NewEnum, colItems[objItem]
        If (name && objItem.IPAddress[0])
            ips.Insert(name,objItem.IPAddress[0])
    }
    Return ips
}
