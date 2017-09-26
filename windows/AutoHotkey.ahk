; -*- comment-start: ";" -*-
; AutoHotkey.ahk

; 無変換キー
; +sc07B	::	Send {Browser_Forward}
; sc07B	::	Send {Browser_Back}
; Temporary change for ignoring ~~Edge's bug~~ ?????.
+sc07B	::	Send !{Right}
sc07B	::	Send, !{Left}

; 変換キー
!sc079	::	Send {ShiftDown}{CtrlDown}{Tab}{ShiftUp}{CtrlUp}
+sc079	::	Send {ShiftDown}{CtrlDown}{Tab}{ShiftUp}{CtrlUp}
sc079	::	Send {CtrlDown}{Tab}{CtrlUp}

; カタカナひらがなキー
; * デフォルトではカタカナひらがなキーは AHK で利用することが出来ないので
;   レジストリを変更して他のキーにリマップし，そのキーをフックする
;   今回は KeyTweak を使って `Macintosh= (NumpadClear)` に割り当てている．
+!sc059	::	Send, ^T
!sc059	::	Send, ^w
sc059 :: Clipboard := Clipboard
; not working. why?
; sc059 & h :: Send {Left}
; sc059 & j :: Send {Down}
; sc059 & k :: Send {Up}
; sc059 & l :: Send {Right}

;#space::Send, !{Space}
;+#space::Send, !{Space}
;^#space::Send, !{Space}

; not working
; sc029 :: Ctrl

; I love Apple :)
; #space::sc029
; when you are using English as Primary system language,
; you might want to "override" preferred input methods.
; check Control Panel\Clock, Language, and Region\Language\Advanced settings.

#space::
    if (A_PriorHotkey <> A_ThisHotkey or A_TimeSincePriorHotkey > 400) {
        ; Single press -> toggle IME (send Hankaku/zenkaku)
        Send, {sc029}
        return
    } else {
        ; Double press -> Original behavior
        ; (but also toggle IME back again... not cool hack)
        Send, {sc029}
        Send, #{space}
        return
    }

; #space::
;        Loop 500
;             Click
; #IfWinNotActive ahk_class Emacs
If WinNotActive ("ahk_class Emacs")
{
#IfWinNotActive ahk_title Emacs, ahk_class cygwin/x X rl
!sc14B :: Send, ^{Left}
!sc14D :: Send, ^{Right}
+!sc14B :: Send, +^{Left}
+!sc14D :: Send, +^{Right}
#IfWinNotActive
; #IfWinNotActive
}

vk02D ::

; this won't do; capslock will stick.
; CapsLock::Ctrl
; sc03a::Ctrl
