; ModuleID = 'sbox_lookup'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: sbox_lookup ; Address: 0x11A9
; Intent: Byte lookup into SBOX_1 using low 8 bits of input (confidence=0.95). Evidence: uses only AL; loads byte from SBOX_1+index.
; Preconditions: None
; Postconditions: Returns zero-extended SBOX_1[(unsigned char)input]

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local i32 @sbox_lookup(i32 %x) local_unnamed_addr {
entry:
  %masked = and i32 %x, 255
  %idx = zext i32 %masked to i64
  %p = getelementptr i8, i8* @SBOX_1, i64 %idx
  %b = load i8, i8* %p, align 1
  %ret = zext i8 %b to i32
  ret i32 %ret
}

@SBOX_1 = external dso_local global i8