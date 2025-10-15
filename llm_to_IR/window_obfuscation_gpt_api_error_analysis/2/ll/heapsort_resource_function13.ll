; ModuleID = 'tls_callback'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_1400023D0(i8*, i32, i8*)

define void @TlsCallback_1(i8* noundef %DllHandle, i32 noundef %Reason, i8* noundef %Reserved) local_unnamed_addr {
entry:
  %cmp3 = icmp eq i32 %Reason, 3
  br i1 %cmp3, label %call, label %check0

check0:
  %is0 = icmp eq i32 %Reason, 0
  br i1 %is0, label %call, label %ret

call:
  musttail call void @sub_1400023D0(i8* noundef %DllHandle, i32 noundef %Reason, i8* noundef %Reserved)
  ret void

ret:
  ret void
}