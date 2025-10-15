; ModuleID = 'quick_sort_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

define dso_local void @quick_sort(i32* %arr, i32 %lo, i32 %hi) local_unnamed_addr {
entry:
  %cmp0 = icmp slt i32 %lo, %hi
  br i1 %cmp0, label %partition.init, label %ret0

partition.init:
  %diff = sub nsw i32 %hi, %lo
  %half = ashr i32 %diff, 1
  %mid = add nsw i32 %lo, %half
  %mid64 = sext i32 %mid to i64
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid64
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %partition.loop

partition.loop:
  %i.ph = phi i32 [ %lo, %partition.init ], [ %i.next, %after.swap ]
  %j.ph = phi i32 [ %hi, %partition.init ], [ %j.next, %after.swap ]
  br label %inc_i

inc_i:
  %i.inc = phi i32 [ %i.ph, %partition.loop ], [ %i.inc.next, %inc_i ]
  %i.idx64 = sext i32 %i.inc to i64
  %i.elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.idx64
  %i.val = load i32, i32* %i.elem.ptr, align 4
  %cmp.i = icmp slt i32 %i.val, %pivot
  br i1 %cmp.i, label %inc_i.cont, label %dec_j

inc_i.cont:
  %i.inc.next = add nsw i32 %i.inc, 1
  br label %inc_i

dec_j:
  %i.hold = phi i32 [ %i.inc, %inc_i ], [ %i.hold, %dec_j.cont ]
  %j.dec = phi i32 [ %j.ph, %partition.loop ], [ %j.dec.next, %dec_j.cont ]
  %j.idx64 = sext i32 %j.dec to i64
  %j.elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.idx64
  %j.val = load i32, i32* %j.elem.ptr, align 4
  %cmp.j = icmp sgt i32 %j.val, %pivot
  br i1 %cmp.j, label %dec_j.cont, label %check

dec_j.cont:
  %j.dec.next = add nsw i32 %j.dec, -1
  br label %dec_j

check:
  %i.check = phi i32 [ %i.hold, %dec_j ]
  %j.check = phi i32 [ %j.dec, %dec_j ]
  %cmp.ij = icmp sle i32 %i.check, %j.check
  br i1 %cmp.ij, label %do.swap, label %after.partition

do.swap:
  %i.swap.idx64 = sext i32 %i.check to i64
  %j.swap.idx64 = sext i32 %j.check to i64
  %i.swap.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.swap.idx64
  %j.swap.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.swap.idx64
  %val.i = load i32, i32* %i.swap.ptr, align 4
  %val.j = load i32, i32* %j.swap.ptr, align 4
  store i32 %val.j, i32* %i.swap.ptr, align 4
  store i32 %val.i, i32* %j.swap.ptr, align 4
  %i.next = add nsw i32 %i.check, 1
  %j.next = add nsw i32 %j.check, -1
  br label %after.swap

after.swap:
  br label %partition.loop

after.partition:
  %i.part = phi i32 [ %i.check, %check ]
  %j.part = phi i32 [ %j.check, %check ]
  %left.cond = icmp slt i32 %lo, %j.part
  br i1 %left.cond, label %left.call, label %after.left

left.call:
  call void @quick_sort(i32* %arr, i32 %lo, i32 %j.part)
  br label %after.left

after.left:
  %right.cond = icmp slt i32 %i.part, %hi
  br i1 %right.cond, label %right.call, label %ret

right.call:
  call void @quick_sort(i32* %arr, i32 %i.part, i32 %hi)
  br label %ret

ret0:
  ret void

ret:
  ret void
}