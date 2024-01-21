PilgrimMites(M, H) {
Middle := ( M + H ) / 2
    Random, r1, 0, Middle - M, A_Now . A_IsCritical . %A_TickCount%
    Random, r2, 0, H - Middle, A_Now . A_IsCritical . %A_TickCount%
    Anchor := M + r1 + r2
    if (Anchor < M || Anchor > H) {
        MsgBox, 49, Anchor Error, % "Invalid anchor: " . Anchor . "`nRestarting`nPlease contact PilgrimMites if this message appears."
        Reload
    } else {
        Return Anchor
    }
}

Click(Delay_Min:=35.0, Delay_Max:=60.0,SpamPrevent_Min:=35.0,SpamPrevent_Max:=60.0) {
DllCall("user32.dll\mouse_event", uint, 0x0002, int, 0, int, 0, uint, 0, int, 0)
	Sleep, PilgrimMites(Delay_Min, Delay_Max)
DllCall("user32.dll\mouse_event", uint, 0x0004, int, 0, int, 0, uint, 0, int, 0)
    Sleep, PilgrimMites(SpamPrevent_Min, SpamPrevent_Max)
return
}

Random(min, max) {
	Random, R1, min, max
	Random, R2, max, min
	Random, R, R1, R2
	If (R > Min || R < Max) {
	return r
	}
}

Rand(range=8) {
    Random, r, -%range%, +%range%
    Return R
}

TRandom(min, max) {
target := (min + max) / 2
range := (max - min) * 0.28  ; calculate the range around the target value
min_range := target - range  ; calculate the minimum and maximum values within the range
max_range := target + range
Random, anchor, min_range, max_range, A_Now . A_IsCritical . %A_TickCount%
Return anchor  ; return the random value as the anchor point
}

MoveMouse(x := 0,y := 0) {
	Sleep 1
    DllCall("user32.dll\mouse_event", "UInt", 0x01, "Int", x, "Int", y)
}

ModifiedMove(x,y,LoopCount){
modifier := 2.52/sens
	Loop, %LoopCount% {
		MoveMouse(x * modifier, y * modifier)
	}
}

Speak(text, Volume := 100) {
    sp := ComObjCreate("SAPI.SpVoice")
    sp.Rate := 1.5
    sp.Volume := Volume
    sp.Speak(text)
    Return
}


MouseClick(button) {
    DllCall("mouse_event", uint, (button = "Left" ? 0x0002 : (button = "Right" ? 0x0008 : 0)), int, 0, int, 0, uint, 0, int, 0)
    Sleep, PilgrimMites(Delay_Min, Delay_Max)
    DllCall("mouse_event", uint, (button = "Left" ? 0x0004 : (button = "Right" ? 0x0010 : 0)), int, 0, int, 0, uint, 0, int, 0)
    Sleep, PilgrimMites(SpamPrevent_Min, SpamPrevent_Max)
}

MouseMove(X, Y) {
    MouseGetPos, CurrentX, CurrentY
    NewX := CurrentX + X
    NewY := CurrentY + Y
    distance := Sqrt((NewX - CurrentX)^2 + (NewY - CurrentY)^2)
    Loop, %distance% {
	MoveX:= (NewX - CurrentX) / distance
	MoveY:= (NewY - CurrentY) / distance
        MoveMouseR(MoveX, MoveY)
    }
}

MoveMouseR(dx, dy) {
    MouseGetPos, CurrentX, CurrentY
    NewX := (CurrentX + dx) 
    NewY := (CurrentY + dy) 
    DllCall("SetCursorPos", "int", NewX, "int", NewY)
    Sleep, Random(.1,2.0)
}

ShowToolTip(Text := "", X := 0, Y := 0, WhichToolTip := 1) {
    CoordMode, Tooltip, Screen  
    ;ToolTip, , , , %WhichToolTip%
    ToolTip, %Text%, %X%, %Y%, %WhichToolTip%, MonitorPrimary
}

MouseWheel(w) { ; send mouse wheel movement, pos=forwards neg=backwards
Sleep, 1
    DllCall("mouse_event", "UInt", 0x800, "UInt", 0, "UInt", 0, "UInt", %w%)
}

PictureCheck(image_path, URL) {
if (FileExist(image_path)) {
	} else {
	URLDownloadToFile, %url%, %image_path%
	msgbox, %image_path% downloaded from %url%
		if (ErrorLevel = 1) {
			MsgBox, , ERROR!,Failed to save %image_path%. Error code: %ErrorLevel%
		}
	}
}

ReadSettings() {
    if (FileExist("Settings.ini")) {
        IniRead, Key_AK, Settings.ini, Hotkeys, Key_AK, %Key_AK%
        IniRead, Key_M4A1, Settings.ini, Hotkeys, Key_M4A1, %Key_M4A1%
        IniRead, Key_M4A4, Settings.ini, Hotkeys, Key_M4A4, %Key_M4A4%
        IniRead, Key_Famas, Settings.ini, Hotkeys, Key_Famas, %Key_Famas%
        IniRead, Key_Galil, Settings.ini, Hotkeys, Key_Galil, %Key_Galil%
        IniRead, Key_UMP, Settings.ini, Hotkeys, Key_UMP, %Key_UMP%
        IniRead, Key_AUG, Settings.ini, Hotkeys, Key_AUG, %Key_AUG%
        IniRead, Key_SG, Settings.ini, Hotkeys, Key_SG, %Key_SG%
        IniRead, Key_180, Settings.ini, Hotkeys, Key_180, %Key_180%
        IniRead, Key_RCoff, Settings.ini, Hotkeys, Key_RCoff, %Key_RCoff%
        IniRead, Key_RapidFire, Settings.ini, Hotkeys, Key_RapidFire, %Key_RapidFire%
        IniRead, Key_PixelBot, Settings.ini, Hotkeys, Key_PixelBot, %Key_PixelBot%
		IniRead, Key_BHOP, Settings.ini, Hotkeys, Key_BHOP
		IniRead, Key_UniversalRCS, Settings.ini, Hotkeys, Key_UniversalRCS
		IniRead, reaction_min, Settings.ini, PixelBot, reaction_min
		IniRead, reaction_max, Settings.ini, PixelBot, reaction_max
		IniRead, CrossHairTrans, Settings.ini, CrossHair, CrossHairTrans
		IniRead, SelectedCrosshair, Settings.ini, CrossHair, SelectedCrosshair
		IniRead, CrossHairSize, Settings.ini, CrossHair, CrossHairSize
		IniRead, CrossHairColor, Settings.ini, CrossHair, CrossHairColor
		IniRead, sens, Settings.ini, General, sens
		IniRead, zoomsens, Settings.ini, General, zoomsens
		IniRead, Speed, Settings.ini, General, Speed
		IniRead, CurrentPattern, Settings.ini, General, CurrentPattern
		IniRead, RFL, Settings.ini, RapidFire, RFL
		IniRead, RFH, Settings.ini, RapidFire, RFH
		IniRead, Zoom, Settings.ini, Magnifier, Zoom
		IniRead, Size, Settings.ini, Magnifier, Size
		IniRead, Delay, Settings.ini, Magnifier, Delay
		IniRead, RCSNotification, Settings.ini, Toggle, RCSNotification
		IniRead, TriggerBotNotification, Settings.ini, Toggle, TriggerBotNotification
		IniRead, Magnifier, Settings.ini, Toggle, Magnifier
		IniRead, CrossHairT, Settings.ini, Toggle, CrossHairT
		IniRead, DuckT, Settings.ini, Toggle, DuckT
		IniRead, TurnAroundT, Settings.ini, Toggle, TurnAroundT
		IniRead, TriggerBotT, Settings.ini, Toggle, TriggerBotT
		IniRead, RapidFireT, Settings.ini, Toggle, RapidFireT
		IniRead, BHOPT, Settings.ini, Toggle, BHOPT
		IniRead, Legit, Settings.ini, Toggle, Legit
		IniRead, Perfect, Settings.ini, Toggle, Perfect
		IniRead, ScrollWheel, Settings.ini, Toggle, ScrollWheel
		IniRead, UniversalRCS, Settings.ini, Toggle, UniversalRCS
    } else {
        MsgBox, Settings.ini does NOT exist.
    }
}

SaveSettings() {
    if (FileExist("Settings.ini")) {
		IniWrite, %sens%, Settings.ini, General, sens
		IniWrite, %zoomsens%, Settings.ini, General, zoomsens
		IniWrite, %Speed%, Settings.ini, General, Speed
		IniWrite, %CurrentPattern%, Settings.ini, General, CurrentPattern
        IniWrite, %Key_AK%, Settings.ini, Hotkeys, Key_AK
        IniWrite, %Key_M4A1%, Settings.ini, Hotkeys, Key_M4A1
        IniWrite, %Key_M4A4%, Settings.ini, Hotkeys, Key_M4A4
        IniWrite, %Key_Famas%, Settings.ini, Hotkeys, Key_Famas
        IniWrite, %Key_Galil%, Settings.ini, Hotkeys, Key_Galil
        IniWrite, %Key_UMP%, Settings.ini, Hotkeys, Key_UMP
        IniWrite, %Key_AUG%, Settings.ini, Hotkeys, Key_AUG
        IniWrite, %Key_SG%, Settings.ini, Hotkeys, Key_SG
        IniWrite, %Key_180%, Settings.ini, Hotkeys, Key_180
        IniWrite, %Key_RCoff%, Settings.ini, Hotkeys, Key_RCoff
        IniWrite, %Key_RapidFire%, Settings.ini, Hotkeys, Key_RapidFire
        IniWrite, %Key_PixelBot%, Settings.ini, Hotkeys, Key_PixelBot
        IniWrite, %Key_Safety%, Settings.ini, Hotkeys, Key_Safety
		IniWrite, %Key_BHOP%, Settings.ini, Hotkeys, Key_BHOP
		IniWrite, %Key_UniversalRCS%, Settings.ini, Hotkeys, Key_UniversalRCS
		IniWrite, %reaction_min%, Settings.ini, PixelBot, reaction_min
		IniWrite, %reaction_max%, Settings.ini, PixelBot, reaction_max
		IniWrite, %CrossHairTrans%, Settings.ini, CrossHair, CrossHairTrans
		IniWrite, %SelectedCrosshair%, Settings.ini, CrossHair, SelectedCrosshair
		IniWrite, %CrossHairSize%, Settings.ini, CrossHair, CrossHairSize
		IniWrite, %CrossHairColor%, Settings.ini, CrossHair, CrossHairColor
		IniWrite, %RFL%, Settings.ini, RapidFire, RFL
		IniWrite, %RFH%, Settings.ini, RapidFire, RFH
		IniWrite, %Zoom%, Settings.ini, Magnifier, zoom
		IniWrite, %Size%, Settings.ini, Magnifier, Size
		IniWrite, %Delay%, Settings.ini, Magnifier, Delay
		IniWrite, %RCSNotification%, Settings.ini, Toggle, RCSNotification
		IniWrite, %TriggerBotNotification%, Settings.ini, Toggle, TriggerBotNotification
		IniWrite, %CrossHairT%, Settings.ini, Toggle, CrossHairT
		IniWrite, %Magnifier%, Settings.ini, Toggle, Magnifier
		IniWrite, %DuckT%, Settings.ini, Toggle, DuckT
		IniWrite, %TurnAroundT%, Settings.ini, Toggle, TurnAroundT
		IniWrite, %TriggerBotT%, Settings.ini, Toggle, TriggerBotT
		IniWrite, %RapidFireT%, Settings.ini, Toggle, RapidFireT
		IniWrite, %BHOPT%, Settings.ini, Toggle, BHOPT
		IniWrite, %Legit%, Settings.ini, Toggle, Legit
		IniWrite, %Perfect%, Settings.ini, Toggle, Perfect
		IniWrite, %ScrollWheel%, Settings.ini, Toggle, ScrollWheel
		IniWrite, %RecoilSafety%, Settings.ini, Toggle, RecoilSafety
		IniWrite, %UniversalRCS%, Settings.ini, Toggle, UniversalRCS

    } else {
        MsgBox, Settings.ini does NOT exist.
    }
}

CustomSave(Value, Section, Name) {
    if (FileExist("Settings.ini")) {
        IniWrite, %Value%, Settings.ini, %Section%, %Name%
    } else {
        MsgBox, Settings.ini does NOT exist.
    }
}

CustomRead(Value, Section, Name) {
    if (FileExist("Settings.ini")) {
        IniRead, %Value%, Settings.ini, %Section%, %Name%
    } else {
        MsgBox, Settings.ini does NOT exist.
    }
}

MoveMouseTest(xRadius := 0, yRadius := 1) {
        angle := Rand(1)  ; A_Index contains the current iteration.
        x := xRadius * Cos(angle)
        y := yRadius
        DllCall("user32.dll\mouse_event", "UInt", 0x01, "Int", x, "Int", y)
        Sleep Random(10.0,14.0)
}

RunAsAdmin() {
	Global 0
	IfEqual, A_IsAdmin, 1, Return 0
	Loop, %0%
		params .= A_Space . %A_Index%
	DllCall("shell32\ShellExecute" (A_IsUnicode ? "":"A"),uint,0,str,"RunAs",str,(A_IsCompiled ? A_ScriptFullPath : A_AhkPath),str,(A_IsCompiled ? "": """" . A_ScriptFullPath . """" . A_Space) params,str,A_WorkingDir,int,1)
	ExitApp
}

HasDuplicates(arr) {
    disallowedHotkeys := ["^r", "End", "Pause"] ; List of disallowed hotkeys
    unique := {}
    
    for index, value in arr {
        if (unique.HasKey(value)) {
		     MsgBox, 48, Duplicate Hotkeys Found, Duplicate hotkeys were found. Please make sure each hotkey is unique.
            return true
        }
        
        ; Check if the current value is a disallowed hotkey
        for _, hotkey in disallowedHotkeys {
            if (value = hotkey) {
			msgbox, This KeyBind is not Allowed, by PilgrimMites.
                return true
            }
        }
        
        unique[value] := true
    }
    
    return false
}

; Function to get process name based on PID
GetProcessName(PID) {
    Process, Exist, %PID%
    return (ErrorLevel) ? "Unknown Process Name" : ProcessName
}

ToggleScript(ByRef Script,timerName, timerInterval, soundOff, soundON) {
    if (CurrentTime - last_toggle_time >= cooldown_duration) {
        last_toggle_time := CurrentTime
        if (Script) {
			If  (AcceptT) {
				ShowToolTip("", , 40, 3)
			}
            Script := false
            SetTimer, %timerName%, Off
            SoundBeep, %soundOff%, 300
        } else {
			If  !(AcceptT) {
				ShowToolTip("AutoAccpt | ON", , 40, 3)
			}
            Script := true
            SetTimer, %timerName%, %timerInterval%
            SoundBeep, %soundON%, 300
        }
    }
}

StartSequence() {
;DO NOT TOUCH
if !FileExist("Settings.ini") {
	FileAppend, [PilgrimMites] Available @ " https://www.unknowncheats.me/forum/counter-strike-2-releases/605440-ahk-multiscript-peans-rcs.html " `n, Settings.ini
	SaveSettings()
	} Else {
	ReadSettings()
		if (CrosshairT) {
			Gosub CrossHair
		}
			if (Magnifier) {
				Gosub ZoomIN
			}
				If (TriggerBotT && TriggerBotNotification) {
					ShowToolTip("PixelBot | ON", , 20, 2)
				}
					If (UniversalRCS && RCSNotification) {
						ShowToolTip("Universal RCS | ON", , , 1)
					}
	IfExist, FBI_Evee.PNG
		Menu, Tray, Icon, FBI_Evee.PNG, ,1
	else
		MsgBox, 49, Agent Evee Status Report,Agent Evee IS MISSING!`nSTART THE HELICOPTER WE NEED TO FIND AGENT EVEE!!
		ifMsgBox ok
		{
		PictureCheck("FBI_Evee.png","https://i.imgur.com/EPeUF8M.png")
		MsgBox, , Agent Evee Status Report,The Helicopter found and saved Evee. Hazaah!
		}
		IfMsgBox Cancel
		{
		MsgBox, ,Evee's never die ... They're just MIA., You left Evee behind.`nMission Failed, we'll get'em next time.
		PictureCheck("FBI_Evee.png","https://i.imgur.com/EPeUF8M.png")
		MsgBox, , Agent Evee Status Report, The Helicopter found Evee, KIA they couldnt save her.
		}
}
ReadSettings()
MainLoop()
}