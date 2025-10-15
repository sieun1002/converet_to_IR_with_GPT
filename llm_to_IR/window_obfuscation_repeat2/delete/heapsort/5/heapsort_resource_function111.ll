; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_140007030 = global i32 0, align 4

declare void @sub_140001870()

define void @sub_1400018F0() {
entry:
  %0 = load i32, i32* @dword_140007030, align 4
  %1 = icmp eq i32 %0, 0
  br i1 %1, label %loc_140001900, label %ret

ret:
  ret void

loc_140001900:
  store i32 1, i32* @dword_140007030, align 4
  musttail call void @sub_140001870()
  ret void
}