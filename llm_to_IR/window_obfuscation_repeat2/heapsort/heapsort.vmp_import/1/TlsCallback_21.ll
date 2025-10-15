; ModuleID = 'tls_callback_2'
target triple = "x86_64-pc-windows-msvc"

declare dso_local void @sub_140002370(i8* noundef, i32 noundef, i8* noundef)

define dso_local void @TlsCallback_2(i8* noundef %arg0, i32 noundef %arg1, i8* noundef %arg2) {
entry:
  %cmp3 = icmp eq i32 %arg1, 3
  br i1 %cmp3, label %call, label %check0

check0:
  %cmp0 = icmp eq i32 %arg1, 0
  br i1 %cmp0, label %call, label %ret

call:
  musttail call void @sub_140002370(i8* noundef %arg0, i32 noundef %arg1, i8* noundef %arg2)
  ret void

ret:
  ret void
}