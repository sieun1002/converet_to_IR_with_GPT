; ModuleID = 'recovered_sub_1400018F0'
target triple = "x86_64-pc-windows-msvc"

@dword_140007030 = dso_local global i32 0, align 4

declare dso_local void @sub_140001870()

define dso_local void @sub_1400018F0() local_unnamed_addr {
entry:
  %load.flag = load i32, i32* @dword_140007030, align 4
  %is.zero = icmp eq i32 %load.flag, 0
  br i1 %is.zero, label %set_and_call, label %ret_block

ret_block:
  ret void

set_and_call:
  store i32 1, i32* @dword_140007030, align 4
  tail call void @sub_140001870()
  ret void
}