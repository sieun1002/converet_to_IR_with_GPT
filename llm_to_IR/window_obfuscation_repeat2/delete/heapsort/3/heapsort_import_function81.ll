; ModuleID = 'sub_140001CA0_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@dword_1400070A0 = external global i32
@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@off_1400043A0 = external global i8*
@off_1400043B0 = external global i8*
@off_1400043C0 = external global i8*

declare i32 @sub_140002690()
declare i64 @sub_1400028E0()

define void @sub_140001CA0() {
entry:
  %g0 = load i32, i32* @dword_1400070A0, align 4
  %cmp0 = icmp eq i32 %g0, 0
  br i1 %cmp0, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %n = call i32 @sub_140002690()
  %n64 = sext i32 %n to i64
  %mul5 = mul nsw i64 %n64, 5
  %bytes = mul nsw i64 %mul5, 8
  %plus15 = add i64 %bytes, 15
  %aligned = and i64 %plus15, -16
  %align_adj = call i64 @sub_1400028E0()
  %buf = alloca i8, i64 %aligned, align 16
  store i32 0, i32* @dword_1400070A4, align 4
  store i8* %buf, i8** @qword_1400070A8, align 8
  %pend = load i8*, i8** @off_1400043B0, align 8
  %pstart = load i8*, i8** @off_1400043C0, align 8
  %pend_i = ptrtoint i8* %pend to i64
  %pstart_i = ptrtoint i8* %pstart to i64
  %diff = sub i64 %pend_i, %pstart_i
  %gt7 = icmp sgt i64 %diff, 7
  br i1 %gt7, label %maybe, label %ret

maybe:
  br label %ret

ret:
  ret void
}