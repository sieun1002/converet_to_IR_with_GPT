; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@off_140004420 = external dso_local global i32*, align 8

declare dso_local void @sub_140001010()

define dso_local void @sub_1400013E0() {
entry:
  %0 = load i32*, i32** @off_140004420, align 8
  store i32 1, i32* %0, align 4
  call void @sub_140001010()
  ret void
}