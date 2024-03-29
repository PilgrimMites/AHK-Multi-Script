﻿CrossHairHWND := 0

CrossHair:
If (CrosshairT) {
GoSub CreateCrossHair
    } else {
GoSub DestroyCrossHair
    }
Return

CreateCrossHair:
	ActiveWindow := WinExist("A")
    Gui, CrossHair:new, -Caption +E0x80000 +LastFound +Owner +AlwaysOnTop +E0x20
	Gui, CrossHair:Margin, -1, -1
    Gui, CrossHair:Font, c%CrossHairColor% s%CrossHairSize% q4
    Gui, CrossHair:Add, Text, , %SelectedCrosshair%
	Controlgetpos, , , CrossHairW, CrossHairH, ,
	xPos  := (ScreenWidth//2 - CrossHairW//2 + 1)
	yPos  := (ScreenHeight//2 - CrossHairH//2 + 1 )
	Gui CrossHair:show, x%xPos% y%yPos% NA
    Gui, CrossHair:Color, 00FF00
    WinSet, TransColor, 00FF00 %CrossHairTrans%
	WinActivate, ahk_id %ActiveWindow%
    CrossHairT := true
	WinGet, CrossHairHWND, ID
return

DestroyCrossHair:
	Gui, CrossHair:Destroy
	CrossHairT:= false
Return

CrossHairMenu:
If !Gui2 {
Gui, 2: +LastFound  -MinimizeBox
Gui, 2: Show, w440 h95,CAUTION:
Gui, 2: Color, Black
Gui, 2: Add, Text, x50 y20 Center BackgroundTrans cRed, These CrossHairs WILL NOT Save Properly. USE WITH CAUTION!
Gui, 2: Add, Button, x0 y50 w22 h40 gSelectCrosshair, 🥚
Gui, 2: Add, Button, x22 y50 w22 h40 gSelectCrosshair, 👌
Gui, 2: Add, Button, x44 y50 w22 h40 gSelectCrosshair, ❤️
Gui, 2: Add, Button, x66 y50 w22 h40 gSelectCrosshair, 💀
Gui, 2: Add, Button, x88 y50 w22 h40 gSelectCrosshair, ☠️
Gui, 2: Add, Button, x110 y50 w22 h40 gSelectCrosshair, ❄️
Gui, 2: Add, Button, x132 y50 w22 h40 gSelectCrosshair, 🦄
Gui, 2: Add, Button, x154 y50 w22 h40 gSelectCrosshair, 👻
Gui, 2: Add, Button, x176 y50 w22 h40 gSelectCrosshair, ☺
Gui, 2: Add, Button, x198 y50 w22 h40 gSelectCrosshair, ○
Gui, 2: Add, Button, x220 y50 w22 h40 gSelectCrosshair, ◊
Gui, 2: Add, Button, x242 y50 w22 h40 gSelectCrosshair, ◎
Gui, 2: Add, Button, x264 y50 w22 h40 gSelectCrosshair, ⚔
Gui, 2: Add, Button, x286 y50 w22 h40 gSelectCrosshair, ☢
Gui, 2: Add, Button, x308 y50 w22 h40 gSelectCrosshair, ⚙
Gui, 2: Add, Button, x330 y50 w22 h40 gSelectCrosshair, ✜
Gui, 2: Add, Button, x352 y50 w22 h40 gSelectCrosshair, ✠
Gui, 2: Add, Button, x374 y50 w22 h40 gSelectCrosshair, ✣
Gui, 2: Add, Button, x396 y50 w22 h40 gSelectCrosshair, ✜
Gui, 2: Add, Button, x418 y50 w22 h40 gSelectCrosshair, ☭
Gui2 := true
return
	} Else {
	Gosub Close2
}
return

CrossHairTrans1:
if (CrossHairHWND) {
GuiControlGet, CrossHairTrans, , CrossHairTrans
WinSet, TransColor, 00FF00 %CrossHairTrans%, ahk_id %CrossHairHWND%
}
Return

SelectCrosshair:
If (CrosshairT) {
    SelectedCrosshair := A_GuiControl
    GuiControl,,SelectedCrosshair, %SelectedCrosshair%
	GoSub CreateCrossHair
	}
return

UpdateCrossHair:
GuiControlGet, CrossHairColor
GuiControlGet, CrossHairSize
GuiControl,, ColorSample, Font Sample
Gui, CrossHair:Font, c%CrossHairColor% s%CrossHairSize% q4
Return