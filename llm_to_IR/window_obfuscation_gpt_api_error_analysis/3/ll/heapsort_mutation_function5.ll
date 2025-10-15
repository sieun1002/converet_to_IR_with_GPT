; ModuleID = 'sub_140001430_module'
target triple = "x86_64-pc-windows-msvc"

declare dso_local void @Function()

declare dso_local i32 @j__crt_atexit(void ()* noundef)

define dso_local i32 @sub_140001430() local_unnamed_addr {
entry:
  %0 = call i32 @j__crt_atexit(void ()* noundef @Function)
  ret i32 %0
}