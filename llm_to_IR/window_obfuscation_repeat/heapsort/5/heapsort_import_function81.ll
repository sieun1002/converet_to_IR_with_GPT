; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = dso_local global i32 0, align 4
@dword_1400070A4 = dso_local global i32 0, align 4
@qword_1400070A8 = dso_local global i64 0, align 8
@off_1400043A0 = dso_local global i8* null, align 8
@off_1400043B0 = dso_local global i8* null, align 8
@off_1400043C0 = dso_local global i8* null, align 8

define dso_local void @sub_140001CA0() nounwind {
entry:
  %v0 = load i32, i32* @dword_1400070A0, align 4
  %cmp0 = icmp eq i32 %v0, 0
  br i1 %cmp0, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  br label %ret

ret:
  ret void
}