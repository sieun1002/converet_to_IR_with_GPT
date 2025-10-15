; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare dllimport i32 @atexit(void ()*)

define dso_local void @Function() {
entry:
  ret void
}

define dso_local i32 @j__crt_atexit(void ()* %fn) {
entry:
  %call = tail call i32 @atexit(void ()* %fn)
  ret i32 %call
}

define dso_local i32 @sub_140001430() {
entry:
  %call1 = tail call i32 @j__crt_atexit(void ()* @Function)
  ret i32 %call1
}