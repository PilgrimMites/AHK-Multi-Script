#NoEnv
#Requires AutoHotkey v1.1.33.10
FileEncoding, UTF-16
#MaxThreadsPerHotkey 4
#SingleInstance Force
#KeyHistory 0
#MaxMem 4095
#MaxThreads 255
#MaxThreadsBuffer on
#InstallMouseHook
#InstallKeybdHook
Process, Priority, , R
ListLines Off
SetWorkingDir %A_ScriptDir%
SetKeyDelay,-1
SetControlDelay, -1
SetBatchLines,-1
SetTitleMatchMode, 2  
SetTitleMatchMode, Fast

RunAsAdmin()

Global ScreenWidth := A_ScreenWidth, ScreenHeight := A_ScreenHeight, CurrentTime := A_TickCount, Center_X := ScreenWidth // 2+1, Center_Y := ScreenHeight // 2+1

Global sens := 1.8, Zoomsens := 0.75, reaction_min := 25, reaction_max := 100, RFL := 50, RFH := 80, Speed:= 1

Global CrossHairTrans := 220, SelectedCrosshair := "+",CrossHairSize := 20, CrossHairColor:= "BA000"

Global Magnifier := False, Zoom := 1, Size := 30, Delay := 10, MagnifierTrans := 220

Global key_AK := "Numpad1", Key_M4A1 := "Numpad2", Key_M4A4 := "Numpad3", Key_Famas := "Numpad4", Key_Galil := "Numpad5", Key_UMP := "Numpad6", Key_AUG := "Numpad7", Key_SG := "Numpad8", Key_UniversalRCS:= "Numpad9", Key_RCoff := "Numpad0", key_180 := "v", Key_shoot := "LButton", Key_Zoom := "Alt", Key_RapidFire := "XButton1", Key_PixelBot := "XButton2", Key_BHOP := "Space", Key_Duck := "c", Key_Safety:= "n"

Global CurrentPattern,humanizer,waitdivider,humanizer88,waitdivider88

Global GuiVisible := False,BHOPT := False, RapidFireT := False, TriggerBotT := False, TurnAroundT := False, AcceptT := False, CrosshairT := False, DuckT := False, RCSNotification := True, TriggerBotNotification := True, RecoilSafety:= False, UniversalRCS := False, Legit :=  False, Perfect := False, ScrollWheel := False, Pause := False, SpeechT := True

Global WhichToolTip := 20, ProgressRange := 100

e1 :=  Chr(84) . Chr(72) . Chr(73) . Chr(83) . Chr(32) . Chr(83) . Chr(82) . Chr(73) . Chr(80) . Chr(84) . Chr(32) . Chr(73) . Chr(83) . Chr(32) . Chr(70) . Chr(82) . Chr(69) . Chr(69)

Version := "V1.6.10"
/*
Note: Making this script more universal has become my latest goal. I still plan on improving RCS and making it shorter, with a new function. This will shorten this script about 3k lines.
Note: I have been playing with default keys to best fit without having to rebind NVIDIA or IN-Game settings
Removed: PrankMsgBox From being used but is still in source.
Removed: Useless Code and double code was put into subroutes or functions
Added Menu tray options | Toggle Menu|Magnifier|CrossHair|ElevateProcess|ReloadScript|PauseScript|HideScript|ExitScript
Added Subroutes File
Added GunSelection Function
Added Magnifing Glass hotkeys for zoom IN/OUT
Added Toggle Speech
Added Magnifier Transparency slider
Updated ALL RECOIL ACCURACY IMPROVED (This took awhile)
Updated Saving/Reading Functions to now create settings.ini if not found
Updated Magnifier | to match CrossHair Format | Hotkey no longer needs to close GUI to prevent bug | & CrossHair not Staying running or closing under certain conditions | Zoom in/out tooltip to appear and dissapear 
Updated Magnifier to now be a circle and not square(I may give option for both later) | now extremely smooth with 0 lag (Results may very with CPU/Timer) | Default Zoom 1.5 -> 1
Updated Main Loop, So now you can use PixelBot, RapidFire, BHOP, Universal RCS With other games | Will now Empty Working Set clearing memory
Updated Error handling for Menu tray and all SubRoutes
Updated Handling of Main GUI to work with hotkey and Menu tray
Updated UnHook Handling and when/how its applied
Updated PrankMsgBox to be more universal/funnier
Updated All MsgBox, Made them look nicer and Added timers (Not on save msgbox's)
Updated GUI QOL x3
Updated ToolTip Function to have timer
Updated All ToolTips
Updated Main Loop bug with new Universal RCS (everything after wasnt working) | reduced cpu usage
Updated Tooltip Function bug with timer
Updated Save function (removed saving gun on key press)
Updated Turn Around to use new function
Updated Speak Function to only work with All windows and languages (Had to rework twice)
Updated How to For AutoEXEC.CFG for cs2
Updated Default Hotkeys for GUI | Auto Accept | Magnifier Toggle & zooming in/out | Crosshair Toggle | Recoil Safety 
Updated Magnifier Zoom In/Out to no longer get stuck and properly display correct tooltip.
Updated Modifier Variable to be more accurate
Updated GetKeyStates error checking (Preventing bugs & spamming) | Sleep 100 --> 250
Updated Reload hotkey causing multiple instances to start
Updated Agent Evee Download
Updated Download Function to display progress bar. (Just for visuals)
Updated BHOP | Legit better humanized | Perfect reduced CPU usage | ScrollWheel msgbox/info/clipboard | Error Checking
Updated Speech and saving/Reading Function
Updated Save buttons and thier saving method & removed unnecessary saves
Updated Crosshair & Magnifier to destroy if GUI is closed and not saved
Updated Crosshair & Magnifier when using hotkey for crosshair and gui Check box doesnt change
Updated Menu tray to have check marks
Updated Transparency Sliders to update on slide but not save
Updated Start sequence error checking
Updated UniversalRCSNotification & PixelBotNotification Subroute
Updated universalRCS check box, notifaction, hotkey, not syncing WITH recoil off.
Updated Magnifier to never go uncder saved zoom / Over * 31
Updated MainMenu tray menu check/uncheck to work more universal
Updated Save Recoil Button improper saving
Updated Universal recoil method and pattern to me human like
*/

VarSetCapacity(INPUT, 28)
VarSetCapacity(MOUSEINPUT, 24)
VarSetCapacity(KEYBDINPUT, 16)
VarSetCapacity(HARDWAREINPUT, 8)
VarSetCapacity(INPUT_union, 24)

StartSequence()
#Include Subroutes.AHK
#Include Zoom.AHK
#Include Functions.AHK
#Include Crosshair.AHK
Return

~*+F1::Goto, ToggleGUI

~*+F2::
GoSub MagnifierToggler
Return

~*+F3::
Gosub, CrosshairToggler
Return

~*+F4::ToggleScript(AcceptT, "Accept", 50, 600, 1600)
return

MainLoop() { 
	loop {
	Sleep, 2
	DllCall("psapi.dll\EmptyWorkingSet", "UInt", -1)
	Sleep, 2
	while (CurrentPattern = "UniversalRCS" && GetKeyState(key_shoot, "P")) {
		modifier := 2.52 / sens ; 2.52
		humanizer := 6
		ScaledSpeed:= (Speed/modifier)
		x := TRandom(-.3,.3,Random(0,2)) + Rand((speed * TRandom(.0,1.850)))* modifier
		y := ScaledSpeed * humanizer / modifier
		if !GetKeyState(key_shoot, "P") {
			break
		}
		
		MoveMouse(x,y)
	}
	While (TriggerBotT && GetKeyState(Key_PixelBot, "P"))  {
	PixelGetColor, colorx, %Center_X%, %Center_Y%, Fast . A_IsCritical
	PixelSearch, , , %Center_X%, %Center_Y%, %Center_X%, %Center_Y%, %colorx%, 2, Fast . A_IsCritical
		if (ErrorLevel = 1) {
			if (colorx != "0xFFFFFF") {
				Sleep, Random(reaction_min,reaction_max)
				Click()
				Sleep, 250
			}
		}
	}
	While (RapidFireT && GetKeyState(Key_RapidFire, "P"))  {
	sleep, PilgrimMites(RFL,RFH)
	Click()
	}
	While (BHOPT && GetKeyState(Key_BHOP, "D"))  {
		if (ScrollWheel=1) {
			Sleep, 5
			MouseClick, WheelDown
			Sleep, 5
			MouseClick, WheelUp
			Sleep, 5
		} ELSE {
			
		}
		if (Perfect=1)  {
			Sleep,15
			Send, {Space Down}
			Sleep,15
			Send, {Space Up}
			Sleep,15
		} ELSE {
		}
		if (Legit=1) {
			Sleep,15
			Send, {Space Down}
			Sleep, Random(30,70)
			Send, {Space Up}
			Sleep, 15
		} ELSE {
		}
		if !GetKeyState(Key_BHOP, "P") {
		break
		}
	}
	if GetKeyState(key_RCoff, "P")  {
		if (CurrentPattern != "Recoil OFF") {
			GunSelection("Recoil OFF", 0, 0,"Recoil | Off" )

			if (UniversalRCS) {
				UniversalRCS:= FALSE
				GuiControl,, Universal RCS, % (UniversalRCS ? "1" : "0")
			}		
		}
	Sleep, 250
	}
	if GetKeyState(key_UniversalRCS, "P")  {
		if (CurrentPattern != "UniversalRCS") {
			UniversalRCS:=!UniversalRCS
			GuiControl,, Universal RCS, % (UniversalRCS ? "1" : "0")
			GunSelection("UniversalRCS", 0, 0,"Universal R C S" )
		}
	}
		IfWinActive, ahk_exe CS2.exe
		{
		if GetKeyState(key_AK, "P")  { ; 90%
			if (CurrentPattern != "AK") {
				GunSelection("AK", 3.8, 4.7,"AK | On" )
			}
		Sleep, 250
		}
		if GetKeyState(key_M4A1, "P") { ; 99%
			if (CurrentPattern != "M4A1") {
				GunSelection("M4A1", 4.2, 4.17,"M4A1 | On" )
			}
		Sleep, 250
		}
		if GetKeyState(key_M4A4, "P") { ; 90% 
			if (CurrentPattern != "M4A4") {
				GunSelection("M4A4", 3.72, 4.17,"M4A4 | On" )
				humanizer88 := 3.7, waitdivider88 := 3.9
			}
		Sleep, 250
		}
		if GetKeyState(key_Famas, "P") { ; 85%
			if (CurrentPattern != "FAMAS") {
				GunSelection("FAMAS", 3.75, 4.10,"Famas | On" )
			}
		Sleep, 250
		}
		if GetKeyState(key_Galil, "P") { ; 99%
			if (CurrentPattern != "GALIL") {
				GunSelection("GALIL", 3.95, 4.7,"Galil | On" )
			}
		Sleep, 250
		}
		if GetKeyState(key_UMP, "P") { ; 90%
			if (CurrentPattern != "UMP") {
				GunSelection("UMP", 4.7, 4.27,"UMP | On" )
			}
		Sleep, 250
		}
		if GetKeyState(key_AUG, "P") { ; 95% | Zoom  95%
			if (CurrentPattern != "AUG") {
				GunSelection("AUG", 4.2, 4.7,"AUG | On" )
			}
		Sleep, 250
		}
		if GetKeyState(key_SG, "P") { ; 80% | Zoom  90%
			if (CurrentPattern != "SG") {
				GunSelection("SG", 4.2, 4.7,"SG | On" )
			}
		Sleep, 250
		}
			While (TurnAroundT && GetKeyState(Key_180, "P"))  {
			modifier := 2.52/sens
				Random, chance, 0.0, 1.0
				PosNeg := chance <= 0.49 ? -1 : 1
					MoveMouse(PosNeg * 225 * modifier, Rand(1)*PosNeg) ;3249
					ModifiedMove(PosNeg * 432 * modifier,0,7)
					Sleep, Random(250,300)
			}
			While (DuckT && GetKeyState(Key_Duck, "P"))  {
				ModifiedMove(Rand(1.0),-10,6)
				KeyWait, %key_Duck%, L
				ModifiedMove(Rand(1.0),10,6)
			}
		If (RecoilSafety) {
			If GetKeyState(Key_Safety, "P") {
				GoSub RCS
			}
			} Else {
				GoSub RCS 
			}
		} 
	Sleep, 2
	} ; Loop
Return	
} ; Main Loop Function

RCS:
While GetKeyState(key_shoot, "P")  {
modifier := PilgrimMites(2.520,2.521) / sens ; 2.52
if CurrentPattern = AK
{
loop
{
sleep 50
if !GetKeyState(key_shoot, "P")
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot, "P")
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 19/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 19/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 19/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 19/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot, "P")
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 29/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 29/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 29/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 29/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot, "P")
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 31/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 31/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 31/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 31/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot, "P")
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier, "UInt", 31/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier, "UInt", 31/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier, "UInt", 31/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier, "UInt", 31/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot, "P")
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 8/humanizer*modifier, "UInt", 28/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 8/humanizer*modifier, "UInt", 28/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 8/humanizer*modifier, "UInt", 28/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 8/humanizer*modifier, "UInt", 28/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot, "P")
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier, "UInt", 21/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier, "UInt", 21/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier, "UInt", 21/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier, "UInt", 21/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot, "P")
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -17/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -17/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -17/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -17/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot, "P")
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -42/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -42/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -42/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -42/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -21/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -21/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -21/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -21/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 12/humanizer*modifier, "UInt", 11/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 12/humanizer*modifier, "UInt", 11/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 12/humanizer*modifier, "UInt", 11/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 12/humanizer*modifier, "UInt", 11/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -15/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -15/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -15/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -15/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -26/humanizer*modifier, "UInt", -8/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -26/humanizer*modifier, "UInt", -8/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -26/humanizer*modifier, "UInt", -8/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -26/humanizer*modifier, "UInt", -8/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 40/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 40/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 40/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 40/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 19/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 19/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 19/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 19/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 27/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 27/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 27/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 27/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 33/humanizer*modifier, "UInt", -10/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 33/humanizer*modifier, "UInt", -10/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 33/humanizer*modifier, "UInt", -10/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 33/humanizer*modifier, "UInt", -10/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -21/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -21/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -21/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -21/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 7/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 7/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 7/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 7/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier, "UInt", 9/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier, "UInt", 9/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier, "UInt", 9/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier, "UInt", 9/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 19/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 19/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 19/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 19/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -20/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -20/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -20/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -20/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -33/humanizer*modifier, "UInt", -4/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -33/humanizer*modifier, "UInt", -4/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -33/humanizer*modifier, "UInt", -4/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -33/humanizer*modifier, "UInt", -4/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -45/humanizer*modifier, "UInt", -21/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -45/humanizer*modifier, "UInt", -21/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -45/humanizer*modifier, "UInt", -21/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -45/humanizer*modifier, "UInt", -21/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -14/humanizer*modifier, "UInt", 1/humanizer*modifier)
if !GetKeyState(key_shoot, "P")
{
break
}
DllCall("user32.dll\mouse_event", uint, 4, int, 0, int, 0, uint, 0, int, 0)
sleep 1000
}
}

else if CurrentPattern = M4A1
{
loop
{

sleep 15
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 1/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 1/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 1/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 1/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 14/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 14/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 14/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 14/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 18/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 18/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 18/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 18/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier, "UInt", 21/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier, "UInt", 21/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier, "UInt", 21/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier, "UInt", 21/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier-1, "UInt", 20/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier-1, "UInt", 20/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier-1, "UInt", 20/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 20/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 14/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 14/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 14/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 14/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 8/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 8/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 8/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 8/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier+1, "UInt", 5/humanizer*modifier+1)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -14/humanizer*modifier-1, "UInt", 5/humanizer*modifier+1)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -14/humanizer*modifier-1, "UInt", 5/humanizer*modifier+1)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -14/humanizer*modifier, "UInt", 5/humanizer*modifier+1)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -14/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -25/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -25/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -25/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -25/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -19/humanizer*modifier-1, "UInt", 0/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -19/humanizer*modifier-1, "UInt", 0/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -19/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -19/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -22/humanizer*modifier+2, "UInt", -3/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -22/humanizer*modifier+2, "UInt", -3/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -22/humanizer*modifier+1, "UInt", -3/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -22/humanizer*modifier+1, "UInt", -3/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 1/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 1/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 1/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 1/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 8/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 8/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 8/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 8/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -11/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -11/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -11/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -11/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 3/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 3/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 3/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 3/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", uint, 4, int, 0, int, 0, uint, 0, int, 0)
sleep 1000
}
}

else if CurrentPattern = M4A4
{
loop
{

sleep 15
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 2/humanizer88*modifier, "UInt", 7/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 2/humanizer88*modifier, "UInt", 7/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 2/humanizer88*modifier, "UInt", 7/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 2/humanizer88*modifier, "UInt", 7/humanizer88*modifier)
sleep 88/waitdivider88
;ShowToolTip(2, , , 1, 5)
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 9/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 9/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 9/humanizer*modifier)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 9/humanizer*modifier)
sleep 99/waitdivider
;ShowToolTip(3, , , 1, 5)
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier, "UInt", 16/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier, "UInt", 16/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier, "UInt", 16/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier, "UInt", 16/humanizer*modifier)
sleep 87/waitdivider
;ShowToolTip(4, , , 1, 5)
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 21/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 21/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 21/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 21/humanizer*modifier)
sleep 87/waitdivider
;ShowToolTip(5, , , 1, 5)
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 23/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 23/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 23/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 23/humanizer*modifier)
sleep 87/waitdivider
;ShowToolTip(6, , , 1, 5)
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", 27/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", 27/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", 27/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", 27/humanizer*modifier)
sleep 87/waitdivider
;ShowToolTip(7, , , 1, 5)
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer88*modifier, "UInt", 15/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer88*modifier, "UInt", 15/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer88*modifier, "UInt", 15/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer88*modifier, "UInt", 15/humanizer88*modifier)
sleep 88/waitdivider88
;ShowToolTip(8, , , 1, 5)
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 11/humanizer88*modifier, "UInt", 13/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 11/humanizer88*modifier, "UInt", 13/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 11/humanizer88*modifier, "UInt", 13/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 11/humanizer88*modifier, "UInt", 13/humanizer88*modifier)
sleep 88/waitdivider88
;ShowToolTip(9, , , 1, 5)
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 22/humanizer88*modifier, "UInt", 5/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 22/humanizer88*modifier, "UInt", 5/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 22/humanizer88*modifier, "UInt", 5/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 22/humanizer88*modifier, "UInt", 5/humanizer88*modifier)
sleep 88/waitdivider88
;ShowToolTip(10, , , 1, 5)
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -24/humanizer88*modifier, "UInt", 11/humanizer88*modifier) ;10
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -24/humanizer88*modifier, "UInt", 11/humanizer88*modifier)
sleep 88/waitdivider88d
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -24/humanizer88*modifier, "UInt", 11/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -24/humanizer88*modifier, "UInt", 11/humanizer88*modifier)
sleep 88/waitdivider88
;ShowToolTip(11, , , 1, 5)
if !GetKeyState(key_shoot, "P")
{

break
}

DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -24/humanizer88*modifier, "UInt", 6/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -24/humanizer88*modifier, "UInt", 6/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -24/humanizer88*modifier, "UInt", 6/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -24/humanizer88*modifier, "UInt", 6/humanizer88*modifier)
sleep 88/waitdivider88
;ShowToolTip(12, , , 1, 5)
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -30/humanizer88*modifier, "UInt", -4/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -30/humanizer88*modifier, "UInt", -4/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -30/humanizer88*modifier, "UInt", -4/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -30/humanizer88*modifier, "UInt", -4/humanizer88*modifier)
sleep 88/waitdivider88
;ShowToolTip(13, , , 1, 5)
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -24/humanizer88*modifier, "UInt", 0/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -24/humanizer88*modifier, "UInt", 0/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -24/humanizer88*modifier, "UInt", 0/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -24/humanizer88*modifier, "UInt", 0/humanizer88*modifier)
sleep 88/waitdivider88
;ShowToolTip(14, , , 1, 5)
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -25/humanizer88*modifier, "UInt", -6/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -25/humanizer88*modifier, "UInt", -6/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -25/humanizer88*modifier, "UInt", -6/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -25/humanizer88*modifier, "UInt", -6/humanizer88*modifier)
sleep 88/waitdivider88
;ShowToolTip(15, , , 1, 5)
if !GetKeyState(key_shoot, "P")
{

break
}

DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 10/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 10/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 10/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 10/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 87/waitdivider
;ShowToolTip(16, , , 1, 5)
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 87/waitdivider
;ShowToolTip(17, , , 1, 5)
if !GetKeyState(key_shoot, "P")
{

break
}
;line15
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -11/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -11/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -11/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -11/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 87/waitdivider
;ShowToolTip(18, , , 1, 5)
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -13/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -13/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -13/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -13/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 87/waitdivider
;ShowToolTip(19, , , 1, 5)
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 24/humanizer88*modifier, "UInt", 2/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 24/humanizer88*modifier, "UInt", 2/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 24/humanizer88*modifier, "UInt", 2/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 24/humanizer88*modifier, "UInt", 2/humanizer88*modifier)
sleep 88/waitdivider88
;ShowToolTip(20, , , 1, 5)
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 33/humanizer88*modifier, "UInt", -1/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 33/humanizer88*modifier, "UInt", -1/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 33/humanizer88*modifier, "UInt", -1/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 33/humanizer88*modifier, "UInt", -1/humanizer88*modifier)
sleep 88/waitdivider88
;ShowToolTip(21, , , 1, 5)
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 24/humanizer88*modifier, "UInt", 6/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 24/humanizer88*modifier, "UInt", 6/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 24/humanizer88*modifier, "UInt", 6/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 24/humanizer88*modifier, "UInt", 6/humanizer88*modifier)
sleep 88/waitdivider88
;ShowToolTip(22, , , 1, 5)
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 27/humanizer88*modifier, "UInt", 3/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 27/humanizer88*modifier, "UInt", 3/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 27/humanizer88*modifier, "UInt", 3/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 27/humanizer88*modifier, "UInt", 3/humanizer88*modifier)
sleep 88/waitdivider88
;ShowToolTip(23, , , 1, 5)
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 10/humanizer88*modifier, "UInt", 2/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 10/humanizer88*modifier, "UInt", 2/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 10/humanizer88*modifier, "UInt", 2/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 10/humanizer88*modifier, "UInt", 2/humanizer88*modifier)
sleep 88/waitdivider88
;ShowToolTip(24, , , 1, 5)
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -11/humanizer88*modifier, "UInt", 0/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -11/humanizer88*modifier, "UInt", 0/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -11/humanizer88*modifier, "UInt", 0/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -11/humanizer88*modifier, "UInt", 0/humanizer88*modifier)
sleep 88/waitdivider88
;ShowToolTip(25, , , 1, 5)
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -15/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -15/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -15/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -15/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 87/waitdivider
;ShowToolTip(26, , , 1, 5)
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 87/waitdivider
;ShowToolTip(27, , , 1, 5)
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 87/waitdivider
;ShowToolTip(28, , , 1, 5)
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 3/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 3/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 3/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 3/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 87/waitdivider
;ShowToolTip(29, , , 1, 5)
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 87/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 87/waitdivider
;ShowToolTip(30, , , 1, 5)
if !GetKeyState(key_shoot, "P")
{

break
}
DllCall("user32.dll\mouse_event", uint, 4, int, 0, int, 0, uint, 0, int, 0)
sleep 1000
}
}

else if CurrentPattern = FAMAS
{
loop
{

sleep 30
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 1/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 1/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 1/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 1/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 17/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 17/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 17/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 17/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 20/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 20/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 20/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 20/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 18/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 18/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 18/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 18/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 16/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 16/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 16/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 16/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -16/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -16/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -16/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -16/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
} ; # 10
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -20/humanizer*modifier, "UInt", 8/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -20/humanizer*modifier, "UInt", 8/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -20/humanizer*modifier, "UInt", 8/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -20/humanizer*modifier, "UInt", 8/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -16/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -16/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -16/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -16/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -13/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -13/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -13/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -13/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 87/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 23/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 23/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 23/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 23/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 12/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 12/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 12/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 12/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 20/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 20/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 20/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 20/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 3/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 3/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 3/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 3/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 80/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -25/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -25/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -25/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -25/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 80/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 84/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 11/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 11/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 11/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 11/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 80/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", -7/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", -7/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", -7/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", -7/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", -10/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", -10/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", -10/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", -10/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", uint, 4, int, 0, int, 0, uint, 0, int, 0)
sleep 1000
}
}

else if CurrentPattern = GALIL
{
loop
{

sleep 10
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 4/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 4/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 4/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier, "UInt", 5/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier, "UInt", 5/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier, "UInt", 5/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 10/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 10/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 10/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 12/humanizer*modifier, "UInt", 15/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 12/humanizer*modifier, "UInt", 15/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 12/humanizer*modifier, "UInt", 15/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 12/humanizer*modifier, "UInt", 15/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 21/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 21/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 21/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 21/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 2/humanizer*modifier, "UInt", 24/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 2/humanizer*modifier, "UInt", 24/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 2/humanizer*modifier, "UInt", 24/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 2/humanizer*modifier, "UInt", 24/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 16/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 16/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 16/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 16/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 11/humanizer*modifier, "UInt", 10/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 11/humanizer*modifier, "UInt", 10/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 11/humanizer*modifier, "UInt", 10/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 11/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 14/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 14/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 14/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 14/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -22/humanizer*modifier, "UInt", 8/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -22/humanizer*modifier, "UInt", 8/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -22/humanizer*modifier, "UInt", 8/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -22/humanizer*modifier, "UInt", 8/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -30/humanizer*modifier, "UInt", -3/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -30/humanizer*modifier, "UInt", -3/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -30/humanizer*modifier, "UInt", -3/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -30/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -29/humanizer*modifier, "UInt", -13/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -29/humanizer*modifier, "UInt", -13/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -29/humanizer*modifier, "UInt", -13/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -29/humanizer*modifier, "UInt", -13/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 8/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 8/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 8/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 8/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -12/humanizer*modifier, "UInt", 2/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -12/humanizer*modifier, "UInt", 2/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -12/humanizer*modifier, "UInt", 2/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -12/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier, "UInt", 1/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier, "UInt", 1/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier, "UInt", 1/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 1/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 1/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 1/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 50
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 7/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 7/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 7/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 25/humanizer*modifier, "UInt", 7/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 25/humanizer*modifier, "UInt", 7/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 25/humanizer*modifier, "UInt", 7/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 25/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 4/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 4/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 4/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 25/humanizer*modifier, "UInt", -3/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 25/humanizer*modifier, "UInt", -3/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 25/humanizer*modifier, "UInt", -3/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 25/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 31/humanizer*modifier, "UInt", -9/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 31/humanizer*modifier, "UInt", -9/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 31/humanizer*modifier, "UInt", -9/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 31/humanizer*modifier, "UInt", -9/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 3/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 3/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 3/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -12/humanizer*modifier, "UInt", 3/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -12/humanizer*modifier, "UInt", 3/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -12/humanizer*modifier, "UInt", 3/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -12/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier, "UInt", -1/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier, "UInt", -1/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier, "UInt", -1/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 10/humanizer*modifier, "UInt", -1/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 10/humanizer*modifier, "UInt", -1/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 10/humanizer*modifier, "UInt", -1/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 10/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 16/humanizer*modifier, "UInt", -4/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 16/humanizer*modifier, "UInt", -4/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 16/humanizer*modifier, "UInt", -4/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 16/humanizer*modifier, "UInt", -4/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 5/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 5/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 5/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -32/humanizer*modifier, "UInt", -5/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -32/humanizer*modifier, "UInt", -5/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -32/humanizer*modifier, "UInt", -5/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -32/humanizer*modifier, "UInt", -5/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -24/humanizer*modifier, "UInt", -3/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -24/humanizer*modifier, "UInt", -3/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -24/humanizer*modifier, "UInt", -3/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -24/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -15/humanizer*modifier, "UInt", 5/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -15/humanizer*modifier, "UInt", 5/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -15/humanizer*modifier, "UInt", 5/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -15/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 8/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 8/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 8/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 8/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -14/humanizer*modifier, "UInt", -3/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -14/humanizer*modifier, "UInt", -3/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -14/humanizer*modifier, "UInt", -3/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -14/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -24/humanizer*modifier, "UInt", -14/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -24/humanizer*modifier, "UInt", -14/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -24/humanizer*modifier, "UInt", -14/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -24/humanizer*modifier, "UInt", -14/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -13/humanizer*modifier, "UInt", -1/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -13/humanizer*modifier, "UInt", -1/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -13/humanizer*modifier, "UInt", -1/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", -13/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", uint, 4, int, 0, int, 0, uint, 0, int, 0)
sleep 1000
}
}

else if CurrentPattern = UMP
{
loop
{

sleep 15
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 16/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 16/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 16/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 16/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 18/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 18/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 18/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 18/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier, "UInt", 18/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier, "UInt", 18/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier, "UInt", 18/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier, "UInt", 18/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 23/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 23/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 23/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 23/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 23/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 23/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 23/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 23/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 26/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 26/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 26/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 26/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{
; ------------------------------------------ # 8
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 11/humanizer*modifier, "UInt", 17/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 11/humanizer*modifier, "UInt", 17/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 11/humanizer*modifier, "UInt", 17/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 11/humanizer*modifier, "UInt", 17/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
} ; #10
DllCall("mouse_event", "UInt", 0x01, "UInt", 9/humanizer*modifier, "UInt", 13/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 9/humanizer*modifier, "UInt", 13/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 9/humanizer*modifier, "UInt", 13/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 9/humanizer*modifier, "UInt", 13/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 9/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 9/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 9/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 9/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -12/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -12/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -12/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -12/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -19/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 85/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -19/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 85/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -19/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 85/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -19/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 85/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", -5/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", -5/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", -5/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", -5/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 17/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 85/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 17/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 85/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 17/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 85/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 17/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 85/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -20/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -20/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -20/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -20/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 90/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", uint, 4, int, 0, int, 0, uint, 0, int, 0)
sleep 1000
}
}

else if CurrentPattern = AUG
{
if GetKeyState(key_Zoom)
{
;this is the best scale I could figure out for Zoomed in norecoil
obs:=.75/Zoomsens
}
else
{
obs:=1
}
loop
{

sleep 30
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier*obs, "UInt", 3.25/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier*obs, "UInt", 3.25/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier*obs, "UInt", 3.25/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier*obs, "UInt", 3.25/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier*obs, "UInt", 22/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier*obs, "UInt", 22/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier*obs, "UInt", 22/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier*obs, "UInt", 22/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier*obs, "UInt", 26/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier*obs, "UInt", 26/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier*obs, "UInt", 26/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier*obs, "UInt", 26/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 7.25/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 7.25/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 7.25/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 7.25/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 11/humanizer*modifier*obs, "UInt", 30/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 11/humanizer*modifier*obs, "UInt", 30/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 11/humanizer*modifier*obs, "UInt", 30/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 11/humanizer*modifier*obs, "UInt", 30/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 21/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 21/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 21/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 21/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 12/humanizer*modifier*obs, "UInt", 15/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 12/humanizer*modifier*obs, "UInt", 15/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 12/humanizer*modifier*obs, "UInt", 15/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 12/humanizer*modifier*obs, "UInt", 15/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 13/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 13/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 13/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 13/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -18/humanizer*modifier*obs, "UInt", 11/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -18/humanizer*modifier*obs, "UInt", 11/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -18/humanizer*modifier*obs, "UInt", 11/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -18/humanizer*modifier*obs, "UInt", 11/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -25/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -25/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -25/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -25/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier*obs, "UInt", 0/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier*obs, "UInt", 0/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier*obs, "UInt", 0/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier*obs, "UInt", 0/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 10/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 10/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 10/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 10/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -22/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -22/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -22/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -22/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -10/humanizer*modifier*obs, "UInt", -11/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -10/humanizer*modifier*obs, "UInt", -11/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -10/humanizer*modifier*obs, "UInt", -11/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -10/humanizer*modifier*obs, "UInt", -11/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -33/humanizer*modifier*obs, "UInt", -13/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -33/humanizer*modifier*obs, "UInt", -13/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -33/humanizer*modifier*obs, "UInt", -13/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -33/humanizer*modifier*obs, "UInt", -13/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier*obs, "UInt", 0/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier*obs, "UInt", 0/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier*obs, "UInt", 0/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier*obs, "UInt", 0/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 1/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 1/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 1/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 1/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier*obs, "UInt", 3/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier*obs, "UInt", 3/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier*obs, "UInt", 3/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier*obs, "UInt", 3/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier*obs, "UInt", 1/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier*obs, "UInt", 1/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier*obs, "UInt", 1/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier*obs, "UInt", 1/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 17/humanizer*modifier*obs, "UInt", -3/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 17/humanizer*modifier*obs, "UInt", -3/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 17/humanizer*modifier*obs, "UInt", -3/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 17/humanizer*modifier*obs, "UInt", -3/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 7.25/humanizer*modifier*obs, "UInt", -11/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 7.25/humanizer*modifier*obs, "UInt", -11/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 7.25/humanizer*modifier*obs, "UInt", -11/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 7.25/humanizer*modifier*obs, "UInt", -11/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 19/humanizer*modifier*obs, "UInt", 0/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 19/humanizer*modifier*obs, "UInt", 0/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 19/humanizer*modifier*obs, "UInt", 0/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 19/humanizer*modifier*obs, "UInt", 0/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -16/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -16/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -16/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -16/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -16/humanizer*modifier*obs, "UInt", 3/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -16/humanizer*modifier*obs, "UInt", 3/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -16/humanizer*modifier*obs, "UInt", 3/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -16/humanizer*modifier*obs, "UInt", 3/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier*obs, "UInt", 1/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier*obs, "UInt", 1/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier*obs, "UInt", 1/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier*obs, "UInt", 1/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", uint, 4, int, 0, int, 0, uint, 0, int, 0)
sleep 1000
}
}

else if CurrentPattern = SG
{
if GetKeyState(key_Zoom) {
obs:=.75/Zoomsens
} else {
obs:=1
}
loop
{

sleep 30
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier*obs, "UInt", 9/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier*obs, "UInt", 9/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier*obs, "UInt", 9/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier*obs, "UInt", 9/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3.25/humanizer*modifier*obs, "UInt", 3.75/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3.25/humanizer*modifier*obs, "UInt", 3.75/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3.25/humanizer*modifier*obs, "UInt", 3.75/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3.25/humanizer*modifier*obs, "UInt", 3.75/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2.25/humanizer*modifier*obs, "UInt", 6.25/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2.25/humanizer*modifier*obs, "UInt", 6.25/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2.25/humanizer*modifier*obs, "UInt", 6.25/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2.25/humanizer*modifier*obs, "UInt", 6.25/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier*obs, "UInt", 29/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier*obs, "UInt", 29/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier*obs, "UInt", 29/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier*obs, "UInt", 29/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier*obs, "UInt", 31/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier*obs, "UInt", 31/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier*obs, "UInt", 31/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier*obs, "UInt", 31/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier*obs, "UInt", 36/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier*obs, "UInt", 36/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier*obs, "UInt", 36/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier*obs, "UInt", 36/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier*obs, "UInt", 14/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier*obs, "UInt", 14/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier*obs, "UInt", 14/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier*obs, "UInt", 14/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 17/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 17/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 17/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 17/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier*obs, "UInt", 12/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier*obs, "UInt", 12/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier*obs, "UInt", 12/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier*obs, "UInt", 12/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -15/humanizer*modifier*obs, "UInt", 8/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -15/humanizer*modifier*obs, "UInt", 8/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -15/humanizer*modifier*obs, "UInt", 8/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -15/humanizer*modifier*obs, "UInt", 8/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier*obs, "UInt", 11/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier*obs, "UInt", 11/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier*obs, "UInt", 11/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier*obs, "UInt", 11/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -18/humanizer*modifier*obs, "UInt", -6/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -18/humanizer*modifier*obs, "UInt", -6/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -18/humanizer*modifier*obs, "UInt", -6/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -18/humanizer*modifier*obs, "UInt", -6/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -26/humanizer*modifier*obs, "UInt", -17/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -26/humanizer*modifier*obs, "UInt", -17/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -26/humanizer*modifier*obs, "UInt", -17/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -26/humanizer*modifier*obs, "UInt", -17/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -18/humanizer*modifier*obs, "UInt", -9/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -18/humanizer*modifier*obs, "UInt", -9/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -18/humanizer*modifier*obs, "UInt", -9/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -18/humanizer*modifier*obs, "UInt", -9/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier*obs, "UInt", -2/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier*obs, "UInt", -2/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier*obs, "UInt", -2/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier*obs, "UInt", -2/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 20/humanizer*modifier*obs, "UInt", 3/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 20/humanizer*modifier*obs, "UInt", 3/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 20/humanizer*modifier*obs, "UInt", 3/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 20/humanizer*modifier*obs, "UInt", 3/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 23/humanizer*modifier*obs, "UInt", -5/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 23/humanizer*modifier*obs, "UInt", -5/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 23/humanizer*modifier*obs, "UInt", -5/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 23/humanizer*modifier*obs, "UInt", -5/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 21/humanizer*modifier*obs, "UInt", -1/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 21/humanizer*modifier*obs, "UInt", -1/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 21/humanizer*modifier*obs, "UInt", -1/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 21/humanizer*modifier*obs, "UInt", -1/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier*obs, "UInt", 9/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier*obs, "UInt", 9/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier*obs, "UInt", 9/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier*obs, "UInt", 9/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 9/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 9/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 9/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 9/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 16/humanizer*modifier*obs, "UInt", 7/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 16/humanizer*modifier*obs, "UInt", 7/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 16/humanizer*modifier*obs, "UInt", 7/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 16/humanizer*modifier*obs, "UInt", 7/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 21/humanizer*modifier*obs, "UInt", -3/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 21/humanizer*modifier*obs, "UInt", -3/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 21/humanizer*modifier*obs, "UInt", -3/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 21/humanizer*modifier*obs, "UInt", -3/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 29/humanizer*modifier*obs, "UInt", -4/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 29/humanizer*modifier*obs, "UInt", -4/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 29/humanizer*modifier*obs, "UInt", -4/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 29/humanizer*modifier*obs, "UInt", -4/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 16/humanizer*modifier*obs, "UInt", 8/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 16/humanizer*modifier*obs, "UInt", 8/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 16/humanizer*modifier*obs, "UInt", 8/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 16/humanizer*modifier*obs, "UInt", 8/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 38/humanizer*modifier*obs, "UInt", -5/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 38/humanizer*modifier*obs, "UInt", -5/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 38/humanizer*modifier*obs, "UInt", -5/humanizer*modifier*obs)
sleep 99/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 38/humanizer*modifier*obs, "UInt", -5/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", uint, 4, int, 0, int, 0, uint, 0, int, 0)
sleep 1000
}
}
}
Return


;Welp you did it, you lurked on all this naked code. Pervert....
