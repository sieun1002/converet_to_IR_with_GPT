; ModuleID = 'xtime'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: xtime  ; Address: 0x11EE
; Intent: AES GF(2^8) xtime (multiply by 2 with reduction by 0x1B) (confidence=0.98). Evidence: shift-by-7 mask and multiply-by-27 (0x1B) then xor with x<<1
; Preconditions: Input is treated as an 8-bit value.
; Postconditions: Returns ((x << 1) ^ ((x >> 7) * 0x1B)) truncated to 8 bits.

define dso_local i8 @xtime(i8 %x) local_unnamed_addr {
entry:
  %x32 = zext i8 %x to i32
  %twice = shl i32 %x32, 1
  %msb = lshr i8 %x, 7
  %msb32 = zext i8 %msb to i32
  %mul27 = mul i32 %msb32, 27
  %xor = xor i32 %twice, %mul27
  %res = trunc i32 %xor to i8
  ret i8 %res
}