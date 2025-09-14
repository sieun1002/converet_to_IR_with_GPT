; ModuleID = 'rotl28'
source_filename = "rotl28"

define i32 @rotl28(i32 %x, i32 %s) #0 {
entry:
  %xmasked = and i32 %x, 268435455
  %s_mask = and i32 %s, 31
  %shl = shl i32 %xmasked, %s_mask
  %inv = sub i32 28, %s
  %inv_mask = and i32 %inv, 31
  %shr = lshr i32 %xmasked, %inv_mask
  %or = or i32 %shl, %shr
  %res = and i32 %or, 268435455
  ret i32 %res
}

attributes #0 = { nounwind readnone willreturn }