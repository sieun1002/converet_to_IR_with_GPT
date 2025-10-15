; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external global i32*, align 8
@qword_1400070D0 = external global i32 (i8*)*, align 8

declare void @sub_140001010()

define void @sub_1400013E0() {
entry:
  %0 = load i32*, i32** @off_140004400, align 8
  store i32 1, i32* %0, align 4
  call void @sub_140001010()
  ret void
}

define i32 @sub_140002080(i8* %ctx) {
entry:
  %fnptr = load i32 (i8*)*, i32 (i8*)** @qword_1400070D0, align 8
  %isnull = icmp eq i32 (i8*)* %fnptr, null
  br i1 %isnull, label %ret_zero, label %tailcall

tailcall:
  %call = tail call i32 %fnptr(i8* %ctx)
  ret i32 %call

ret_zero:
  ret i32 0
}