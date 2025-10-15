; ModuleID = 'tls_callback_module'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_1400023D0(i8*, i32, i8*)

define void @TlsCallback_1(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %cmp_three = icmp eq i32 %Reason, 3
  br i1 %cmp_three, label %tail, label %check_zero

check_zero:
  %cmp_zero = icmp eq i32 %Reason, 0
  br i1 %cmp_zero, label %tail, label %retblk

retblk:
  ret void

tail:
  musttail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void
}