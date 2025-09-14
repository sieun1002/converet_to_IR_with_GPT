; ModuleID = 'sbox_lookup'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: sbox_lookup ; Address: 0x11A9
; Intent: S-box byte substitution lookup (confidence=0.90). Evidence: accesses table named SBOX_1; masks index to 8 bits.

; Preconditions: SBOX_1 points to a contiguous table of at least 256 bytes.
; Postconditions: returns zero-extended byte SBOX_1[(uint8_t)input].

; Only the necessary external declarations:

@SBOX_1 = external global i8

define dso_local i32 @sbox_lookup(i32 %arg) local_unnamed_addr {
entry:
  %trunc = trunc i32 %arg to i8
  %idx = zext i8 %trunc to i64
  %ptr = getelementptr inbounds i8, i8* @SBOX_1, i64 %idx
  %val = load i8, i8* %ptr, align 1
  %z = zext i8 %val to i32
  ret i32 %z
}