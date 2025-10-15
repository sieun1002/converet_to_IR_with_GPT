; ModuleID = 'tls_callback.ll'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_1400023D0(i8* noundef, i32 noundef, i8* noundef)

define void @TlsCallback_1(i8* noundef %arg_DllHandle, i32 noundef %arg_Reason, i8* noundef %arg_Reserved) {
entry:
  %cmp_reason_is_3 = icmp eq i32 %arg_Reason, 3
  br i1 %cmp_reason_is_3, label %tailjmp, label %check_zero

check_zero:
  %cmp_reason_is_0 = icmp eq i32 %arg_Reason, 0
  br i1 %cmp_reason_is_0, label %tailjmp, label %retblock

tailjmp:
  musttail call void @sub_1400023D0(i8* %arg_DllHandle, i32 %arg_Reason, i8* %arg_Reserved)
  ret void

retblock:
  ret void
}