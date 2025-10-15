; ModuleID = 'tls_callback_module'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_1400023D0(i8* noundef, i32 noundef, i8* noundef)

define void @TlsCallback_1(i8* noundef %hModule, i32 noundef %dwReason, i8* noundef %pReserved) {
entry:
  %cmp3 = icmp eq i32 %dwReason, 3
  br i1 %cmp3, label %call, label %cont

cont:
  %cmp0 = icmp eq i32 %dwReason, 0
  br i1 %cmp0, label %call, label %ret

call:
  musttail call void @sub_1400023D0(i8* noundef %hModule, i32 noundef %dwReason, i8* noundef %pReserved)
  ret void

ret:
  ret void
}