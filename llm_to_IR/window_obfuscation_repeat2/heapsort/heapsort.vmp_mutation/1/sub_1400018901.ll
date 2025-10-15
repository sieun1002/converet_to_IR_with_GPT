; ModuleID = 'module'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@dword_140007030 = dso_local global i32 0, align 4

declare dso_local i32 @sub_140001810()

define dso_local i32 @sub_140001890() {
entry:
  %load = load i32, i32* @dword_140007030, align 4
  %iszero = icmp eq i32 %load, 0
  br i1 %iszero, label %set_and_call, label %ret_old

ret_old:
  ret i32 %load

set_and_call:
  store i32 1, i32* @dword_140007030, align 4
  %call = tail call i32 @sub_140001810()
  ret i32 %call
}