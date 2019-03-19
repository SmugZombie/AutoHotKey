#Persistent
#SingleInstance, force
#NoEnv
#Include, WinRun.ahk

AppName = OnAir Controller
MyDimensions := 20
Version = 0.0.5
status = 0
username = %A_UserName% 

IfNotExist, %A_ScriptDir%/img
   FileCreateDir, %A_ScriptDir%/img

Extract_OffAir(A_ScriptDir . "/img/" . "OffAir.png")
Extract_OnAir(A_ScriptDir . "/img/" . "OnAir.png")

SysGet, Mon1, Monitor, 1 
MyHeight := (A_ScreenHeight - 10 - 50)
MyWidth := (Mon1Right - MyDimensions - 10)
IniRead, MyHeight, mediacontrolsettings.ini, Options, MyHeight, %MyHeight%
IniRead, MyWidth, mediacontrolsettings.ini, Options, MyWidth, %MyWidth%
Gui -Resize -MaximizeBox -MaximizeBox +AlwaysOnTop +ToolWindow -SysMenu +LastFound

Gui, Color, 232528
WinSet, Transparent, 150
;Gui, Add, Button, x0 y0 h20 w10 disabled, 
Gui, Add, Picture, x1 y0 h50 w125 gToggle vPicture, img\OffAir.png

Gui, Show, h50 w125, OnAir Controller %Version%

Menu, Tray, NoStandard
Menu, Tray, add, Reload, Reload
Menu, Tray, add,
Menu, Tray, add, &Quit, Close

;getStatus()

OnMessage(0x203, "WM_LBUTTONDBLCLK")
return

getStatus(){
	global

	command = powershell.exe -C "(Invoke-WebRequest -Uri \"https://[DOMAIN]/onair/api/?user=%username%&action=getMe\").Content"
    response := CMDRun(command)

    if(response == "true"){
    	GuiControl, -Redraw,     Picture
    	GuiControl,,Picture, img\OnAir.png
    	GuiControl, +Redraw,    Picture
    	status = 1
    }
    response = 
    command = 

}

Toggle:

	if( status == 1 ){
		GuiControl, -Redraw,     Picture
    	GuiControl,, Picture, img\OffAir.png
    	GuiControl, +Redraw,    Picture
    	status = 0
    	command = powershell.exe -C "Invoke-WebRequest -Uri \"https://[DOMAIN]/onair/api/?user=%username%&action=endCall\""
    	CMDRun(command)
	}
	else{
		GuiControl, -Redraw,     Picture
    	GuiControl,, Picture, img\OnAir.png
    	GuiControl, +Redraw,    Picture
    	status = 1
    	command = powershell.exe -C "Invoke-WebRequest -Uri \"https://[DOMAIN]/onair/api/?user=%username%&action=newCall\""
    	CMDRun(command)
	}

return

Close:
	command = powershell.exe -C "Invoke-WebRequest -Uri \"https://[DOMAIN]/onair/api/?user=%username%&action=endCall\""
    CMDRun(command)
    ExitApp, 1
return

Reload:

	Reload

return



OffAir_Get(_What)
{
	Static Size = 5173, Name = "OffAir.png", Extension = "png", Directory = "C:\Users\ron.egli\Desktop"
	, Options = "Size,Name,Extension,Directory"
	;This function returns the size(in bytes), name, filename, extension or directory of the file stored depending on what you ask for.
	If (InStr("," Options ",", "," _What ","))
		Return %_What%
}

Extract_OffAir(_Filename, _DumpData = 0)
{
	;This function "extracts" the file to the location+name you pass to it.
	Static HasData = 1, Out_Data, Ptr, ExtractedData
	Static 1 = "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"
	
	If (!HasData)
		Return -1
	
	If (!ExtractedData){
		ExtractedData := True
		, Ptr := A_IsUnicode ? "Ptr" : "UInt"
		, VarSetCapacity(TD, 7088 * (A_IsUnicode ? 2 : 1))
		
		Loop, 1
			TD .= %A_Index%, %A_Index% := ""
		
		VarSetCapacity(Out_Data, Bytes := 5173, 0)
		, DllCall("Crypt32.dll\CryptStringToBinary" (A_IsUnicode ? "W" : "A"), Ptr, &TD, "UInt", 0, "UInt", 1, Ptr, &Out_Data, A_IsUnicode ? "UIntP" : "UInt*", Bytes, "Int", 0, "Int", 0, "CDECL Int")
		, TD := ""
	}
	
	IfExist, %_Filename%
		FileDelete, %_Filename%
	
	h := DllCall("CreateFile", Ptr, &_Filename, "Uint", 0x40000000, "Uint", 0, "UInt", 0, "UInt", 4, "Uint", 0, "UInt", 0)
	, DllCall("WriteFile", Ptr, h, Ptr, &Out_Data, "UInt", 5173, "UInt", 0, "UInt", 0)
	, DllCall("CloseHandle", Ptr, h)
	
	If (_DumpData)
		VarSetCapacity(Out_Data, 5173, 0)
		, VarSetCapacity(Out_Data, 0)
		, HasData := 0
}


OnAir_Get(_What)
{
	Static Size = 6031, Name = "OnAir.png", Extension = "png", Directory = "D:\Dropbox (Personal)\DEV\AHK\OnAir\img"
	, Options = "Size,Name,Extension,Directory"
	;This function returns the size(in bytes), name, filename, extension or directory of the file stored depending on what you ask for.
	If (InStr("," Options ",", "," _What ","))
		Return %_What%
}

Extract_OnAir(_Filename, _DumpData = 0)
{
	;This function "extracts" the file to the location+name you pass to it.
	Static HasData = 1, Out_Data, Ptr, ExtractedData
	Static 1 = "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"
	
	If (!HasData)
		Return -1
	
	If (!ExtractedData){
		ExtractedData := True
		, Ptr := A_IsUnicode ? "Ptr" : "UInt"
		, VarSetCapacity(TD, 8263 * (A_IsUnicode ? 2 : 1))
		
		Loop, 1
			TD .= %A_Index%, %A_Index% := ""
		
		VarSetCapacity(Out_Data, Bytes := 6031, 0)
		, DllCall("Crypt32.dll\CryptStringToBinary" (A_IsUnicode ? "W" : "A"), Ptr, &TD, "UInt", 0, "UInt", 1, Ptr, &Out_Data, A_IsUnicode ? "UIntP" : "UInt*", Bytes, "Int", 0, "Int", 0, "CDECL Int")
		, TD := ""
	}
	
	IfExist, %_Filename%
		FileDelete, %_Filename%
	
	h := DllCall("CreateFile", Ptr, &_Filename, "Uint", 0x40000000, "Uint", 0, "UInt", 0, "UInt", 4, "Uint", 0, "UInt", 0)
	, DllCall("WriteFile", Ptr, h, Ptr, &Out_Data, "UInt", 6031, "UInt", 0, "UInt", 0)
	, DllCall("CloseHandle", Ptr, h)
	
	If (_DumpData)
		VarSetCapacity(Out_Data, 6031, 0)
		, VarSetCapacity(Out_Data, 0)
		, HasData := 0
}





