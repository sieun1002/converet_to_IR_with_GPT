; ModuleID = 'insertion_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: insertion_sort ; Address: 0x1189
; Intent: In-place insertion sort of an int32 array in ascending order (confidence=0.98). Evidence: index by 4-byte stride; shift-down loop while key < A[j-1]; outer i from 1..n-1.
; Preconditions: arr points to at least n 32-bit elements.
; Postconditions: arr is sorted in nondecreasing order.

; Only the necessary external declarations:
; (none)

define dso_local void @insertion_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %outer.inc, %entry
  %i = phi i64 [ 1, %entry ], [ %i.next, %outer.inc ]
  %cmp.i.n = icmp ult i64 %i, %n
  br i1 %cmp.i.n, label %outer.body, label %ret

outer.body:                                       ; preds = %outer.cond
  %key.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %key.ptr, align 4
  br label %inner.cond

inner.cond:                                       ; preds = %inner.body, %outer.body
  %j = phi i64 [ %i, %outer.body ], [ %j.dec, %inner.body ]
  %j.iszero = icmp eq i64 %j, 0
  br i1 %j.iszero, label %inner.end, label %inner.check

inner.check:                                      ; preds = %inner.cond
  %j.minus1 = add i64 %j, -1
  %prev.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.minus1
  %prev = load i32, i32* %prev.ptr, align 4
  %need.shift = icmp slt i32 %key, %prev
  br i1 %need.shift, label %inner.body, label %inner.end

inner.body:                                       ; preds = %inner.check
  %dest.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %prev, i32* %dest.ptr, align 4
  %j.dec = add i64 %j, -1
  br label %inner.cond

inner.end:                                        ; preds = %inner.check, %inner.cond
  %j.exit = phi i64 [ %j, %inner.cond ], [ %j, %inner.check ]
  %ins.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.exit
  store i32 %key, i32* %ins.ptr, align 4
  br label %outer.inc

outer.inc:                                        ; preds = %inner.end
  %i.next = add i64 %i, 1
  br label %outer.cond

ret:                                              ; preds = %outer.cond
  ret void
}