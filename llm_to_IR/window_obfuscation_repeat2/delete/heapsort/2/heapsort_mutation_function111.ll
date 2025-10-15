; ModuleID = 'tls_callback_module'
source_filename = "tls_callback_module"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare void @sub_1400023D0(i8*, i32, i8*)

define void @TlsCallback_1(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %cmp3 = icmp eq i32 %Reason, 3
  br i1 %cmp3, label %call, label %check0

check0:
  %cmp0 = icmp eq i32 %Reason, 0
  br i1 %cmp0, label %call, label %ret

ret:
  ret void

call:
  musttail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void
}