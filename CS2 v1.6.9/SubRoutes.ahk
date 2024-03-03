ToggleGUI:
if (GuiVisible) {
	GoSub GuiClose
} Else {
    GoSub MainGui
}
Return

MainGui:
if !GuiVisible {
		;Gui, Add, Picture, x1 y1 w330 h455, %A_ScriptDir%\Background.jpg	
	Menu, Tray, check, Toggle Main Menu
	DPMenu := "XButton1|XButton2|Z|X|C|Alt|Ctrl|CapsLock"
	Tabs := "Recoil|PixelBot|RapidFire|Magnifier|Crosshair|Extras"
	GuiVisible := true
	ReadSettings()
	
	Gui, +AlwaysOnTop  +Owner -MinimizeBox
	Gui, Margin, 0, 0
	Gui, Color, Black
	Gui, Font, cWhite s14, Impact
	;Gui, Add, Progress, x0 y400 w331 H41 Background404040 Disabled hwndHPROG
	Gui, Add, Button,x15 y400 w300 gButtonHandler, SAVE EVERYTHING
	Gui, Add, Tab, xM+1 yM+1 Section w330 h400 , %Tabs%
	Gui, Add, GroupBox, xs+10 ys+55 Section w160 H330,RCS
	Gui, tab, Recoil
	Gui, Add, text, xs+5  ys+25, Sensitivity:
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
	Gui, Add, text, xs+170  ys+185, Hotkey:
	Gui, Add, Hotkey, xs+170  ys+153   w60 vKey_UniversalRCS, %Key_UniversalRCS%
	Gui, Add, text, xs+250  ys+185, Speed:
	Gui, Add, Edit, xs+250  ys+153    w50 cBlack vSpeed1, %Speed%

	Gui, Add, text, xs+180  ys+215, Zoom Hotkey:
	Gui, Add, Hotkey, xs+180  ys+243   w110 vKey_Zoom, %Key_Zoom%

	Gui, Add, Button, xS+180 ys+280  w110 h40 gButtonHandler +0x8000, Save Recoil

	Gui, Font, s20, Impact

	Gui, tab, PixelBot
	Gui, Add, CheckBox, xS+95 ys+30 Checked%TriggerBotT% gCheckBoxHandler, PixelBot
	Gui, Add, Combobox, xS+80 ys+70 w150 vKey_PixelBot, %DPMenu%
	GuiControl, Choose, Key_PixelBot, %Key_PixelBot%
	Gui, Add, Text, xS+5 ys+120 h20 Center, Min:
	Gui, Add, edit, xS+5 ys+150 cBlack vReactionMin, %reaction_min%
	Gui, Add, Text, xS+240 ys+120 h20 Center, Max:
	Gui, Add, edit, xS+240 ys+150 cBlack vReactionMax, %reaction_max%
	GUI Add, Text, xS+80 ys+130 c0xB0AE3B BackgroundTrans, Shoots When`nCenter Pixel`nChanges Color
	Gui, Add, CheckBox, xS+35 ys+260 Checked%TriggerBotNotification% gCheckBoxHandler, PixelBot Notification
	Gui, Add, Button, xS+35 ys+305 w250 h30 gButtonHandler, Save Pixel Bot

	Gui, tab, RapidFire
	Gui, Add, CheckBox, xS+90 ys+30 Checked%RapidFireT% gCheckBoxHandler, RapidFire
	Gui, Add, Combobox, xS+80 ys+70 w150 vKey_RapidFire, %DPMenu%
	GuiControl, Choose, Key_RapidFire, %Key_RapidFire%
	Gui, Add, Text, xS+5 ys+120 h20 Center, Min:
	Gui, Add, edit, xS+5 ys+150 cBlack vRFL1, %RFL%
	Gui, Add, Text, xS+240 ys+120 h20 Center, Max:
	Gui, Add, edit, xS+240 ys+150 cBlack vRFH1, %RFH%
	Gui, Add, Button, xS+35 ys+305 w250 h30 gButtonHandler, Save Rapid Fire

	Gui, Tab, Magnifier
	Gui, Add, CheckBox, xS+50 ys+25  Checked%Magnifier% gCheckBoxHandler, Magnifing Glass
	Gui, Add, Text, xS+5 ys+70 h20 Center, Zoom
	Gui, Add, Edit, xS+5 ys+100 cBlack vZoom1, %Zoom%
	
	Gui, Add, Text, xS+120 ys+70 h20 Center, Size
	Gui, Add, Edit, xS+120 ys+100 cBlack vSize1, %Size%
	
	Gui, Add, Text, xS+225 ys+70 h20 Center, Timer
	Gui, Add, Edit, xS+225 ys+100 cBlack vDelay1, %Delay%
	Gui, Add, Text, xS+25 ys+150 h20 Center c0xB0AE3B, Save otherwise`nSettings will not change.
	Gui, Add, Text, xS+50 ys+220 h20 Center c0x719FD0, Transparency Slider
	Gui, Add, Slider, xS+0 ys+260 W310 vMagnifierTrans gMagnifierTrans1 +ToolTip +Range0.0-224, %MagnifierTrans%
	
	Gui, Add, Button, xS+35 ys+305 w250 h30  gButtonHandler, Save Magnifier

	Gui, Tab, Crosshair
	Gui, Add, CheckBox, xS+50 ys+25 Checked%CrosshairT% gCheckBoxHandler, CrossHair Toggle
	Gui, Add, Text, xS+15 ys+80 h20 Center, Size:
	Gui, Add, Edit, xS+70 ys+78 cBlack vCrosshairSize, %CrosshairSize%
	Gui, Add, Text, xS+130 ys+80 h20 Center, Color:
	Gui, Add, Edit, xS+200 ys+78 cBlack vCrossHairColor, %CrossHairColor%
	Gui, Add, Text, xS+70 ys+140 h20 Center c0x719FD0, Select CrossHair
	Gui, Add, Button, xS+180 ys+180 w80 h30 gCrossHairMenu, Extras
	Gui, Add, Button, xS+50  ys+180 w30 h30 gSelectCrosshair, ∙
	Gui, Add, Button, xS+80 ys+180 w30 h30 gSelectCrosshair, +
	Gui, Add, Button, xS+110 ys+180 w30 h30 gSelectCrosshair, ×
	Gui, Add, Button, xS+140  ys+180 w30 h30 gSelectCrosshair, ¤
	Gui, Add, Text, xS+50 ys+220 h20 Center c0x719FD0, Transparency Slider
	Gui, Add, Slider, xS+0 ys+260 W310 vCrossHairTrans gCrossHairTrans1 +ToolTip +Range0.0-224, %CrossHairTrans%
	Gui, Add, Button, xS+35 ys+305 w250 h30 gButtonHandler, Save CrossHair

	Gui, tab, Extras
	Gui, Add, CheckBox, xS+5 ys+25 Checked%TurnAroundT% gCheckBoxHandler, Turn Around
	Gui, Add, Hotkey, xS+190 ys+20 w80 vkey_180, %Key_180%

	Gui, Add, CheckBox, xS+5 ys+70 Checked%BHOPT% gCheckBoxHandler, BHOP
	Gui, Add, Hotkey, xS+100 ys+65 w80 vKey_BHOP, %Key_BHOP%
	Gui, Add, Radio, xS+5 ys+105 Checked%Legit% vLegit gBHOP_Handler, Legit
	Gui, Add, Radio, xS+100 ys+105 Checked%Perfect% vPerfect gBHOP_Handler, Perfect
	Gui, Add, Radio, xS+5 ys+135 Checked%ScrollWheel% vScrollWheel gBHOP_Handler, ScrollWheel


	Gui, Add, CheckBox, xS+5 ys+170 Checked%SpeechT% gCheckBoxHandler, Toggle Speech
	Gui, Add, CheckBox, xS+5 ys+200 Checked%DuckT% gCheckBoxHandler, Crouch Correction
	
	Gui, Add, Button, xS+35 ys+235 w125 h60 gButtonHandler, Mouse Properties
	Gui Add, Button, xS+185 ys+235 w100 h60 gSelectProcess, Elevate Priority
	Gui, Add, Button, xS+35 ys+305 w250 h30 gButtonHandler, Save Extras
	
	rty := [e1, Version, A143, ajmf0, Jam, Bananananana, shoe, cat]
	iuy := 1
	ahgdsfh := rty[iuy]"!" . " | " . Version
	GoSub GUIBHOP
	Gui, Show, x0 y0, %A_UserName% %ahgdsfh%


Return
} Else {
Return
}

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
 
UniversalRCSHandler:
if (CurrentPattern != "UniversalRCS") {
	UniversalRCS:=!UniversalRCS
	GuiControl,, Universal RCS, % (UniversalRCS ? "1" : "0")	
	GunSelection("UniversalRCS", 0, 0,"Universal R C S" )
	Gosub, UniversalRCSNotification
} Else {
	UniversalRCS:=!UniversalRCS
	GuiControl,, Universal RCS, % (UniversalRCS ? "1" : "0")	
	GunSelection("OFF", 0, 0,"Recoil | Off" )
	Gosub, UniversalRCSNotification
}
Return

UniversalRCSNotification:
If (RCSNotification && UniversalRCS = 1) {
	ShowToolTip("Universal R C S", , , 1)
} Else {
	ShowToolTip("", , , 1)
}
return

PixelBotNotification:
If (TriggerBotT && TriggerBotNotification) {
	ShowToolTip("PixelBot | ON", , 20, 2)
} Else {
	ShowToolTip(, , 20, 2)
} 
Return

CheckBoxHandler:
	if (GuiVisible) {
        if (A_GuiControl = "Universal RCS") {
			Gosub, UniversalRCSHandler
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
		} else if (A_GuiControl = "Toggle Speech") {
			SpeechT := !SpeechT
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
				MsgBox, 64, FYI, This is WIP. `nAll it does is slightly move mouse up on crouch and down on release.`nCurrent key bind  C, 5
			}
		}
    } Else {
		Msgbox, 48, Error!, Error Checkbox Handler. GUI not Visible., 5
	}
Return ; Toggle Speech

BHOP_Handler:
    if (BHOPT) {
        if (A_GuiControl = "Legit") {
			if (Legit = 0) {
				Legit := 1, Perfect := 0, ScrollWheel := 0
			}
		} else if (A_GuiControl = "Perfect") {
			if (Perfect = 0) {
				Legit := 0, Perfect := 1, ScrollWheel := 0
			}
        } else if (A_GuiControl = "ScrollWheel") {
			if (ScrollWheel = 0) {
				Legit := 0, Perfect := 0, ScrollWheel := 1
				Msgbox, 1, Bind Scroll Wheel IN-GAME,ScrollWheel BHOP will sometimes NOT work when BHOP is bound to spacebar!`n`n"Bind mwheeldown +jump;bind mwheelup +jump;bind space +jump"`n`nDo you want to copy to your Clipboard?,20
				IfMsgBox ok
				{
				Clipboard := "Bind mwheeldown +jump;bind mwheelup +jump;bind space +jump"
				}
			}
		}
    } else {
        Legit := 0, Perfect := 0, ScrollWheel := 0
		GoSub, GUIBHOP
        MsgBox, 64, %ahgdsfh%, BHOP is toggled OFF. Please Toggle ON., 3
    }
 Return
 
 GUIBHOP:
	GuiControl,, BHOP, % (BHOPT ? "1" : "0")
	GuiControl,, Legit, % (Legit ? "1" : "0")
	GuiControl,, Perfect, % (Perfect ? "1" : "0")
	GuiControl,, ScrollWheel, % (ScrollWheel ? "1" : "0")
Return
 
ButtonHandler:
	if (GuiVisible) {
        if (A_GuiControl = "SAVE EVERYTHING") {
            Gui, Submit
            hotkeys := [Key_AK, Key_M4A1, Key_M4A4, Key_Famas, Key_Galil, Key_UMP, Key_AUG, Key_SG, Key_RCoff, Key_RapidFire, Key_PixelBot, Key_BHOP, Key_Duck, Key_180, Key_Safety,Key_UniversalRCS]
            if (HasDuplicates(hotkeys)) {
                return
            }

            if (ReactionMin >= ReactionMax) {
                MsgBox, 48, Warning: Invalid Input | %ahgdsfh%, The minimum reaction time should be lower than the maximum reaction time.`nPlease make sure to enter a valid range., 5
                return
            }

            if (RFL1 >= RFH1) {
                MsgBox, 48, Warning: Invalid Input | %ahgdsfh%, The minimum reaction time should be lower than the maximum reaction time.`nPlease make sure to enter a valid range., 5
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
			Saving := [[Key_AK, "Hotkeys", "Key_AK"], [Key_M4A1, "Hotkeys", "Key_M4A1"], [Key_M4A4, "Hotkeys", "Key_M4A4"], [Key_Famas, "Hotkeys", "Key_Famas"], [Key_Galil, "Hotkeys", "Key_Galil"], [Key_UMP, "Hotkeys", "Key_UMP"], [Key_AUG, "Hotkeys", "Key_AUG"], [Key_SG, "Hotkeys", "Key_SG"], [Key_RCoff, "Hotkeys", "Key_RCoff"], [Key_Zoom, "Hotkeys", "Key_Zoom"], [sens, "General", "sens"],[Speed, "General", "Speed"],[RCSNotification, "Toggle", "RCSNotification"],[Key_UniversalRCS, "Hotkeys", "Key_UniversalRCS"],[UniversalRCS, "Toggle", "UniversalRCS"]]
				for index, Save in Saving {
					CustomSave(Save.1, Save.2, Save.3)
				}
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
                MsgBox, 48, Warning: Invalid Input | %ahgdsfh%, The minimum reaction time should be lower than the maximum reaction time.`nPlease make sure to enter a valid range., 5
                return
            }
            global reaction_min := ReactionMin, reaction_max := ReactionMax 
            MsgBox, 4, Do you want to Save?, Toggle State: %TriggerBotT%`nTriggerBot: %Key_PixelBot%`nTBMin: %reaction_min%`nTBMax: %reaction_max%`nNotification: %TriggerBotNotification%
            IfMsgBox Yes
				Saving := [[Key_PixelBot, "Hotkeys", "Key_PixelBot"], [reaction_min, "RapidFire", "reaction_min"], [reaction_max, "RapidFire", "reaction_max"], [TriggerBotT, "Toggle", "TriggerBotT"], [TriggerBotNotification, "Toggle", "TriggerBotNotification"]]
				for index, Save in Saving {
					CustomSave(Save.1, Save.2, Save.3)
				}
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
                MsgBox, 48, Warning: Invalid Input | %ahgdsfh%, The minimum reaction time should be lower than the maximum reaction time.`nPlease make sure to enter a valid range., 5
                return
            }
            global RFL := RFL1, RFH := RFH1  
            MsgBox, 4, Do you want to Save?, Toggle State: %RapidFireT%`nRapidFire: %Key_RapidFire%`nRFMin: %RFL%`nRFMax: %RFH%
            IfMsgBox Yes
				Saving := [[Key_RapidFire, "Hotkeys", "Key_RapidFire"], [RFL, "RapidFire", "RFL"], [RFH, "RapidFire", "RFH"], [RapidFireT, "Toggle", "RapidFireT"]]
				for index, Save in Saving {
					CustomSave(Save.1, Save.2, Save.3)
				}	
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
				Saving := [[Zoom, "Magnifier", "Zoom"], [Size, "Magnifier", "Size"], [Delay, "Magnifier", "Delay"], [Magnifier, "Toggle", "Magnifier"]]
				for index, Save in Saving {
					CustomSave(Save.1, Save.2, Save.3)

				}
				if (Magnifier) {
					GoSub DestroyZoomin
					GoSub CreateZoomIN
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
				Saving := [[CrossHairTrans, "CrossHair", "CrossHairTrans"], [SelectedCrosshair, "CrossHair", "SelectedCrosshair"], [CrossHairSize, "CrossHair", "CrossHairSize"], [CrossHairColor, "CrossHair", "CrossHairColor"], [CrossHairT, "Toggle", "CrossHairT"]]
				for index, Save in Saving {
					CustomSave(Save.1, Save.2, Save.3)
				}
				if (CrossHairT) {
					GoSub DestroyCrossHair
					GoSub CreateCrossHair
				}
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
            MsgBox, 4, Do you want to Save?, TurnAround Toggle: %TurnAroundT%`nTurn Around Key: %key_180%`nBHOP Toggle: %BHOPT%`nBHOP Key: %Key_BHOP%`nLegit: %Legit%`nPerfect: %Perfect%`nScrollWheel: %ScrollWheel%`nCrouch Correction Toggle: %DuckT%`nSpeech Toggle: %SpeechT%
            IfMsgBox Yes
				Saving := [[Key_180, "Hotkeys", "Key_180"], [Key_BHOP, "Hotkeys", "Key_BHOP"], [TurnAroundT, "Toggle", "TurnAroundT"], [BHOPT, "Toggle", "BHOPT"], [Legit, "Toggle", "Legit"], [Perfect, "Toggle", "Perfect"], [ScrollWheel, "Toggle", "ScrollWheel"], [DuckT, "Toggle", "DuckT"], [SpeechT, "Toggle", "SpeechT"]]
				for index, Save in Saving {
					CustomSave(Save.1, Save.2, Save.3)
				}

				Gosub GuiClose
            Return
            IfMsgBox NO
				Gosub GuiClose
            Return
        } else if (A_GuiControl = "Mouse Properties") {
			Run main.cpl  ; This opens the Mouse Properties window
        } else if (A_GuiControl = "Elevate Priority") {
			Gosub, SelectProcess
		}
    }
Return

FindSettings:
if !FileExist("Settings.ini") {
	FileAppend, [PilgrimMites] Available @ " https://www.unknowncheats.me/forum/counter-strike-2-releases/605440-ahk-multiscript-peans-rcs.html " `n, Settings.ini
	SaveSettings()
} Else {
MsgBox, 48,ERROR!,Settings already exist!, 5
}
Return

; Stop lurking through my code aint nothing good in here.

GuiClose:
GuiEscape:
if (GuiVisible = true) {
    Gui, Destroy
	Menu, Tray, Uncheck, Toggle Main Menu
	GuiVisible := False
}
	GoSub Close2
	GoSub Close_M_CH
return

Close2:
    if (Gui2 = true) {
        Gui 2:Destroy
		Gui2 := False
    }
return

Close_M_CH:
if (CrossHairT = 0) {
    Gosub DestroyCrossHair
}
if (Magnifier = 0) {
    Gosub DestroyZoomin
}
Return

ExitScript:
	Gosub GuiClose
	Gosub UnHook
	Speak("Exiting Script")
    ExitApp
return

UnHook:
    if (hHook) {
        DllCall("UnhookWindowsHookEx", Ptr, hHook)
        MsgBox, 64, Success, Process UnHooked!, 3
    } Else {
        ;MsgBox, 48,ERROR!,UnhookWindowsHookEx failed!, 5
    }
    if (hMod) {
        DllCall("FreeLibrary", Ptr, hMod)
		MsgBox, 64, Success, Library UnLoaded!, 3
    } Else {
        ;MsgBox, 48,ERROR!,Library unloaded failed!, 5
    }
Return

HideToolTip:
ShowToolTip("", 0, 40, 4)
SetTimer, HideToolTip, Off
ToolTip := False
return

SelectProcess:
InputBox, ExeName, Select Process, Enter a process Name(Exe) or PID:
    if (ExeName != "") {
        Process, Exist, %ExeName%       
        if (ErrorLevel) {
            PID := ErrorLevel
            hProcess := DllCall("OpenProcess", "uint", 0x1F0FFF, "int", false, "uint", PID)
            if (hProcess) {
                PriorityClass := DllCall("GetPriorityClass", "uint", hProcess)
                if (PriorityClass = 0x00000080) {
                    MsgBox, 64, Found!,Process Selected`nPID: %PID%`nName: %ExeName%`nAlready at Real Time Priority, 5
                } else {
                    if (DllCall("SetPriorityClass", "uint", hProcess, "uint", 0x00000080)) {
                        MsgBox, 64, Success!,Process Selected`nPID: %PID%`nName: %ExeName%`nElevated to Real Time Priority, 5
                    } else {
                        MsgBox, 48, Error!,Error elevating priority for `nPID: %PID%`nName: %ExeName%`nLastError: %A_LastError%`n 5 = Access Denied, 5
                    }
                }
                DllCall("CloseHandle", "uint", hProcess)
            } else {
                MsgBox, 48, Error,Error opening process for `nPID: %PID%`nName: %ExeName%`nLastError: %A_LastError%, 5
            }
        } else {
           MsgBox, 48, Error!,Process not found`nName/PID: %UserInput%, 5
        }
    } else {
        Msgbox, 32, Why you no enter name?,No process name or PID entered., 5
	}
return

HideProcess:
{
if ((A_Is64bitOS=1) && (A_PtrSize!=4))
        hMod := DllCall("LoadLibrary", Str, "hyde64.dll", Ptr)
    else if ((A_Is32bitOS=1) && (A_PtrSize=4))
        hMod := DllCall("LoadLibrary", Str, "hyde.dll", Ptr)
    else
    {
        MsgBox, 48,ERROR!,Mixed Versions detected!`nOS Version and AHK Version need to be the same (x86 & AHK32 or x64 & AHK64).`n`nScript will now Reload!, 5
        Goto, Reload
    }
 
    if (hMod)
    {
        hHook := DllCall("SetWindowsHookEx", Int, 5, Ptr, DllCall("GetProcAddress", Ptr, hMod, AStr, "CBProc", ptr), Ptr, hMod, Ptr, 0, Ptr)
        if (!hHook)
        {
            MsgBox, 48,ERROR!,SetWindowsHookEx failed!`nScript will now Reload!, 5
            Goto, Reload
        }
    }
    else
    {
        MsgBox, 48,ERROR!,LoadLibrary failed!`nScript will now Reload!, 5
        Goto, Reload
    }
 
    MsgBox, 64,SUCCESS!,% "Process ('" . A_ScriptName . "') hidden!", 5
}
return

PrankMsgBox:
If (GuiVisible) {
MsgBox, 49, bababooey, Please Run GAME First!
IfMsgBox Ok
    return
IfMsgBox Cancel
    MsgBox, 49, Are You Sure?, Do you want to Run this GAME?, 5
    IfMsgBox Ok
        MsgBox, 49, Just Do it!, What are you waiting for? The gnomes are getting restless!, 5
    IfMsgBox Cancel
        MsgBox, 49, %A_UserName% How the hell?, Still not pressing the magical "Run GAME" button, huh?, 5
        IfMsgBox Ok
            MsgBox, 49, %A_UserName% Start it already!, Alright, maybe it will start if you blink three times and hop on one foot!, 5
            IfMsgBox Cancel
                MsgBox, 49, %A_UserName% Really?, Seriously? Maybe you need to perform a secret dance!, 5
                IfMsgBox Ok
                    MsgBox, 49, %A_UserName% Its Go Time!, It's time for the legendary dance-off!, 5
                    IfMsgBox Cancel
                        MsgBox, 49, %A_UserName% Are You Sure?, You must really enjoy our chat., 5
                        IfMsgBox Ok
                            MsgBox, 49, %A_UserName% start it!, Your dedication to avoiding Gaming is impressive, but let's run it now!, 5
                            IfMsgBox Cancel
                                MsgBox, 49, Are You Sure?, Wafius are waiting for you! Maybe She's shy and needs an invitation?
                                IfMsgBox Ok
                                    MsgBox, 49, %A_UserName% Go start it!, The unicorn is waiting to grant your wish! You have to start the game first!, 5
                                    IfMsgBox Cancel
                                        MsgBox, 49, %A_UserName% Are You Sure?, You're testing the limits of my patience. Run the damn game already!, 5
                                        IfMsgBox Ok
                                            MsgBox, 49, %A_UserName% start it already!, The ninja turtles are on standby. They need action!, 5
											IfMsgBox Ok
                                                Goto, PrankMsgBox
												IfMsgBox Cancel
												run https://www.youtube.com/watch?v=dQw4w9WgXcQ
												Reload
}
Return

Pause:
{
Pause := !Pause
if (Pause) {
	Sleep 100
    Speak("Paused Script")
	Sleep 100
	Menu, Tray, check, Pause Script
	Pause
} Else {
	Sleep 100
	Speak("UnPaused Script")
	Sleep 100
	Menu, Tray, uncheck, Pause Script
	Pause
	}
}
Return

Reload:
	Sleep 100
	Speak("Reloading Script")
	Sleep 100
	Gosub, UnHook
	Reload
Return

Update_Progress_Bar:
    if (FileExist(Image_Name)) {
        GuiControl, PictureCheck:, ProgressRange, 100
			SetTimer, Update_Progress_Bar, Off
    } else {
        Progress += 2 
		GuiControl, PictureCheck:, ProgressRange, %Progress%
		If (Progress > 99) {
				SetTimer, Update_Progress_Bar, Off
		}
    }
Return

Pause:: Goto, Pause

#r::Goto, Reload

End::Goto, ExitScript
