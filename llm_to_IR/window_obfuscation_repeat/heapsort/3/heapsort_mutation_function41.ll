; ModuleID = 'fixed'
source_filename = "fixed.ll"
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@global_int = internal global i32 0, align 4
@off_140004400 = dso_local global i32* @global_int, align 8

declare void @sub_140001010()

declare void (i32)* @signal(i32, void (i32)*)

define dso_local i32 @start() {
entry:
  %p = load i32*, i32** @off_140004400, align 8
  store i32 0, i32* %p, align 4
  call void @sub_140001010()
  ret i32 0
}

define dso_local i32 @TopLevelExceptionFilter(i8* %rec) {
entry:
  %old = call void (i32)* @signal(i32 8, void (i32)* null)
  ret i32 0
}