; ModuleID = 'fixed_module'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043F0 = external global i64*, align 8

define i64 @sub_140002A20() {
entry:
  %0 = load i64*, i64** @off_1400043F0, align 8
  %1 = load i64, i64* %0, align 8
  ret i64 %1
}