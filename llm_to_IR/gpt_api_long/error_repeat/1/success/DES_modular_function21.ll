; ModuleID = 'rotl28'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: rotl28  ; Address: 0x1205
; Intent: rotate-left within 28-bit unsigned lane (confidence=0.95). Evidence: mask 0x0FFFFFFF and shifts by n and (28 - n)
; Preconditions: Prefer 0 <= n < 28 for conventional 28-bit rotation semantics.
; Postconditions: Result is masked to 28 bits.

define dso_local i32 @rotl28(i32 %v, i32 %n) local_unnamed_addr {
entry:
  %masked_v = and i32 %v, 268435455
  %shamt1 = and i32 %n, 31
  %l = shl i32 %masked_v, %shamt1
  %sub = sub i32 28, %n
  %shamt2 = and i32 %sub, 31
  %r = lshr i32 %masked_v, %shamt2
  %or = or i32 %l, %r
  %res = and i32 %or, 268435455
  ret i32 %res
}