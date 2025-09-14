; ModuleID = 'xtime'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: xtime ; Address: 0x11EE
; Intent: AES GF(2^8) xtime (multiply by 2) (confidence=0.95). Evidence: shift-by-7, XOR with 0x1B pattern
; Preconditions: Input is treated as an unsigned 8-bit value.
; Postconditions: Returns ((x << 1) ^ ((x >> 7) * 0x1B)) truncated to 8 bits.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)

define dso_local i8 @xtime(i8 %x) local_unnamed_addr {
entry:
  %x32 = zext i8 %x to i32
  %twice = shl i32 %x32, 1
  %msb32 = lshr i32 %x32, 7
  %msb1 = and i32 %msb32, 1
  %mul27 = mul nuw i32 %msb1, 27
  %res32 = xor i32 %twice, %mul27
  %res8 = trunc i32 %res32 to i8
  ret i8 %res8
}