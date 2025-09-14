; ModuleID = 'sbox_lookup'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: sbox_lookup ; Address: 0x11A9
; Intent: Byte-wise S-box lookup in SBOX_1 (confidence=0.96). Evidence: zero-extends AL, indexes SBOX_1, returns byte.
; Preconditions:
; Postconditions: Returns 0..255 (zero-extended)

@SBOX_1 = external global [256 x i8]

define dso_local i32 @sbox_lookup(i32 %arg) local_unnamed_addr {
entry:
  %al = trunc i32 %arg to i8
  %idx = zext i8 %al to i64
  %p = getelementptr inbounds [256 x i8], [256 x i8]* @SBOX_1, i64 0, i64 %idx
  %b = load i8, i8* %p, align 1
  %ret = zext i8 %b to i32
  ret i32 %ret
}