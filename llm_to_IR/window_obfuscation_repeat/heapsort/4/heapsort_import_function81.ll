; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = external global i32, align 4
@dword_1400070A4 = external global i32, align 4
@qword_1400070A8 = external global i8*, align 8
@off_1400043B0 = external global i8*, align 8
@off_1400043C0 = external global i8*, align 8
@off_1400043A0 = external global i8*, align 8

declare i32 @sub_140002690()
declare i64 @sub_1400028E0()
declare void @sub_140001B30(i8*)
declare void @sub_140002B78(i8*, i8*, i32)
declare i32 @sub_140001AD0(i8*, ...)
declare void @loc_1400298F9()

define void @sub_140001CA0() #0 {
entry:
  %init_flag = load i32, i32* @dword_1400070A0, align 4
  %is_inited = icmp ne i32 %init_flag, 0
  br i1 %is_inited, label %ret, label %do_init

do_init:
  store i32 1, i32* @dword_1400070A0, align 4
  %v1 = call i32 @sub_140002690()
  %v1.sext = sext i32 %v1 to i64
  %v2 = call i64 @sub_1400028E0()
  store i32 0, i32* @dword_1400070A4, align 4
  %buf = alloca [64 x i8], align 16
  %buf.i8 = bitcast [64 x i8]* %buf to i8*
  store i8* %buf.i8, i8** @qword_1400070A8, align 8
  br label %ret

ret:
  ret void
}

attributes #0 = { "uwtable" }