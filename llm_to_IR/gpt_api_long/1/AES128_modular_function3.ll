; ModuleID = 'xtime'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: xtime  ; Address: 0x11EE
; Intent: AES GF(2^8) multiply-by-2 (xtime) for a byte (confidence=0.95). Evidence: ((x<<1) XOR (0x1B * (x>>7))) pattern, name 'xtime'
; Preconditions: Only the low 8 bits of %x are used.
; Postconditions: Returns ((%x & 0xFF) << 1) XOR (0x1B * ((%x & 0xFF) >> 7)) as i32.

define dso_local i32 @xtime(i32 %x) local_unnamed_addr {
entry:
  %t = trunc i32 %x to i8
  %z = zext i8 %t to i32
  %two = shl i32 %z, 1
  %hb8 = lshr i8 %t, 7
  %hb = zext i8 %hb8 to i32
  %mul = mul i32 %hb, 27
  %res = xor i32 %two, %mul
  ret i32 %res
}