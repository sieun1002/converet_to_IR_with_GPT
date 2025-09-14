; ModuleID = 'xtime'
target triple = "x86_64-pc-linux-gnu"

define dso_local i8 @xtime(i8 noundef %x) #0 {
entry:
  %x2 = shl i8 %x, 1
  %msb = lshr i8 %x, 7
  %t = mul i8 %msb, 27
  %r = xor i8 %x2, %t
  ret i8 %r
}

attributes #0 = { nounwind readnone willreturn }