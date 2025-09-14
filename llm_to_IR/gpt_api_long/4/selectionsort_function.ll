; ModuleID = 'selection_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: selection_sort  ; Address: 0x1169
; Intent: In-place selection sort (ascending) of i32 array (confidence=0.98). Evidence: nested loops, min-index tracking, final swap per outer iteration.
; Preconditions: a points to at least n contiguous i32 elements; n >= 0.
; Postconditions: a[0..n) is sorted in nondecreasing order.

define dso_local void @selection_sort(i32* %a, i32 %n) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:                                       ; i loop: for (i = 0; i < n-1; ++i)
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %n_minus_one = add nsw i32 %n, -1
  %outer_cmp = icmp slt i32 %i, %n_minus_one
  br i1 %outer_cmp, label %outer.body, label %exit

outer.body:
  %j0 = add i32 %i, 1
  br label %inner.cond

inner.cond:                                       ; j loop: for (j = i+1; j < n; ++j)
  %minidx = phi i32 [ %i, %outer.body ], [ %min.next, %inner.inc ]
  %j = phi i32 [ %j0, %outer.body ], [ %j.next, %inner.inc ]
  %inner_cmp = icmp slt i32 %j, %n
  br i1 %inner_cmp, label %inner.body, label %after.inner

inner.body:
  %j64 = sext i32 %j to i64
  %min64 = sext i32 %minidx to i64
  %jptr = getelementptr inbounds i32, i32* %a, i64 %j64
  %minptr = getelementptr inbounds i32, i32* %a, i64 %min64
  %vj = load i32, i32* %jptr
  %vmin = load i32, i32* %minptr
  %is_less = icmp slt i32 %vj, %vmin
  %min.next = select i1 %is_less, i32 %j, i32 %minidx
  br label %inner.inc

inner.inc:
  %j.next = add i32 %j, 1
  br label %inner.cond

after.inner:
  %i64 = sext i32 %i to i64
  %min64_2 = sext i32 %minidx to i64
  %iptr = getelementptr inbounds i32, i32* %a, i64 %i64
  %minptr2 = getelementptr inbounds i32, i32* %a, i64 %min64_2
  %vi = load i32, i32* %iptr
  %vmin2 = load i32, i32* %minptr2
  store i32 %vmin2, i32* %iptr
  store i32 %vi, i32* %minptr2
  br label %outer.inc

outer.inc:
  %i.next = add i32 %i, 1
  br label %outer.cond

exit:
  ret void
}