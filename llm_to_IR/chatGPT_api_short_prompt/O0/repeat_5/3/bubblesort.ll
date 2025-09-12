; ModuleID = 'bubble_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bubble_sort ; Address: 0x1189
; Intent: In-place ascending bubble sort with last-swap bound optimization (confidence=0.98). Evidence: adjacent compare/swap on 32-bit ints; outer bound set to last swap index.
; Preconditions: arr points to at least n contiguous 32-bit integers.
; Postconditions: arr[0..n-1] is sorted in nondecreasing order.

; Only the necessary external declarations:

define dso_local void @bubble_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp.le1 = icmp ule i64 %n, 1
  br i1 %cmp.le1, label %return, label %outer.check

outer.check:                                           ; loop over passes
  %ub = phi i64 [ %n, %entry ], [ %lastiter, %after.inner.nz ]
  %ub.gt1 = icmp ugt i64 %ub, 1
  br i1 %ub.gt1, label %inner.cond, label %return

inner.cond:                                            ; inner loop i from 1 to ub-1
  %i = phi i64 [ 1, %outer.check ], [ %i.next, %inner.latch ]
  %lastiter = phi i64 [ 0, %outer.check ], [ %last.next, %inner.latch ]
  %i.lt.ub = icmp ult i64 %i, %ub
  br i1 %i.lt.ub, label %inner.body, label %after.inner

inner.body:
  %idxm1 = add i64 %i, -1
  %pprev = getelementptr inbounds i32, i32* %arr, i64 %idxm1
  %pcur = getelementptr inbounds i32, i32* %arr, i64 %i
  %vprev = load i32, i32* %pprev, align 4
  %vcur = load i32, i32* %pcur, align 4
  %gt = icmp sgt i32 %vprev, %vcur
  br i1 %gt, label %swap, label %noswap

swap:
  store i32 %vcur, i32* %pprev, align 4
  store i32 %vprev, i32* %pcur, align 4
  br label %inner.latch

noswap:
  br label %inner.latch

inner.latch:
  %last.next = phi i64 [ %i, %swap ], [ %lastiter, %noswap ]
  %i.next = add i64 %i, 1
  br label %inner.cond

after.inner:
  %last.zero = icmp eq i64 %lastiter, 0
  br i1 %last.zero, label %return, label %after.inner.nz

after.inner.nz:
  br label %outer.check

return:
  ret void
}