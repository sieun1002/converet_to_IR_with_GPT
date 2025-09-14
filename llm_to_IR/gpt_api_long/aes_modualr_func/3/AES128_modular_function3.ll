; ModuleID = 'xtime'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: xtime  ; Address: 0x11EE
; Intent: AES GF(2^8) xtime (multiply by 2 with Rijndael reduction) (confidence=0.95). Evidence: msb test and XOR with 27 (0x1b)
; Preconditions: Only the low 8 bits of %x are used.
; Postconditions: Returns (2*X) XOR (27 * (X>>7)), as a 32-bit integer.

define dso_local i32 @xtime(i32 %x) local_unnamed_addr {
entry:
  %x8 = trunc i32 %x to i8
  %x32 = zext i8 %x8 to i32
  %twice = shl i32 %x32, 1
  %msb8 = lshr i8 %x8, 7
  %msb32 = zext i8 %msb8 to i32
  %mul = mul i32 %msb32, 27
  %res = xor i32 %twice, %mul
  ret i32 %res
}