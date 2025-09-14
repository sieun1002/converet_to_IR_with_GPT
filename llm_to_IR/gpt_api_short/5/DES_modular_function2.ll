; ModuleID = 'rotl28'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: rotl28 ; Address: 0x1205
; Intent: 28-bit rotate-left (confidence=0.98). Evidence: mask to 28 bits; combine (x << n) with (x >> (28 - n)) then mask.
; Preconditions: Shift count is used modulo 32 (lower 5 bits). Typical intended range: 0..27.
; Postconditions: Return value is masked to 28 bits (0x0FFFFFFF).

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)

define dso_local i32 @rotl28(i32 %a, i32 %s) local_unnamed_addr {
entry:
  %a_mask = and i32 %a, 268435455
  %s_mask = and i32 %s, 31
  %shl = shl i32 %a_mask, %s_mask
  %t = sub i32 28, %s
  %t_mask = and i32 %t, 31
  %shr = lshr i32 %a_mask, %t_mask
  %or = or i32 %shl, %shr
  %res = and i32 %or, 268435455
  ret i32 %res
}