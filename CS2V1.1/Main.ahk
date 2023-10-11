#NoEnv
#MaxThreadsPerHotkey 2
#SingleInstance Force
#KeyHistory 0
#MaxMem 4095
#MaxThreads 255
#MaxThreadsBuffer on
Process,Priority,,High
SetWorkingDir %A_ScriptDir%
ListLines Off

RunAsAdmin()

Global ScreenWidth := A_ScreenWidth, ScreenHeight := A_ScreenHeight, CurrentTime := A_TickCount, Center_X := ScreenWidth // 2+1, Center_Y := ScreenHeight // 2+1
Global sens := 1.8, Zoomsens := 0.75, reaction_min := 25, reaction_max := 100, RFL := 50, RFH := 80
Global CrossHairTrans := 220, SelectedCrosshair := "+",CrossHairSize := 20
Global Magnifier := False, Zoom := 1.5, Size := 30, Delay := 10

Global key_AK := "f5", Key_M4A1 := "f6", Key_M4A4 := "f7", Key_Famas := "f8", Key_Galil := "f9", Key_UMP := "f10", Key_AUG := "f11", Key_SG := "f12", Key_RCoff := "x", key_180 := "v", Key_shoot := "LButton", Key_Zoom := "Alt", Key_hold1 := "XButton1", Key_hold2 := "XButton2", Key_BHOP := "Space", Key_Duck := "c"

Global BHOPT := False, RapidFireT := False, TriggerBotT := False, TurnAroundT := False, AcceptT := False, CrosshairT := False, DuckT := False, RCSNotification := True

Version := "CS2 V1.1"
/*
Reverted Magnifier to AHK file. It wasnt loading saved settings.
Put Crosshair Into AHK file.
Fixed Abunch of Bugs for Magnifier
Removed Various Old Code from CSGO.
Fixed Realtime Priority not working for CS2
Wider Edit Boxes, To see hotkeys better
Added MsgBox Prank
CPU Saver/ Main loop will not work unless CS2 is running.
Added Customize Size of Crosshair (Must save)
Adjusted Default Values.
Fixed Magnifier And CrossHair not opening if toggle is saved on
Reworked Crosshair toggle method

Save Everything, saves Toggle state for  GUI Toggles
Updated Save/Read Function for better looking INI file
Custom Save Function
Independent Saving For Recoil, Pixelbot, RapidFire, Crosshair, Magnifier
Will not allow Saving of certian keybinds to prevent issues.
When saving RapidFire it will verify if Min is lower then Max.
CrossHair no longer needs to be saved to be updated.
*/

VarSetCapacity(INPUT, 28)
VarSetCapacity(MOUSEINPUT, 24)
VarSetCapacity(KEYBDINPUT, 16)
VarSetCapacity(HARDWAREINPUT, 8)
VarSetCapacity(INPUT_union, 24)

if !FileExist("Settings.ini") {
	FileAppend, [General]`n, Settings.ini
	SaveSettings()
	} Else {
	ReadSettings()
	if (CrosshairT) {
	Gosub Crosshair
	Gosub Crosshair
	}
	if (Magnifier) {
	Gosub ZoomIN
	}
}
MainLoop()
#Include Zoom.AHK
#Include Functions.AHK
#Include Crosshair.AHK

GuiVisible := False
~^f1::
if (GuiVisible) {
	GoSub GuiClose
} Else {
    GoSub MainGui
}
return

~^f2::ToggleScript(AcceptT, "Accept", 50, 600, 1600)
return

MainGui:
if !GuiVisible {
DPMenu := "XButton1|XButton2|Z|X|C|Alt|Ctrl|CapsLock"
Tabs := "Recoil|PixelBot|RapidFire|Magnifier|Crosshair|Extras"
				;hwnd := WinExist("A")
ReadSettings()
GuiVisible := true
Gui, +AlwaysOnTop +ToolWindow +Owner
Gui, Color, Black
Gui, Font, cWhite s14, Impact
Gui, Add, Button,x20 y420 w300 gSaveButton, SAVE EVERYTHING
Gui, Add, Tab, xM+1 yM+1 Section w310 h400, %Tabs%

Gui, Add, GroupBox, xs+10 ys+55 Section  W200 H330,RCS
Gui, tab, Recoil
Gui, add, text, xs+5  ys+25, Sensitivity:
Gui, Add, Edit, xs+95  ys+23    w100 cBlack vSens1, %sens%
Gui, Add, Text, xs+5  ys+55 , AK-47:
Gui, Add, Hotkey, xs+75  ys+53   w100 vKey_AK, %Key_AK%
Gui, Add, Text, xs+5  ys+85 , M4A1:
Gui, Add, Hotkey, xs+75  ys+83    w100 vKey_M4A1, %Key_M4A1%
Gui, Add, Text, xs+5  ys+115, M4A4:
Gui, Add, Hotkey, xs+75  ys+113    w100 vKey_M4A4, %Key_M4A4%
Gui, Add, Text, xs+5  ys+145, Famas:
Gui, Add, Hotkey, xs+75  ys+143    w100 vKey_Famas, %Key_Famas%
Gui, Add, Text, xs+5  ys+175, Galil:
Gui, Add, Hotkey, xs+75  ys+173    w100 vKey_Galil, %Key_Galil%
Gui, Add, Text, xs+5  ys+205, UMP:
Gui, Add, Hotkey, xs+75  ys+203    w100 vKey_UMP, %Key_UMP%
Gui, Add, Text, xs+5  ys+235, AUG:
Gui, Add, Hotkey, xs+75  ys+233    w100 vKey_AUG, %Key_AUG%
Gui, Add, Text, xs+5  ys+265, SG:
Gui, Add, Hotkey, xs+75  ys+263    w100 vKey_SG, %Key_SG%
Gui, Add, Text, xs+5  ys+295, Recoil Off:
Gui, Add, Hotkey, xs+95  ys+293    w100 vKey_RCoff, %Key_RCoff%
Gui Add, Button, xS+220 ys+275 w65 h55 gSaveRecoil, Save Recoil

;Gui, Add, GroupBox, xs+150 ys+5 W140 H325,Settings

Gui, Font, s20, Impact
Gui, tab, PixelBot
Gui, Add, CheckBox, xS+70 ys+30 Checked%TriggerBotT% GTriggerBot_CB, PixelBot
Gui, Add, DropDownList, xS+70 ys+70 w150 vKey_Hold2, %DPMenu%
GuiControl, Choose, key_hold2, %key_hold2%
Gui, Add, Text, xS+5 ys+120 h20 Center, Min:
Gui, Add, Edit, xS+5 ys+150 cBlack vReactionMin, %reaction_min%
Gui, Add, Text, xS+230 ys+120 h20 Center, Max:
Gui, Add, Edit, xS+230 ys+150 cBlack vReactionMax, %reaction_max%
GUI ADD, Text, xS+70 ys+180 c0xB0AE3B BackgroundTrans, Shoots When`nCenter Pixel`nChanges Color
Gui Add, Button, xS+20 ys+305 w250 h30 gSavePixelBot, Save Pixel Bot

Gui, tab, RapidFire
Gui, Add, CheckBox, xS+70 ys+30 Checked%RapidFireT% gRapidFire_CB, RapidFire
Gui, Add, DropDownList, xS+70 ys+70 w150 vKey_Hold1, %DPMenu%
GuiControl, Choose, key_hold1, %key_hold1%
Gui, Add, Text, xS+5 ys+120 h20 Center, Min:
Gui, Add, Edit, xS+5 ys+150 cBlack vRFL1, %RFL%
Gui, Add, Text, xS+230 ys+120 h20 Center, Max:
Gui, Add, Edit, xS+230 ys+150 cBlack vRFH1, %RFH%
Gui Add, Button, xS+20 ys+305 w250 h30 gSaveRapidFire, Save Rapid Fire

Gui, Tab, Magnifier
Gui, Add, CheckBox, xS+5 ys+25 Checked%Magnifier% gMagnifier_CB, Magnifing Glass
Gui, Add, Text, xS+5 ys+120 h20 Center, Zoom
Gui, Add, Edit, xS+5 ys+150 cBlack vZoom1, %Zoom%
Gui, Add, Text, xS+100 ys+120 h20 Center, Size
Gui, Add, Edit, xS+100 ys+150 cBlack vSize1, %Size%
Gui, Add, Text, xS+200 ys+120 h20 Center, Timer
Gui, Add, Edit, xS+200 ys+150 cBlack vDelay1, %Delay%
Gui, Add, Text, xS+5 ys+210 h20 Center c0x719FD0, Save otherwise`nSettings will not change.
Gui Add, Button, xS+20 ys+305 w250 h30  gSaveMagnifier, Save Magnifier
;GuiControl,, Magnifing Glass, % (Magnifier ? "1" : "0")

Gui, Tab, Crosshair
Gui, Add, CheckBox, xS+5 ys+25 Checked%CrosshairT% gCrossHair_CB, CrossHair Toggle
Gui, Add, Text, xS+5 ys+80 h20 Center, Size
Gui, Add, Edit, xS+60 ys+78 cBlack vCrosshairSize, %CrosshairSize%
Gui, Add, Text, xS+60 ys+140 h20 Center c0x719FD0, Select CrossHair
Gui Add, Button, xS+180 ys+180 w80 h30 gCrossHairMenu, Extras
Gui, Add, Button, xS+20  ys+180 w30 h30 gSelectCrosshair, ∙
Gui, Add, Button, xS+50 ys+180 w30 h30 gSelectCrosshair, +
Gui, Add, Button, xS+80 ys+180 w30 h30 gSelectCrosshair, ×
Gui, Add, Button, xS+110  ys+180 w30 h30 gSelectCrosshair, ¤
Gui, Add, Text, xS+70 ys+220 h20 Center c0x719FD0, Transparency
Gui, Add, Slider, xS+0 ys+260 W290 vCrossHairTrans gCrossHairTrans1 +ToolTip +Range0.0-225.0, %CrossHairTrans%
Gui Add, Button, xS+20 ys+305 w250 h30 gSaveCrossHair, Save CrossHair

Gui, tab, Extras
Gui, Add, CheckBox, xS+5 ys+25 Checked%TurnAroundT% gTurnAround_CB, Turn Around
Gui, Add, Hotkey, xS+180 ys+20 w50 vkey_180, %Key_180%
Gui, Add, CheckBox, xS+5 ys+90 Checked%BHOPT% gBHOP_CB, BHOP
Gui, Add, Hotkey, xS+100 ys+85 w80 vKey_BHOP, %Key_BHOP%
Gui, Add, CheckBox, xS+5 ys+170 Checked%DuckT% gDuck_CB, Crouch Correction
Gui, Add, CheckBox, xS+5 ys+270 Checked%RCSNotification% gRCSNotification_CB, RCS Notification
Gui Add, Button, xS+20 ys+305 w250 h30 gSelectProcess, Real Time Priority
Gui, Submit, NoHide
    Gui, Show, x0 y0, PilgrimMites %Version%
		   ; WinActivate, ahk_id %hwnd%
Return
}

CrossHair_CB:
CrossHairT:=!CrossHairT
GoSub CrossHair
return

Magnifier_CB:
Magnifier:=!Magnifier
GoSub ZoomIN
return

RCSNotification_CB:
RCSNotification := !RCSNotification
If (!RCSNotification) {
ToolTip
}
return

RapidFire_CB:
RapidFireT := !RapidFireT
return

TriggerBot_CB:
TriggerBotT := !TriggerBotT
return

TurnAround_CB:
TurnAroundT := !TurnAroundT
return

BHOP_CB:
BHOPT := !BHOPT
return

Duck_CB:
DuckT := !DuckT
If DuckT {
MsgBox, 48, Warning, This is WIP. `nAll it does is slightly move mouse up on crouch and down on release.`nCurrent key bind  C
}
Return

SelectProcess:
IfWinExist, ahk_exe cs2.exe
{
    IfWinNotActive, ahk_exe cs2.exe
    {
        WinActivate, ahk_exe cs2.exe
        WinGet, ActiveExe, ProcessName, A
    }
    If (ActiveExe = "cs2.exe") {
        PID := DllCall("GetCurrentProcessId")
        DllCall("SetPriorityClass", "uint", PID, "uint", 0x00000080)
        MsgBox, , Process Selected, PID: %PID%`nName: %ActiveExe%`nElevated to Real Time Priority
	}
	}  Else  {
GoSub, prankMsgBox
}
return

prankMsgBox:
if (GuiVisible) {
MsgBox, 49, bababooey, Please Run CS2 First!
IfMsgBox Ok
    return
IfMsgBox Cancel
    MsgBox, 49, Are You Sure?, Do you want to Run CS2?
    IfMsgBox Ok
        MsgBox, 49, Go start it!, What are you waiting for? The CS2 gnomes are getting restless!
    IfMsgBox Cancel
        MsgBox, 49, Are You Sure?, Still not pressing the magical "Run CS2" button, huh?
        IfMsgBox Ok
            MsgBox, 49, Go start it!, Alright, maybe CS2 will start if you blink three times and hop on one foot!
            IfMsgBox Cancel
                MsgBox, 49, Are You Sure?, Seriously? Maybe you need to perform a secret CS2 dance!
                IfMsgBox Ok
                    MsgBox, 49, Go start it!, It's time for the legendary CS2 dance-off!
                    IfMsgBox Cancel
                        MsgBox, 49, Are You Sure?, You must really enjoy our chat. But seriously, run CS2!
                        IfMsgBox Ok
                            MsgBox, 49, Go start it!, Your dedication to avoiding CS2 is impressive, but let's run it now!
                            IfMsgBox Cancel
                                MsgBox, 49, Are You Sure?, CS2 is waiting for you! Maybe it's shy and needs an invitation?
                                IfMsgBox Ok
                                    MsgBox, 49, Go start it!, The CS2 unicorn is waiting to grant your wish! Just run it!
                                    IfMsgBox Cancel
                                        MsgBox, 49, Are You Sure?, You're testing the limits of CS2s patience. Run it already!
                                        IfMsgBox Ok
                                            MsgBox, 49, Go start it!, The CS2 ninja turtles are on standby. They need action!
                                                Goto, prankMsgBox
}
Return

Accept:
If (AcceptT) {
ToolTip , Auto Accept ON, 0, 20, 2
    CenterXMin := ScreenWidth * 0.44, CenterXMax := ScreenWidth * 0.56
    CenterYMin := ScreenHeight * 0.40, CenterYMax := ScreenHeight * 0.45
    AcceptX := Random(CenterXMin, CenterXMax), AcceptY := Random(CenterYMin, CenterYMax)
    randomSpeed := Random(6, 12)
    PixelGetColor, colorA, %Center_X%, %Center_Y%, Fast
    PixelSearch,,, %Center_X%, %Center_Y%, %Center_X%, %Center_Y%, %colorA%, 2, Fast
    if (ErrorLevel = 1) {
        Mousegetpos, MouseX, MouseY, Window
        X1 := MouseX + Rand(10), Y1 := MouseY + Rand(10)
        sleep, Random(1000, 3000) ;Sleep Before moving
        MouseMove, %AcceptX%, %AcceptY%, %randomSpeed%
        Click()
        sleep, Random(100, 500) ;Sleep Before moving
        MouseMove, %X1%, %Y1%, %randomSpeed%
        SetTimer, Accept, Off
		ToolTip, , , ,2
        AcceptT := false
    }
}
Return

SaveButton:
if (GuiVisible) {
Gosub LineSave1
	global sens := Sens1, reaction_min := ReactionMin, reaction_max := ReactionMax, RFL := RFL1, RFH := RFH1,  Zoom := Zoom1, Size := Size1, Delay := Delay1
	MsgBox, 4, Do you want to Save?,THIS WILL SAVE ALL TOGGLE ON|OFF!`nSensitivity: %sens%`nAK: %Key_AK%`nM4A1: %Key_M4A1%`nM4A4: %Key_M4A4%`nFamas: %Key_Famas%`nGalil: %Key_Galil%`nUMP: %Key_UMP%`nAUG: %Key_AUG%`nSG: %Key_SG%`n180: %Key_180%`nRecoil Off: %Key_RCoff%`nBHOP Key: %Key_BHOP%`nRapidFire: %Key_hold1%`nRFMin: %RFL%`nRFMax: %RFH%`nTriggerBot: %Key_hold2%`nTBMin: %reaction_min%`nTBMax: %reaction_max%`n
IfMsgBox Yes
        SaveSettings()
		Gosub, MainGui
IfMsgBox NO
		 Gosub, MainGui
}
Return

SaveRecoil:
if (GuiVisible) {
Gosub LineSave1
	global sens := Sens1
	MsgBox, 4, Do you want to Save?, Sensitivity: %sens%`nAK: %Key_AK%`nM4A1: %Key_M4A1%`nM4A4: %Key_M4A4%`nFamas: %Key_Famas%`nGalil: %Key_Galil%`nUMP: %Key_UMP%`nAUG: %Key_AUG%`nSG: %Key_SG%`nRecoil Off: %Key_RCoff%
IfMsgBox Yes
CustomSave(Key_AK, "Hotkeys", "Key_AK")
CustomSave(Key_M4A1, "Hotkeys", "Key_M4A1")
CustomSave(Key_M4A4, "Hotkeys", "Key_M4A4")
CustomSave(Key_Famas, "Hotkeys", "Key_Famas")
CustomSave(Key_Galil, "Hotkeys", "Key_Galil")
CustomSave(Key_UMP, "Hotkeys", "Key_UMP")
CustomSave(Key_AUG, "Hotkeys", "Key_AUG")
CustomSave(Key_SG, "Hotkeys", "Key_SG")
CustomSave(Key_180, "Hotkeys", "Key_180")
CustomSave(Key_RCoff, "Hotkeys", "Key_RCoff")
CustomSave(sens, "General", "sens")
		Gosub, MainGui
IfMsgBox NO
		 Gosub, MainGui
}
Return

SaveRapidFire:
if (GuiVisible) {
Gosub LineSave1
	global RFL := RFL1, RFH := RFH1,  
	MsgBox, 4, Do you want to Save?, Toggle State: %RapidFireT%`nRapidFire: %Key_hold1%`nRFMin: %RFL%`nRFMax: %RFH%
IfMsgBox Yes
		CustomSave(Key_Hold1,"Hotkeys", "Key_Hold1")
		CustomSave(RFL,"RapidFire", "RFL")
		CustomSave(RFH,"RapidFire", "RFH")
		CustomSave(RapidFireT,"Toggle", "RapidFireT")
		Gosub, MainGui
IfMsgBox NO
		 Gosub, MainGui
}
Return

SavePixelBot:
if (GuiVisible) {
Gosub LineSave1
	global reaction_min := ReactionMin, reaction_max := ReactionMax 
	MsgBox, 4, Do you want to Save?, Toggle State: %TriggerBotT%`nTriggerBot: %Key_hold2%`nTBMin: %reaction_min%`nTBMax: %reaction_max%
IfMsgBox Yes
		CustomSave(Key_hold2,"Hotkeys", "Key_hold2")
		CustomSave(reaction_min,"PixelBot", "reaction_min")
		CustomSave(reaction_max,"PixelBot", "reaction_max")
		CustomSave(TriggerBotT,"Toggle", "TriggerBotT")
		Gosub, MainGui
IfMsgBox NO
		 Gosub, MainGui
}
Return

SaveCrossHair:
if (GuiVisible) {
Gosub LineSave1
	MsgBox, 4, Do you want to Save?, Toggle State: %CrossHairT%`nCrossHair: %SelectedCrosshair%`nCrossHair Trans: %CrossHairTrans%`nCrossHairSize: %CrossHairSize%
IfMsgBox Yes
		CustomSave(CrossHairTrans,"CrossHair", "CrossHairTrans")
		CustomSave(SelectedCrosshair,"CrossHair", "SelectedCrosshair")
		CustomSave(CrossHairSize,"CrossHair", "CrossHairSize")
		CustomSave(CrossHairT,"Toggle", "CrossHairT")
		Gosub, MainGui
IfMsgBox NO
		 Gosub, MainGui
}
Return

SaveMagnifier:
if (GuiVisible) {
Gosub LineSave1
	global Zoom:=Zoom1, Size := Size1, Delay := Delay1
	MsgBox, 4, Do you want to Save?, Toggle State: %Magnifier%`nZoom: %Zoom%`nSize: %Size%`nDelay: %Delay%
IfMsgBox Yes
CustomSave(Zoom, "Magnifier", "Zoom")
CustomSave(Size, "Magnifier", "Size")
CustomSave(Delay, "Magnifier", "Delay")
CustomSave(Magnifier, "Toggle", "Magnifier")
		Gosub, MainGui
IfMsgBox NO
		 Gosub, MainGui
}
Return

DuplicateCheck:
hotkeys := [Key_AK, Key_M4A1, Key_M4A4, Key_Famas, Key_Galil, Key_UMP, Key_AUG, Key_SG, Key_RCoff, Key_hold1, Key_hold2, Key_BHOP, Key_Duck, Key_180]
    if (HasDuplicates(hotkeys)) {
        MsgBox, 48, Duplicate Hotkeys Found, Duplicate hotkeys were found. Please make sure each hotkey is unique.
        return
    }
return

RangeCheck:
    if (ReactionMin >= ReactionMax) {
        MsgBox, 48, Warning: Invalid Input, The minimum reaction time should be lower than the maximum reaction time.`nPlease make sure to enter a valid range.
        return
    }
	if (RFL1 >= RFH1) {
        MsgBox, 48, Warning: Invalid Input, The minimum reaction time should be lower than the maximum reaction time.`nPlease make sure to enter a valid range.
        return
    }
Return

LineSave1:
 Gui, Submit
 Gosub GuiClose
 Gosub DuplicateCheck
 Gosub RangeCheck
Return

GuiClose:
GuiEscape:
    if (GuiVisible = true) {
        Gui, Destroy
		GuiVisible := False
    }
	GoSub Close2
return

Close2:
    if (Gui2 = true) {
        Gui 2:Destroy
		Gui2 := False
    }
return

MainLoop() {
WinWait, ahk_exe cs2.exe
loop {
DllCall("kernel32\Sleep", "UInt", 1)
While (TriggerBotT && GetKeyState(key_hold2, "P")) {
PixelGetColor, colorx, %Center_X%, %Center_Y%, Fast . A_IsCritical
PixelSearch, found_x, found_y, %Center_X%, %Center_Y%, %Center_X%, %Center_Y%, %colorx%, 1, Fast . A_IsCritical
	if (ErrorLevel = 1) {
		if (colorx != "0xFFFFFF") {
			Sleep, Random(reaction_min,reaction_max)
			Click()
			Sleep, 300
		}
	}
}
While (RapidFireT && GetKeyState(key_hold1, "P"))  {
sleep, PilgrimMites(RFL,RFH)
Click()
}
While (BHOPT && GetKeyState(Key_BHOP, "P"))  {
	SendInput, {Blind}{Space Down}
    sleep, PilgrimMites(10,20)
	SendInput, {Blind}{Space Up}
	sleep, PilgrimMites(10,30)
}
While (TurnAroundT && GetKeyState(Key_180, "P"))  {
modifier := 2.52/sens
    Random, chance, 0, 1
	PosNeg := chance <= 0.49 ? -1 : 1
		MoveMouse(PosNeg * 225 * modifier, 2*PosNeg) ;3249
        MoveMouse(PosNeg * 432 * modifier, 2/PosNeg)
        MoveMouse(PosNeg * 432 * modifier, 2*PosNeg)
        MoveMouse(PosNeg * 432 * modifier, 2/PosNeg)
        MoveMouse(PosNeg * 432 * modifier, 2*PosNeg)
        MoveMouse(PosNeg * 432 * modifier, 2/PosNeg)
        MoveMouse(PosNeg * 432 * modifier, 2*PosNeg)
        MoveMouse(PosNeg * 432 * modifier, 2/PosNeg)
		Sleep, PilgrimMites(250,300)
}
While (DuckT && GetKeyState(Key_Duck, "P"))  {
	MoveMouse(0,-10)
	MoveMouse(0,-10)
	MoveMouse(0,-10)
	MoveMouse(0,-10)
	MoveMouse(0,-10)
	MoveMouse(0,-10)
		KeyWait, %key_Duck%, L
		MoveMouse(0,10)
		MoveMouse(0,10)
		MoveMouse(0,10)
		MoveMouse(0,10)
		MoveMouse(0,10)
		MoveMouse(0,10)
}

if GetKeyState(key_RCoff, "P") {
If (RCSNotification) {
ToolTip
ToolTip Recoil | Off, 0,0
}
ak := false, m4a1 := false, m4a4 := false, famas := false, galil := false, ump := false, aug := false, sg := false
}
if GetKeyState(key_AK, "P")  {
If (RCSNotification) {
ToolTip
ToolTip AK-47 | On, 0, 0
}
ak := true, m4a1 := false, m4a4 := false, famas := false, galil := false, ump := false, aug := false, sg := false, humanizer :=  3.8, waitdivider := 4.7
}
if GetKeyState(key_M4A1, "P")  {
If (RCSNotification) {
ToolTip
ToolTip M4A1 | On, 0,0
}
m4a1 := true, ak := false, m4a4 := false, famas := false, galil := false, ump := false, aug := false, sg := false, humanizer := 3.65, waitdivider := 4.17
}
if GetKeyState(key_M4A4, "P")  {
If (RCSNotification) {
ToolTip
ToolTip M4A4 | On, 0,0
}
m4a4 := true, ak := false, m4a1 := false, famas := false, galil := false, ump := false, aug := false, sg := false, humanizer88 := 3.65, humanizer := 3.64, waitdivider88 := 4.17, waitdivider := 4.13
}
if GetKeyState(key_Famas, "P")  {
If (RCSNotification) {
ToolTip
ToolTip Famas | On, 0,0
}
famas := true, ak := false, m4a1 := false, m4a4 := false, galil := false, ump := false, aug := false, sg := false
}
if GetKeyState(key_Galil, "P")  {
If (RCSNotification) {
ToolTip
ToolTip Galil | On, 0,0
}
galil := true, ak := false, m4a1 := false, m4a4 := false, famas := false, ump := false, aug := false, sg := false
}
if GetKeyState(key_UMP, "P")  {
If (RCSNotification) {
ToolTip
ToolTip UMP | On, 0,0
}
ump := true, ak := false, m4a1 := false, m4a4 := false, famas := false, galil := false, aug := false, sg := false
}
if GetKeyState(key_SG, "P")  {
If (RCSNotification) {
ToolTip
ToolTip SG | On, 0,0
}
sg := true, ump := false, ak := false, m4a1 := false, m4a4 := false, famas := false, galil := false, aug := false
}
if GetKeyState(key_AUG, "P")  {
If (RCSNotification) {
ToolTip
ToolTip AUG | On, 0,0
}
aug := true, ump := false, ak := false, m4a1 := false, m4a4 := false, famas := false, galil := false, sg := false
}

;NoRecoil
if GetKeyState(key_shoot, "P") {
;----------------- All code below will never change. If it does, I will mention so. Dont re-copy unless needed.
modifier := PilgrimMites(2.519,2.521) / sens ; 2.52
if ak
{
loop
{
sleep 50
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 19/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 19/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 19/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 19/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 29/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 29/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 29/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 29/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 31/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 31/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 31/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 31/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier, "UInt", 31/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier, "UInt", 31/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier, "UInt", 31/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier, "UInt", 31/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 8/humanizer*modifier, "UInt", 28/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 8/humanizer*modifier, "UInt", 28/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 8/humanizer*modifier, "UInt", 28/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 8/humanizer*modifier, "UInt", 28/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier, "UInt", 21/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier, "UInt", 21/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier, "UInt", 21/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier, "UInt", 21/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -17/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -17/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -17/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -17/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -42/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -42/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -42/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -42/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -21/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -21/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -21/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -21/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 12/humanizer*modifier, "UInt", 11/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 12/humanizer*modifier, "UInt", 11/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 12/humanizer*modifier, "UInt", 11/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 12/humanizer*modifier, "UInt", 11/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -15/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -15/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -15/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -15/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -26/humanizer*modifier, "UInt", -8/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -26/humanizer*modifier, "UInt", -8/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -26/humanizer*modifier, "UInt", -8/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -26/humanizer*modifier, "UInt", -8/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 40/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 40/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 40/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 40/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 19/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 19/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 19/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 19/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 27/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 27/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 27/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 27/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 33/humanizer*modifier, "UInt", -10/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 33/humanizer*modifier, "UInt", -10/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 33/humanizer*modifier, "UInt", -10/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 33/humanizer*modifier, "UInt", -10/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -21/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -21/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -21/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -21/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 7/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 7/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 7/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 7/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier, "UInt", 9/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier, "UInt", 9/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier, "UInt", 9/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier, "UInt", 9/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 19/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 19/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 19/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 19/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -20/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -20/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -20/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -20/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -33/humanizer*modifier, "UInt", -4/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -33/humanizer*modifier, "UInt", -4/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -33/humanizer*modifier, "UInt", -4/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -33/humanizer*modifier, "UInt", -4/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -45/humanizer*modifier, "UInt", -21/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -45/humanizer*modifier, "UInt", -21/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -45/humanizer*modifier, "UInt", -21/humanizer*modifier)
sleep 99/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -45/humanizer*modifier, "UInt", -21/humanizer*modifier)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -14/humanizer*modifier, "UInt", 1/humanizer*modifier)
if !GetKeyState(key_shoot)
{
break
}
DllCall("mouse_event", uint, 4, int, 0, int, 0, uint, 0, int, 0)
sleep 1000
}
}

else if m4a1
{
loop
{

sleep 15
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 1/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 1/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 1/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 1/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 14/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 14/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 14/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 14/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 18/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 18/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 18/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 18/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier, "UInt", 21/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier, "UInt", 21/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier, "UInt", 21/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier, "UInt", 21/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier-1, "UInt", 24/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier-1, "UInt", 24/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier-1, "UInt", 24/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 24/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 14/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 14/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 14/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 14/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 8/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 8/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 8/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 8/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier+1, "UInt", 5/humanizer*modifier+1)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -14/humanizer*modifier-1, "UInt", 5/humanizer*modifier+1)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -14/humanizer*modifier-1, "UInt", 5/humanizer*modifier+1)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -14/humanizer*modifier, "UInt", 5/humanizer*modifier+1)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -14/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -25/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -25/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -25/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -25/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -19/humanizer*modifier-1, "UInt", 0/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -19/humanizer*modifier-1, "UInt", 0/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -19/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -19/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -22/humanizer*modifier+2, "UInt", -3/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -22/humanizer*modifier+2, "UInt", -3/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -22/humanizer*modifier+1, "UInt", -3/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -22/humanizer*modifier+1, "UInt", -3/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 1/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 1/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 1/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 1/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 8/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 8/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 8/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 8/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -13/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -13/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -13/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -13/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 3/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 3/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 3/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 3/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 1/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 1/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 1/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 88/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 1/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", uint, 4, int, 0, int, 0, uint, 0, int, 0)
sleep 1000
}
}

else if m4a4
{
loop
{

sleep 15
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 2/humanizer88*modifier, "UInt", 7/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", 2/humanizer88*modifier, "UInt", 7/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", 2/humanizer88*modifier, "UInt", 7/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", 2/humanizer88*modifier, "UInt", 7/humanizer88*modifier)
sleep 88/waitdivider88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 9/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 9/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 9/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 9/humanizer*modifier)
sleep 87/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier, "UInt", 16/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier, "UInt", 16/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier, "UInt", 16/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier, "UInt", 16/humanizer*modifier)
sleep 87/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 7/humanizer*modifier, "UInt", 21/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 7/humanizer*modifier, "UInt", 21/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 7/humanizer*modifier, "UInt", 21/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 7/humanizer*modifier, "UInt", 21/humanizer*modifier)
sleep 87/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 23/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 23/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 23/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 23/humanizer*modifier)
sleep 87/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier, "UInt", 27/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier, "UInt", 27/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier, "UInt", 27/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier, "UInt", 27/humanizer*modifier)
sleep 87/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 16/humanizer88*modifier, "UInt", 15/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", 16/humanizer88*modifier, "UInt", 15/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", 16/humanizer88*modifier, "UInt", 15/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", 16/humanizer88*modifier, "UInt", 15/humanizer88*modifier)
sleep 88/waitdivider88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 11/humanizer88*modifier, "UInt", 13/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", 11/humanizer88*modifier, "UInt", 13/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", 11/humanizer88*modifier, "UInt", 13/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", 11/humanizer88*modifier, "UInt", 13/humanizer88*modifier)
sleep 88/waitdivider88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 22/humanizer88*modifier, "UInt", 5/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", 22/humanizer88*modifier, "UInt", 5/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", 22/humanizer88*modifier, "UInt", 5/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", 22/humanizer88*modifier, "UInt", 5/humanizer88*modifier)
sleep 88/waitdivider88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer88*modifier, "UInt", 11/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer88*modifier, "UInt", 11/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer88*modifier, "UInt", 11/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", -4/humanizer88*modifier, "UInt", 11/humanizer88*modifier)
sleep 88/waitdivider88
if !GetKeyState(key_shoot)
{

break
}

DllCall("mouse_event", "UInt", 0x01, "UInt", -18/humanizer88*modifier, "UInt", 6/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", -18/humanizer88*modifier, "UInt", 6/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", -18/humanizer88*modifier, "UInt", 6/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", -18/humanizer88*modifier, "UInt", 6/humanizer88*modifier)
sleep 88/waitdivider88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -30/humanizer88*modifier, "UInt", -4/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", -30/humanizer88*modifier, "UInt", -4/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", -30/humanizer88*modifier, "UInt", -4/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", -30/humanizer88*modifier, "UInt", -4/humanizer88*modifier)
sleep 88/waitdivider88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -24/humanizer88*modifier, "UInt", 0/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", -24/humanizer88*modifier, "UInt", 0/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", -24/humanizer88*modifier, "UInt", 0/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", -24/humanizer88*modifier, "UInt", 0/humanizer88*modifier)
sleep 88/waitdivider88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -25/humanizer88*modifier, "UInt", -6/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", -25/humanizer88*modifier, "UInt", -6/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", -25/humanizer88*modifier, "UInt", -6/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", -25/humanizer88*modifier, "UInt", -6/humanizer88*modifier)
sleep 88/waitdivider88
if !GetKeyState(key_shoot)
{

break
}

DllCall("mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 87/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 8/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 8/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 8/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 8/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 87/waitdivider
if !GetKeyState(key_shoot)
{

break
}
;line15
DllCall("mouse_event", "UInt", 0x01, "UInt", -11/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -11/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -11/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -11/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 87/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -13/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -13/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -13/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -13/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 87/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 2/humanizer88*modifier, "UInt", 2/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", 2/humanizer88*modifier, "UInt", 2/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", 2/humanizer88*modifier, "UInt", 2/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", 2/humanizer88*modifier, "UInt", 2/humanizer88*modifier)
sleep 88/waitdivider88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 33/humanizer88*modifier, "UInt", -1/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", 33/humanizer88*modifier, "UInt", -1/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", 33/humanizer88*modifier, "UInt", -1/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", 33/humanizer88*modifier, "UInt", -1/humanizer88*modifier)
sleep 88/waitdivider88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 10/humanizer88*modifier, "UInt", 6/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", 10/humanizer88*modifier, "UInt", 6/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", 10/humanizer88*modifier, "UInt", 6/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", 10/humanizer88*modifier, "UInt", 6/humanizer88*modifier)
sleep 88/waitdivider88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 27/humanizer88*modifier, "UInt", 3/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", 27/humanizer88*modifier, "UInt", 3/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", 27/humanizer88*modifier, "UInt", 3/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", 27/humanizer88*modifier, "UInt", 3/humanizer88*modifier)
sleep 88/waitdivider88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 10/humanizer88*modifier, "UInt", 2/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", 10/humanizer88*modifier, "UInt", 2/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", 10/humanizer88*modifier, "UInt", 2/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", 10/humanizer88*modifier, "UInt", 2/humanizer88*modifier)
sleep 88/waitdivider88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 11/humanizer88*modifier, "UInt", 0/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", 11/humanizer88*modifier, "UInt", 0/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", 11/humanizer88*modifier, "UInt", 0/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("mouse_event", "UInt", 0x01, "UInt", 11/humanizer88*modifier, "UInt", 0/humanizer88*modifier)
sleep 88/waitdivider88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -12/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -12/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -12/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", -12/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 87/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 87/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 87/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 3/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 3/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 3/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 87/waitdivider
DllCall("mouse_event", "UInt", 0x01, "UInt", 3/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 87/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", -1/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", -1/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", -1/humanizer*modifier)
DllCall("mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", -1/humanizer*modifier)
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", uint, 4, int, 0, int, 0, uint, 0, int, 0)
sleep 1000
}
}

else if famas
{
loop
{

sleep 30
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -4*modifier, "UInt", 5*modifier)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 1*modifier, "UInt", 4*modifier)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -6*modifier, "UInt", 10*modifier)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -1*modifier, "UInt", 17*modifier)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 0*modifier, "UInt", 20*modifier)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 14*modifier, "UInt", 18*modifier)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 16*modifier, "UInt", 12*modifier)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -6*modifier, "UInt", 12*modifier)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -20*modifier, "UInt", 8*modifier)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -16*modifier, "UInt", 5*modifier)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -13*modifier, "UInt", 2*modifier)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 4*modifier, "UInt", 5*modifier)
sleep 87
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 23*modifier, "UInt", 4*modifier)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 12*modifier, "UInt", 6*modifier)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 20*modifier, "UInt", -3*modifier)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 5*modifier, "UInt", 0*modifier)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 15*modifier, "UInt", 0*modifier)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 3*modifier, "UInt", 5*modifier)
sleep 80
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -4*modifier, "UInt", 3*modifier)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -25*modifier, "UInt", -1*modifier)
sleep 80
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -3*modifier, "UInt", 2*modifier)
sleep 84
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 11*modifier, "UInt", 0*modifier)
sleep 80
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 15*modifier, "UInt", -7*modifier)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 15*modifier, "UInt", -10*modifier)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", uint, 4, int, 0, int, 0, uint, 0, int, 0)
sleep 1000
}
}

else if galil
{
loop
{

sleep 10
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 4*modifier, "UInt", 4*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -2*modifier, "UInt", 5*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 6*modifier, "UInt", 10*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 12*modifier, "UInt", 15*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -1*modifier, "UInt", 21*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 2*modifier, "UInt", 24*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 6*modifier, "UInt", 16*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 11*modifier, "UInt", 10*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -4*modifier, "UInt", 14*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -22*modifier, "UInt", 8*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -30*modifier, "UInt", -3*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -29*modifier, "UInt", -13*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -9*modifier, "UInt", 8*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -12*modifier, "UInt", 2*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -7*modifier, "UInt", 1*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 0*modifier, "UInt", 1*modifier)
sleep 50
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 4*modifier, "UInt", 7*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 25*modifier, "UInt", 7*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 14*modifier, "UInt", 4*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 25*modifier, "UInt", -3*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 31*modifier, "UInt", -9*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 6*modifier, "UInt", 3*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -12*modifier, "UInt", 3*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 13*modifier, "UInt", -1*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 10*modifier, "UInt", -1*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 16*modifier, "UInt", -4*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -9*modifier, "UInt", 5*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -32*modifier, "UInt", -5*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -24*modifier, "UInt", -3*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -15*modifier, "UInt", 5*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 6*modifier, "UInt", 8*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -14*modifier, "UInt", -3*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -24*modifier, "UInt", -14*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -13*modifier, "UInt", -1*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", uint, 4, int, 0, int, 0, uint, 0, int, 0)
sleep 1000
}
}

else if ump
{
loop
{

sleep 15
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -1*modifier, "UInt", 6*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -4*modifier, "UInt", 8*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -2*modifier, "UInt", 18*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -4*modifier, "UInt", 23*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -9*modifier, "UInt", 23*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -3*modifier, "UInt", 26*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 11*modifier, "UInt", 17*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -4*modifier, "UInt", 12*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 9*modifier, "UInt", 13*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 18*modifier, "UInt", 8*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 15*modifier, "UInt", 5*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -1*modifier, "UInt", 3*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 5*modifier, "UInt", 6*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 0*modifier, "UInt", 6*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 9*modifier, "UInt", -3*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 5*modifier, "UInt", -1*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -12*modifier, "UInt", 4*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -19*modifier, "UInt", 1*modifier)
sleep 85
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -1*modifier, "UInt", -2*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 15*modifier, "UInt", -5*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 17*modifier, "UInt", -2*modifier)
sleep 85
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -6*modifier, "UInt", 3*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -20*modifier, "UInt", -2*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -3*modifier, "UInt", -1*modifier)
sleep 90
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", uint, 4, int, 0, int, 0, uint, 0, int, 0)
sleep 1000
}
}

else if aug
{
if GetKeyState(key_Zoom)
{
;this is the best scale I could figure out for Zoomed in norecoil
obs:=1.2/Zoomsens
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
DllCall("mouse_event", "UInt", 0x01, "UInt", 5*modifier*obs, "UInt", 6*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 0*modifier*obs, "UInt", 13*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -5*modifier*obs, "UInt", 22*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -7*modifier*obs, "UInt", 26*modifier*obs)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 5*modifier*obs, "UInt", 29*modifier*obs)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 9*modifier*obs, "UInt", 30*modifier*obs)
sleep 80
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 14*modifier*obs, "UInt", 21*modifier*obs)
sleep 80
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 6*modifier*obs, "UInt", 15*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 14*modifier*obs, "UInt", 13*modifier*obs)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -16*modifier*obs, "UInt", 11*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -5*modifier*obs, "UInt", 6*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 13*modifier*obs, "UInt", 0*modifier*obs)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 1*modifier*obs, "UInt", 6*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -22*modifier*obs, "UInt", 5*modifier*obs)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -38*modifier*obs, "UInt", -11*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -31*modifier*obs, "UInt", -13*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -3*modifier*obs, "UInt", 6*modifier*obs)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -5*modifier*obs, "UInt", 5*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -9*modifier*obs, "UInt", 0*modifier*obs)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 24*modifier*obs, "UInt", 1*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 32*modifier*obs, "UInt", 3*modifier*obs)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 15*modifier*obs, "UInt", 6*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -5*modifier*obs, "UInt", 1*modifier*obs)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 17*modifier*obs, "UInt", -3*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 29*modifier*obs, "UInt", -11*modifier*obs)
sleep 95
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 19*modifier*obs, "UInt", 0*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -16*modifier*obs, "UInt", 6*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -16*modifier*obs, "UInt", 3*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -4*modifier*obs, "UInt", 1*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", uint, 4, int, 0, int, 0, uint, 0, int, 0)
sleep 1000
}
}

else if sg
{
if GetKeyState(key_Zoom)
{
;this is the best scale I could figure out for Zoomed in norecoil
obs:=1.2/Zoomsens
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
DllCall("mouse_event", "UInt", 0x01, "UInt", -4*modifier*obs, "UInt", 9*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -13*modifier*obs, "UInt", 15*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -9*modifier*obs, "UInt", 25*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -6*modifier*obs, "UInt", 29*modifier*obs)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -8*modifier*obs, "UInt", 31*modifier*obs)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -7*modifier*obs, "UInt", 36*modifier*obs)
sleep 80
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -20*modifier*obs, "UInt", 14*modifier*obs)
sleep 80
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 14*modifier*obs, "UInt", 17*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -8*modifier*obs, "UInt", 12*modifier*obs)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -15*modifier*obs, "UInt", 8*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -5*modifier*obs, "UInt", 5*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 6*modifier*obs, "UInt", 5*modifier*obs)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -8*modifier*obs, "UInt", 6*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 2*modifier*obs, "UInt", 11*modifier*obs)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -14*modifier*obs, "UInt", -6*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -20*modifier*obs, "UInt", -17*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -18*modifier*obs, "UInt", -9*modifier*obs)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -8*modifier*obs, "UInt", -2*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 41*modifier*obs, "UInt", 3*modifier*obs)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 56*modifier*obs, "UInt", -5*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 43*modifier*obs, "UInt", -1*modifier*obs)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 18*modifier*obs, "UInt", 9*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 14*modifier*obs, "UInt", 9*modifier*obs)
sleep 88
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 6*modifier*obs, "UInt", 7*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 21*modifier*obs, "UInt", -3*modifier*obs)
sleep 95
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", 29*modifier*obs, "UInt", -4*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -6*modifier*obs, "UInt", 8*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -15*modifier*obs, "UInt", 5*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", "UInt", 0x01, "UInt", -38*modifier*obs, "UInt", -5*modifier*obs)
sleep 89
if !GetKeyState(key_shoot)
{

break
}
DllCall("mouse_event", uint, 4, int, 0, int, 0, uint, 0, int, 0)
sleep 1000
}
}
}
}
return
}
Pause::Pause
#r::Reload
End::ExitApp
