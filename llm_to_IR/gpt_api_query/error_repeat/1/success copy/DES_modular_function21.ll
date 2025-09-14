; rotl28: rotate 28-bit value left by b (x86 semantics: shift counts masked to 5 bits)
define dso_local i32 @rotl28(i32 %a, i32 %b) {
entry:
  %a28 = and i32 %a, 268435455           ; 0x0FFFFFFF
  %s1  = and i32 %b, 31                  ; mask to lower 5 bits (x86 shift semantics)
  %left = shl i32 %a28, %s1
  %sub = sub i32 28, %b
  %s2  = and i32 %sub, 31
  %right = lshr i32 %a28, %s2
  %or = or i32 %left, %right
  %res = and i32 %or, 268435455          ; mask result to 28 bits
  ret i32 %res
}