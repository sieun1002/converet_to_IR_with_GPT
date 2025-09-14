; ModuleID = 'rotl28'
source_filename = "rotl28"
target triple = "x86_64-pc-linux-gnu"

define dso_local i32 @rotl28(i32 %a, i32 %s) {
entry:
  %a28 = and i32 %a, 268435455          ; 0x0FFFFFFF
  %s_mask = and i32 %s, 31
  %shl = shl i32 %a28, %s_mask
  %sub = sub i32 28, %s
  %shr_cnt = and i32 %sub, 31
  %shr = lshr i32 %a28, %shr_cnt
  %or = or i32 %shr, %shl
  %res = and i32 %or, 268435455         ; 0x0FFFFFFF
  ret i32 %res
}