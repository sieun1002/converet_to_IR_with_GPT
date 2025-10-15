; ModuleID = 'linear_search_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define dso_local x86_64_win64cc i32 @linear_search(i32* nocapture readonly %arr, i32 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop.cond

loop.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.inc ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %loop.body, label %exit

loop.body:
  %idx.ext = sext i32 %i to i64
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %val = load i32, i32* %ptr, align 4
  %eq = icmp eq i32 %val, %key
  br i1 %eq, label %found, label %loop.inc

loop.inc:
  %i.next = add nsw i32 %i, 1
  br label %loop.cond

found:
  ret i32 %i

exit:
  ret i32 -1
}