; ModuleID: win64_atexit_wrapper
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

declare dllimport i32 @atexit(void ()*)

define dso_local void @Function() local_unnamed_addr {
entry:
  ret void
}

define dso_local i32 @j__crt_atexit(void ()* %fn) local_unnamed_addr {
entry:
  %call = tail call i32 @atexit(void ()* %fn)
  ret i32 %call
}

define dso_local i32 @sub_140001430() local_unnamed_addr {
entry:
  %call = tail call i32 @j__crt_atexit(void ()* @Function)
  ret i32 %call
}