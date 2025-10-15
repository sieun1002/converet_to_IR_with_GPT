; ModuleID = 'fixed'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@dword_140007030 = dso_local global i32 0, align 4

declare dso_local void @sub_140001870()

define dso_local void @sub_1400018F0() {
entry:
  %0 = load i32, i32* @dword_140007030, align 4
  %1 = icmp eq i32 %0, 0
  br i1 %1, label %init, label %ret

init:
  store i32 1, i32* @dword_140007030, align 4
  tail call void @sub_140001870()
  ret void

ret:
  ret void
}