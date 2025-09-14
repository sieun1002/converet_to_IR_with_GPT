; ModuleID = 'sbox_lookup'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: sbox_lookup ; Address: 0x11A9
; Intent: Lookup SBOX_1[(uint8_t)input] and return the byte zero-extended to int (confidence=0.90). Evidence: uses low 8 bits (al), movzx on load
; Preconditions: @SBOX_1 has at least 256 bytes
; Postconditions: Returns a value in [0,255] from the S-box

; Only the necessary external declarations:

@SBOX_1 = external dso_local global [256 x i8]

define dso_local i32 @sbox_lookup(i32 %arg) local_unnamed_addr {
entry:
  %idx8 = trunc i32 %arg to i8
  %idx64 = zext i8 %idx8 to i64
  %eltptr = getelementptr inbounds [256 x i8], [256 x i8]* @SBOX_1, i64 0, i64 %idx64
  %val8 = load i8, i8* %eltptr, align 1
  %val32 = zext i8 %val8 to i32
  ret i32 %val32
}