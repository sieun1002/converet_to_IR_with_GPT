; ModuleID = 'selection_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: selection_sort  ; Address: 0x1169
; Intent: In-place ascending selection sort of an i32 array (confidence=0.98). Evidence: nested loops track min index and swap with current position
; Preconditions: a points to at least n contiguous i32 elements; n >= 0
; Postconditions: The first n elements at a are sorted in non-decreasing order (in-place; not stable)

define dso_local void @selection_sort(i32* %a, i32 %n) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %outer.inc, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %n_minus1 = add i32 %n, -1
  %outer.cmp = icmp slt i32 %i, %n_minus1
  br i1 %outer.cmp, label %outer.body, label %ret

outer.body:                                       ; preds = %outer.cond
  %min.init = %i
  %j.init = add i32 %i, 1
  br label %inner.cond

inner.cond:                                       ; preds = %inner.body.end, %outer.body
  %j = phi i32 [ %j.init, %outer.body ], [ %j.next, %inner.body.end ]
  %min.cur = phi i32 [ %min.init, %outer.body ], [ %min.next, %inner.body.end ]
  %cmpj = icmp slt i32 %j, %n
  br i1 %cmpj, label %inner.body, label %after.inner

inner.body:                                       ; preds = %inner.cond
  %j.idx64 = sext i32 %j to i64
  %min.idx64 = sext i32 %min.cur to i64
  %j.ptr = getelementptr inbounds i32, i32* %a, i64 %j.idx64
  %min.ptr = getelementptr inbounds i32, i32* %a, i64 %min.idx64
  %j.val = load i32, i32* %j.ptr, align 4
  %min.val = load i32, i32* %min.ptr, align 4
  %lt = icmp slt i32 %j.val, %min.val
  %min.next = select i1 %lt, i32 %j, i32 %min.cur
  %j.next = add i32 %j, 1
  br label %inner.body.end

inner.body.end:                                   ; preds = %inner.body
  br label %inner.cond

after.inner:                                      ; preds = %inner.cond
  %min.final = %min.cur
  %i.idx64 = sext i32 %i to i64
  %min2.idx64 = sext i32 %min.final to i64
  %i.ptr = getelementptr inbounds i32, i32* %a, i64 %i.idx64
  %min2.ptr = getelementptr inbounds i32, i32* %a, i64 %min2.idx64
  %temp = load i32, i32* %i.ptr, align 4
  %minval2 = load i32, i32* %min2.ptr, align 4
  store i32 %minval2, i32* %i.ptr, align 4
  store i32 %temp, i32* %min2.ptr, align 4
  br label %outer.inc

outer.inc:                                        ; preds = %after.inner
  %i.next = add i32 %i, 1
  br label %outer.cond

ret:                                              ; preds = %outer.cond
  ret void
}