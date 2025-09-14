; ModuleID = 'rotl28.ll'
source_filename = "rotl28"
target triple = "x86_64-pc-linux-gnu"

define dso_local i32 @rotl28(i32 %x, i32 %n) local_unnamed_addr #0 {
entry:
  %masked = and i32 %x, 268435455
  %n_mod32 = and i32 %n, 31
  %shl = shl i32 %masked, %n_mod32
  %sub = sub i32 28, %n
  %sub_mod32 = and i32 %sub, 31
  %shr = lshr i32 %masked, %sub_mod32
  %or = or i32 %shl, %shr
  %res = and i32 %or, 268435455
  ret i32 %res
}

attributes #0 = { nounwind readnone }