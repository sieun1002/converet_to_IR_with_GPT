; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare void @Function()
declare i32 @atexit(void ()*)

define i32 @j__crt_atexit(void ()* %f) {
entry:
  %r = tail call i32 @atexit(void ()* %f)
  ret i32 %r
}

define i32 @sub_140001430() {
entry:
  %call = tail call i32 @j__crt_atexit(void ()* @Function)
  ret i32 %call
}