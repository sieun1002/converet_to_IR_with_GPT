; ModuleID = 'rotl28'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: rotl28  ; Address: 0x1205
; Intent: 28-bit rotate-left of a value by a shift count (confidence=0.98). Evidence: mask 0x0FFFFFFF, combine (x<<s) with (x>>(28-s))
; Preconditions: Shift counts follow x86 semantics (masked to 0..31). For true 28-bit rotation semantics, pass 0..28.

define dso_local i32 @rotl28(i32 %x, i32 %s) local_unnamed_addr {
entry:
  %x28 = and i32 %x, 268435455
  %amt1 = and i32 %s, 31
  %shl = shl i32 %x28, %amt1
  %t = sub i32 28, %s
  %amt2 = and i32 %t, 31
  %shr = lshr i32 %x28, %amt2
  %or = or i32 %shl, %shr
  %res = and i32 %or, 268435455
  ret i32 %res
}