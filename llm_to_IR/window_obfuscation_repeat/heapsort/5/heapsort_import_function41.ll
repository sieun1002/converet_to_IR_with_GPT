; ModuleID = 'tls_callback_module'
source_filename = "tls_callback.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare void @sub_1400023D0(i8*, i32, i8*)

define void @TlsCallback_2(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %cmp3 = icmp eq i32 %Reason, 3
  br i1 %cmp3, label %calljmp, label %checkzero

checkzero:
  %iszero = icmp eq i32 %Reason, 0
  br i1 %iszero, label %calljmp, label %retblock

retblock:
  ret void

calljmp:
  musttail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void
}