; ModuleID = 'xtime'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: xtime  ; Address: 0x11EE
; Intent: AES GF(2^8) xtime: multiply a byte by 2 with reduction by 0x1b if msb set (confidence=0.98). Evidence: pattern (x>>7)*0x1b XOR (x<<1), use of only low 8 bits.
; Preconditions: Only the low 8 bits of %x are used.
; Postconditions: Returns the xtime result in the low 8 bits (0..255).

define dso_local i32 @xtime(i32 %x) local_unnamed_addr {
entry:
  %x8 = trunc i32 %x to i8
  %x32 = zext i8 %x8 to i32
  %dbl = shl i32 %x32, 1
  %msb8 = lshr i8 %x8, 7
  %msb = zext i8 %msb8 to i32
  %red = mul i32 %msb, 27
  %mix = xor i32 %dbl, %red
  %res = and i32 %mix, 255
  ret i32 %res
}