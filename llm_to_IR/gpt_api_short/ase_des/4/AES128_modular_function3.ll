; ModuleID = 'xtime'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: xtime ; Address: 0x11EE
; Intent: AES GF(2^8) multiply-by-2 (xtime) (confidence=0.98). Evidence: uses (byte<<1) XOR (0x1b * (byte>>7)); detects MSB via shr 7.
; Preconditions: Only the low 8 bits of the input are used.
; Postconditions: Returns ((a&0xFF)<<1) XOR (27 * ((a&0xFF)>>7)) as a 32-bit int (not truncated to 8 bits).

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local i32 @xtime(i32 %a) local_unnamed_addr {
entry:
  %a8 = trunc i32 %a to i8
  %aext = zext i8 %a8 to i32
  %twice = shl i32 %aext, 1
  %msb = lshr i32 %aext, 7
  ; compute 27 * msb without mul: ((msb*3) * 9) == (msb*27)
  %t2 = add i32 %msb, %msb         ; 2*msb
  %t3 = add i32 %t2, %msb          ; 3*msb
  %t24 = shl i32 %t3, 3            ; 24*msb
  %t27 = add i32 %t3, %t24         ; 27*msb
  %res = xor i32 %twice, %t27
  ret i32 %res
}