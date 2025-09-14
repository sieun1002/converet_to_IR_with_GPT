; ModuleID = 'xtime.ll'
source_filename = "xtime"
target triple = "x86_64-unknown-linux-gnu"

define dso_local i8 @xtime(i8 %x) local_unnamed_addr #0 {
entry:
  %shl = shl i8 %x, 1
  %msb = lshr i8 %x, 7
  %mul27 = mul nuw nsw i8 %msb, 27
  %res = xor i8 %shl, %mul27
  ret i8 %res
}

attributes #0 = { nounwind readnone willreturn }