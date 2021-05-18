; Basketball game in the Gold Saucer / Wonder Square
; Usually works pretty well, but on the 10-shots ones sometimes it keeps going?

; Supposed to be about 450 miliseconds, but the optimal for me was found to be less than that
global ShootHold := 442

#Include %A_ScriptDir%
#Include util.ahk


; Single Shot
Shoot()
{
	Send {%OkKey% down}
	Sleep %ShootHold%
	Send {%OkKey% up}
}

; 10 Shots
Shoot10()
{
	Loop, 10
	{
		If Stop
			Return 0
		Shoot()
		Sleep 5500
	}
	Return 1
}

; Entire Game (4 rounds of 10 shoots with a double-or-nothing shot at the end of each round)
; Takes about 5 minutes, costs 200 Gil, nets 300 GP
WholeGame()
{
	Menu, Tray, Icon, shell32.dll, 25 ; 'dialogs'
	PressCircle()
	If Stop
		Return 0
	PressCircle()
	PressCircle()
	PressCircle()
	Menu, Tray, Icon, shell32.dll, 47 ; 'waiting'
	Sleep 2500
	Loop, 4
	{
		If Stop
			Return 0
		Menu, Tray, Icon, shell32.dll, 44 ; 'star/shooting'
		If not Shoot10()
			Return 0
		Menu, Tray, Icon, shell32.dll, 25 ; 'dialogs'
		PressCircle()
		Sleep 200
		PressCircle()
		Sleep 200
		PressCircle()
		Sleep 200
		PressCircle()
		Sleep 200
		PressCircle()
		Menu, Tray, Icon, shell32.dll, 266 ; 'waiting'
		Sleep 1500
		If Stop
			Return 0
		Menu, Tray, Icon, shell32.dll, 44 ; 'star/shooting'
		Shoot() ; double-or-nothing shot
		Sleep 4500
		If Stop
			Return 0
		Menu, Tray, Icon, shell32.dll, 25 ; 'dialogs'
		PressCircle()
		Sleep 1500
	}
	If Stop
		Return 0
	PressCircle()
	Sleep 750
	PressCircle()
	Return 1
}


#IfWinActive FINAL FANTASY VII

l::
Sleep 200
Shoot()
Return

k::
Sleep 200
Shoot10()
Return

j::
Sleep 200
WholeGame()
Return

u::
Sleep 200
Loop, 10
{
	If Stop
		Break
	If not WholeGame()
		Break
	Sleep 1000
}
Return

; Hotkeys in all scripts
; F9 key shows a colorpicker
F9::ColorPicker()

; Esc stops most actions
Esc::Stop=1

#IfWinActive

^r::Reload  ; ctrl-r, reloads the current script
