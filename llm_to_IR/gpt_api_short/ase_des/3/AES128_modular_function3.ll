; ModuleID = 'xtime'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: xtime ; Address: 0x11EE
; Intent: AES GF(2^8) xtime (multiply by 2 with reduction) (confidence=0.98). Evidence: computes (x<<1) xor (0x1B * ((x>>7)&1))
; Preconditions: Only the low 8 bits of the input are used.
; Postconditions: Returns ((x & 0xFF) << 1) xor (0x1B * ((x>>7)&1)) as a 32-bit value (no final 8-bit mask).

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

; Use the IDA symbol here (e.g., @heap_sort or @main)
define dso_local i32 @xtime(i32 %x) local_unnamed_addr {
entry:
  %0 = trunc i32 %x to i8
  %1 = zext i8 %0 to i32
  %twox = shl i32 %1, 1
  %2 = lshr i8 %0, 7
  %3 = zext i8 %2 to i32
  %4 = add i32 %3, %3
  %5 = add i32 %4, %3
  %6 = shl i32 %5, 3
  %7 = add i32 %6, %5
  %res = xor i32 %twox, %7
  ret i32 %res
}