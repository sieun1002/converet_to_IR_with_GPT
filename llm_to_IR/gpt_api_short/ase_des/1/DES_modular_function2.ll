; ModuleID = 'rotl28'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: rotl28 ; Address: 0x1205
; Intent: 28-bit left rotate (confidence=0.95). Evidence: mask with 0x0FFFFFFF; use (x<<s)|(x>>(28-s))
; Preconditions: s ideally in [0,27] to model a true 28-bit rotation (x86 masks shifts by 31)
; Postconditions: result masked to 28 bits

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)

define dso_local i32 @rotl28(i32 %a, i32 %s) local_unnamed_addr {
entry:
  %x28 = and i32 %a, 268435455
  %s_shl = and i32 %s, 31
  %tmp = sub i32 28, %s
  %s_shr = and i32 %tmp, 31
  %l = shl i32 %x28, %s_shl
  %r = lshr i32 %x28, %s_shr
  %o = or i32 %l, %r
  %res = and i32 %o, 268435455
  ret i32 %res
}