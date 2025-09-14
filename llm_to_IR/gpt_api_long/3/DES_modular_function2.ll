; ModuleID = 'rotl28'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: rotl28  ; Address: 0x1205
; Intent: rotate-left within 28-bit field (confidence=0.95). Evidence: mask 0x0FFFFFFF; combine (v << s) | (v >> (28 - s))
; Preconditions: Shift counts are taken modulo 32 (x86 semantics).
; Postconditions: Result masked to 28 bits.

define dso_local i32 @rotl28(i32 %v, i32 %s) local_unnamed_addr {
entry:
  %v28 = and i32 %v, 268435455
  %s_mask = and i32 %s, 31
  %left = shl i32 %v28, %s_mask
  %sub = sub i32 28, %s
  %rcount = and i32 %sub, 31
  %right = lshr i32 %v28, %rcount
  %res = or i32 %left, %right
  %res28 = and i32 %res, 268435455
  ret i32 %res28
}