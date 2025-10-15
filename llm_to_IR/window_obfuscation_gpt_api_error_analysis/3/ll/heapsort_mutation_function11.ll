; ModuleID = 'tls_callback_module'
source_filename = "tls_callback.ll"
target triple = "x86_64-pc-windows-msvc"

declare dso_local void @sub_1400023D0(i8* noundef, i32 noundef, i8* noundef)

define dso_local void @TlsCallback_1(i8* noundef %DllHandle, i32 noundef %Reason, i8* noundef %Reserved) local_unnamed_addr {
entry:
  %cmp3 = icmp eq i32 %Reason, 3
  br i1 %cmp3, label %tail_dispatch, label %check_zero

check_zero:
  %cmp0 = icmp eq i32 %Reason, 0
  br i1 %cmp0, label %tail_dispatch, label %ret_block

ret_block:
  ret void

tail_dispatch:
  musttail call void @sub_1400023D0(i8* noundef %DllHandle, i32 noundef %Reason, i8* noundef %Reserved)
  ret void
}