; SmugDev WinLock.ahk
; github.com/SmugZombie

/* 
[Settings]              ; The script doesn't see this line.  The ini sees a new section heading.
 */
PassChar = z            ; Use any character you like
PassWord = cheese         ; Same for password
/* 
[EndSettings]           ; The ini sees the lines above as keys and values.  The script sees values assigned to variables.
 */


F12::                   ; Lock everything
    ; **************************************************************
    ; *** A single press of PassChar immediately unlocks computer ***
    ; *** Any other key pressed requires full password           ***
    ; **************************************************************        
    WinMinimizeAll                      ; Hide what's on screen
    Hotkey !Tab, NULL   
    Hotkey LWIN, NULL   
    Hotkey RWIN, NULL                   ; Disable alt-tab
    BlockInput, MouseMove               ; Disable mousemoves
    Input, SingleKey, L1                ; Wait for user to type something.
    If (SingleKey <> PassChar)          ; PassChar?
        {                               ; No, so demand full password
            String :=
            While String <> PassWord
                InputBox String, Computer is locked!, Password:, HIDE, 250, 150
        }
    SoundPlay c:\Windows\Media\B6.WAV   ; Play sound to announce computer successfully unlocked
    Hotkey !Tab, Off                    ; Restore alt-tab
    Hotkey LWIN, Off   
    Hotkey RWIN, Off
    BlockInput MouseMoveOff             ; Restore mouse moves
    WinMinimizeAllUndo                  ; Restore screen
    reload
Return    

NULL:                                   ; Dummy routine for alt-tab (does nothing)
Return
