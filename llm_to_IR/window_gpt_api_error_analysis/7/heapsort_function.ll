; ModuleID = 'heap_sort.ll'
source_filename = "heap_sort.ll"
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

define void @heap_sort(i32* %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp_n = icmp ule i64 %n, 1
  br i1 %cmp_n, label %exit, label %heapify.init

heapify.init:
  %half = lshr i64 %n, 1
  br label %heapify.loop

heapify.loop:
  %i.cur = phi i64 [ %half, %heapify.init ], [ %i.next, %heapify.after_inner ]
  %i.is.zero = icmp eq i64 %i.cur, 0
  br i1 %i.is.zero, label %after.heapify, label %heapify.preinner

heapify.preinner:
  %i.next = add i64 %i.cur, -1
  br label %inner.loop

inner.loop:
  %j.cur = phi i64 [ %i.next, %heapify.preinner ], [ %child.idx, %inner.swap ]
  %j.twice = shl i64 %j.cur, 1
  %left = or i64 %j.twice, 1
  %left.in = icmp ult i64 %left, %n
  br i1 %left.in, label %have.left, label %inner.break

have.left:
  %right = add i64 %left, 1
  %right.in = icmp ult i64 %right, %n
  %left.ptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %left.val = load i32, i32* %left.ptr, align 4
  br i1 %right.in, label %check.right, label %child.is.left

check.right:
  %right.ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right.val = load i32, i32* %right.ptr, align 4
  %right.gt.left = icmp sgt i32 %right.val, %left.val
  br i1 %right.gt.left, label %child.is.right, label %child.is.left

child.is.left:
  br label %select.child

child.is.right:
  br label %select.child

select.child:
  %child.idx = phi i64 [ %left, %child.is.left ], [ %right, %child.is.right ]
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %j.val = load i32, i32* %j.ptr, align 4
  %child.ptr = getelementptr inbounds i32, i32* %arr, i64 %child.idx
  %child.val = load i32, i32* %child.ptr, align 4
  %j.lt.child = icmp slt i32 %j.val, %child.val
  br i1 %j.lt.child, label %inner.swap, label %inner.break

inner.swap:
  store i32 %child.val, i32* %j.ptr, align 4
  store i32 %j.val, i32* %child.ptr, align 4
  br label %inner.loop

inner.break:
  br label %heapify.after_inner

heapify.after_inner:
  br label %heapify.loop

after.heapify:
  %k.init = add i64 %n, -1
  br label %reduce.loop

reduce.loop:
  %k.cur = phi i64 [ %k.init, %after.heapify ], [ %k.next, %reduce.after_inner ]
  %k.nonzero = icmp ne i64 %k.cur, 0
  br i1 %k.nonzero, label %reduce.body, label %exit

reduce.body:
  %root.ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %root.val = load i32, i32* %root.ptr, align 4
  %k.ptr = getelementptr inbounds i32, i32* %arr, i64 %k.cur
  %k.val = load i32, i32* %k.ptr, align 4
  store i32 %k.val, i32* %root.ptr, align 4
  store i32 %root.val, i32* %k.ptr, align 4
  br label %reduce.inner.loop

reduce.inner.loop:
  %j2.cur = phi i64 [ 0, %reduce.body ], [ %child2.idx, %reduce.inner.swap ]
  %j2.twice = shl i64 %j2.cur, 1
  %left2 = or i64 %j2.twice, 1
  %left2.ge.k = icmp uge i64 %left2, %k.cur
  br i1 %left2.ge.k, label %reduce.after_inner, label %reduce.have.left

reduce.have.left:
  %right2 = add i64 %left2, 1
  %right2.in = icmp ult i64 %right2, %k.cur
  %left2.ptr = getelementptr inbounds i32, i32* %arr, i64 %left2
  %left2.val = load i32, i32* %left2.ptr, align 4
  br i1 %right2.in, label %reduce.check.right, label %reduce.child.left

reduce.check.right:
  %right2.ptr = getelementptr inbounds i32, i32* %arr, i64 %right2
  %right2.val = load i32, i32* %right2.ptr, align 4
  %right2.gt.left2 = icmp sgt i32 %right2.val, %left2.val
  br i1 %right2.gt.left2, label %reduce.child.right, label %reduce.child.left

reduce.child.left:
  br label %reduce.select.child

reduce.child.right:
  br label %reduce.select.child

reduce.select.child:
  %child2.idx = phi i64 [ %left2, %reduce.child.left ], [ %right2, %reduce.child.right ]
  %j2.ptr = getelementptr inbounds i32, i32* %arr, i64 %j2.cur
  %j2.val = load i32, i32* %j2.ptr, align 4
  %child2.ptr = getelementptr inbounds i32, i32* %arr, i64 %child2.idx
  %child2.val = load i32, i32* %child2.ptr, align 4
  %j2.ge.child2 = icmp sge i32 %j2.val, %child2.val
  br i1 %j2.ge.child2, label %reduce.after_inner, label %reduce.inner.swap

reduce.inner.swap:
  store i32 %child2.val, i32* %j2.ptr, align 4
  store i32 %j2.val, i32* %child2.ptr, align 4
  br label %reduce.inner.loop

reduce.after_inner:
  %k.next = add i64 %k.cur, -1
  br label %reduce.loop

exit:
  ret void
}