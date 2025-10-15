; ModuleID = 'tls_callback_module'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_1400023D0(i8*, i32, i8*)

define void @TlsCallback_2(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %cmp_reason_3 = icmp eq i32 %Reason, 3
  br i1 %cmp_reason_3, label %tailcall, label %check_zero

check_zero:
  %cmp_reason_0 = icmp eq i32 %Reason, 0
  br i1 %cmp_reason_0, label %tailcall, label %ret

tailcall:
  tail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

ret:
  ret void
}