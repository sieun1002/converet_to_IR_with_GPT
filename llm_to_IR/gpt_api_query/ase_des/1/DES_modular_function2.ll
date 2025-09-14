; ModuleID = 'rotl28.ll'
target triple = "x86_64-pc-linux-gnu"

define i32 @rotl28(i32 %x, i32 %n) {
entry:
  %x28 = and i32 %x, 268435455
  %n_mask = and i32 %n, 31
  %shl = shl i32 %x28, %n_mask
  %tmp = sub i32 28, %n
  %rs_amt = and i32 %tmp, 31
  %lshr = lshr i32 %x28, %rs_amt
  %or = or i32 %shl, %lshr
  %res = and i32 %or, 268435455
  ret i32 %res
}