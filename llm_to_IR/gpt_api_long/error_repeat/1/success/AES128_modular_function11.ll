; ModuleID = 'sbox_lookup'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: sbox_lookup  ; Address: 0x11A9
; Intent: Lookup the byte at SBOX_1[ arg & 0xFF ] and return it as i32 (confidence=0.98). Evidence: zero-extend of AL, lea of SBOX_1, byte load indexed by RAX.
; Preconditions: SBOX_1 provides at least 256 bytes; only the low 8 bits of the input are used.
; Postconditions: Returns a value in [0,255].

@SBOX_1 = external dso_local global [256 x i8]

define dso_local i32 @sbox_lookup(i32 %x) local_unnamed_addr {
entry:
  %tr = trunc i32 %x to i8
  %idx = zext i8 %tr to i64
  %elem.ptr = getelementptr [256 x i8], [256 x i8]* @SBOX_1, i64 0, i64 %idx
  %val = load i8, i8* %elem.ptr, align 1
  %res = zext i8 %val to i32
  ret i32 %res
}