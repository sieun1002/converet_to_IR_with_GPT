; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_140007030 = external global i32, align 4

declare void @sub_140001810()

define void @sub_140001890() {
entry:
  %0 = load i32, i32* @dword_140007030, align 4
  %cmp = icmp eq i32 %0, 0
  br i1 %cmp, label %set, label %ret

ret:
  ret void

set:
  store i32 1, i32* @dword_140007030, align 4
  musttail call void @sub_140001810()
  ret void
}