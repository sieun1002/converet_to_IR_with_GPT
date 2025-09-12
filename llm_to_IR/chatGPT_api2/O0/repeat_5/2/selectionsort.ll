; ModuleID = 'selection_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: selection_sort  ; Address: 0x1169
; Intent: In-place ascending selection sort for i32 array (confidence=0.99). Evidence: min-index search inner loop; unconditional swap each outer iteration
; Preconditions: arr points to at least n 32-bit elements (if n > 0).
; Postconditions: arr[0..n-1] sorted in nondecreasing order.

define dso_local void @selection_sort(i32* %arr, i32 %n) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %outer.latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %n_minus1 = add i32 %n, -1
  %cond.outer = icmp slt i32 %i, %n_minus1
  br i1 %cond.outer, label %outer.body, label %exit

outer.body:                                       ; preds = %outer.cond
  %min.init = %i
  %j.init = add i32 %i, 1
  br label %inner.cond

inner.cond:                                       ; preds = %inner.body, %outer.body
  %min.cur = phi i32 [ %min.init, %outer.body ], [ %min.updated, %inner.body ]
  %j.cur = phi i32 [ %j.init, %outer.body ], [ %j.next, %inner.body ]
  %cond.inner = icmp slt i32 %j.cur, %n
  br i1 %cond.inner, label %inner.body, label %after.inner

inner.body:                                       ; preds = %inner.cond
  %j.idx = sext i32 %j.cur to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.idx
  %j.val = load i32, i32* %j.ptr, align 4
  %min.idx = sext i32 %min.cur to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.idx
  %min.val = load i32, i32* %min.ptr, align 4
  %is.less = icmp slt i32 %j.val, %min.val
  %min.updated = select i1 %is.less, i32 %j.cur, i32 %min.cur
  %j.next = add i32 %j.cur, 1
  br label %inner.cond

after.inner:                                      ; preds = %inner.cond
  %i.idx = sext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.idx
  %tmp = load i32, i32* %i.ptr, align 4
  %min.idx2 = sext i32 %min.cur to i64
  %min.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %min.idx2
  %min.val2 = load i32, i32* %min.ptr2, align 4
  store i32 %min.val2, i32* %i.ptr, align 4
  store i32 %tmp, i32* %min.ptr2, align 4
  br label %outer.latch

outer.latch:                                      ; preds = %after.inner
  %i.next = add i32 %i, 1
  br label %outer.cond

exit:                                             ; preds = %outer.cond
  ret void
}