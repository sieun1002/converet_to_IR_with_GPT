; ModuleID: fixed_module
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"

@gflag = internal global i32 0, align 4
@off_140004400 = global i32* @gflag, align 8
@qword_1400070D0 = global i32 (i8*)* null, align 8

declare void @sub_140001010()

define void @start() {
entry:
  %ptr = load i32*, i32** @off_140004400, align 8
  store i32 0, i32* %ptr, align 4
  call void @sub_140001010()
  ret void
}

define i32 @TopLevelExceptionFilter(i8* %rec) {
entry:
  %cb = load i32 (i8*)*, i32 (i8*)** @qword_1400070D0, align 8
  %cbnull = icmp eq i32 (i8*)* %cb, null
  br i1 %cbnull, label %retzero, label %docall

docall:
  %res = call i32 %cb(i8* %rec)
  ret i32 %res

retzero:
  ret i32 0
}

define void @sub_140001010() {
entry:
  ret void
}