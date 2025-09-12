; ModuleID = 'selection_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: selection_sort ; Address: 0x1169
; Intent: In-place ascending selection sort of an int array (confidence=0.98). Evidence: nested loops with min-index tracking; swap arr[i] with arr[min]
; Preconditions: arr points to at least n i32 elements; n >= 0
; Postconditions: arr[0..n-1] sorted in nondecreasing order

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local void @selection_sort(i32* %arr, i32 %n) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:                                          ; preds = %outer.inc, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %n_minus_1 = add i32 %n, -1
  %cmp.outer = icmp slt i32 %i, %n_minus_1
  br i1 %cmp.outer, label %outer.body, label %return

outer.body:                                          ; preds = %outer.cond
  %min.init = add i32 %i, 0
  %j.init = add i32 %i, 1
  br label %inner.cond

inner.cond:                                          ; preds = %inner.body, %outer.body
  %j = phi i32 [ %j.init, %outer.body ], [ %j.next, %inner.body ]
  %minIdx = phi i32 [ %min.init, %outer.body ], [ %min.next, %inner.body ]
  %cmp.inner = icmp slt i32 %j, %n
  br i1 %cmp.inner, label %inner.body, label %after.inner

inner.body:                                          ; preds = %inner.cond
  %j.idx64 = sext i32 %j to i64
  %arr.j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.idx64
  %val.j = load i32, i32* %arr.j.ptr, align 4
  %min.idx64 = sext i32 %minIdx to i64
  %arr.min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.idx64
  %val.min = load i32, i32* %arr.min.ptr, align 4
  %isLess = icmp slt i32 %val.j, %val.min
  %min.next = select i1 %isLess, i32 %j, i32 %minIdx
  %j.next = add i32 %j, 1
  br label %inner.cond

after.inner:                                         ; preds = %inner.cond
  %i.idx64 = sext i32 %i to i64
  %arr.i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.idx64
  %tmp = load i32, i32* %arr.i.ptr, align 4
  %min.idx64.2 = sext i32 %minIdx to i64
  %arr.min2.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.idx64.2
  %val.min2 = load i32, i32* %arr.min2.ptr, align 4
  store i32 %val.min2, i32* %arr.i.ptr, align 4
  store i32 %tmp, i32* %arr.min2.ptr, align 4
  br label %outer.inc

outer.inc:                                           ; preds = %after.inner
  %i.next = add i32 %i, 1
  br label %outer.cond

return:                                              ; preds = %outer.cond
  ret void
}