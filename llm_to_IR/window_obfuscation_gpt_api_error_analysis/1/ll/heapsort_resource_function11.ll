; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_140007030 = external global i32, align 4

declare void @sub_140001870()

define void @sub_1400018F0() local_unnamed_addr {
entry:
  %g0 = load i32, i32* @dword_140007030, align 4
  %cmp0 = icmp eq i32 %g0, 0
  br i1 %cmp0, label %init, label %ret

init:
  store i32 1, i32* @dword_140007030, align 4
  musttail call void @sub_140001870()
  ret void

ret:
  ret void
}