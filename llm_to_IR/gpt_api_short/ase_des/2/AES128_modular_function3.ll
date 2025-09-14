; ModuleID = 'xtime'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: xtime ; Address: 0x11EE
; Intent: AES GF(2^8) xtime (multiply-by-2 with reduction) (confidence=0.95). Evidence: computes (a<<1) XOR (0x1B if a's MSB set)
; Preconditions: Only the low 8 bits of the input are used.
; Postconditions: Returns a 32-bit value equal to ((x&0xFF)<<1) XOR (0x1B if (x&0x80)!=0 else 0).

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local i32 @xtime(i32 %x) local_unnamed_addr {
entry:
  %x8 = trunc i32 %x to i8
  %a32 = zext i8 %x8 to i32
  %twice = shl i32 %a32, 1
  %msb = lshr i8 %x8, 7
  %msb32 = zext i8 %msb to i32
  %mul27 = mul i32 %msb32, 27
  %res = xor i32 %twice, %mul27
  ret i32 %res
}