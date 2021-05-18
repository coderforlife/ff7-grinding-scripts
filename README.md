# FF7 Automatic Playing Scripts

These are scripts to automate several portions of the FF7 game to assist in grinding or getting "perfect" games. Most of these scripts are AutoHotkey (AHK) scripts. The AHK v1.1 program can be downloaded from <https://github.com/Lexikos/AutoHotkey_L/releases>. You don't need to fully install the program, you can use a program like 7-zip to extract the AutoHotkeyU64.exe (or similar) program from the installer.

## Settings/Utilities: util.ahk

All other AHK scripts include this file. This file defines the general settings and utility functions. If you have changed your key bindings from the default, you need to edit the beginning of this file.

Additionally, this file defines settings for determining if the game is currently in a battle or not. This is accomplished by checking the color of a specific pixel. The location (`PxCheckX`, `PxCheckY`) and color (`PxCheckColorBattle`) of this pixel changes based on the resolution of the game so you will have to adjust this if you don't use windowed mode with a resolution of 1024x768. To discover a pixel to use, use the `F9` key during a battle (you can pause the game, it doesn't effect the pixel) and choose a pixel in the lower-right-hand corner of the screen (that is never covered during battle). Pressing `Esc` stops the color-picker (and most other things).

Other AHK scripts include some specific settings as well, see below for more details.

All scripts have the `F9` colorpicker, `Esc` stop action, and `Ctrl+R` script reload hotkeys.

## Auto-fighting: autofight.ahk

No settings besides those in util.ahk (it heavily uses the battle pixel check from that file though).

Provides the following hotkeys:

- `F1`: causes the player to walk left and right continuously. Once in a battle, keeps holding Ok/Circle/X to continuously attack. Once battle is over, it goes back to moving left and right.
- `F2`: like `F1` except the player walks up and down.
- `F3`: like `F1` except causes the player to go in a tight circle on the world map by holding down PgUp/L1 + Left. This has strange behavior when used not on the world map.
- `Shift+F1`, `Shift+F2`, `Shift+F3`: like `F1`, `F2`, and `F3` except that the PgUp+PgDn (L1+R1) are held to attempt to escape. It also returns to moving faster (since it assumes there should be no post-battle screen).

Use `Esc` to stop any of these.

None of these cause the player to run, but the enemy encounter rate (per time) is the same when [running or walking](https://gamefaqs.gamespot.com/boards/197341-final-fantasy-vii/56797136).

To make the most of this you should have [Enemy Lure materia](https://finalfantasy.fandom.com/wiki/Enemy_Lure_(Final_Fantasy_VII)) (2x level 2+ and a level 1 which provides the maximum benefit of 200% in the field and 400% on the world map).

By pairing [Sneak Attack materia](https://finalfantasy.fandom.com/wiki/Sneak_Attack_(Final_Fantasy_VII)) with [Steal](https://finalfantasy.fandom.com/wiki/Steal_(Final_Fantasy_VII_ability)) or [Morph](https://finalfantasy.fandom.com/wiki/Morph_(Final_Fantasy_VII)) the player can grind for non-dropped items. For morphing, it is best used on Yuffie with the [Conformer](https://finalfantasy.fandom.com/wiki/Conformer_(Final_Fantasy_VII))). Combining with a [Mega All materia](https://finalfantasy.fandom.com/wiki/Mega_All) items can be stolen or all enemies can be morphed at once.

By using [Sneak Attack materia](https://finalfantasy.fandom.com/wiki/Sneak_Attack_(Final_Fantasy_VII)) paired with a level 1 [Exit materia](https://finalfantasy.fandom.com/wiki/Exit_(Final_Fantasy_VII)) can be used to gain escapes for maxing out the [Chocobuckle enemy skill](https://finalfantasy.fandom.com/wiki/Chocobuckle_(Final_Fantasy_VII)). This may allow escaping from battles faster with `Shift+F1`, `Shift+F2`, `Shift+F3`.

## [Battle Square](https://finalfantasy.fandom.com/wiki/Battle_Square): battle-square.ahk

Settings besides those in util.ahk: (also heavily uses the battle pixel check from that file as well)

- `PxCheckColorInbetweenBattle`: the color of the pixel at `PxCheckX`, `PxCheckY` (from util.ahk) when seeing the in-between battle screen (the one that says "GREAT!", "Do you want to continue?" and the slots).
- `SlotsWait`: the number of miliseconds to wait for the slots to spin, may change which slots come up more often, but I don't really know if this has any noticeable effect

Provides the following hotkeys:

- `F1`: usable if you are already in a battle-square battle or standing at the counter facing the lady ready to start. Runs through getting the game started (talking to the lady), then through all of the rounds of the battle including the slots, accepting the prizes at the end, and then walks back up to the counter and starts another game. If you are watching the game and need to interrupt it, press `Esc`, do you actions, and restart this with `F1` (but only if still in a battle or at the counter).
- `Shift+F1`: like `F1` except that the game is quit after the first battle. Useful for getting Tissues.

Use `Esc` to stop any of these.

This script assumes that you have the special battle already, tons of GP, and are fully equipped to just continuously attack. You may lose sometimes and win other times, but after about a day you will likely be full on all of the special (useless) prizes.

Bonus: this script changes the AHK tray icon based on where it is in the script.

## [Wonder Square: Basketball](https://finalfantasy.fandom.com/wiki/Wonder_Square#Basketball_Game): basketball.ahk

One setting:

- `ShootHold`: the number of milliseconds to hold the basketball before releasing. Should be approximately 450 ms however I have always found it to be shorter, sometimes even as low as 388 for some setups.

Provides the following hotkeys:

- `L`: shoots the basketball once if already in the game
- `K`: shoots the basketball ten times if already in the game (one round, not including double-or-nothing)
- `J`: plays one entire basketball game (four rounds of 10 shots plus double-or-nothings), should be standing at the machine but not yet playing the game. Costs 200 Gil, nets 300 GP, and takes about 5 minutes.
- `U`: plays ten entire games (takes about 50 minutes)

Use `Esc` to stop most of these.

Bugs: sometimes the shoot-10 (and thus the entire game) gets off and things go awry

Bonus: this script changes the AHK tray icon based on where it is in the script.

## [Wonder Square: Wonder Catcher](https://finalfantasy.fandom.com/wiki/Wonder_Square#Wonder_Catcher): wonder-catcher.ahk

Settings:

- `RightMachine`: set to `True` if using the right machine (requires different keys to approach), or `False` to use the left machine
- `DetectPrize`: set to `True` to have the script detect and tally which prizes are obtained. This was used to create the table on the Fandom Wiki page. This does require a some extra work, see below.

Provides the following hotkeys:

- `Alt-G`: Go! Plays the game continuously. You must already be standing close to the machine. Use `Esc` to stop.
- `Alt-S`: Show prize counts (if using `DetectPrize`)
- `Alt-R`: Reset prize counts (if using `DetectPrize`)

The left machine gives megalixirs and 0.7767 GP / game on average.  
The right machine gives elixirs and 0.8196 GP / game on average.

The prize detection requires the images in the wonder-catcher folder with the names "potion.png", "nothing.png", "1gp.png", "3gp.png", "ether.png", "pd.png", "megalixir.png", "elixir.png", "80gp.png", and "100gp.png". Images can be missing or incorrect, in which case the script will ask you to add the image when it is needed. You can use `Win+S` to make a screen shot, crop out just the name, and save it to the folder. At that point the script will continue until it finds the next issue. If you want to go really far, the images support the color #FF00FF as transparent. The provided images are for 1024x768. If the resolution changes dramatically, the numbers given to the `ImageSearch` may also need to be adjusted.

## Chocobo Square

Coming soon: a script to go through Chocobo races automatically to get very rare prizes.

## Speed Square

Coming soon: a script to go through the Speed Square game to get the odd prizes there.
