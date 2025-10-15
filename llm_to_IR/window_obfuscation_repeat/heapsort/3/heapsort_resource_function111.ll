; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@dword_140007030 = dso_local global i32 0, align 4

declare dso_local void @sub_140001870()

define dso_local void @sub_1400018F0() {
entry:
  %g = load i32, i32* @dword_140007030, align 4
  %iszero = icmp eq i32 %g, 0
  br i1 %iszero, label %init, label %retblk

init:
  store i32 1, i32* @dword_140007030, align 4
  tail call void @sub_140001870()
  ret void

retblk:
  ret void
}