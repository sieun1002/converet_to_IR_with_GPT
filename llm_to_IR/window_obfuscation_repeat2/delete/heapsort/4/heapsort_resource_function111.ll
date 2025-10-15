; ModuleID = 'fixed'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@dword_140007030 = dso_local global i32 0, align 4

declare dso_local void @sub_140001870()

define dso_local void @sub_1400018F0() {
entry:
  %v = load i32, i32* @dword_140007030, align 4
  %iszero = icmp eq i32 %v, 0
  br i1 %iszero, label %then, label %ret

then:
  store i32 1, i32* @dword_140007030, align 4
  musttail call void @sub_140001870()
  ret void

ret:
  ret void
}