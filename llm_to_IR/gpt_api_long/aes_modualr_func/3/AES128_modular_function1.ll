; ModuleID = 'sbox_lookup'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: sbox_lookup  ; Address: 0x11A9
; Intent: 8-bit S-box lookup from table SBOX_1 (confidence=0.95). Evidence: mask to 8-bit index; table byte load via symbol SBOX_1
; Preconditions: @SBOX_1 points to at least 256 contiguous bytes; only the low 8 bits of the input are used.
; Postconditions: Returns zero-extended 8-bit value from SBOX_1[input & 0xFF].

; Only the needed extern declarations:

@SBOX_1 = external dso_local global i8

define dso_local i32 @sbox_lookup(i32 %arg) local_unnamed_addr {
entry:
  %masked = and i32 %arg, 255
  %idx64 = zext i32 %masked to i64
  %ptr = getelementptr inbounds i8, i8* @SBOX_1, i64 %idx64
  %val = load i8, i8* %ptr, align 1
  %ret = zext i8 %val to i32
  ret i32 %ret
}