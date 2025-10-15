target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"

@dword_140007030 = global i32 0, align 4

declare i32 @sub_140001810()

define i32 @sub_140001890() {
entry:
  %0 = load i32, i32* @dword_140007030, align 4
  %cmp = icmp eq i32 %0, 0
  br i1 %cmp, label %init, label %ret

ret:
  ret i32 %0

init:
  store i32 1, i32* @dword_140007030, align 4
  %1 = tail call i32 @sub_140001810()
  ret i32 %1
}