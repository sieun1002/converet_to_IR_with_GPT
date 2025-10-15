; ModuleID = 'heapsort_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define void @heap_sort(i32* %arr, i64 %n) {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %ret, label %heapify.pre

heapify.pre:
  %half = lshr i64 %n, 1
  br label %heapify.outer

heapify.outer:
  %i = phi i64 [ %half, %heapify.pre ], [ %i.dec, %heapify.afterInner ]
  %i.iszero = icmp eq i64 %i, 0
  br i1 %i.iszero, label %after_heapify, label %heapify.inner.header

heapify.inner.header:
  %j = phi i64 [ %i, %heapify.outer ], [ %k, %heapify.swap ]
  %j.mul2 = mul i64 %j, 2
  %left = add i64 %j.mul2, 1
  %left.ge.n = icmp uge i64 %left, %n
  br i1 %left.ge.n, label %heapify.afterInner, label %heapify.rightcheck

heapify.rightcheck:
  %right = add i64 %left, 1
  %right.lt.n = icmp ult i64 %right, %n
  br i1 %right.lt.n, label %heapify.compareChildren, label %heapify.parentCompare.left

heapify.compareChildren:
  %left.ptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %left.val = load i32, i32* %left.ptr, align 4
  %right.ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right.val = load i32, i32* %right.ptr, align 4
  %right.gt.left = icmp sgt i32 %right.val, %left.val
  br i1 %right.gt.left, label %heapify.parentCompare.right, label %heapify.parentCompare.left

heapify.parentCompare.left:
  %k.left = phi i64 [ %left, %heapify.rightcheck ], [ %left, %heapify.compareChildren ]
  br label %heapify.parentCompare

heapify.parentCompare.right:
  %k.right = phi i64 [ %right, %heapify.compareChildren ]
  br label %heapify.parentCompare

heapify.parentCompare:
  %k = phi i64 [ %k.left, %heapify.parentCompare.left ], [ %k.right, %heapify.parentCompare.right ]
  %parent.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %parent.val = load i32, i32* %parent.ptr, align 4
  %child.ptr = getelementptr inbounds i32, i32* %arr, i64 %k
  %child.val = load i32, i32* %child.ptr, align 4
  %parent.lt.child = icmp slt i32 %parent.val, %child.val
  br i1 %parent.lt.child, label %heapify.swap, label %heapify.afterInner

heapify.swap:
  store i32 %child.val, i32* %parent.ptr, align 4
  store i32 %parent.val, i32* %child.ptr, align 4
  br label %heapify.inner.header

heapify.afterInner:
  %i.dec = add i64 %i, -1
  br label %heapify.outer

after_heapify:
  %i2.init = add i64 %n, -1
  br label %sort.outer

sort.outer:
  %i2 = phi i64 [ %i2.init, %after_heapify ], [ %i2.dec, %sort.afterInner ]
  %i2.iszero = icmp eq i64 %i2, 0
  br i1 %i2.iszero, label %ret, label %sort.swapRoot

sort.swapRoot:
  %root.ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %last.ptr = getelementptr inbounds i32, i32* %arr, i64 %i2
  %root.val = load i32, i32* %root.ptr, align 4
  %last.val = load i32, i32* %last.ptr, align 4
  store i32 %last.val, i32* %root.ptr, align 4
  store i32 %root.val, i32* %last.ptr, align 4
  br label %sort.inner.header

sort.inner.header:
  %j2 = phi i64 [ 0, %sort.swapRoot ], [ %k2, %sort.swap ]
  %j2.mul2 = mul i64 %j2, 2
  %left2 = add i64 %j2.mul2, 1
  %left2.ge.i2 = icmp uge i64 %left2, %i2
  br i1 %left2.ge.i2, label %sort.afterInner, label %sort.rightcheck

sort.rightcheck:
  %right2 = add i64 %left2, 1
  %right2.lt.i2 = icmp ult i64 %right2, %i2
  br i1 %right2.lt.i2, label %sort.compareChildren, label %sort.parentCompare.left

sort.compareChildren:
  %left2.ptr = getelementptr inbounds i32, i32* %arr, i64 %left2
  %left2.val = load i32, i32* %left2.ptr, align 4
  %right2.ptr = getelementptr inbounds i32, i32* %arr, i64 %right2
  %right2.val = load i32, i32* %right2.ptr, align 4
  %right2.gt.left2 = icmp sgt i32 %right2.val, %left2.val
  br i1 %right2.gt.left2, label %sort.parentCompare.right, label %sort.parentCompare.left

sort.parentCompare.left:
  %k2.left = phi i64 [ %left2, %sort.rightcheck ], [ %left2, %sort.compareChildren ]
  br label %sort.parentCompare

sort.parentCompare.right:
  %k2.right = phi i64 [ %right2, %sort.compareChildren ]
  br label %sort.parentCompare

sort.parentCompare:
  %k2 = phi i64 [ %k2.left, %sort.parentCompare.left ], [ %k2.right, %sort.parentCompare.right ]
  %parent2.ptr = getelementptr inbounds i32, i32* %arr, i64 %j2
  %parent2.val = load i32, i32* %parent2.ptr, align 4
  %child2.ptr = getelementptr inbounds i32, i32* %arr, i64 %k2
  %child2.val = load i32, i32* %child2.ptr, align 4
  %parent2.ge.child2 = icmp sge i32 %parent2.val, %child2.val
  br i1 %parent2.ge.child2, label %sort.afterInner, label %sort.swap

sort.swap:
  store i32 %child2.val, i32* %parent2.ptr, align 4
  store i32 %parent2.val, i32* %child2.ptr, align 4
  br label %sort.inner.header

sort.afterInner:
  %i2.dec = add i64 %i2, -1
  br label %sort.outer

ret:
  ret void
}