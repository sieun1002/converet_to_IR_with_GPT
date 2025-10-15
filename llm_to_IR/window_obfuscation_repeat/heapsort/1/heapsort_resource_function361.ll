; ModuleID = 'stack_probe_module'
source_filename = "stack_probe.ll"
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"

declare i8* @llvm.stacksave()

define void @sub_1400028E0(i64 %size) {
entry:
  %sp = call i8* @llvm.stacksave()
  br label %loop.header

loop.header:
  %cur = phi i8* [ %sp, %entry ], [ %cur.dec, %loop.body ]
  %sz = phi i64 [ %size, %entry ], [ %sz.dec, %loop.body ]
  %cmp = icmp ugt i64 %sz, 4096
  br i1 %cmp, label %loop.body, label %after

loop.body:
  %cur.dec = getelementptr inbounds i8, i8* %cur, i64 -4096
  %touch = load volatile i8, i8* %cur.dec, align 1
  %sz.dec = sub i64 %sz, 4096
  br label %loop.header

after:
  %neg = sub i64 0, %sz
  %final = getelementptr inbounds i8, i8* %cur, i64 %neg
  %touch2 = load volatile i8, i8* %final, align 1
  ret void
}