; ModuleID = 'module'
source_filename = "module"
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

declare void @sub_1400023D0(i8*, i32, i8*)

define void @TlsCallback_1(i8* %DllHandle, i32 %Reason, i8* %Reserved) {
entry:
  %cmp3 = icmp eq i32 %Reason, 3
  br i1 %cmp3, label %do, label %checkzero

checkzero:
  %iszero = icmp eq i32 %Reason, 0
  br i1 %iszero, label %do, label %ret

do:
  musttail call void @sub_1400023D0(i8* %DllHandle, i32 %Reason, i8* %Reserved)
  ret void

ret:
  ret void
}