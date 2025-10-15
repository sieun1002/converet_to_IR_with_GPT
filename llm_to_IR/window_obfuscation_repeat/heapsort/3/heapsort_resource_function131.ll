; ModuleID = 'TlsCallbackModule'
source_filename = "TlsCallback_1.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare void @sub_1400023D0(i8*, i32, i8*)

define void @TlsCallback_1(i8* %hModule, i32 %dwReason, i8* %reserved) {
entry:
  %cmp = icmp eq i32 %dwReason, 3
  br i1 %cmp, label %do_call, label %check_zero

check_zero:
  %cmpz = icmp eq i32 %dwReason, 0
  br i1 %cmpz, label %do_call, label %ret

do_call:
  tail call void @sub_1400023D0(i8* %hModule, i32 %dwReason, i8* %reserved)
  ret void

ret:
  ret void
}