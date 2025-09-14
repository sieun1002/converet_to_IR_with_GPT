; ModuleID = 'rotl28'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: rotl28 ; Address: 0x1205
; Intent: 28-bit rotate-left (confidence=0.95). Evidence: mask with 0x0FFFFFFF and combine (val<<s) | (val>>(28-s))
; Preconditions: For canonical 28-bit rotation semantics, shift in [0,28]; otherwise behaves with x86 shift-count mod 32.
; Postconditions: Returns a 28-bit value (upper 4 bits cleared).

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local i32 @rotl28(i32 %value, i32 %shift) local_unnamed_addr {
entry:
  %v28 = and i32 %value, 268435455
  %sh1 = and i32 %shift, 31
  %lhs = shl i32 %v28, %sh1
  %sub = sub i32 28, %shift
  %sh2 = and i32 %sub, 31
  %rhs = lshr i32 %v28, %sh2
  %comb = or i32 %lhs, %rhs
  %res = and i32 %comb, 268435455
  ret i32 %res
}