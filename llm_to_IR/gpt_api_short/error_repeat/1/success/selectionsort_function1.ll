; ModuleID = 'selection_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: selection_sort ; Address: 0x1169
; Intent: In-place ascending selection sort of i32 array (confidence=1.00). Evidence: inner min-index search (arr[j] < arr[min]), swap with arr[i], loop bounds i < n-1, j < n.
; Preconditions: arr points to at least n contiguous i32 elements; n >= 0.
; Postconditions: arr is a permutation of the input and sorted in nondecreasing order.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local void @selection_sort(i32* %arr, i32 %n) local_unnamed_addr {
entry:
  %n.minus1 = add nsw i32 %n, -1
  br label %outer.cond

outer.cond:                                        ; preds = %entry, %outer.inc
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %cmp.outer = icmp slt i32 %i, %n.minus1
  br i1 %cmp.outer, label %outer.body, label %return

outer.body:                                        ; preds = %outer.cond
  %j.init = add nsw i32 %i, 1
  br label %inner.cond

inner.cond:                                        ; preds = %inner.inc, %outer.body
  %min.cur = phi i32 [ %i, %outer.body ], [ %min.next, %inner.inc ]
  %j = phi i32 [ %j.init, %outer.body ], [ %j.next, %inner.inc ]
  %cmp.inner = icmp slt i32 %j, %n
  br i1 %cmp.inner, label %inner.body, label %after.inner

inner.body:                                        ; preds = %inner.cond
  %j.ext = sext i32 %j to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.ext
  %val.j = load i32, i32* %j.ptr, align 4
  %min.ext = sext i32 %min.cur to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.ext
  %val.min = load i32, i32* %min.ptr, align 4
  %is.less = icmp slt i32 %val.j, %val.min
  %min.next = select i1 %is.less, i32 %j, i32 %min.cur
  br label %inner.inc

inner.inc:                                         ; preds = %inner.body
  %j.next = add nsw i32 %j, 1
  br label %inner.cond

after.inner:                                       ; preds = %inner.cond
  %i.ext = sext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %tmp = load i32, i32* %i.ptr, align 4
  %min2.ext = sext i32 %min.cur to i64
  %min2.ptr = getelementptr inbounds i32, i32* %arr, i64 %min2.ext
  %min.val2 = load i32, i32* %min2.ptr, align 4
  store i32 %min.val2, i32* %i.ptr, align 4
  store i32 %tmp, i32* %min2.ptr, align 4
  br label %outer.inc

outer.inc:                                         ; preds = %after.inner
  %i.next = add nsw i32 %i, 1
  br label %outer.cond

return:                                            ; preds = %outer.cond
  ret void
}