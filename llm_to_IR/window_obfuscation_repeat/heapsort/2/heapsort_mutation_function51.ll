; ModuleID = 'ir_fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

declare dllimport i32 @j__crt_atexit(void ()*) #1

define dso_local i32 @sub_140001430() local_unnamed_addr #0 {
entry:
  %call = tail call i32 @j__crt_atexit(void ()* @Function)
  ret i32 %call
}

define dso_local void @Function() local_unnamed_addr #0 {
entry:
  ret void
}

attributes #0 = { nounwind }
attributes #1 = { nounwind }