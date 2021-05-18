#Include %A_ScriptDir%
#Include util.ahk

; Walk back and forth until we get into a battle
; Out initial direction is random since we are trying not to have a left or right bias
WalkBackAndForth()
{
	If Rand(0,1)
		dir = %LeftKey%
	Else
		dir = %RightKey%
	Loop
	{
		Send {%dir% Down}
		Send {%OkKey% Down} ; just in case we are stuck in post-battle screen
		Sleep 250
		Send {%OkKey% Up}
		Send {%dir% Up}
		Sleep 2
		If (Stop)
			Return 0
		If IsInBattle()
			Break
		If (dir = "Left")
			dir = %RightKey%
		Else
			dir = %LeftKey%
	}
	Return 1
}

; Walk up and down until we get into a battle
; Out initial direction is random since we are trying not to have a left or right bias
WalkUpAndDown()
{
	If Rand(0,1)
		dir = %UpKey%
	Else
		dir = %DownKey%
	Loop
	{
		Send {%dir% Down}
		Send {%OkKey% Down} ; just in case we are stuck in post-battle screen
		Sleep 250
		Send {%OkKey% Up}
		Send {%dir% Up}
		Sleep 2
		If (Stop)
			Return 0
		If IsInBattle()
			Break
		If (dir = "Up")
			dir = %DownKey%
		Else
			dir = %UpKey%
	}
	Return 1
}

; Walk in a circle on the world map until we get into a battle
WalkInCircle_WM()
{
	Send {%PgUpKey% Down} ; L1
	Send {%LeftKey% Down}
	Sleep 250
	Loop
	{
		If (Stop)
		{
			Send {%LeftKey% Up}
			Send {%PgUpKey% Up}
			Return 0
		}
		Send {%OkKey% Down} ; just in case we are stuck in post-battle screen
		Sleep 25
		Send {%OkKey% Up}
		If IsInBattle()
			Break
		Send {%LeftKey% Down}
	}
	Send {%LeftKey% Up}
	Send {%PgUpKey% Up}
	Return 1
}

; Continously tell everyone to attack
Battle_Attack()
{
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

; Continously tell everyone to escape
Battle_Escape()
{
	Send {%PgUpKey% Down}
	Sleep 20
	Send {%PgDnKey% Down}
	Sleep 200
	Loop
	{
		If (Stop)
		{
			Send {%PgUpKey% Up}
			Sleep 20
			Send {%PgDnKey% Up}
			Return 0
		}
		PressOk(10)
		If not IsInBattle()
			Break
	}
	Send {%PgUpKey% Up}
	Sleep 20
	Send {%PgDnKey% Up}
	Return 1
}

; Click through after battle summary
FinishBattle()
{
	Sleep 2000
	Loop 10 ; in case we never see black, give up after 8 iterations (~2.8 secs)
	{
		If (Stop)
			Return 0
		PressOk()
		PixelGetColor, color, %PxCheckX%, %PxCheckY%, RGB
		If (color = 0x000000)
			Break
	}
	Return 1
}


#IfWinActive FINAL FANTASY VII
F1::
global Stop := 0
Loop
{
	If Stop 
		Return
	If not WalkBackAndForth()
		Return
	If not Battle_Attack()
		Return
	If not FinishBattle()
		Return
}

F2::
global Stop := 0
Loop
{
	If Stop 
		Return
	If not WalkUpAndDown()
		Return
	If not Battle_Attack()
		Return
	If not FinishBattle()
		Return
}

F3::
global Stop := 0
Loop
{
	If Stop
		Return
	If not WalkInCircle_WM()
		Return
	If not Battle_Attack()
		Return
	If not FinishBattle()
		Return
}

+F1::
global Stop := 0
Loop
{
	If Stop
		Return
	If not WalkBackAndForth()
		Return
	If not Battle_Escape()
		Return
}

+F2::
global Stop := 0
Loop
{
	If Stop
		Return
	If not WalkUpAndDown()
		Return
	If not Battle_Escape()
		Return
}

+F3::
global Stop := 0
Loop
{
	If Stop
		Return
	If not WalkInCircle_WM()
		Return
	If not Battle_Escape()
		Return
}


; Hotkeys in all scripts
; F9 key shows a colorpicker
F9::ColorPicker()

; Esc stops most actions
Esc::Stop=1

#IfWinActive

^r::Reload  ; ctrl-r, reloads the current script
