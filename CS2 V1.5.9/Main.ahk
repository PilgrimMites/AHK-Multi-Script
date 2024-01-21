#NoEnv
#MaxThreadsPerHotkey 4
#SingleInstance Force
#KeyHistory 0
#MaxMem 4095
#MaxThreads 255
#MaxThreadsBuffer on
Process, Priority, , R
ListLines Off
SetWorkingDir %A_ScriptDir%
SetKeyDelay,-1, 1
SetControlDelay, -1
SetBatchLines,-1

RunAsAdmin()

Global ScreenWidth := A_ScreenWidth, ScreenHeight := A_ScreenHeight, CurrentTime := A_TickCount, Center_X := ScreenWidth // 2+1, Center_Y := ScreenHeight // 2+1
Global sens := 1.8, Zoomsens := 0.75, reaction_min := 25, reaction_max := 100, RFL := 50, RFH := 80, Speed:= 1
Global CrossHairTrans := 220, SelectedCrosshair := "+",CrossHairSize := 20, CrossHairColor:= "BA000"
Global Magnifier := False, Zoom := 1.5, Size := 30, Delay := 10

Global key_AK := "Numpad1", Key_M4A1 := "Numpad2", Key_M4A4 := "Numpad3", Key_Famas := "Numpad4", Key_Galil := "Numpad5", Key_UMP := "Numpad6", Key_AUG := "Numpad7", Key_SG := "Numpad8", Key_UniversalRCS:= "Numpad9", Key_RCoff := "Numpad0", key_180 := "v", Key_shoot := "LButton", Key_Zoom := "Alt", Key_RapidFire := "XButton1", Key_PixelBot := "XButton2", Key_BHOP := "Space", Key_Duck := "c", Key_Safety:= "b", Key_Magnifier:= "0",CurrentPattern := ""

Global BHOPT := False, RapidFireT := False, TriggerBotT := False, TurnAroundT := False, AcceptT := False, CrosshairT := False, DuckT := False, RCSNotification := True, TriggerBotNotification := True, RecoilSafety:= False, UniversalRCS := False, Legit :=  False, Perfect := False, ScrollWheel := False

e1 :=  Chr(84) . Chr(72) . Chr(73) . Chr(83) . Chr(32) . Chr(83) . Chr(82) . Chr(73) . Chr(80) . Chr(84) . Chr(32) . Chr(73) . Chr(83) . Chr(32) . Chr(70) . Chr(82) . Chr(69) . Chr(69)

Version := "CS2 V1.5.9"
/*
Added ScrollWheel Hop
Added Text To Speech Function
Added Speech for Pause, Reload, Exit, notifications
Added Mouse Properties Button
Updated Settings.INI (Please delete older version)
Updated Save Extras not saving BHOP correctly
Updated Legit Hop | Perfect hop to be more accurate while human like.
Updated Crosshair Max Transparency From 225 -> 224 (Preventing PixelBot from shooting)
Updated Magnifier Transparency From 220 -> 200 (You can now see through Magnifier)
Updated Handling of all Check boxes to be handled through one subroute.
Updated Handling of all Buttons to be handled through one subroute.
Updated Launching of Main GUI
Updated RCS Notifications
Updated Universal RCS Randomization on X Axis (Human like pull down)
Updated Handling of RCS Arrays
Updated RCS to be more accurate | Famas, 
Updated Magnifier Deleting of previous frame
Updated Realtime priority to be useable for any PID or EXE with error checking
*/

VarSetCapacity(INPUT, 28)
VarSetCapacity(MOUSEINPUT, 24)
VarSetCapacity(KEYBDINPUT, 16)
VarSetCapacity(HARDWAREINPUT, 8)
VarSetCapacity(INPUT_union, 24)

StartSequence()
#Include Zoom.AHK
#Include Functions.AHK
#Include Crosshair.AHK

GuiVisible := False
~!F1::
if (GuiVisible) {
	GoSub GuiClose
	return
} Else {
    GoSub MainGui
	return
}
return

~!F2::ToggleScript(AcceptT, "Accept", 50, 600, 1600)
return

~!F3::
Magnifier:=!Magnifier
GoSub ZoomIN
CustomSave(Magnifier,"Toggle", "Magnifier")
If (GUIVisible) {
GoSub GuiClose
}
Return


MainGui:
if !GuiVisible {
DPMenu := "XButton1|XButton2|Z|X|C|Alt|Ctrl|CapsLock"
Tabs := "Recoil|PixelBot|RapidFire|Magnifier|Crosshair|Extras"
GuiVisible := true
ReadSettings()

Gui, +AlwaysOnTop  +Owner -MinimizeBox
Gui, Margin, 0, 0
Gui, Color, Black
Gui, Font, cWhite s14, Impact
Gui, Add, Button,x15 y400 w300 gButtonHandler, SAVE EVERYTHING
Gui, Add, Tab, xM+1 yM+1 Section w330 h400, %Tabs%

Gui, Add, GroupBox, xs+10 ys+55 Section  w160 H330,RCS
Gui, tab, Recoil
Gui, add, text, xs+5  ys+25, Sensitivity:
Gui, Add, Edit, xs+95  ys+23    w60 cBlack vSens1, %sens%
Gui, Add, Text, xs+5  ys+55 , AK-47:
Gui, Add, Hotkey, xs+55  ys+53   w100 vKey_AK, %Key_AK%
Gui, Add, Text, xs+5  ys+85 , M4A1:
Gui, Add, Hotkey, xs+55  ys+83    w100 vKey_M4A1, %Key_M4A1%
Gui, Add, Text, xs+5  ys+115, M4A4:
Gui, Add, Hotkey, xs+55  ys+113    w100 vKey_M4A4, %Key_M4A4%
Gui, Add, Text, xs+5  ys+145, Famas:
Gui, Add, Hotkey, xs+65  ys+143    w90 vKey_Famas, %Key_Famas%
Gui, Add, Text, xs+5  ys+175, Galil:
Gui, Add, Hotkey, xs+55  ys+173    w100 vKey_Galil, %Key_Galil%
Gui, Add, Text, xs+5  ys+205, UMP:
Gui, Add, Hotkey, xs+55  ys+203    w100 vKey_UMP, %Key_UMP%
Gui, Add, Text, xs+5  ys+235, AUG:
Gui, Add, Hotkey, xs+55  ys+233    w100 vKey_AUG, %Key_AUG%
Gui, Add, Text, xs+5  ys+265, SG:
Gui, Add, Hotkey, xs+55  ys+263    w100 vKey_SG, %Key_SG%
Gui, Add, Text, xs+5  ys+295, Recoil Off:
Gui, Add, Hotkey, xs+95  ys+293    w60 vKey_RCoff, %Key_RCoff%

Gui, Add, GroupBox, xs+160 ys+5 W150 H325,Other
Gui, Add, CheckBox, xS+170 ys+30 Checked%RCSNotification% gCheckBoxHandler, Notification

Gui, Add, CheckBox, xS+170 ys+60 Checked%RecoilSafety% gCheckBoxHandler, Recoil Safety
Gui, Add, Hotkey, xs+180  ys+83   w110 vKey_Safety, %Key_Safety%

Gui, Add, CheckBox, xS+170 ys+125 Checked%UniversalRCS% gCheckBoxHandler, Universal RCS
Gui, add, text, xs+170  ys+185, Hotkey:
Gui, Add, Hotkey, xs+170  ys+153   w60 vKey_UniversalRCS, %Key_UniversalRCS%
Gui, add, text, xs+250  ys+185, Speed:
Gui, Add, Edit, xs+250  ys+153    w50 cBlack vSpeed1, %Speed%

Gui, add, text, xs+180  ys+215, Zoom Hotkey:
Gui, Add, Hotkey, xs+180  ys+243   w110 vKey_Zoom, %Key_Zoom%

Gui Add, Button, xS+180 ys+280  w110 h40 gButtonHandler +0x8000, Save Recoil

Gui, Font, s20, Impact

Gui, tab, PixelBot
Gui, Add, CheckBox, xS+95 ys+30 Checked%TriggerBotT% gCheckBoxHandler, PixelBot
Gui, Add, Combobox, xS+80 ys+70 w150 vKey_PixelBot, %DPMenu%
GuiControl, Choose, Key_PixelBot, %Key_PixelBot%
Gui, Add, Text, xS+5 ys+120 h20 Center, Min:
Gui, Add, edit, xS+5 ys+150 cBlack vReactionMin, %reaction_min%
Gui, Add, Text, xS+240 ys+120 h20 Center, Max:
Gui, Add, edit, xS+240 ys+150 cBlack vReactionMax, %reaction_max%
GUI ADD, Text, xS+80 ys+130 c0xB0AE3B BackgroundTrans, Shoots When`nCenter Pixel`nChanges Color
Gui, Add, CheckBox, xS+35 ys+260 Checked%TriggerBotNotification% gCheckBoxHandler, PixelBot Notification
Gui Add, Button, xS+35 ys+305 w250 h30 gButtonHandler, Save Pixel Bot

Gui, tab, RapidFire
Gui, Add, CheckBox, xS+90 ys+30 Checked%RapidFireT% gCheckBoxHandler, RapidFire
Gui, Add, Combobox, xS+80 ys+70 w150 vKey_RapidFire, %DPMenu%
GuiControl, Choose, Key_RapidFire, %Key_RapidFire%
Gui, Add, Text, xS+5 ys+120 h20 Center, Min:
Gui, Add, edit, xS+5 ys+150 cBlack vRFL1, %RFL%
Gui, Add, Text, xS+240 ys+120 h20 Center, Max:
Gui, Add, edit, xS+240 ys+150 cBlack vRFH1, %RFH%
Gui Add, Button, xS+35 ys+305 w250 h30 gButtonHandler, Save Rapid Fire

Gui, Tab, Magnifier
Gui, Add, CheckBox, xS+50 ys+25  Checked%Magnifier% gCheckBoxHandler, Magnifing Glass
Gui, Add, Text, xS+5 ys+100 h20 Center, Zoom
Gui, Add, Edit, xS+5 ys+130 cBlack vZoom1, %Zoom%
Gui, Add, Text, xS+120 ys+100 h20 Center, Size
Gui, Add, Edit, xS+120 ys+130 cBlack vSize1, %Size%
Gui, Add, Text, xS+225 ys+100 h20 Center, Timer
Gui, Add, Edit, xS+225 ys+130 cBlack vDelay1, %Delay%
Gui, Add, Text, xS+25 ys+210 h20 Center c0x719FD0, Save otherwise`nSettings will not change.
Gui Add, Button, xS+35 ys+305 w250 h30  gButtonHandler, Save Magnifier

Gui, Tab, Crosshair
Gui, Add, CheckBox, xS+50 ys+25 Checked%CrosshairT% gCheckBoxHandler, CrossHair Toggle
Gui, Add, Text, xS+15 ys+80 h20 Center, Size:
Gui, Add, Edit, xS+70 ys+78 cBlack vCrosshairSize, %CrosshairSize%
Gui, Add, Text, xS+130 ys+80 h20 Center, Color:
Gui, Add, Edit, xS+200 ys+78 cBlack vCrossHairColor, %CrossHairColor%
Gui, Add, Text, xS+70 ys+140 h20 Center c0x719FD0, Select CrossHair
Gui Add, Button, xS+180 ys+180 w80 h30 gCrossHairMenu, Extras
Gui, Add, Button, xS+50  ys+180 w30 h30 gSelectCrosshair, ∙
Gui, Add, Button, xS+80 ys+180 w30 h30 gSelectCrosshair, +
Gui, Add, Button, xS+110 ys+180 w30 h30 gSelectCrosshair, ×
Gui, Add, Button, xS+140  ys+180 w30 h30 gSelectCrosshair, ¤
Gui, Add, Text, xS+80 ys+220 h20 Center c0x719FD0, Transparency
Gui, Add, Slider, xS+0 ys+260 W310 vCrossHairTrans gCrossHairTrans1 +ToolTip +Range0.0-224, %CrossHairTrans%
Gui Add, Button, xS+35 ys+305 w250 h30 gButtonHandler, Save CrossHair

Gui, tab, Extras
Gui, Add, CheckBox, xS+5 ys+25 Checked%TurnAroundT% gCheckBoxHandler, Turn Around
Gui, Add, Hotkey, xS+190 ys+20 w80 vkey_180, %Key_180%

Gui, Add, CheckBox, xS+5 ys+85 Checked%BHOPT% gCheckBoxHandler, BHOP
Gui, Add, Hotkey, xS+100 ys+80 w80 vKey_BHOP, %Key_BHOP%
Gui, Add, Radio, xS+5 ys+120 Checked%Legit% vLegit gBHOP_Handler, Legit
Gui, Add, Radio, xS+100 ys+120 Checked%Perfect% vPerfect gBHOP_Handler, Perfect
Gui, Add, Radio, xS+5 ys+150 Checked%ScrollWheel% vScrollWheel gBHOP_Handler, ScrollWheel

Gui, Add, CheckBox, xS+5 ys+200 Checked%DuckT% gCheckBoxHandler, Crouch Correction

Gui Add, Button, xS+35 ys+235 w250 h30 gButtonHandler, Mouse Properties
Gui Add, Button, xS+35 ys+270 w250 h30 gButtonHandler, Real Time Priority
Gui Add, Button, xS+35 ys+305 w250 h30 gButtonHandler, Save Extras

rty := [e1, Version]
iuy := 1
ahgdsfh := rty[iuy] . " " . Version
GoSub GUIBHOP
Gui, Show, x0 y0, %ahgdsfh%
Return
} Else {
Return
}

UniversalRCSNotification:
If (RCSNotification) {
ShowToolTip("Universal RCS | ON", , , 1)
} Else {
ShowToolTip("", , , 1)
}
If (!UniversalRCS) {
ShowToolTip("", , , 1)
}
return

PixelBotNotification:
If (!TriggerBotNotification) {
	ShowToolTip(, , 20, 2)
} 
If (TriggerBotT && TriggerBotNotification) {
	ShowToolTip("PixelBot | ON", , 20, 2)
}
If !TriggerBotT {
	ShowToolTip(, , 20, 2)
}
Return

CheckBoxHandler:
	if (GuiVisible) {
        if (A_GuiControl = "Universal RCS") {
            UniversalRCS:=!UniversalRCS
			CurrentPattern := "UniversalRCS"
			;CustomSave(CurrentPattern,"General", "CurrentPattern")
			Gosub, UniversalRCSNotification
		} else if (A_GuiControl = "Recoil Safety") {
			RecoilSafety:=!RecoilSafety
        } else if (A_GuiControl = "CrossHair Toggle") {
			CrossHairT:=!CrossHairT
			GoSub CrossHair
		} else if (A_GuiControl = "Magnifing Glass") {
			Magnifier:=!Magnifier
			GoSub ZoomIN
		} else if (A_GuiControl = "RapidFire") {
			RapidFireT := !RapidFireT
		} else if (A_GuiControl = "PixelBot") {
			TriggerBotT := !TriggerBotT
			Gosub PixelBotNotification
		} else if (A_GuiControl = "Notification") {
			RCSNotification := !RCSNotification
			Gosub, UniversalRCSNotification
		} else if (A_GuiControl = "PixelBot Notification") {
			TriggerBotNotification := !TriggerBotNotification
			Gosub PixelBotNotification
		} else if (A_GuiControl = "Turn Around") {
			TurnAroundT := !TurnAroundT
		} else if (A_GuiControl = "BHOP") {
			BHOPT := !BHOPT
			if (!BHOP) {
				Legit := 0, Perfect := 0, ScrollWheel := 0
			GoSub GUIBHOP
			} 
		} else if (A_GuiControl = "Crouch Correction") {
			DuckT := !DuckT
			If (DuckT) {
				MsgBox, 48, Warning, This is WIP. `nAll it does is slightly move mouse up on crouch and down on release.`nCurrent key bind  C
			}
		}
    } Else {
	Msgbox, Error Checkbox Handler. GUI not Visible.
	}
Return

BHOP_Handler:
    if (BHOPT) {
        if (A_GuiControl = "Legit") {
            Legit := 1, Perfect := 0, ScrollWheel := 0
		} else if (A_GuiControl = "Perfect") {
			Legit := 0, Perfect := 1, ScrollWheel := 0
        } else if (A_GuiControl = "ScrollWheel") {
			Legit := 0, Perfect := 0, ScrollWheel := 1
			Msgbox, Please have scroll wheel up and down set to jump in game.`n"Bind mwheeldown +jump;bind mwheelup +jump;bind space +jump"
		}
    } else {
        Legit := 0, Perfect := 0, ScrollWheel := 0
		GoSub, GUIBHOP
		Gosub GuiClose
        MsgBox, ,%ahgdsfh%, BHOP is toggled OFF. Please Toggle ON.
		Goto MainGui
    }
 Return
 
ButtonHandler:
	if (GuiVisible) {
		if (A_GuiControl = "Mouse Properties") {
			Run main.cpl  ; This opens the Mouse Properties window
        } else if (A_GuiControl = "Real Time Priority") {
            Gosub SelectProcess
        } else if (A_GuiControl = "SAVE EVERYTHING") {
            Gui, Submit
            hotkeys := [Key_AK, Key_M4A1, Key_M4A4, Key_Famas, Key_Galil, Key_UMP, Key_AUG, Key_SG, Key_RCoff, Key_RapidFire, Key_PixelBot, Key_BHOP, Key_Duck, Key_180, Key_Safety,Key_UniversalRCS]
            if (HasDuplicates(hotkeys)) {
                return
            }

            if (ReactionMin >= ReactionMax) {
                MsgBox, 48, Warning: Invalid Input | %ahgdsfh%, The minimum reaction time should be lower than the maximum reaction time.`nPlease make sure to enter a valid range.
                return
            }

            if (RFL1 >= RFH1) {
                MsgBox, 48, Warning: Invalid Input | %ahgdsfh%, The minimum reaction time should be lower than the maximum reaction time.`nPlease make sure to enter a valid range.
                return
            }

            global sens := Sens1, reaction_min := ReactionMin, reaction_max := ReactionMax, RFL := RFL1, RFH := RFH1, Zoom := Zoom1, Size := Size1, Delay := Delay1, Speed := Speed1
            MsgBox, 4, Do you want to Save?,THIS WILL SAVE ALL TOGGLE ON|OFF!`nSensitivity: %sens%`nAK: %Key_AK%`nM4A1: %Key_M4A1%`nM4A4: %Key_M4A4%`nFamas: %Key_Famas%`nGalil: %Key_Galil%`nUMP: %Key_UMP%`nAUG: %Key_AUG%`nSG: %Key_SG%`n180: %Key_180%`nRecoil Off: %Key_RCoff%`nBHOP Key: %Key_BHOP%`nRapidFire: %Key_RapidFire%`nRFMin: %RFL%`nRFMax: %RFH%`nTriggerBot: %Key_PixelBot%`nTBMin: %reaction_min%`nTBMax: %reaction_max%`nRCSNotification: %RCSNotification%`nPixelBot Notification: %TriggerBotNotification%`nPixelBot: %TriggerBotT%`nRapidFireT: %RapidFireT%`nCrossHairT: %CrossHairT%`nMagnifierT: %Magnifier%`nTurnAround Toggle: %TurnAroundT%`nTurn Around Key: %key_180%`nBHOP Toggle: %BHOPT%`nBHOP Key: %Key_BHOP%`nLegit: %Legit%`nPerfect: %Perfect%`nCrouch Correction Toggle: %DuckT%`nRecoilSafety: %RecoilSafety%`nUniversalRCS: %UniversalRCS%`nKey_UniversalRCS: %Key_UniversalRCS%`nSpeed: %Speed%`nZoom Key: %Key_Zoom%
            IfMsgBox Yes
                SaveSettings()
				Gosub GuiClose
            Return
            IfMsgBox NO
				Gosub GuiClose
            Return
        } else if (A_GuiControl = "SAVE RECOIL") {
            Gui, Submit
            hotkeys := [Key_AK, Key_M4A1, Key_M4A4, Key_Famas, Key_Galil, Key_UMP, Key_AUG, Key_SG, Key_RCoff, Key_RapidFire, Key_PixelBot, Key_BHOP, Key_Duck, Key_180, Key_Safety,Key_UniversalRCS]
            if (HasDuplicates(hotkeys)) {
                return
            }

            global sens := Sens1, Speed := Speed1
            MsgBox, 4, Do you want to Save?, Sensitivity: %sens%`nAK: %Key_AK%`nM4A1: %Key_M4A1%`nM4A4: %Key_M4A4%`nFamas: %Key_Famas%`nGalil: %Key_Galil%`nUMP: %Key_UMP%`nAUG: %Key_AUG%`nSG: %Key_SG%`nKey_UniversalRCS: %Key_UniversalRCS%`nRecoil Off: %Key_RCoff%`nNotification: %RCSNotification%`nRecoilSafety: %RecoilSafety%`nUniversalRCS: %UniversalRCS%`nSpeed: %Speed%`nZoom Key: %Key_Zoom%
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
                CustomSave(Key_Zoom, "Hotkeys", "Key_Zoom")
                CustomSave(sens, "General", "sens")
                CustomSave(Speed, "General", "Speed")
                CustomSave(RCSNotification,"Toggle", "RCSNotification")
                CustomSave(Key_UniversalRCS, "Hotkeys", "Key_UniversalRCS")
                CustomSave(UniversalRCS,"Toggle", "UniversalRCS")
				Gosub GuiClose
            Return
            IfMsgBox NO
				Gosub GuiClose
            Return
        } else if (A_GuiControl = "SAVE PIXEL BOT") {
            Gui, Submit
            hotkeys := [Key_AK, Key_M4A1, Key_M4A4, Key_Famas, Key_Galil, Key_UMP, Key_AUG, Key_SG, Key_RCoff, Key_RapidFire, Key_PixelBot, Key_BHOP, Key_Duck, Key_180, Key_Safety,Key_UniversalRCS]
            if (HasDuplicates(hotkeys)) {
                return
            }
            if (ReactionMin >= ReactionMax) {
                MsgBox, 48, Warning: Invalid Input | %ahgdsfh%, The minimum reaction time should be lower than the maximum reaction time.`nPlease make sure to enter a valid range.
                return
            }
            global reaction_min := ReactionMin, reaction_max := ReactionMax 
            MsgBox, 4, Do you want to Save?, Toggle State: %TriggerBotT%`nTriggerBot: %Key_PixelBot%`nTBMin: %reaction_min%`nTBMax: %reaction_max%`nNotification: %TriggerBotNotification%
            IfMsgBox Yes
                CustomSave(Key_PixelBot,"Hotkeys", "Key_PixelBot")
                CustomSave(reaction_min,"PixelBot", "reaction_min")
                CustomSave(reaction_max,"PixelBot", "reaction_max")
                CustomSave(TriggerBotT,"Toggle", "TriggerBotT")
                CustomSave(TriggerBotNotification,"Toggle", "TriggerBotNotification")
				Gosub GuiClose
			Return
            IfMsgBox NO
				Gosub GuiClose
            Return
        } else if (A_GuiControl = "SAVE RAPID FIRE") {
            Gui, Submit
            hotkeys := [Key_AK, Key_M4A1, Key_M4A4, Key_Famas, Key_Galil, Key_UMP, Key_AUG, Key_SG, Key_RCoff, Key_RapidFire, Key_PixelBot, Key_BHOP, Key_Duck, Key_180, Key_Safety,Key_UniversalRCS]
            if (HasDuplicates(hotkeys)) {
                return
            }
            if (RFL1 >= RFH1) {
                MsgBox, 48, Warning: Invalid Input | %ahgdsfh%, The minimum reaction time should be lower than the maximum reaction time.`nPlease make sure to enter a valid range.
                return
            }
            global RFL := RFL1, RFH := RFH1  
            MsgBox, 4, Do you want to Save?, Toggle State: %RapidFireT%`nRapidFire: %Key_RapidFire%`nRFMin: %RFL%`nRFMax: %RFH%
            IfMsgBox Yes
                CustomSave(Key_RapidFire,"Hotkeys", "Key_RapidFire")
                CustomSave(RFL,"RapidFire", "RFL")
                CustomSave(RFH,"RapidFire", "RFH")
                CustomSave(RapidFireT,"Toggle", "RapidFireT")
				Gosub GuiClose
            Return
            IfMsgBox NO
				Gosub GuiClose
            Return
        } else if (A_GuiControl = "SAVE Magnifier") {
            Gui, Submit
            global Zoom:=Zoom1, Size := Size1, Delay := Delay1
            MsgBox, 4, Do you want to Save?, Toggle State: %Magnifier%`nZoom: %Zoom%`nSize: %Size%`nDelay: %Delay%
            IfMsgBox Yes
                CustomSave(Zoom, "Magnifier", "Zoom")
                CustomSave(Size, "Magnifier", "Size")
                CustomSave(Delay, "Magnifier", "Delay")
                CustomSave(Magnifier, "Toggle", "Magnifier")
				If (Magnifier = 1) {
					Loop, 2
					{
						Magnifier:=!Magnifier
						Sleep, 1
						Gosub ZoomIN
					}
				}
				Gosub GuiClose
            Return
            IfMsgBox NO
				Gosub GuiClose
            Return
        } else if (A_GuiControl = "SAVE CrossHair") {
            Gui, Submit
            MsgBox, 4, Do you want to Save?, Toggle State: %CrossHairT%`nCrossHair: %SelectedCrosshair%`nCrossHair Trans: %CrossHairTrans%`nCrossHairSize: %CrossHairSize%`nCrossHairColor: %CrossHairColor%
            IfMsgBox Yes
                CustomSave(CrossHairTrans,"CrossHair", "CrossHairTrans")
                CustomSave(SelectedCrosshair,"CrossHair", "SelectedCrosshair")
                CustomSave(CrossHairSize,"CrossHair", "CrossHairSize")
                CustomSave(CrossHairColor,"CrossHair", "CrossHairColor")
                CustomSave(CrossHairT,"Toggle", "CrossHairT")
				Gosub GuiClose
            Return
            IfMsgBox NO
				Gosub GuiClose
            Return
        } else if (A_GuiControl = "Save Extras") {
            Gui, Submit
            hotkeys := [Key_AK, Key_M4A1, Key_M4A4, Key_Famas, Key_Galil, Key_UMP, Key_AUG, Key_SG, Key_RCoff, Key_RapidFire, Key_PixelBot, Key_BHOP, Key_Duck, Key_180, Key_Safety,Key_UniversalRCS]
            if (HasDuplicates(hotkeys)) {
                return 
            }
            MsgBox, 4, Do you want to Save?, TurnAround Toggle: %TurnAroundT%`nTurn Around Key: %key_180%`nBHOP Toggle: %BHOPT%`nBHOP Key: %Key_BHOP%`nLegit: %Legit%`nPerfect: %Perfect%`nScrollWheel: %ScrollWheel%`nCrouch Correction Toggle: %DuckT%
            IfMsgBox Yes
                CustomSave(Key_180,"Hotkeys", "Key_180")
                CustomSave(Key_BHOP,"Hotkeys", "Key_BHOP")
                CustomSave(TurnAroundT,"Toggle", "TurnAroundT")
                CustomSave(BHOPT,"Toggle", "BHOPT")
                CustomSave(Legit,"Toggle", "Legit")
                CustomSave(Perfect,"Toggle", "Perfect")
                CustomSave(ScrollWheel,"Toggle", "ScrollWheel")
                CustomSave(DuckT,"Toggle", "DuckT")
				Gosub GuiClose
            Return
            IfMsgBox NO
				Gosub GuiClose
            Return
        }
    }
Return

GUIBHOP:
	GuiControl,, BHOP, % (BHOPT ? "1" : "0")
	GuiControl,, Legit, % (Legit ? "1" : "0")
	GuiControl,, Perfect, % (Perfect ? "1" : "0")
	GuiControl,, ScrollWheel, % (ScrollWheel ? "1" : "0")
Return

SelectProcess:
    InputBox, UserInput, Select Process, Enter a process name or PID:

    if (UserInput != "") {
        ; Check if user input is a numeric PID
        if (RegExMatch(UserInput, "^\d+$")) {
            PID := UserInput
            ExeName := GetProcessName(PID)
        } else {
            ExeName := UserInput
            ; Get the process ID based on the process name
            Process, Exist, %ExeName%
            PID := ErrorLevel
        }

        if (PID) {
            ; Open the process with PROCESS_QUERY_INFORMATION to check current priority
            hProcess := DllCall("OpenProcess", "uint", 0x0400, "int", false, "uint", PID)
            
            if (hProcess) {
                ; Get the process priority class
                PriorityClass := DllCall("GetPriorityClass", "uint", hProcess)
                
                if (PriorityClass = 0x00000080) {
                    ; Display message if the process is already running at Real Time priority
                    MsgBox, Process Selected, `nPID: %PID%`nName: %ExeName%`nAlready at Real Time Priority
                } else {
                    ; Set process priority to Real Time
                    if (DllCall("SetPriorityClass", "uint", hProcess, "uint", 0x00000080)) {
                        ; Display success message
                        MsgBox, Process Selected, `nPID: %PID%`nName: %ExeName%`nElevated to Real Time Priority
                    } else {
                        ; Display detailed error message if priority elevation fails
                        MsgBox, Error elevating priority for `nPID: %PID%`nName: %ExeName%`nLastError: %A_LastError%
                    }
                }

                ; Close the process handle
                DllCall("CloseHandle", "uint", hProcess)
            } else {
                ; Display error message if unable to open the process
                MsgBox, Error opening process for `nPID: %PID%`nName: %ExeName%`nLastError: %A_LastError%
            }
        } else {
            ; Display message if process name or PID not found
            MsgBox, Process not found`nName/PID: %UserInput%
        }
    } else {
        ; Display message if no process name or PID is entered
        Msgbox, No process name or PID entered.
    }
return

Accept:
If (AcceptT) {
    CenterXMin := ScreenWidth * 0.4500, CenterXMax := ScreenWidth * 0.5600
    CenterYMin := ScreenHeight * 0.4200, CenterYMax := ScreenHeight * 0.4500
    AcceptX := PilgrimMites(CenterXMin, CenterXMax), AcceptY := PilgrimMites(CenterYMin, CenterYMax)
    randomSpeed := Random(6, 12)
    PixelGetColor, colorA, %Center_X%, %Center_Y%, Fast
    PixelSearch,,, %Center_X%, %Center_Y%, %Center_X%, %Center_Y%, %colorA%, 2, Fast
    if (ErrorLevel = 1) {
        Mousegetpos, MouseX, MouseY, Window
        X1 := MouseX + Rand(10), Y1 := MouseY + Rand(10)
        sleep, Random(1000, 3000) 
        MouseMove, %AcceptX%, %AcceptY%, %randomSpeed%
		Sleep, Random(100, 500) 
        Click()
        sleep, Random(100, 500) 
        MouseMove, %X1%, %Y1%, %randomSpeed%
		sleep, Random(100, 500) 
        SetTimer, Accept, Off
		ShowToolTip("", , 40, 3)
		SoundBeep, %soundOff%, 300
        AcceptT := false
    }
}
Return

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
											IfMsgBox Ok
                                                Goto, prankMsgBox
												IfMsgBox Cancel
												run https://www.youtube.com/watch?v=dQw4w9WgXcQ
												Reload
}
Return

; Stop lurking through my code aint nothing good in here.

GuiClose:
GuiEscape:
    if (GuiVisible = true) {
        Gui, Destroy
		GuiVisible := False
    }
	GoSub Close2
	GoSub CloseVisuals
return

Close2:
    if (Gui2 = true) {
        Gui 2:Destroy
		Gui2 := False
    }
return

CloseVisuals:
ReadSettings()
if (CrossHairT = 0) {
    Gosub DestroyCrossHair
}
if (Magnifier = 0) {
    Gosub ZoomIN
}
Return

humanizer :=  0, waitdivider := 0

MainLoop() { 
loop {
Sleep, 1

While (TriggerBotT && GetKeyState(Key_PixelBot, "P"))  {
PixelGetColor, colorx, %Center_X%, %Center_Y%, Fast . A_IsCritical
PixelSearch, , , %Center_X%, %Center_Y%, %Center_X%, %Center_Y%, %colorx%, 3, Fast . A_IsCritical
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
While (BHOPT && GetKeyState(Key_BHOP, "P"))  {
if (Perfect=1)  {
	Sleep,10
	Send, {Space Down}
	Sleep,5
	Send, {Space Up}
	Sleep,10
	} ELSE {
	}
if (Legit=1) {
	Sleep,15
	Send, {Space Down}
	Sleep, Random(15,25)
	Send, {Space Up}
	Sleep, 15
	} ELSE {
	}
if (ScrollWheel=1) {
	Sleep, 1
	MouseClick, WheelDown
	Sleep, 1
	MouseClick, WheelUp
	Sleep, 1
	} ELSE {
	}
}
While (TurnAroundT && GetKeyState(Key_180, "P"))  {
modifier := 2.52/sens
    Random, chance, 0.0, 1.0
	PosNeg := chance <= 0.49 ? -1 : 1
		MoveMouse(PosNeg * 225 * modifier, Rand(1)*PosNeg) ;3249
		Loop, 7 {
        MoveMouse(PosNeg * 432 * modifier,0)
		}
		Sleep, Random(250,300)
}
While (DuckT && GetKeyState(Key_Duck, "P"))  {
ModifiedMove(Rand(1.0),-10,6)
		KeyWait, %key_Duck%, L
ModifiedMove(Rand(1.0),10,6)
}

IfWinActive, ahk_exe cs2.exe
{
if GetKeyState(key_RCoff, "P")  {
CurrentPattern := "OFF"
;CustomSave(CurrentPattern,"General", "CurrentPattern")
GuiControl,, Universal RCS, % (UniversalRCS ? "1" : "0")
Sleep, 1
If (RCSNotification) {
ToolTip
Sleep, 1
ToolTip Recoil | Off, 0,0,1
Speak("Recoil OFF")
}
}
if GetKeyState(key_AK, "P")  {
CurrentPattern := "AK"
humanizer :=  3.8, waitdivider := 4.7

Sleep, 1
If (RCSNotification) {
ToolTip
Sleep, 1
ToolTip AK-47 | On, 0, 0,1
Sleep, 1
Speak("A K")
}
}
if GetKeyState(key_M4A1, "P")  {
CurrentPattern := "M4A1"
humanizer := 4.2, waitdivider := 4.17

Sleep, 1
If (RCSNotification) {
ToolTip
Sleep, 1
ToolTip M4A1 | On, 0,0,1
Sleep, 1
Speak("M 4 A 1")
}
}
if GetKeyState(key_M4A4, "P")  {
CurrentPattern := "M4A4"
humanizer88 := 3.80, humanizer := 3.64, waitdivider88 := 4.17, waitdivider := 4.13

Sleep, 1
If (RCSNotification) {
ToolTip
Sleep, 1
ToolTip M4A4 | On, 0,0,1
Sleep, 1
Speak("M 4 A 4")
}
}
if GetKeyState(key_Famas, "P")  {
CurrentPattern := "FAMAS"
humanizer :=  3.49, waitdivider := 4.10

Sleep, 1
If (RCSNotification) {
ToolTip
Sleep, 1
ToolTip Famas | On, 0,0,1
Sleep, 1
Speak("Famas")
}
}
if GetKeyState(key_Galil, "P")  {
CurrentPattern := "GALIL"
humanizer :=  3.95, waitdivider := 4.9

Sleep, 1
If (RCSNotification) {
ToolTip
Sleep, 1
ToolTip Galil | On, 0,0,1
Sleep, 1
Speak("Galil")
}
}
if GetKeyState(key_UMP, "P")  {
CurrentPattern := "UMP"
humanizer :=  3.85, waitdivider := 1

Sleep, 1
If (RCSNotification) {
ToolTip
Sleep, 1
ToolTip UMP | On, 0,0,1
Sleep, 1
Speak("UMP")
}
}
if GetKeyState(key_SG, "P")  {
CurrentPattern := "SG"
humanizer :=  4.2, waitdivider := 1

Sleep, 1
If (RCSNotification) {
ToolTip
Sleep, 1
ToolTip SG | On, 0,0,1
Sleep, 1
Speak("S G")
}
}
if GetKeyState(key_AUG, "P")  {
CurrentPattern := "AUG"
humanizer :=  4.2, waitdivider := 1

Sleep, 1
If (RCSNotification) {
ToolTip
Sleep, 1
ToolTip AUG | On, 0,0,1
Sleep, 1
Speak("AUG")
}
}
if GetKeyState(key_UniversalRCS, "P")  {
CurrentPattern := "UniversalRCS"
GuiControl,, Universal RCS, % (UniversalRCS ? "1" : "0")
Sleep, 1
If (RCSNotification) {
Gosub, UniversalRCSNotification
Sleep, 1
Speak("Universal R C S")
}
}

If (RecoilSafety) {
	If GetKeyState(Key_Safety, "P") {
		GoSub RCS
	}
		} Else {
			GoSub RCS 
		}
	} 
}

RCS:
While GetKeyState(key_shoot, "P")  {
modifier := PilgrimMites(2.51900,2.52000) / sens ; 2.52
if CurrentPattern = UniversalRCS 
{
	if !GetKeyState(key_shoot) {
		break
	}
	MoveMouse(Rand(TRandom(0,1.8))* modifier, 1 * modifier + Speed)
}

if CurrentPattern = AK
{
loop
{
sleep 50
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -14/humanizer*modifier, "UInt", 1/humanizer*modifier)
if !GetKeyState(key_shoot)
{
break
}
DllCall("user32.dll\mouse_event", uint, 4, int, 0, int, 0, uint, 0, int, 0)
sleep 1000
}
}

if CurrentPattern = M4A1
{
loop
{

sleep 15
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier-1, "UInt", 24/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier-1, "UInt", 24/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier-1, "UInt", 24/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 24/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -13/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -13/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -13/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -13/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 3/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 3/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 3/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 3/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 1/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 1/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 1/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 1/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", uint, 4, int, 0, int, 0, uint, 0, int, 0)
sleep 1000
}
}

if CurrentPattern = M4A4
{
loop
{

sleep 15
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -14/humanizer88*modifier, "UInt", 11/humanizer88*modifier) ;10
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -14/humanizer88*modifier, "UInt", 11/humanizer88*modifier)
sleep 88/waitdivider88d
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -14/humanizer88*modifier, "UInt", 11/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -14/humanizer88*modifier, "UInt", 11/humanizer88*modifier)
sleep 88/waitdivider88
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 12/humanizer88*modifier, "UInt", 2/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 12/humanizer88*modifier, "UInt", 2/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 12/humanizer88*modifier, "UInt", 2/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 12/humanizer88*modifier, "UInt", 2/humanizer88*modifier)
sleep 88/waitdivider88
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 10/humanizer88*modifier, "UInt", 6/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 10/humanizer88*modifier, "UInt", 6/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 10/humanizer88*modifier, "UInt", 6/humanizer88*modifier)
sleep 88/waitdivider88
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 10/humanizer88*modifier, "UInt", 6/humanizer88*modifier)
sleep 88/waitdivider88
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
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
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", -1/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", -1/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", -1/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", -1/humanizer*modifier)
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", uint, 4, int, 0, int, 0, uint, 0, int, 0)
sleep 1000
}
}

if CurrentPattern = FAMAS
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
if !GetKeyState(key_shoot) ; 5
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
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier, "UInt", 8/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier, "UInt", 8/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier, "UInt", 8/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier, "UInt", 8/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot) ; 10
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
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3.25/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3.25/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3.25/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3.25/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 87/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5.75/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5.75/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5.75/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5.75/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 1.5/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 1.5/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 1.5/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 1.5/humanizer*modifier)
sleep 88/waitdivider
if !GetKeyState(key_shoot) ; 15
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", -3/humanizer*modifier)
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
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 0/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 0/humanizer*modifier)
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
if !GetKeyState(key_shoot) ; 20
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -6.25/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -6.25/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -6.25/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -6.25/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 80/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 88/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 2/humanizer*modifier)
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
if !GetKeyState(key_shoot) ; 25
{

break
}
DllCall("user32.dll\mouse_event", uint, 4, int, 0, int, 0, uint, 0, int, 0)
sleep 1000
}
}

if CurrentPattern = GALIL
{
loop
{

sleep 10
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 3/humanizer*modifier, "UInt", 15/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 3/humanizer*modifier, "UInt", 15/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 3/humanizer*modifier, "UInt", 15/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 3/humanizer*modifier, "UInt", 15/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 21/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 21/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 21/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 21/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 2/humanizer*modifier, "UInt", 24/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 2/humanizer*modifier, "UInt", 24/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 2/humanizer*modifier, "UInt", 24/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 2/humanizer*modifier, "UInt", 24/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 16/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 16/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 16/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 16/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 11/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 11/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 11/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 11/humanizer*modifier, "UInt", 10/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 14/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 14/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 14/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 14/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -22/humanizer*modifier, "UInt", 8/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -22/humanizer*modifier, "UInt", 8/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -22/humanizer*modifier, "UInt", 8/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -22/humanizer*modifier, "UInt", 8/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -30/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -30/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -30/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -30/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -29/humanizer*modifier, "UInt", -13/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -29/humanizer*modifier, "UInt", -13/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -29/humanizer*modifier, "UInt", -13/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -29/humanizer*modifier, "UInt", -13/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 8/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 8/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 8/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 8/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -12/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -12/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -12/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -12/humanizer*modifier, "UInt", 2/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 50/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 50/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 50/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 50/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 4/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 25/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 25/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 25/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 25/humanizer*modifier, "UInt", 7/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 25/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 25/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 25/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 25/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 31/humanizer*modifier, "UInt", -9/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 31/humanizer*modifier, "UInt", -9/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 31/humanizer*modifier, "UInt", -9/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 31/humanizer*modifier, "UInt", -9/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -12/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -12/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -12/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -12/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 10/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 10/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 10/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 10/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 16/humanizer*modifier, "UInt", -4/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 16/humanizer*modifier, "UInt", -4/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 16/humanizer*modifier, "UInt", -4/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 16/humanizer*modifier, "UInt", -4/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{
break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -32/humanizer*modifier, "UInt", -5/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -32/humanizer*modifier, "UInt", -5/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -32/humanizer*modifier, "UInt", -5/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -32/humanizer*modifier, "UInt", -5/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -24/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -24/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -24/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -24/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -15/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -15/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -15/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -15/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 8/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 8/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 8/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier, "UInt", 8/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -14/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -14/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -14/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -14/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -24/humanizer*modifier, "UInt", -14/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -24/humanizer*modifier, "UInt", -14/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -24/humanizer*modifier, "UInt", -14/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -24/humanizer*modifier, "UInt", -14/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 90/waitdivider
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", uint, 4, int, 0, int, 0, uint, 0, int, 0)
sleep 1000
}
}

if CurrentPattern = UMP
{
loop
{
sleep 15
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 6/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 6/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 6/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 8/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 8/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 8/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 8/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier, "UInt", 18/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier, "UInt", 18/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier, "UInt", 18/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier, "UInt", 18/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 23/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 23/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 23/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 23/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 23/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 23/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 23/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier, "UInt", 23/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 26/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 26/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 26/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", 26/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 11/humanizer*modifier, "UInt", 17/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 11/humanizer*modifier, "UInt", 17/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 11/humanizer*modifier, "UInt", 17/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 11/humanizer*modifier, "UInt", 17/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 12/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 12/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 12/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier, "UInt", 12/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 9/humanizer*modifier, "UInt", 13/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 9/humanizer*modifier, "UInt", 13/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 9/humanizer*modifier, "UInt", 13/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 9/humanizer*modifier, "UInt", 13/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier, "UInt", 8/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier, "UInt", 8/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier, "UInt", 8/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier, "UInt", 8/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", 5/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", 5/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", 5/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", 5/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 3/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 3/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 3/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", 6/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", 6/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", 6/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 6/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 6/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 6/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 0/humanizer*modifier, "UInt", 6/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 9/humanizer*modifier, "UInt", -3/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 9/humanizer*modifier, "UInt", -3/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 9/humanizer*modifier, "UInt", -3/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 9/humanizer*modifier, "UInt", -3/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", -1/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", -1/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", -1/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -12/humanizer*modifier, "UInt", 4/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -12/humanizer*modifier, "UInt", 4/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -12/humanizer*modifier, "UInt", 4/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -12/humanizer*modifier, "UInt", 4/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -19/humanizer*modifier, "UInt", 1/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -19/humanizer*modifier, "UInt", 1/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -19/humanizer*modifier, "UInt", 1/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -19/humanizer*modifier, "UInt", 1/humanizer*modifier)
sleep 85/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", -2/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", -2/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", -2/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", -5/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", -5/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", -5/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier, "UInt", -5/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 17/humanizer*modifier, "UInt", -2/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 17/humanizer*modifier, "UInt", -2/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 17/humanizer*modifier, "UInt", -2/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 17/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 85/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier, "UInt", 3/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier, "UInt", 3/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier, "UInt", 3/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -20/humanizer*modifier, "UInt", -2/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -20/humanizer*modifier, "UInt", -2/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -20/humanizer*modifier, "UInt", -2/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -20/humanizer*modifier, "UInt", -2/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", -1/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", -1/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", -1/humanizer*modifier)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier, "UInt", -1/humanizer*modifier)
sleep 90/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", uint, 4, int, 0, int, 0, uint, 0, int, 0)
sleep 1000
}
}

if CurrentPattern = AUG
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
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 5/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
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
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier*obs, "UInt", 22/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier*obs, "UInt", 22/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier*obs, "UInt", 22/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier*obs, "UInt", 26/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier*obs, "UInt", 26/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier*obs, "UInt", 26/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier*obs, "UInt", 26/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 7.25/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 7.25/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 7.25/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 7.25/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 11/humanizer*modifier*obs, "UInt", 30/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 11/humanizer*modifier*obs, "UInt", 30/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 11/humanizer*modifier*obs, "UInt", 30/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 11/humanizer*modifier*obs, "UInt", 30/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 21/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 21/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 21/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 21/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 12/humanizer*modifier*obs, "UInt", 15/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 12/humanizer*modifier*obs, "UInt", 15/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 12/humanizer*modifier*obs, "UInt", 15/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 12/humanizer*modifier*obs, "UInt", 15/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 13/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 13/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 13/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 13/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -18/humanizer*modifier*obs, "UInt", 11/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -18/humanizer*modifier*obs, "UInt", 11/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -18/humanizer*modifier*obs, "UInt", 11/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -18/humanizer*modifier*obs, "UInt", 11/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -25/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -25/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -25/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -25/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier*obs, "UInt", 0/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier*obs, "UInt", 0/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier*obs, "UInt", 0/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 13/humanizer*modifier*obs, "UInt", 0/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 10/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 10/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 10/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 10/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -22/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -22/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -22/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -22/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -10/humanizer*modifier*obs, "UInt", -11/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -10/humanizer*modifier*obs, "UInt", -11/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -10/humanizer*modifier*obs, "UInt", -11/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -10/humanizer*modifier*obs, "UInt", -11/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -33/humanizer*modifier*obs, "UInt", -13/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -33/humanizer*modifier*obs, "UInt", -13/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -33/humanizer*modifier*obs, "UInt", -13/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -33/humanizer*modifier*obs, "UInt", -13/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier*obs, "UInt", 0/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier*obs, "UInt", 0/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier*obs, "UInt", 0/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier*obs, "UInt", 0/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 1/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 1/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 1/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 1/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier*obs, "UInt", 3/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier*obs, "UInt", 3/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier*obs, "UInt", 3/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier*obs, "UInt", 3/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier*obs, "UInt", 1/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier*obs, "UInt", 1/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier*obs, "UInt", 1/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier*obs, "UInt", 1/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 17/humanizer*modifier*obs, "UInt", -3/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 17/humanizer*modifier*obs, "UInt", -3/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 17/humanizer*modifier*obs, "UInt", -3/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 17/humanizer*modifier*obs, "UInt", -3/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 7.25/humanizer*modifier*obs, "UInt", -11/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 7.25/humanizer*modifier*obs, "UInt", -11/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 7.25/humanizer*modifier*obs, "UInt", -11/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 7.25/humanizer*modifier*obs, "UInt", -11/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 19/humanizer*modifier*obs, "UInt", 0/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 19/humanizer*modifier*obs, "UInt", 0/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 19/humanizer*modifier*obs, "UInt", 0/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 19/humanizer*modifier*obs, "UInt", 0/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -16/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -16/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -16/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -16/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -16/humanizer*modifier*obs, "UInt", 3/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -16/humanizer*modifier*obs, "UInt", 3/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -16/humanizer*modifier*obs, "UInt", 3/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -16/humanizer*modifier*obs, "UInt", 3/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier*obs, "UInt", 1/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier*obs, "UInt", 1/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -4/humanizer*modifier*obs, "UInt", 1/humanizer*modifier*obs)
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

if CurrentPattern = SG
{
if GetKeyState(key_Zoom) {
obs:=.80/Zoomsens
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
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier*obs, "UInt", 9/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier*obs, "UInt", 9/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -1/humanizer*modifier*obs, "UInt", 9/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3.25/humanizer*modifier*obs, "UInt", 3.75/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3.25/humanizer*modifier*obs, "UInt", 3.75/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3.25/humanizer*modifier*obs, "UInt", 3.75/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -3.25/humanizer*modifier*obs, "UInt", 3.75/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2.25/humanizer*modifier*obs, "UInt", 6.25/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2.25/humanizer*modifier*obs, "UInt", 6.25/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2.25/humanizer*modifier*obs, "UInt", 6.25/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2.25/humanizer*modifier*obs, "UInt", 6.25/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier*obs, "UInt", 29/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier*obs, "UInt", 29/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier*obs, "UInt", 29/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -6/humanizer*modifier*obs, "UInt", 29/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier*obs, "UInt", 31/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier*obs, "UInt", 31/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier*obs, "UInt", 31/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier*obs, "UInt", 31/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier*obs, "UInt", 36/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier*obs, "UInt", 36/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier*obs, "UInt", 36/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -7/humanizer*modifier*obs, "UInt", 36/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier*obs, "UInt", 14/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier*obs, "UInt", 14/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier*obs, "UInt", 14/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier*obs, "UInt", 14/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 17/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 17/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 17/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 17/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier*obs, "UInt", 12/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier*obs, "UInt", 12/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier*obs, "UInt", 12/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier*obs, "UInt", 12/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -15/humanizer*modifier*obs, "UInt", 8/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -15/humanizer*modifier*obs, "UInt", 8/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -15/humanizer*modifier*obs, "UInt", 8/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -15/humanizer*modifier*obs, "UInt", 8/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -5/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 6/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -8/humanizer*modifier*obs, "UInt", 6/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier*obs, "UInt", 11/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier*obs, "UInt", 11/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier*obs, "UInt", 11/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -2/humanizer*modifier*obs, "UInt", 11/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -18/humanizer*modifier*obs, "UInt", -6/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -18/humanizer*modifier*obs, "UInt", -6/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -18/humanizer*modifier*obs, "UInt", -6/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -18/humanizer*modifier*obs, "UInt", -6/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -26/humanizer*modifier*obs, "UInt", -17/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -26/humanizer*modifier*obs, "UInt", -17/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -26/humanizer*modifier*obs, "UInt", -17/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -26/humanizer*modifier*obs, "UInt", -17/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -18/humanizer*modifier*obs, "UInt", -9/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -18/humanizer*modifier*obs, "UInt", -9/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -18/humanizer*modifier*obs, "UInt", -9/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -18/humanizer*modifier*obs, "UInt", -9/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier*obs, "UInt", -2/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier*obs, "UInt", -2/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier*obs, "UInt", -2/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", -9/humanizer*modifier*obs, "UInt", -2/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 20/humanizer*modifier*obs, "UInt", 3/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 20/humanizer*modifier*obs, "UInt", 3/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 20/humanizer*modifier*obs, "UInt", 3/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 20/humanizer*modifier*obs, "UInt", 3/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 23/humanizer*modifier*obs, "UInt", -5/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 23/humanizer*modifier*obs, "UInt", -5/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 23/humanizer*modifier*obs, "UInt", -5/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 23/humanizer*modifier*obs, "UInt", -5/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 21/humanizer*modifier*obs, "UInt", -1/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 21/humanizer*modifier*obs, "UInt", -1/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 21/humanizer*modifier*obs, "UInt", -1/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 21/humanizer*modifier*obs, "UInt", -1/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier*obs, "UInt", 9/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier*obs, "UInt", 9/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier*obs, "UInt", 9/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 18/humanizer*modifier*obs, "UInt", 9/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 9/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 9/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 9/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 14/humanizer*modifier*obs, "UInt", 9/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 16/humanizer*modifier*obs, "UInt", 7/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 16/humanizer*modifier*obs, "UInt", 7/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 16/humanizer*modifier*obs, "UInt", 7/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 16/humanizer*modifier*obs, "UInt", 7/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 21/humanizer*modifier*obs, "UInt", -3/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 21/humanizer*modifier*obs, "UInt", -3/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 21/humanizer*modifier*obs, "UInt", -3/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 21/humanizer*modifier*obs, "UInt", -3/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 29/humanizer*modifier*obs, "UInt", -4/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 29/humanizer*modifier*obs, "UInt", -4/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 29/humanizer*modifier*obs, "UInt", -4/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 29/humanizer*modifier*obs, "UInt", -4/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 16/humanizer*modifier*obs, "UInt", 8/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 16/humanizer*modifier*obs, "UInt", 8/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 16/humanizer*modifier*obs, "UInt", 8/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 16/humanizer*modifier*obs, "UInt", 8/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 15/humanizer*modifier*obs, "UInt", 5/humanizer*modifier*obs)
sleep 99/waitdivider
if !GetKeyState(key_shoot)
{

break
}
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 38/humanizer*modifier*obs, "UInt", -5/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 38/humanizer*modifier*obs, "UInt", -5/humanizer*modifier*obs)
DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", 38/humanizer*modifier*obs, "UInt", -5/humanizer*modifier*obs)
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
}

Pause := False

Pause:: 
{
Pause := !Pause
if (Pause) {
	Sleep 100
    Speak("Paused")
	Sleep 100
	Pause
} Else {
	Sleep 100
	Speak("UnPaused")
	Sleep 100
	Pause
	}
	Return
}

#r::
Speak("Reloading Script")
Reload
Return

End::
Speak("Exiting Script")
ExitApp

;Welp you did it, you lurked on all this naked code. Pervert....