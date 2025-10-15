; ModuleID = 'tls_callback_module'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_1400023D0(i8*, i32, i8*)

define void @TlsCallback_1(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %is_detach = icmp eq i32 %Reason, 3
  br i1 %is_detach, label %do_call, label %check_zero

check_zero:
  %is_zero = icmp eq i32 %Reason, 0
  br i1 %is_zero, label %do_call, label %ret

do_call:
  musttail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

ret:
  ret void
}