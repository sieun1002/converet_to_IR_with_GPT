; ModuleID = 'sbox_lookup'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: sbox_lookup  ; Address: 0x11A9
; Intent: Byte S-box lookup: return SBOX_1[input & 0xFF] (confidence=0.93). Evidence: AL-masked index; table byte load via base+index.

@SBOX_1 = external global [256 x i8]

define dso_local i32 @sbox_lookup(i32 %x) local_unnamed_addr {
entry:
  %x8 = trunc i32 %x to i8
  %idx = zext i8 %x8 to i64
  %p = getelementptr inbounds [256 x i8], [256 x i8]* @SBOX_1, i64 0, i64 %idx
  %b = load i8, i8* %p, align 1
  %ret = zext i8 %b to i32
  ret i32 %ret
}