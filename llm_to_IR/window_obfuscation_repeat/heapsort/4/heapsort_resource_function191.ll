; ModuleID = 'fixed'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare dllimport i8* @memcpy(i8*, i8*, i64)

@dword_1400070A0 = dso_local global i32 0, align 4
@dword_1400070A4 = dso_local global i32 0, align 4
@qword_1400070A8 = dso_local global i8* null, align 8
@off_1400043B0 = dso_local global i8* null, align 8
@off_1400043C0 = dso_local global i8* null, align 8
@off_1400043A0 = dso_local global i8* null, align 8
@__imp_VirtualProtect = external dllimport global i32 (i8*, i64, i32, i32*)*, align 8

define dso_local void @sub_140001CA0() {
entry:
  %init = load i32, i32* @dword_1400070A0, align 4
  %cmp = icmp eq i32 %init, 0
  br i1 %cmp, label %do_init, label %ret

do_init:
  store i32 1, i32* @dword_1400070A0, align 4
  store i32 0, i32* @dword_1400070A4, align 4
  %buf = alloca [64 x i8], align 16
  %bufptr = bitcast [64 x i8]* %buf to i8*
  store i8* %bufptr, i8** @qword_1400070A8, align 8
  br label %ret

ret:
  ret void
}

define dso_local i32 @sub_140002690() {
entry:
  ret i32 0
}

define dso_local i64 @sub_1400028E0(i64 %x) {
entry:
  ret i64 %x
}

define dso_local void @sub_140001B30(i8* %p) {
entry:
  ret void
}

define dso_local void @sub_140001AD0(...) {
entry:
  ret void
}