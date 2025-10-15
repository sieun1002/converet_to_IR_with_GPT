; ModuleID = 'tls_callback_module'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_1400023D0(i8*, i32, i8*)

define void @TlsCallback_2(i8* %arg1, i32 %arg2, i8* %arg3) {
entry:
  %cmp3 = icmp eq i32 %arg2, 3
  br i1 %cmp3, label %call, label %check_zero

check_zero:
  %cmp0 = icmp eq i32 %arg2, 0
  br i1 %cmp0, label %call, label %ret

call:
  tail call void @sub_1400023D0(i8* %arg1, i32 %arg2, i8* %arg3)
  ret void

ret:
  ret void
}