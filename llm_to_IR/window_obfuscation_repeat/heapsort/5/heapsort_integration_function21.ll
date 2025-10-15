; ModuleID = 'tls_callback_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

declare void @sub_1400023D0(i8* noundef, i32 noundef, i8* noundef)

define void @TlsCallback_2(i8* noundef %DllHandle, i32 noundef %Reason, i8* noundef %Reserved) {
entry:
  %cmp3 = icmp eq i32 %Reason, 3
  br i1 %cmp3, label %call, label %checkzero

checkzero:
  %isz = icmp eq i32 %Reason, 0
  br i1 %isz, label %call, label %ret

call:
  musttail call void @sub_1400023D0(i8* noundef %DllHandle, i32 noundef %Reason, i8* noundef %Reserved)
  ret void

ret:
  ret void
}