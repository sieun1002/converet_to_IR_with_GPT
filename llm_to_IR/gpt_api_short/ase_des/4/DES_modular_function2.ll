; ModuleID = 'rotl28'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: rotl28 ; Address: 0x1205
; Intent: rotate-left within 28-bit field (confidence=0.86). Evidence: mask with 0x0FFFFFFF; combine (x << s) | (x >> (28 - s)) with logical shift.
; Preconditions: shift in [0,28] for strict 28-bit rotate semantics; otherwise x86 shift-count mod 32 semantics apply.
; Postconditions: return value masked to 28 bits.

; Only the necessary external declarations:

; Use the IDA symbol here (e.g., @heap_sort or @main)
define dso_local i32 @rotl28(i32 %a, i32 %s) local_unnamed_addr {
entry:
  %a28 = and i32 %a, 268435455
  %s.mask = and i32 %s, 31
  %shl = shl i32 %a28, %s.mask
  %tmp = sub i32 28, %s
  %r.mask = and i32 %tmp, 31
  %lshr = lshr i32 %a28, %r.mask
  %or = or i32 %shl, %lshr
  %res = and i32 %or, 268435455
  ret i32 %res
}