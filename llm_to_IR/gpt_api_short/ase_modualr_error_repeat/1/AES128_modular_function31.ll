; ModuleID = 'xtime'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: xtime ; Address: 0x11EE
; Intent: AES GF(2^8) multiply-by-2 (xtime) with Rijndael reduction (confidence=0.98). Evidence: conditional 0x1B factor from MSB; XOR with doubled byte.
; Preconditions: Only the low 8 bits of the input are used.
; Postconditions: Returns ((arg & 0xFF) << 1) ^ (0x1B if (arg & 0x80) else 0) as a 32-bit int (no final 8-bit mask).

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local i32 @xtime(i32 %a) local_unnamed_addr {
entry:
  %x8 = trunc i32 %a to i8
  %x32 = zext i8 %x8 to i32
  %double = shl i32 %x32, 1
  %msb8 = lshr i8 %x8, 7
  %msb = zext i8 %msb8 to i32
  %mul = mul i32 %msb, 27
  %res = xor i32 %double, %mul
  ret i32 %res
}