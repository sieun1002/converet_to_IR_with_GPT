; ModuleID = 'sub_140001430_module'
target triple = "x86_64-pc-windows-msvc"

declare dllimport i32 @j__crt_atexit(void ()*)
declare external void @Function()

define dso_local i32 @sub_140001430() {
entry:
  %0 = tail call i32 @j__crt_atexit(void ()* @Function)
  ret i32 %0
}