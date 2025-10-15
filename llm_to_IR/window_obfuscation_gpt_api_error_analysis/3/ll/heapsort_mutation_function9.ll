; ModuleID = 'sub_1400018F0'
target triple = "x86_64-pc-windows-msvc"

@dword_140007030 = external global i32, align 4

declare dso_local i32 @sub_140001870()

define dso_local i32 @sub_1400018F0() local_unnamed_addr {
entry:
  %flag = load i32, i32* @dword_140007030, align 4
  %iszero = icmp eq i32 %flag, 0
  br i1 %iszero, label %init, label %ret

ret:
  ret i32 %flag

init:
  store i32 1, i32* @dword_140007030, align 4
  %call = tail call i32 @sub_140001870()
  ret i32 %call
}