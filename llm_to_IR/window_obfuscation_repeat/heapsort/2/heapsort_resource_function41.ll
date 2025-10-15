; ModuleID = 'fixed'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@global_i32 = internal global i32 0, align 4
@off_140004400 = global i32* @global_i32, align 8

define void @sub_140001010() {
entry:
  ret void
}

define void @start() {
entry:
  %p = load i32*, i32** @off_140004400, align 8
  store i32 0, i32* %p, align 4
  call void @sub_140001010()
  ret void
}

define i32 @TopLevelExceptionFilter(i8* %ExceptionPointers) {
entry:
  ret i32 -1
}