; ModuleID = 'xtime'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: xtime ; Address: 0x000011EE
; Intent: AES GF(2^8) multiply-by-2 ("xtime") (confidence=0.98). Evidence: shift by 7 to get top bit; XOR with 27 (0x1B) after doubling.
; Preconditions: Input is an 8-bit value (0..255).
; Postconditions: Returns (x << 1) ^ (0x1B if x & 0x80 else 0), in 8-bit domain.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local i8 @xtime(i8 %x) local_unnamed_addr {
entry:
  %shl = shl i8 %x, 1
  %hi = lshr i8 %x, 7
  %mul = mul i8 %hi, 27
  %res = xor i8 %shl, %mul
  ret i8 %res
}