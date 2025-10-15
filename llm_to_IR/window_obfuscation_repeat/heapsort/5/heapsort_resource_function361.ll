; ModuleID = 'sub_1400028E0.ll'
source_filename = "sub_1400028E0.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define dso_local void @sub_1400028E0(i64 %size, i8* %sp) nounwind {
entry:
  %cmp = icmp ugt i64 %size, 4096
  br i1 %cmp, label %loop, label %tail

loop:
  %sp.ph = phi i8* [ %sp, %entry ], [ %sp.next, %loop ]
  %sz.ph = phi i64 [ %size, %entry ], [ %sz.next, %loop ]
  %sp.next = getelementptr i8, i8* %sp.ph, i64 -4096
  %ld = load volatile i8, i8* %sp.next, align 1
  store volatile i8 %ld, i8* %sp.next, align 1
  %sz.next = sub i64 %sz.ph, 4096
  %cond = icmp ugt i64 %sz.next, 4096
  br i1 %cond, label %loop, label %tail

tail:
  %sp.cur = phi i8* [ %sp, %entry ], [ %sp.next, %loop ]
  %sz.cur = phi i64 [ %size, %entry ], [ %sz.next, %loop ]
  %neg = sub i64 0, %sz.cur
  %sp.final = getelementptr i8, i8* %sp.cur, i64 %neg
  %ld2 = load volatile i8, i8* %sp.final, align 1
  store volatile i8 %ld2, i8* %sp.final, align 1
  ret void
}