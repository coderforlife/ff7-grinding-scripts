; Wonder Catcher Game Auto-Player
; Left Machine:  0.7767 GP / game, has megalixers
; Right Machine: 0.8196 GP / game, has elixers
; Change RightMachine variable for which machine is being played

; If using DetectPrize := True
; The images need to created for the specific game resolution, different versions are for different resolutions, the current set is for 1024x768 windows
; When the program is unable to figure out the image it asks you to update the set of images (and doesn't require a restart of the script)
; The images can use backgrounds with color #FF00FF which is treated as transparent

; TODO: auto-detect resolution https://autohotkey.com/board/topic/55072-get-window-size-in-pixels/

global RightMachine := True
global DetectPrize := True

#Include %A_ScriptDir%
#Include util.ahk


global display := ["Potions", "Nothing", "1 GP", "3 GP", "Ether (actually PD)", "PD (actually ether)", "Megalixir", "Elixir", "80 GP", "100 GP"]
global names := ["potion", "nothing", "1gp", "3gp", "ether", "pd", "megalixir", "elixir", "80gp", "100gp"]
global values := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]


#IfWinActive FINAL FANTASY VII
!r:: ; Reset prize counts (alt-r)
values := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Return

!s:: ; Show prize counts (alt-s)
if (DetectPrize) {
	total := 0
	For i, x In values
		total += x
	s := ""
	For i, x In values
		s .= Format("{:s}:`t{:d}`t{:.2f}%`n", display[i], x, x*100/total)
	s .= Format("Total:`t{:d}", total)
	MsgBox %s%
}
Return

!g:: ; Go! (alt-g)
global Stop := 0
Loop
{
	If Stop
		Break

	; Approach and play the game
	If (RightMachine) {
		Send {%LeftKey% Down}
		Sleep 20
	}
	Send {%UpKey% Down}
	Sleep 20
	PressOk(20)
	If (RightMachine) {
		Send {%LeftKey% Up}
		Sleep 20
	}
	Send {%UpKey% Up}
	Sleep 800
	PressOk(800)
	PressOk(4750)

	; Find out what prize we got
	if (DetectPrize)
	{
		found := 0
		tries := 0
		Loop
		{
			For i, name In names
			{
				ImageSearch, FoundX, FoundY, 250,30, 900,250, *TransFF00FF wonder-catcher\%name%.png
				If ErrorLevel = 0
				{
					; found!
					found := 1
					values[i] += 1
					Break
				}
				; ErrorLevel = 1 -> cannot find image
				; ErrorLevel = 2 -> cannot load image
			}
			If found
				Break
			If Stop
				Return
			If (tries > 5)
			{
				MsgBox Did not find which prize, please update the images and press Ok
				tries = 0
			}
			Sleep 200
			tries += 1
		}
	}

	; Close prize box
	PressOk(1750)
}
Return

; Hotkeys in all scripts
; F9 key shows a colorpicker
F9::ColorPicker()

; Esc stops most actions
Esc::Stop=1

#IfWinActive

^r::Reload  ; ctrl-r, reloads the current script
