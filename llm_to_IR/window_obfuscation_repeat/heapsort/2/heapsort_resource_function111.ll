; ModuleID = 'fixed_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@dword_140007030 = global i32 0, align 4

declare void @sub_140001870()

define void @sub_1400018F0() {
entry:
  %g = load i32, i32* @dword_140007030, align 4
  %iszero = icmp eq i32 %g, 0
  br i1 %iszero, label %loc_140001900, label %ret

loc_140001900:
  store i32 1, i32* @dword_140007030, align 4
  tail call void @sub_140001870()
  br label %ret

ret:
  ret void
}