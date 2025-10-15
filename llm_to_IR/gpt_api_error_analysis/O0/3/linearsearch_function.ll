; ModuleID = 'linear_search.ll'
source_filename = "linear_search.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

define dso_local i32 @linear_search(i32* nocapture readonly %arr, i32 %n, i32 %target) local_unnamed_addr {
entry:
  br label %loop.header

loop.header:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.latch ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %loop.body, label %exit.notfound

loop.body:
  %idxprom = sext i32 %i to i64
  %eltptr = getelementptr inbounds i32, i32* %arr, i64 %idxprom
  %val = load i32, i32* %eltptr, align 4
  %eq = icmp eq i32 %val, %target
  br i1 %eq, label %found, label %loop.latch

loop.latch:
  %i.next = add nsw i32 %i, 1
  br label %loop.header

found:
  ret i32 %i

exit.notfound:
  ret i32 -1
}