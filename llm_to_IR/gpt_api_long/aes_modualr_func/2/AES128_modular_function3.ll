; ModuleID = 'xtime'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: xtime  ; Address: 0x11EE
; Intent: AES GF(2^8) multiply-by-2 (xtime) for a byte (confidence=0.98). Evidence: shift-by-7 MSB test; XOR with 27 (0x1B)
; Preconditions: Input is a byte (0..255).
; Postconditions: Returns ((x << 1) ^ (0x1B if (x & 0x80) else 0)) truncated to 8 bits.

; Only the needed extern declarations:

define dso_local i8 @xtime(i8 %x) local_unnamed_addr {
entry:
  %x32 = zext i8 %x to i32
  %dbl = shl i32 %x32, 1
  %msb = lshr i8 %x, 7
  %msb32 = zext i8 %msb to i32
  %mul27 = mul i32 %msb32, 27
  %xor = xor i32 %dbl, %mul27
  %res = trunc i32 %xor to i8
  ret i8 %res
}