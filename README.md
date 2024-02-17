# AHK-Multi-Script
# [Requires AHKv1](https://www.autohotkey.com/download/ahk-install.exe)

> Multi Script Written in AutoHotKey.
> Some Features can be used on any game.

 ```
I am still learning AHK and coding in general. Im just a year into coding so sorry if this is sloppy.
If you have code to share, or advice to give, Please contact me on UC.
All comments & questions should be posted on Main Thread.
Questions that can be answered in the ReadMe/HowTo will be ignored.
```

* [Main Thread](https://www.unknowncheats.me/forum/counter-strike-2-releases/605440-ahk-multiscript-peans-rcs.html) - UnknownCheats -
 `` Menu Preview``
  * ![](https://i.imgur.com/tN9YTre.png) ![](https://i.imgur.com/ExUlp4f.png)
# Hotkeys: keyboard shortcuts that have to be changed in Source.
* ``Menu:`` ***Shift + F1*** 
* ``AutoAccept:`` ***Shift + F2*** 
* ``Magnifier:`` ***Shift + F3*** 
  * ``Zoom IN/OUT`` ***Shift + Scroll Wheel Down/UP*** 
* ``CrossHair`` ***Shift + F4*** 
* ``Pause:`` ***Pause***
* ``Terminate:`` ***End***
* ``Restart:`` ***Windows key + R*** 



# GUI Toggle ON | OFF: CheckBox toggle for scripts.
* ``CrossHair`` (Tray Menu Toggle | Hotkeys)
* ``RapidFire``
* ``PixelBot`` (ToolTip Notification)
* ``TurnAround``
* ``BHOP`` (Bunny Hop) | Legit & Perfect & ScrollWheel
* ``CrouchCorrection`` (Work in Progress)
* ``Magnifying Glass`` (Tray Menu Toggle | Zoom IN/OUT Hotkeys)
* ``Notifications`` (Tool Tip & Speech)
* ``Universal RCS`` (Pulls mouse down in a human like movement)
* ``Recoil Safety`` (See Troubleshooting and Recommendations)

# Custom Keybinds: user-defined key bindings for specific in-game weapons or actions.
* ``Gun`` | ***Hotkey*** | **Accuracy**
* ``AK``: ***Numpad 1*** | **90%**
* ``M4A1``: ***Numpad 2*** | **95%**
* ``M4A4``: ***Numpad 3*** | **80%**
* ``Famas``: ***Numpad 4*** | **75%**
* ``Galil``: ***Numpad 5*** | **99%**
* ``UMP``: ***Numpad 6*** | **90%**
* ``AUG``: ***Numpad 7*** | **90% | Zoom 95%**
* ``SG``: ***Numpad 8*** | **75% | Zoom 85%**
* ``Universal RCS``: ***Numpad 9*** 
* ``RSCoff``: ***Numpad 0*** 
* ``TurnAround``: **V** 
* ``RapidFire``: ***XButton1*** 
* ``PixelBot``: ***XButton2***
* ``BHOP``: ***Space key*** 
* ``Recoil Safety``: ***B*** 

> [!IMPORTANT]
> # Troubleshooting and Recommendations
> * ``If Pixelbot Spamming try this.``
>   * Don't move mouse. This is pixelbot not triggerbot
>   * Disable FidelityFX Super Resolution
>   * Particle Detail | Low
>   * Dynamic Range | Performance
> * ``If Pixelbot is not shooting its because your ingame crosshair. You must lower the opacity or open the center.``
>   * " cl_crosshairalpha 0 - the crosshair is completely transparent (invisible) "
>   * " cl_crosshairalpha 127 - the crosshair is semi-transparent. "
>   * " cl_crosshairalpha 255 - the crosshair is nontransparent. "
>   * " cl_crosshairalpha 250 - the crosshair is slightly transparent (Mine).
> * ``Recoil to slow?``
>   * Adjust GunSelection("M4A4", 3.64, 4.13,"M4A4 | On" ) by .05 on the 2nd parameter.
>     * Go to Extras Tab Click Mouse Properties &
>     * Set windows mouse sensitivity to middle (50%)
>     * Disable Enhance pointer precision
> * ``If MENU has Errors, Delete Settings.ini.``
> * ``Download NotePad++ and open .AHK with NotePad++ @ the top youll see encoding. Set to UTF-8 LE BOM``
> * ``Recoil Safety requires the designated key to be pressed then left click, in that order to engage the selected recoil.``
