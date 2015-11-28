;SysMenu Menu
menu, SysMenu, add, About
menu, SysMenu, add, Settings
menu, SysMenu, add, SetLocation
menu, SysMenu, add,
menu, SysMenu, add, Reload
menu, SysMenu, add, Quit

;HomeScripts SubMenu
menu, HomeScripts, add, Wifi

;DevScripts SubMenu
menu, DevScripts, add, MonGet
menu, DevScripts, add, ProgramGet

;WorkScripts SubMenu
menu, WorkScripts, add, Stats

;WinScripts SubMenu
menu, WinScripts, add, cmd
menu, WinScripts, add, msconfig
menu, WinScripts, add, rdp
menu, WinScripts, add, ipconfig
menu, WinScripts, add, run
menu, WinScripts, add, hostname
menu, WinScripts, add, Sleeper

;Link Menu
Loop, read, %A_ScriptDir%/parts/links.smug
{
	menu, LinkMenu, add, %A_LoopReadLine%, loadlink
}
menu, LinkMenu, add,
menu, LinkMenu, add, Add Link, addlink
menu, LinkMenu, add, ClearLinks, clearlink

;Script Menu
menu, ScriptMenu, add, Home, :HomeScripts
menu, ScriptMenu, add, Dev, :DevScripts
menu, ScriptMenu, add, Work, :WorkScripts
menu, ScriptMenu, add, WIN, :WinScripts

;Build Main Menu
menu, MainMenu, add, Applications
menu, MainMenu, add, Links, :LinkMenu
menu, MainMenu, add, Scripts, :ScriptMenu
menu, MainMenu, add,
menu, MainMenu, add, System, :SysMenu