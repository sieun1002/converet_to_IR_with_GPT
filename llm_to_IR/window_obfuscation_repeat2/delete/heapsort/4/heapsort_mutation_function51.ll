; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

declare i32 @j__crt_atexit(void ()*)

declare void @Function()

define i32 @sub_140001430() {
entry:
  %0 = tail call i32 @j__crt_atexit(void ()* @Function)
  ret i32 %0
}