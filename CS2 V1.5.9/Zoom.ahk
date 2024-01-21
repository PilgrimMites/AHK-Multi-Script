
ZoomIN:
if (Magnifier) {
hwnd := WinExist("A")
	Rx := Size
    Ry := Size
    Zx := Rx / zoom
    Zy := Ry / zoom
	AW := center_x - Size
	AH :=  center_y + Size
    Gui, MagnifierGUI: +AlwaysOnTop +ToolWindow -Caption +E0x20
	Gui, MagnifierGUI:Show, % "w" . 2*Rx . " h" . 2*Ry . " x" . AW . " y" . AH , Magnifier
    WinGet, MagnifierID, ID, Magnifier
    WinSet, Transparent, 200, Magnifier
    SetTimer, Repaint, %Delay%
    Magnifier := True
WinActivate, ahk_id %hwnd%
} Else {
Gosub ZoomDelete
    Gui, MagnifierGUI:Destroy
    SetTimer, Repaint, Off
    Magnifier := false
}
return

ZoomDelete:
    DllCall("gdi32.dll\DeleteDC", UInt, hdc_frame)
    DllCall("gdi32.dll\DeleteDC", UInt, hdd_frame)
return

Repaint:
if (Magnifier) {
Gosub ZoomDelete
	xz := In(center_x-Zx, 0, ScreenWidth-2*Zx) ; Frame X
	yz := In(center_y-Zy, 0, ScreenHeight-2*Zy) ; Frame Y
    hdd_frame := DllCall("GetDC", UInt, PrintSourceID)
    hdc_frame := DllCall("GetDC", UInt, MagnifierID)
	DllCall("gdi32.dll\StretchBlt", UInt, hdc_frame, Int, 0, Int, 0, Int, 2*Rx, Int, 2*Ry, UInt, hdd_frame, UInt, xz, UInt, yz, Int, 2*Zx, Int, 2*Zy, UInt, 0xCC0020)
}
Return

In(x,a,b) {                      ; closest number to x in [a,b]
   IfLess x, %a%, Return a
   IfLess b, %x%, Return b
   Return x
}