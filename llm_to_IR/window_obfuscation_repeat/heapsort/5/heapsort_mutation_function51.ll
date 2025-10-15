; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

declare dllimport i32 @atexit(void ()*)

define dso_local i32 @j__crt_atexit(void ()* %fn) local_unnamed_addr {
entry:
  %call = tail call i32 @atexit(void ()* %fn)
  ret i32 %call
}

define dso_local void @Function() local_unnamed_addr {
entry:
  ret void
}

define dso_local i32 @sub_140001430() local_unnamed_addr {
entry:
  %call = tail call i32 @j__crt_atexit(void ()* @Function)
  ret i32 %call
}