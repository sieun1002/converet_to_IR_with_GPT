; ModuleID = 'sbox_lookup'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: sbox_lookup  ; Address: 0x11A9
; Intent: S-box lookup: return SBOX_1[x & 0xFF] (confidence=0.95). Evidence: masks input to 8-bit, indexes byte table SBOX_1
; Preconditions: @SBOX_1 has at least 256 bytes
; Postconditions: Return value in range [0,255]

@SBOX_1 = external dso_local global [256 x i8]

define dso_local i32 @sbox_lookup(i32 %x) local_unnamed_addr {
entry:
  %idx8 = trunc i32 %x to i8
  %idx = zext i8 %idx8 to i64
  %eltptr = getelementptr inbounds [256 x i8], [256 x i8]* @SBOX_1, i64 0, i64 %idx
  %val8 = load i8, i8* %eltptr, align 1
  %val = zext i8 %val8 to i32
  ret i32 %val
}