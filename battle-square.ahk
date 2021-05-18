; Assumes you have the special battle and Cloud is well equipped to auto-fight
; Shift+F1 option quits after first battle to harvest Tissues

global PxCheckColorInbetweenBattle := 0x00188C ; 0x00188C for default window colors with a 1024x768 window
global SlotsWait := 0 ; Increasing this causes different slots to be picked, it is in units of ms

#Include %A_ScriptDir%
#Include util.ahk


; Go through the menu to start a new battle square round
GoThroughMenu()
{
	Menu, Tray, Icon, shell32.dll, 161 ; 'people/conversation'
	PressOk(1500) ; start conversation
	PressOk(1500) ; select "special battle"
	PressOk(1500) ; match description
	PressOk(1500) ; "All right, I'll show 'em"
	PressOk(400) ; few more for good measure (jsut the transition screen)
	PressOk(400)
}

; Wait until IsInBattle() returns true
WaitForBattle()
{
	Menu, Tray, Icon, shell32.dll, 266 ; 'waiting'
	Loop
	{
		If Stop
			Return 0
		Sleep 15
		If IsInBattle()
			Break
	}
	Return 1
}

; Check that we are inbetween battles ("GREAT!", continue, and slots)
IsInbetweenBattle()
{
	PixelGetColor, color, %PxCheckX%, %PxCheckY%, RGB
	If (color = PxCheckColorInbetweenBattle)
		Return 1
	Return 0
}

; Continously tell everyone to attack
Battle_Attack()
{
	Menu, Tray, Icon, shell32.dll, 300 ; 'arrow/battle'
	Send {%OkKey% Down}
	Sleep 250
	Loop
	{
		If (Stop)
		{
			Send {%OkKey% Up}
			Return 0
		}
		Sleep 15
		If not IsInBattle()
			Break
		Send {%OkKey% Down}
	}
	Send {%OkKey% Up}
	Return 1
}

; Run through the in-between-rounds screen, including the slots
RunSlots()
{
	Menu, Tray, Icon, shell32.dll, 22 ; 'control panel/between battles'
	Sleep 200 ; short fade that we need to make sure that we skip
	If not IsInbetweenBattle()
		Return 0
	PressOk() ; close "GREAT!"
	PressOk() ; select "Of course!" (i.e. continue)
	PressOk() ; continue "Slot start!"
	Sleep %SlotsWait% ; bias which slot option is selected
	PressOk() ; stop slots
	PressOk() ; continue
	PressOk() ; continue
    Return 1
}

; Quit the battle square by selecting "No way!"
QuitBattleSquare()
{
	Menu, Tray, Icon, shell32.dll, 22 ; 'control panel/between battles'
	Sleep 200 ; short fade to make sure we skip
	If not IsInbetweenBattle()
		Return 0
	PressOk() ; close "GREAT!"
	Send {%RightKey% Down} ; arrow right
	Sleep 100
	Send {%RightKey% Up}
	Sleep 250
	PressOk() ; select "No way!"
    Return 1
}

; Deal with the end of the battle (either win or lose)
EndOfBattle()
{
	Menu, Tray, Icon, shell32.dll, 44 ; 'star/end of battle'
	Sleep 3500 ; TODO: wait for end-of-battle
	Menu, Tray, Icon, shell32.dll, 29 ; 'hand/getting rewards'
	PressOk(500) ; continue past screen that tells us how many BPs earned
	PressOk(500) ; continue past screen with prize won
	If Stop
		Return 0
	; Walk up to the desk
	Menu, Tray, Icon, shell32.dll, 160 ; 'four-way-arrow/walking'
	Send {%RightKey% Down}
	Sleep 4000
	Send {%RightKey% Up}
	Return 1
}


#IfWinActive FINAL FANTASY VII
F1::
global Stop := 0
Loop
{
	If Stop 
		Return
	If not IsInBattle()
	{
		GoThroughMenu()
		If not WaitForBattle()
			Return
	}
	Loop ; repeats <=8 times, RunSlots() returns false after the eighth battle or if we die
	{
		If Stop 
			Return
		If not Battle_Attack()
			Return
		If not RunSlots()
			Break
	}
	If not EndOfBattle()
		Return
}

+F1::
global Stop := 0
Loop
{
	; this one quits after first battle - the goal is to get tissues
	If Stop
		Return
	GoThroughMenu()
	If not WaitForBattle()
		Return
	If not Battle_Attack()
		Return
	If not QuitBattleSquare()
		Return
	If not EndOfBattle()
		Return
}

; Hotkeys in all scripts
; F9 key shows a colorpicker
F9::ColorPicker()

; Esc stops most actions
Esc::Stop=1

#IfWinActive

^r::Reload  ; ctrl-r, reloads the current script
