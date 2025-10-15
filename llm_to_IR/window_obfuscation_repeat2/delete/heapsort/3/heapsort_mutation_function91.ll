; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@dword_140007030 = dso_local global i32 0, align 4

declare dso_local void @sub_140001870()

define dso_local void @sub_1400018F0() {
entry:
  %0 = load i32, i32* @dword_140007030, align 4
  %cmp = icmp eq i32 %0, 0
  br i1 %cmp, label %init, label %retlbl

init:
  store i32 1, i32* @dword_140007030, align 4
  musttail call void @sub_140001870()
  ret void

retlbl:
  ret void
}