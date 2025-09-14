; ModuleID = 'sbox_lookup'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: sbox_lookup ; Address: 0x11A9
; Intent: Lookup a byte from SBOX_1 using low 8 bits of input (confidence=0.88). Evidence: mask to 8-bit, index into SBOX_1, zero-extend result.
; Preconditions: None (input masked to 8 bits).
; Postconditions: Returns a value in range [0, 255].

; Only the necessary external declarations:
; (none)

@SBOX_1 = external global [256 x i8], align 1

define dso_local i32 @sbox_lookup(i32 noundef %arg) local_unnamed_addr {
entry:
  %i8 = trunc i32 %arg to i8
  %idx = zext i8 %i8 to i64
  %p = getelementptr inbounds [256 x i8], [256 x i8]* @SBOX_1, i64 0, i64 %idx
  %val = load i8, i8* %p, align 1
  %z = zext i8 %val to i32
  ret i32 %z
}