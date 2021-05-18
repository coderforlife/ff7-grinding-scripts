; Utilities and settings used by many of the ahk scripts

; Keyboard Bindings
; The values given are for default Steam values
global OkKey = "X"        ; "Ok" or "Circle" key
global LeftKey = "Left"
global RightKey = "Right"
global UpKey = "Up"
global DownKey = "Down"
global PgUpKey = "PgUp"   ; "Page Up" or "L1" key
global PgDnKey = "PgDn"   ; "Page Down" or "R1" key

; Battle-Checking Pixel - use F9 to work these out
; The values given are for default window colors (the blue gradient) with a 1024x768 window
global PxCheckX := 33
global PxCheckY := 704
global PxCheckColorBattle := 0x000882

; Press Ok/Circle/X to continue through a dialog
PressOk(delay:=250)
{
	Send {%OkKey% Down}
	Sleep 100
	Send {%OkKey% Up}
	Sleep %delay%
}

; Generate a random number and return it
Rand(min, max)
{
	Random, out, %min%, %max%
	return out
}

; Check that we are in battle
; This is highly speculative... checks a pixel for a certain color
IsInBattle()
{
	PixelGetColor, color, %PxCheckX%, %PxCheckY%, RGB
	If (color = PxCheckColorBattle)
		Return 1
	Return 0
}

; A color picker that shows the pixel location and its color
; Used to get the colors for the check color values
ColorPicker()
{
	global Stop := 0
	Loop
	{
		If Stop
		{
			ToolTip
			Return
		}
		MouseGetPos, MouseX, MouseY
		PixelGetColor, color, %MouseX%, %MouseY%, RGB
		ToolTip % Format("({:d}, {:d}) : 0x{:06x}", MouseX, MouseY, color)
	}
}

; Pause everything when the focused window is not FF7
Gui +LastFound 
hWnd := WinExist()
DllCall("RegisterShellHookWindow", UInt, Hwnd)
MsgNum := DllCall("RegisterWindowMessage", Str, "SHELLHOOK")
OnMessage(MsgNum, "ShellMessage")
Return
ShellMessage(nCode, wParam, lParam)
{
	If (nCode = 0x0004 or nCode = 0x8004) ; HSHELL_WINDOWACTIVATED and HSHELL_RUDEAPPACTIVATED
	{
		WinGetTitle, title, ahk_id %wParam%
		If (title = "FINAL FANTASY VII")
			Pause, Off, 1
		Else
			Pause, On, 1
	}
}
