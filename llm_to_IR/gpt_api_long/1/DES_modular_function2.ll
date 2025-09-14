; ModuleID = 'rotl28'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: rotl28  ; Address: 0x1205
; Intent: 28-bit rotate-left of a 32-bit value (confidence=0.95). Evidence: mask 0x0FFFFFFF and complementary shifts with (28 - s)
; Preconditions: For true 28-bit rotation, %s should be in [0,27]; otherwise shift counts are masked to 5 bits (x86 semantics).
; Postconditions: Return value is masked to 28 bits (0..268435455).

; Only the needed extern declarations:
; (none)

define dso_local i32 @rotl28(i32 %x, i32 %s) local_unnamed_addr {
entry:
  %masked = and i32 %x, 268435455
  %s_mask = and i32 %s, 31
  %left = shl i32 %masked, %s_mask
  %sub = sub i32 28, %s
  %rshift = and i32 %sub, 31
  %right = lshr i32 %masked, %rshift
  %or = or i32 %left, %right
  %res = and i32 %or, 268435455
  ret i32 %res
}