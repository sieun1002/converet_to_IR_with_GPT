; ModuleID = 'stack_probe_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

define dso_local void @sub_1400028E0(i64 %size) local_unnamed_addr {
entry:
  %is_lt = icmp ult i64 %size, 4096
  br i1 %is_lt, label %final, label %loop

loop:
  %phi.size = phi i64 [ %size, %entry ], [ %sub, %loop ]
  call void asm sideeffect "", "~{memory}"()
  %sub = sub i64 %phi.size, 4096
  %cond = icmp ugt i64 %sub, 4096
  br i1 %cond, label %loop, label %final

final:
  call void asm sideeffect "", "~{memory}"()
  ret void
}