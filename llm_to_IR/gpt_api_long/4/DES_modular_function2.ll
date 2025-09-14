; ModuleID = 'rotl28'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: rotl28  ; Address: 0x1205
; Intent: 28-bit rotate-left by s (confidence=0.95). Evidence: mask 0x0FFFFFFF and combine (x<<s) | (x>>(28-s))
; Preconditions: Shift count follows x86 semantics (masked to 5 bits); typical intended range 0..27.
; Postconditions: Return value is masked to 28 bits.

define dso_local i32 @rotl28(i32 %x, i32 %s) local_unnamed_addr {
entry:
  %x28 = and i32 %x, 268435455
  %s_mask = and i32 %s, 31
  %shl = shl i32 %x28, %s_mask
  %tmp = sub i32 28, %s
  %neg_mask = and i32 %tmp, 31
  %shr = lshr i32 %x28, %neg_mask
  %or = or i32 %shr, %shl
  %res = and i32 %or, 268435455
  ret i32 %res
}