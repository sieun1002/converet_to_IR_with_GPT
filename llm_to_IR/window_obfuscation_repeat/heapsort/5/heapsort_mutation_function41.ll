; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@global_int = internal global i32 1, align 4
@off_140004400 = global i32* @global_int, align 8
@qword_1400070D0 = global i32 (i8*)* null, align 8

declare dllimport void (i32)* @signal(i32, void (i32)*)

define void @sub_140001010() {
entry:
  ret void
}

define void @sub_1400024E0() {
entry:
  ret void
}

define i32 @TopLevelExceptionFilter(i8* %rec) {
entry:
  %call = call void (i32)* @signal(i32 8, void (i32)* null)
  ret i32 -1
}

define void @start() {
entry:
  %p = load i32*, i32** @off_140004400, align 8
  store i32 0, i32* %p, align 4
  call void @sub_140001010()
  ret void
}