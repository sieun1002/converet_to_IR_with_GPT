; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043F0 = external dso_local global i64*, align 8

define dso_local i64 @sub_140002A20() #0 {
entry:
  %p = load i64*, i64** @off_1400043F0, align 8
  %v = load i64, i64* %p, align 8
  ret i64 %v
}

attributes #0 = { nounwind }