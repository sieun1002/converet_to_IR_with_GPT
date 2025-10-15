; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_140007030 = dso_local global i32 0, align 4

declare i32 @sub_140001940()

define dso_local i32 @sub_1400019C0() {
entry:
  %0 = load i32, i32* @dword_140007030, align 4
  %cmp = icmp eq i32 %0, 0
  br i1 %cmp, label %init, label %ret

ret:
  ret i32 %0

init:
  store i32 1, i32* @dword_140007030, align 4
  %call = tail call i32 @sub_140001940()
  ret i32 %call
}