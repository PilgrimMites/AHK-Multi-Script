A_Key := "VK65", B_Key := "VK66", C_Key := "VK67", D_Key := "VK68", E_Key := "VK69", F_Key := "VK70", G_Key := "VK71", H_Key := "VK72", I_Key := "VK73", J_Key := "VK74", K_Key := "VK75", L_Key := "VK76", M_Key := "VK77", N_Key := "VK78", O_Key := "VK79", P_Key := "VK80", Q_Key := "VK81", R_Key := "VK82", S_Key := "VK83", T_Key := "VK84", U_Key := "VK85", V_Key := "VK86", W_Key := "VK87", X_Key := "VK88", Y_Key := "VK89", Z_Key := "VK90"

PilgrimMites(M, H) {
Middle := ( M + H ) / 2
    Random, r1, 0, Middle - M, CurrentTime . A_IsCritical
    Random, r2, 0, H - Middle, CurrentTime . A_IsCritical
    Anchor := M + r1 + r2
    if (Anchor < M || Anchor > H) {
        MsgBox, 49, Anchor Error, % "Invalid anchor: " . Anchor . "`nRestarting`nPlease contact PilgrimMites if this message appears."
        Reload
    } else {
        Return Anchor
    }
}

Click() {
DllCall("user32.dll\mouse_event", uint, 0x0002, int, 0, int, 0, uint, 0, int, 0)
	Sleep, PilgrimMites(35.0, 60.0)
DllCall("user32.dll\mouse_event", uint, 0x0004, int, 0, int, 0, uint, 0, int, 0)
    Sleep, PilgrimMites(35.0, 60.0)
return
}

PictureCheck(image_path) {
if (FileExist(image_path)) {
	msgbox, Evee has been found!
	} else {
	url := "https://i.imgur.com/EPeUF8M.png"
	URLDownloadToFile, %url%, %image_path%
	if (ErrorLevel = 0) {
		MsgBox, , Evee has been found and saved successfully.
	} else {
		MsgBox, , Failed to save Evee. Error code: %ErrorLevel%
	}
	}
}
Return

HasDuplicates(arr) {
    disallowedHotkeys := ["^r", "End", "Pause"] ; List of disallowed hotkeys
    unique := {}
    
    for index, value in arr {
        if (unique.HasKey(value)) {
            return true
        }
        
        ; Check if the current value is a disallowed hotkey
        for _, hotkey in disallowedHotkeys {
            if (value = hotkey) {
                return true
            }
        }
        
        unique[value] := true
    }
    
    return false
}

ToggleScript(ByRef Script,timerName, timerInterval, soundOff, soundON) {
    if (CurrentTime - last_toggle_time >= cooldown_duration) {
        last_toggle_time := CurrentTime
        if (Script) {
			If (AcceptT) {
			ToolTip, , , ,2
			}
            Script := false
            SetTimer, %timerName%, Off
            SoundBeep, %soundOff%, 300
        } else {
            Script := true
            SetTimer, %timerName%, %timerInterval%
            SoundBeep, %soundON%, 300
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
        IniRead, Key_Hold1, Settings.ini, Hotkeys, Key_Hold1, %Key_Hold1%
        IniRead, Key_Hold2, Settings.ini, Hotkeys, Key_Hold2, %Key_Hold2%
		IniRead, Key_BHOP, Settings.ini, Hotkeys, Key_BHOP
		IniRead, reaction_min, Settings.ini, PixelBot, reaction_min
		IniRead, reaction_max, Settings.ini, PixelBot, reaction_max
		IniRead, CrossHairTrans, Settings.ini, CrossHair, CrossHairTrans
		IniRead, SelectedCrosshair, Settings.ini, CrossHair, SelectedCrosshair
		IniRead, CrossHairSize, Settings.ini, CrossHair, CrossHairSize
		IniRead, sens, Settings.ini, General, sens
		IniRead, zoomsens, Settings.ini, General, zoomsens
		IniRead, RFL, Settings.ini, RapidFire, RFL
		IniRead, RFH, Settings.ini, RapidFire, RFH
		IniRead, Zoom, Settings.ini, Magnifier, Zoom
		IniRead, Size, Settings.ini, Magnifier, Size
		IniRead, Delay, Settings.ini, Magnifier, Delay
		IniRead, RCSNotification, Settings.ini, Toggle, RCSNotification
		IniRead, TriggerBotNotification, Settings.ini, Toggle, TriggerBotNotification
		IniRead, Magnifier, Settings.ini, Toggle, Magnifier
		IniRead, DuckT, Settings.ini, Toggle, DuckT
		IniRead, TurnAroundT, Settings.ini, Toggle, TurnAroundT
		IniRead, TriggerBotT, Settings.ini, Toggle, TriggerBotT
		IniRead, RapidFireT, Settings.ini, Toggle, RapidFireT
		IniRead, BHOPT, Settings.ini, Toggle, BHOPT
		IniRead, CrossHairT, Settings.ini, Toggle, CrossHairT
    } else {
        MsgBox, Settings.ini does NOT exist.
    }
}

SaveSettings() {
    if (FileExist("Settings.ini")) {
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
        IniWrite, %Key_Hold1%, Settings.ini, Hotkeys, Key_Hold1
        IniWrite, %Key_Hold2%, Settings.ini, Hotkeys, Key_Hold2
		IniWrite, %Key_BHOP%, Settings.ini, Hotkeys, Key_BHOP
		IniWrite, %reaction_min%, Settings.ini, PixelBot, reaction_min
		IniWrite, %reaction_max%, Settings.ini, PixelBot, reaction_max
		IniWrite, %CrossHairTrans%, Settings.ini, CrossHair, CrossHairTrans
		IniWrite, %SelectedCrosshair%, Settings.ini, CrossHair, SelectedCrosshair
		IniWrite, %CrossHairSize%, Settings.ini, CrossHair, CrossHairSize
		IniWrite, %sens%, Settings.ini, General, sens
		IniWrite, %zoomsens%, Settings.ini, General, zoomsens
		IniWrite, %RFL%, Settings.ini, RapidFire, RFL
		IniWrite, %RFH%, Settings.ini, RapidFire, RFH
		IniWrite, %Zoom%, Settings.ini, Magnifier, zoom
		IniWrite, %Size%, Settings.ini, Magnifier, Size
		IniWrite, %Delay%, Settings.ini, Magnifier, Delay
		IniWrite, %RCSNotification%, Settings.ini, Toggle, RCSNotification
		IniWrite, %TriggerBotNotification%, Settings.ini, Toggle, TriggerBotNotification
		IniWrite, %Magnifier%, Settings.ini, Toggle, Magnifier
		IniWrite, %DuckT%, Settings.ini, Toggle, DuckT
		IniWrite, %TurnAroundT%, Settings.ini, Toggle, TurnAroundT
		IniWrite, %TriggerBotT%, Settings.ini, Toggle, TriggerBotT
		IniWrite, %RapidFireT%, Settings.ini, Toggle, RapidFireT
		IniWrite, %BHOPT%, Settings.ini, Toggle, BHOPT
		IniWrite, %CrossHairT%, Settings.ini, Toggle, CrossHairT
    } else {
        MsgBox, Settings.ini does NOT exist.
    }
}

CustomSave(Variable, Section, Name) {
    if (FileExist("Settings.ini")) {
        IniWrite, %Variable%, Settings.ini, %Section%, %Name%
    } else {
        MsgBox, Settings.ini does NOT exist.
    }
}

MoveMouse(x := 0,y := 0) {
    DllCall("user32.dll\mouse_event", "UInt", 0x01, "Int", x, "Int", y)
    Sleep 1
}

Random(min, max) {
        Random, randNum, min, max
    return randNum
}

Rand(range=8) {
    Random, r, -%range%, +%range%
    Return R
}

RunAsAdmin() {
	Global 0
	IfEqual, A_IsAdmin, 1, Return 0
	Loop, %0%
		params .= A_Space . %A_Index%
	DllCall("shell32\ShellExecute" (A_IsUnicode ? "":"A"),uint,0,str,"RunAs",str,(A_IsCompiled ? A_ScriptFullPath : A_AhkPath),str,(A_IsCompiled ? "": """" . A_ScriptFullPath . """" . A_Space) params,str,A_WorkingDir,int,1)
	ExitApp
}