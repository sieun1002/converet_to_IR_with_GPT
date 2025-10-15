; ModuleID = 'TlsCallback_2.ll'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_1400023D0(i8* noundef, i32 noundef, i8* noundef)

define void @TlsCallback_2(i8* noundef %DllHandle, i32 noundef %Reason, i8* noundef %Reserved) local_unnamed_addr {
entry:
  %cmp_detach = icmp eq i32 %Reason, 3
  br i1 %cmp_detach, label %tailcall, label %check_zero

check_zero:
  %cmp_zero = icmp eq i32 %Reason, 0
  br i1 %cmp_zero, label %tailcall, label %ret

tailcall:
  musttail call void @sub_1400023D0(i8* noundef %DllHandle, i32 noundef %Reason, i8* noundef %Reserved)
  ret void

ret:
  ret void
}