; ModuleID = 'tls_module'
target triple = "x86_64-pc-windows-msvc"

declare dso_local void @sub_1400023D0(i8*, i32, i8*)

define dso_local void @TlsCallback_2(i8* noundef %DllHandle, i32 noundef %Reason, i8* noundef %Reserved) local_unnamed_addr {
entry:
  %cmp.edx.eq3 = icmp eq i32 %Reason, 3
  br i1 %cmp.edx.eq3, label %call_target, label %check_zero

check_zero:
  %cmp.edx.eq0 = icmp eq i32 %Reason, 0
  br i1 %cmp.edx.eq0, label %call_target, label %ret_block

ret_block:
  ret void

call_target:
  tail call void @sub_1400023D0(i8* noundef %DllHandle, i32 noundef %Reason, i8* noundef %Reserved)
  ret void
}