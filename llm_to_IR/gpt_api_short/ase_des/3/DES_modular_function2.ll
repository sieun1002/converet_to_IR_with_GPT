; ModuleID = 'rotl28'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: rotl28 ; Address: 0x1205
; Intent: 28-bit rotate-left (confidence=0.98). Evidence: mask 0x0FFFFFFF; shifts by s and (28 - s)
; Preconditions: None
; Postconditions: Returns ((x << (s&31)) | (x >> ((28 - (s&31)) & 31))) & 0x0FFFFFFF

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local i32 @rotl28(i32 %x, i32 %s) local_unnamed_addr {
entry:
  %x28 = and i32 %x, 268435455
  %s5 = and i32 %s, 31
  %shl = shl i32 %x28, %s5
  %tmp = sub i32 28, %s5
  %rs = and i32 %tmp, 31
  %shr = lshr i32 %x28, %rs
  %or = or i32 %shl, %shr
  %res = and i32 %or, 268435455
  ret i32 %res
}