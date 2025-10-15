; ModuleID = 'atexit_wrapper'
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare dllimport i32 @j__crt_atexit(void ()*)

define void @Function() {
entry:
  ret void
}

define i32 @sub_140001430() {
entry:
  %call = tail call i32 @j__crt_atexit(void ()* @Function)
  ret i32 %call
}