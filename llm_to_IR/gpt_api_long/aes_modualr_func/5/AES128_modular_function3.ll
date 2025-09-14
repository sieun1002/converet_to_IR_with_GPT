; ModuleID = 'xtime'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: xtime  ; Address: 0x11EE
; Intent: AES GF(2^8) xtime (multiply by 2 with 0x1B reduction) (confidence=0.98). Evidence: uses (x<<1) xor (0x1B * (x>>7))
; Preconditions: Input treated as 8-bit value; higher bits ignored.
; Postconditions: Returns 8-bit result in GF(2^8).

define dso_local i8 @xtime(i8 %x) local_unnamed_addr {
entry:
  %msb = lshr i8 %x, 7
  %poly = mul i8 %msb, 27
  %x2 = shl i8 %x, 1
  %res = xor i8 %x2, %poly
  ret i8 %res
}