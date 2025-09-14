; ModuleID = 'sbox_lookup'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: sbox_lookup  ; Address: 0x11A9
; Intent: Lookup a byte from SBOX_1 by 8-bit index (confidence=0.93). Evidence: SBOX_1 symbol and byte-indexed movzx
; Preconditions: %x in [0,255]; @SBOX_1 contains at least 256 bytes
; Postconditions: returns the byte at @SBOX_1[%x]

@SBOX_1 = external global [256 x i8], align 1

define dso_local i8 @sbox_lookup(i8 %x) local_unnamed_addr {
entry:
  %idx = zext i8 %x to i64
  %p = getelementptr inbounds [256 x i8], [256 x i8]* @SBOX_1, i64 0, i64 %idx
  %v = load i8, i8* %p, align 1
  ret i8 %v
}