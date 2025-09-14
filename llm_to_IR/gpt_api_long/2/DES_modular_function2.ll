; ModuleID = 'rotl28'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: rotl28  ; Address: 0x1205
; Intent: 28-bit left rotate within low 28 bits (confidence=0.98). Evidence: mask 0x0FFFFFFF, shifts by s and (28 - s)
; Preconditions: Shift counts follow x86 semantics (masked to 5 bits)
; Postconditions: Returns ((x & 0x0FFFFFFF) << (s&31) | (x & 0x0FFFFFFF) >> ((28 - s)&31)) & 0x0FFFFFFF

; Only the needed extern declarations:

define dso_local i32 @rotl28(i32 %x, i32 %s) local_unnamed_addr {
entry:
  %masked = and i32 %x, 268435455
  %shl_amt = and i32 %s, 31
  %shl = shl i32 %masked, %shl_amt
  %sub = sub i32 28, %s
  %shr_amt = and i32 %sub, 31
  %shr = lshr i32 %masked, %shr_amt
  %or = or i32 %shl, %shr
  %res = and i32 %or, 268435455
  ret i32 %res
}