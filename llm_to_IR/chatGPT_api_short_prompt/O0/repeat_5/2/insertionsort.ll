; ModuleID = 'insertion_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: insertion_sort ; Address: 0x1189
; Intent: In-place ascending insertion sort of i32 array (confidence=0.98). Evidence: key/j pattern with shifting by 4-byte elements; unsigned outer bound (jb) and signed inner compare (jl).
; Preconditions: arr points to at least n 32-bit elements.
; Postconditions: arr[0..n-1] sorted in nondecreasing order.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local void @insertion_sort(i32* %arr, i64 %n) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %outer.latch, %entry
  %i = phi i64 [ 1, %entry ], [ %i.next, %outer.latch ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %outer.body, label %exit

outer.body:                                        ; preds = %outer.cond
  %gep.i = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %gep.i, align 4
  br label %inner.cond

inner.cond:                                        ; preds = %inner.shift, %outer.body
  %j = phi i64 [ %i, %outer.body ], [ %j.dec, %inner.shift ]
  %j.is0 = icmp eq i64 %j, 0
  br i1 %j.is0, label %place, label %inner.test

inner.test:                                        ; preds = %inner.cond
  %jm1 = add i64 %j, -1
  %ptr.jm1 = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %t = load i32, i32* %ptr.jm1, align 4
  %cmp = icmp slt i32 %key, %t
  br i1 %cmp, label %inner.shift, label %place

inner.shift:                                       ; preds = %inner.test
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %t, i32* %ptr.j, align 4
  %j.dec = add i64 %j, -1
  br label %inner.cond

place:                                             ; preds = %inner.test, %inner.cond
  %ptr.j.place = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %key, i32* %ptr.j.place, align 4
  br label %outer.latch

outer.latch:                                       ; preds = %place
  %i.next = add i64 %i, 1
  br label %outer.cond

exit:                                              ; preds = %outer.cond
  ret void
}