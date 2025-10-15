; ModuleID = 'tls_callback_module'
source_filename = "tls_callback.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare dso_local void @sub_1400023D0()

define dso_local void @TlsCallback_1(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %cmp3 = icmp eq i32 %Reason, 3
  br i1 %cmp3, label %tailcall, label %check0

check0:
  %cmp0 = icmp eq i32 %Reason, 0
  br i1 %cmp0, label %tailcall, label %ret

tailcall:
  tail call void @sub_1400023D0()
  ret void

ret:
  ret void
}