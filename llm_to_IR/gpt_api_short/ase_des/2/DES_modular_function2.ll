; ModuleID = 'rotl28'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: rotl28 ; Address: 0x1205
; Intent: rotate-left within 28-bit width (confidence=0.98). Evidence: mask to 28 bits and combine (val<<n) | (val>>(28-n))
; Preconditions: none (shift count is effectively masked to 0..31)
; Postconditions: return is masked to 28 bits

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local i32 @rotl28(i32 %a, i32 %n) local_unnamed_addr {
entry:
  %a28 = and i32 %a, 268435455                  ; 0x0FFFFFFF
  %nmask = and i32 %n, 31                       ; emulate x86 shift count semantics
  %shl = shl i32 %a28, %nmask
  %t = sub i32 28, %n
  %tmask = and i32 %t, 31
  %shr = lshr i32 %a28, %tmask
  %or = or i32 %shl, %shr
  %res = and i32 %or, 268435455                 ; keep within 28 bits
  ret i32 %res
}