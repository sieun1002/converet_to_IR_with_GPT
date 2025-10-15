; ModuleID = 'fixed_module'
source_filename = "fixed_module"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external dso_local global i32*, align 8

declare dso_local void @sub_140001010()

define dso_local void @sub_1400013E0() {
entry:
  %ptr = load i32*, i32** @off_140004400, align 8
  store i32 1, i32* %ptr, align 4
  call void @sub_140001010()
  ret void
}