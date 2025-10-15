target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

define dso_local i32 @linear_search(i32* %arr, i32 %n, i32 %target) local_unnamed_addr {
entry:
  %cmp0 = icmp sle i32 %n, 0
  br i1 %cmp0, label %ret_neg1, label %init

init:
  %n64 = sext i32 %n to i64
  br label %loop

loop:
  %i = phi i64 [ 0, %init ], [ %i.next, %cont ]
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %match = icmp eq i32 %elem, %target
  br i1 %match, label %found, label %cont

cont:
  %i.next = add i64 %i, 1
  %done = icmp eq i64 %i.next, %n64
  br i1 %done, label %ret_neg1, label %loop

found:
  %retidx = trunc i64 %i to i32
  ret i32 %retidx

ret_neg1:
  ret i32 -1
}