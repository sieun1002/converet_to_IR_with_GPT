; ModuleID = 'sbox_lookup'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: sbox_lookup  ; Address: 0x11A9
; Intent: 8-bit S-box byte lookup (confidence=0.95). Evidence: byte-masked index; byte load from SBOX_1
; Preconditions: @SBOX_1 is at least 256 bytes; only low 8 bits of %idx are used
; Postconditions: returns zero-extended SBOX_1[%idx & 0xFF] as i32

@SBOX_1 = external global [256 x i8], align 1

define dso_local i32 @sbox_lookup(i32 %idx) local_unnamed_addr {
entry:
  %idx_tr = and i32 %idx, 255
  %idx64 = zext i32 %idx_tr to i64
  %eltptr = getelementptr inbounds [256 x i8], [256 x i8]* @SBOX_1, i64 0, i64 %idx64
  %val8 = load i8, i8* %eltptr, align 1
  %val32 = zext i8 %val8 to i32
  ret i32 %val32
}