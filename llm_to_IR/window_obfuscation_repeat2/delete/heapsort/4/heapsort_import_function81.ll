; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@dword_1400070A0 = external global i32
@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@off_1400043A0 = external global i8*
@off_1400043B0 = external global i8*
@off_1400043C0 = external global i8*

declare i32 @sub_140002690()
declare void @sub_1400028E0()
declare void @sub_140001B30(i8*)
declare void @sub_140002B78(i8*, i8*, i32)
declare void @sub_140001AD0(i8*)
declare void @loc_1400298F9()

define void @sub_140001CA0() {
entry:
  %loaded = load i32, i32* @dword_1400070A0, align 4
  %iszero = icmp eq i32 %loaded, 0
  br i1 %iszero, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  br label %ret

ret:
  ret void
}