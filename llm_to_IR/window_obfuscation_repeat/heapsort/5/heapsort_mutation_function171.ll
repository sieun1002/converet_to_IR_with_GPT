; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = dso_local global i32 0, align 4
@dword_1400070A4 = dso_local global i32 0, align 4

define dso_local void @sub_140001CA0() {
entry:
  %g = load i32, i32* @dword_1400070A0, align 4
  %cmp = icmp eq i32 %g, 0
  br i1 %cmp, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  store i32 0, i32* @dword_1400070A4, align 4
  ret void

ret:
  ret void
}