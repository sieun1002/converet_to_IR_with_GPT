; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@dword_1400070A0 = dso_local global i32 0, align 4

define void @sub_140001CA0() local_unnamed_addr {
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