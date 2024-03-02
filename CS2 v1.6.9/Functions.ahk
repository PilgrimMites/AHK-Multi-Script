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

GunSelection(CurrentPattern1 := "", humanizer1 :=  0, waitdivider1 := 0,Notification = "" ) {
If (CurrentPattern1 != "") {
CurrentPattern:=CurrentPattern1, humanizer :=  humanizer1, waitdivider := waitdivider1
Sleep, 1
	If (RCSNotification) {
		ShowToolTip("", , , 1)
		Sleep, 1
		ShowToolTip(Notification, , , 1, 5)
		Sleep, 1
		Speak(CurrentPattern)
	}
	;CustomSave(CurrentPattern,"General", "CurrentPattern")
	Return
	} Else {
		MsgBox, 48, ERROR!, Gunselection Function needs the first parameter., 10
	}
}

RCS_Spray(pattern, actions) {
        loop {
            for each, action in actions {
                DllCall("user32.dll\mouse_event", "UInt", 0x01, "UInt", action[1]/humanizer*modifier, "UInt", action[2]/humanizer*modifier)
                sleep 99/waitdivider
                if !GetKeyState(key_shoot, "P") {
                    return  ; Exit function if key is released
                }
            }
            if !GetKeyState(key_shoot, "P") {
                break  ; Exit loop if key is released
            }
            DllCall("user32.dll\mouse_event", uint, 4, int, 0, int, 0, uint, 0, int, 0)
            sleep 1000
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
	} Else {
		MsgBox, 48, ERROR!,Failed Random %r%. `nError code: %ErrorLevel%
	}
}

Rand(range=8) {
    Random, r, -%range%, +%range%
    Return R
}

TRandom(min, max, value := 0.28) {
	target := (min + max) / 2
	range := (max - min) * value
	min_range := target - range 
	max_range := target + range
	Random, anchor, min_range, max_range, A_Now . A_IsCritical . %A_TickCount%
Return anchor
}

MoveMouse(x := 0,y := 0) {
Sleep 1
    DllCall("user32.dll\mouse_event", "UInt", 0x01, "Int", x, "Int", y)
}

ModifiedMove(x,y,LoopCount){
modifier := PilgrimMites(2.52000,2.52100) / sens ; 2.52
	Loop, %LoopCount% {
		MoveMouse(x * modifier, y * modifier)
	}
}

Speak(text, Volume = 90, Rate = 1.5, Gender = "Male") {
    if (SpeechT) {
        if (A_OSVersion > 10) {
			sp := ComObjCreate("SAPI.SpVoice")
			sp.Rate := Rate
			sp.Volume := Volume
			sp.Speak(text)
            return
        } else {
		    MsgBox, 48, %A_UserName%, Speech API Using alternative method.`nPlease let PilgrimMites know if you hear any speech.`nDelete line 121 in functions, 15
            speaker := ComObjCreate("SAPI.SpVoice")
            speaker.Rate := Rate
            speaker.Volume := Volume
            speaker.Speak(text)
            return
        }
    }
}


ShowToolTip(Text = "", X = 0, Y = 0, WhichToolTip1 = 1, Timer = 0) { 
    ToolTip, , , , %WhichToolTip1%
    ToolTip, %Text%, %X%, %Y%, %WhichToolTip1%, 0x20
	ToolTip := True
    if (Timer > 0) {
        SetTimer, HideToolTip, % Timer * 1000
		WhichToolTip:=WhichToolTip1
		return WhichToolTip, Text
    }
return
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

PictureCheck(Image_Name, URL) {
    if (FileExist(Image_Name)) {
        ; File already exists
    } else {
        Gui, PictureCheck: Add, Progress, vProgressRange cGreen w200, Downloading...
        Gui, PictureCheck: Add, Text, , Downloading %Image_Name%`nfrom %URL%
        Gui, PictureCheck: Show,, %A_UserName%
        Progress := 0 
        SetTimer, Update_Progress_Bar, 10 
        URLDownloadToFile, %URL%, %Image_Name%
		Sleep, 1*1000
        Gui, PictureCheck: Destroy
		    if (!FileExist(Image_Name)) {
				SetTimer, Update_Progress_Bar, Off
				MsgBox, 48, ERROR!, Failed to save %Image_Name%. Error code: %ErrorLevel%, 5
			}
		if (Image_Name = "FBI_Evee.png") {
			if (FileExist(Image_Name)) {
				MsgBox, , Agent Evee Status Report,The Helicopter found and saved Evee. Hazaah!
			}	
		} Else {
			if (FileExist(Image_Name)) {
				MsgBox, , %Image_Name% Status Report,The Helicopter found and saved %Image_Name%. Hazaah!
			}	
		}
			if (ErrorLevel = 1) {
				MsgBox, 48, ERROR!, Failed to save %Image_Name%. Error code: %ErrorLevel%, 5
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
		IniRead, MagnifierTrans, Settings.ini, Magnifier, MagnifierTrans
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
		IniRead, SpeechT, Settings.ini, Toggle, SpeechT
    } else {
        MsgBox, 4, Error,Settings.ini does NOT exist.`nWould you like to Create it?
		ifMsgBox, Yes 
		{
		Gosub FindSettings
		} else {
		Return
		}
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
		IniWrite, %MagnifierTrans%, Settings.ini, Magnifier, MagnifierTrans
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
		IniWrite, %SpeechT%, Settings.ini, Toggle, SpeechT

    } else {
        MsgBox, 4, Error,Settings.ini does NOT exist.`nWould you like to Create it?
		ifMsgBox, Yes 
		{
		Gosub FindSettings
		} else {
		Return
		}
    }
}

CustomSave(Value, Section, Name) {
    if (FileExist("Settings.ini")) {
        IniWrite, %Value%, Settings.ini, %Section%, %Name%
        if ErrorLevel
        {
            MsgBox, Error writing to Settings.ini. `n Error: %ErrorLevel%
        }
        else
        {
            ; MsgBox,,,Saving`nName : %Name%`nsection : %section%`nValue : %Value%, 1
        }
    } else {
        MsgBox, 4, Error, Settings.ini does NOT exist.`nWould you like to Create it?
        ifMsgBox, Yes 
        {
            Gosub FindSettings
        } else {
            Return
        }
    }
}

CustomRead(Value, Section, Name) {
    if (FileExist("Settings.ini")) {
        IniRead, %Value%, Settings.ini, %Section%, %Name%
		if ErrorLevel
        {
            MsgBox, Error writing to Settings.ini. `n Error: %ErrorLevel%
			
        }
        else
        {
            ; MsgBox,,,Reading`nName : %Name%`nsection : %section%`nValue : %Value%, 1


        }
    } else {
        MsgBox, 4, Error,Settings.ini does NOT exist.`nWould you like to Create it?
		ifMsgBox, Yes 
		{
		Gosub FindSettings
		} else {
		Return
		}
    }
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

StartSequence() { ; DO NOT TOUCH!!!!!!!!!!!!!!!
Menu, Tray, NoStandard ; to remove default menu
Menu, Tray, Add, Toggle Main Menu, ToggleGUI
Menu, Tray, Add, Toggle CrossHair, CrossHairToggler
Menu, Tray, Add, Toggle Magnifier, MagnifierToggler
Menu, Tray, Add, Elevate Priority, SelectProcess
Menu, Tray, Add, Reload Script, Reload
Menu, Tray, Add, Pause Script, Pause
Menu, Tray, Add, Hide Script, HideProcess
Menu, Tray, Add, Exit Script, ExitScript
Sleep, 1
if !FileExist("Settings.ini") {
	FileAppend, [PilgrimMites] Available @ " https://www.unknowncheats.me/forum/counter-strike-2-releases/605440-ahk-multiscript-peans-rcs.html " `n, Settings.ini
	Sleep, 1
	SaveSettings()
	Sleep, 1
	} Else {
		ReadSettings()
		Sleep, 1
		Gosub Zoomin
		Gosub,Crosshair
		Gosub PixelBotNotification
		Sleep, 1
		Gosub UniversalRCSNotification
		Sleep, 1
	IfExist, FBI_Evee.PNG
	{
		Menu, Tray, Icon, FBI_Evee.PNG, ,1
	} else {
		MsgBox, 49, Agent Evee Status Report,Agent Evee IS MISSING!`nSTART THE HELICOPTER WE NEED TO FIND AGENT EVEE!!
		ifMsgBox ok
		{
			PictureCheck("FBI_Evee.png","https://i.imgur.com/EPeUF8M.png")
		}
	}
	;IfNotExist, Background.jpg
	;{
	;PictureCheck("Background.jpg","https://i.imgur.com/xyQzMrR.jpeg")
	;MsgBox, , ,Background.jpg Downloaded, 5
	;}

}
Sleep, 1
MainLoop()
Return
}

/* 
GenerateRandomUUID() {
    Random, part1, 0, 0xFFFF
    Random, part2, 0, 0xFFFF
    Random, part3, 0, 0xFFFF
    Random, part4, 0, 0xFFFF
    part1 := Format("{:04X}", part1)
    part2 := Format("{:04X}", part2)
    part3 := Format("{:04X}", part3)
    part4 := Format("{:04X}", part4)
    UUID := part1 . part2 . part3 . part4
    ;MsgBox, New Randomized UUID: %UUID%
	return UUID

} 

isMouseShown() ;It suspends the script when mouse is visible (map, inventory, menu).
{
  StructSize := A_PtrSize + 16
  VarSetCapacity(InfoStruct, StructSize)
  NumPut(StructSize, InfoStruct)
  DllCall("GetCursorInfo", UInt, &InfoStruct)
  Result := NumGet(InfoStruct, 8)
 
  if Result > 1
    Return 1
  else
    Return 0
}
Loop
{
  if isMouseShown() == 1
    Suspend On
  else
    Suspend Off
    Sleep 1
}

English (United States): 409 or en-US
English (United Kingdom): 809 or en-GB
Spanish (Spain): 40A or es-ES
Spanish (Mexico): 80A or es-MX
French (France): 40C or fr-FR
French (Canada): C0C or fr-CA
German (Germany): 407 or de-DE
Italian (Italy): 410 or it-IT
Japanese: 411 or ja-JP
Chinese (Simplified): 804 or zh-CN
Chinese (Traditional): 404 or zh-TW

*/
