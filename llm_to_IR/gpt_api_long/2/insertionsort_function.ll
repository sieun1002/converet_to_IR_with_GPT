; ModuleID = 'insertion_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: insertion_sort  ; Address: 0x1189
; Intent: In-place insertion sort (ascending, signed i32) (confidence=0.95). Evidence: 4-byte strides with i32 loads/stores; inner shift loop comparing key < arr[j-1] then shifting.
; Preconditions: a points to at least n elements of i32.
; Postconditions: a[0..n) is sorted ascending using signed 32-bit comparison.

define dso_local void @insertion_sort(i32* %a, i64 %n) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:                                        ; preds = %outer.latch, %entry
  %i = phi i64 [ 1, %entry ], [ %i.next, %outer.latch ]
  %cmp.i.n = icmp ult i64 %i, %n
  br i1 %cmp.i.n, label %outer.body, label %exit

outer.body:                                        ; preds = %outer.cond
  %a.i.ptr = getelementptr inbounds i32, i32* %a, i64 %i
  %key = load i32, i32* %a.i.ptr, align 4
  br label %inner.cond

inner.cond:                                        ; preds = %shift, %outer.body
  %j = phi i64 [ %i, %outer.body ], [ %j.dec, %shift ]
  %j.is.zero = icmp eq i64 %j, 0
  br i1 %j.is.zero, label %insert, label %check

check:                                             ; preds = %inner.cond
  %jm1 = add nsw i64 %j, -1
  %ptr.jm1 = getelementptr inbounds i32, i32* %a, i64 %jm1
  %val.jm1 = load i32, i32* %ptr.jm1, align 4
  %need.shift = icmp slt i32 %key, %val.jm1
  br i1 %need.shift, label %shift, label %insert

shift:                                             ; preds = %check
  %ptr.j = getelementptr inbounds i32, i32* %a, i64 %j
  store i32 %val.jm1, i32* %ptr.j, align 4
  %j.dec = add nsw i64 %j, -1
  br label %inner.cond

insert:                                            ; preds = %check, %inner.cond
  %ptr.j.fin = getelementptr inbounds i32, i32* %a, i64 %j
  store i32 %key, i32* %ptr.j.fin, align 4
  br label %outer.latch

outer.latch:                                       ; preds = %insert
  %i.next = add nuw nsw i64 %i, 1
  br label %outer.cond

exit:                                              ; preds = %outer.cond
  ret void
}