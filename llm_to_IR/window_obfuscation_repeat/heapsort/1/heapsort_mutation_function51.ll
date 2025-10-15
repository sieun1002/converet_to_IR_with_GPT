; ModuleID = 'atexit_wrapper'
target triple = "x86_64-pc-windows-msvc"

declare dllimport i32 @atexit(void ()*)

declare void @Function()

define dso_local i32 @sub_140001430() {
entry:
  %0 = tail call i32 @atexit(void ()* @Function)
  ret i32 %0
}