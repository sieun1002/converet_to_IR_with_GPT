; ModuleID = 'tls_module'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_1400023D0(i8*, i32, i8*)

define void @TlsCallback_2(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %cmp_eq_3 = icmp eq i32 %Reason, 3
  %cmp_eq_0 = icmp eq i32 %Reason, 0
  %is_detach = or i1 %cmp_eq_3, %cmp_eq_0
  br i1 %is_detach, label %tailjmp, label %retblock

tailjmp:
  musttail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

retblock:
  ret void
}