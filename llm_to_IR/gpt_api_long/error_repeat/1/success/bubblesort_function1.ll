; ModuleID = 'bubble_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bubble_sort  ; Address: 0x1189
; Intent: In-place bubble sort of i32 array with last-swap bound optimization (confidence=0.95). Evidence: adjacent 32-bit comparisons/swaps; inner loop from 1..bound-1 with last-swap tracking
; Preconditions: %a points to at least %n contiguous i32 elements
; Postconditions: %a[0..%n-1] is sorted in non-decreasing (signed) order

define dso_local void @bubble_sort(i32* %a, i64 %n) local_unnamed_addr {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %ret, label %outer.header

outer.header:
  %newn = phi i64 [ %n, %entry ], [ %newn2, %outer.latch ]
  br label %inner.header

inner.header:
  %i = phi i64 [ 1, %outer.header ], [ %i.next, %inner.latch ]
  %last = phi i64 [ 0, %outer.header ], [ %last.next, %inner.latch ]
  %cond.i = icmp ult i64 %i, %newn
  br i1 %cond.i, label %inner.body, label %inner.exit

inner.body:
  %i.minus1 = add i64 %i, -1
  %leftptr = getelementptr inbounds i32, i32* %a, i64 %i.minus1
  %rightptr = getelementptr inbounds i32, i32* %a, i64 %i
  %left = load i32, i32* %leftptr, align 4
  %right = load i32, i32* %rightptr, align 4
  %cmp.swap = icmp sgt i32 %left, %right
  br i1 %cmp.swap, label %do.swap, label %no.swap

do.swap:
  store i32 %right, i32* %leftptr, align 4
  store i32 %left, i32* %rightptr, align 4
  br label %inner.latch

no.swap:
  br label %inner.latch

inner.latch:
  %last.next = phi i64 [ %i, %do.swap ], [ %last, %no.swap ]
  %i.next = add i64 %i, 1
  br label %inner.header

inner.exit:
  %iszero = icmp eq i64 %last, 0
  br i1 %iszero, label %ret, label %cont.outer

cont.outer:
  %newn2 = add i64 %last, 0
  %cond.newn = icmp ugt i64 %newn2, 1
  br i1 %cond.newn, label %outer.latch, label %ret

outer.latch:
  br label %outer.header

ret:
  ret void
}