; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@unk_140003050 = external global i8

define dso_local i8* @sub_140002A10() #0 {
entry:
  ret i8* @unk_140003050
}

attributes #0 = { nounwind uwtable "target-cpu"="x86-64" "target-features"="+sse2" }