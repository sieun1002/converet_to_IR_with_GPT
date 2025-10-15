; ModuleID = 'tls_callback_module'
target triple = "x86_64-pc-windows-msvc"

declare dso_local void @sub_1400023D0(i8*, i32, i8*)

define dso_local void @TlsCallback_2(i8* %DllHandle, i32 %Reason, i8* %Reserved) local_unnamed_addr {
entry:
  %cmp3 = icmp eq i32 %Reason, 3
  br i1 %cmp3, label %tailcall, label %check_zero

check_zero:
  %cmp0 = icmp eq i32 %Reason, 0
  br i1 %cmp0, label %tailcall, label %ret

tailcall:
  musttail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

ret:
  ret void
}