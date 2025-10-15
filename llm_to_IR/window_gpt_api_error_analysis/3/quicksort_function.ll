; ModuleID = 'quick_sort_module'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define void @quick_sort(i32* %arr, i32 %left, i32 %right) {
entry:
  %cmpstart = icmp slt i32 %left, %right
  br i1 %cmpstart, label %partition.entry, label %ret

partition.entry:
  %delta = sub i32 %right, %left
  %half = ashr i32 %delta, 1
  %mid = add i32 %left, %half
  %mid64 = sext i32 %mid to i64
  %pivptr = getelementptr inbounds i32, i32* %arr, i64 %mid64
  %pivot = load i32, i32* %pivptr, align 4
  br label %outer.loop

outer.loop:
  %i.cur = phi i32 [ %left, %partition.entry ], [ %i.next2, %do.swap ]
  %j.cur = phi i32 [ %right, %partition.entry ], [ %j.next2, %do.swap ]
  br label %inc.i.loop

inc.i.loop:
  %i.inner = phi i32 [ %i.cur, %outer.loop ], [ %i.inc, %inc.i.loop.inc ]
  %i64 = sext i32 %i.inner to i64
  %iptr = getelementptr inbounds i32, i32* %arr, i64 %i64
  %ival = load i32, i32* %iptr, align 4
  %lt = icmp slt i32 %ival, %pivot
  br i1 %lt, label %inc.i.loop.inc, label %dec.j.loop

inc.i.loop.inc:
  %i.inc = add nsw i32 %i.inner, 1
  br label %inc.i.loop

dec.j.loop:
  %i.fixed = phi i32 [ %i.inner, %inc.i.loop ], [ %i.fixed, %dec.j.loop.body ]
  %j.iter = phi i32 [ %j.cur, %inc.i.loop ], [ %j.dec, %dec.j.loop.body ]
  %j64 = sext i32 %j.iter to i64
  %jptr = getelementptr inbounds i32, i32* %arr, i64 %j64
  %jval = load i32, i32* %jptr, align 4
  %gt = icmp sgt i32 %jval, %pivot
  br i1 %gt, label %dec.j.loop.body, label %compare

dec.j.loop.body:
  %j.dec = add nsw i32 %j.iter, -1
  br label %dec.j.loop

compare:
  %i.final = phi i32 [ %i.fixed, %dec.j.loop ]
  %j.final = phi i32 [ %j.iter, %dec.j.loop ]
  %cmpij = icmp sle i32 %i.final, %j.final
  br i1 %cmpij, label %do.swap, label %part.done

do.swap:
  %i64b = sext i32 %i.final to i64
  %iptr2 = getelementptr inbounds i32, i32* %arr, i64 %i64b
  %j64b = sext i32 %j.final to i64
  %jptr2 = getelementptr inbounds i32, i32* %arr, i64 %j64b
  %vi = load i32, i32* %iptr2, align 4
  %vj = load i32, i32* %jptr2, align 4
  store i32 %vj, i32* %iptr2, align 4
  store i32 %vi, i32* %jptr2, align 4
  %i.next2 = add nsw i32 %i.final, 1
  %j.next2 = add nsw i32 %j.final, -1
  br label %outer.loop

part.done:
  %cond.left = icmp slt i32 %left, %j.final
  br i1 %cond.left, label %recurse.left, label %after.left

recurse.left:
  call void @quick_sort(i32* %arr, i32 %left, i32 %j.final)
  br label %after.left

after.left:
  %cond.right = icmp slt i32 %i.final, %right
  br i1 %cond.right, label %recurse.right, label %ret

recurse.right:
  call void @quick_sort(i32* %arr, i32 %i.final, i32 %right)
  br label %ret

ret:
  ret void
}