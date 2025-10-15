; ModuleID: start_module
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_140004420 = external global i32*, align 8

declare void @sub_140001010()

define dso_local void @start() {
entry:
  %p = load i32*, i32** @off_140004420, align 8
  store i32 0, i32* %p, align 4
  call void @sub_140001010()
  ret void
}