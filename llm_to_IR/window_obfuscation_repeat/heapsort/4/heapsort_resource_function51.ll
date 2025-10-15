; ModuleID = 'sub_140001430_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare dllimport i32 @atexit(void ()*)

define internal void @Function() {
entry:
  ret void
}

define dso_local i32 @sub_140001430() {
entry:
  %call = tail call i32 @atexit(void ()* @Function)
  ret i32 %call
}