; ModuleID = 'selection_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: selection_sort ; Address: 0x1169
; Intent: In-place ascending selection sort of an int array (confidence=0.98). Evidence: tracks min index via arr[j] < arr[min], then swaps a[i] with a[min].
; Preconditions: a points to at least n 32-bit integers.
; Postconditions: a[0..n-1] sorted in nondecreasing order.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local void @selection_sort(i32* nocapture noundef %a, i32 noundef %n) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %outer.latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %n.minus1 = add i32 %n, -1
  %cmp.outer = icmp slt i32 %i, %n.minus1
  br i1 %cmp.outer, label %outer.body, label %exit

outer.body:                                       ; preds = %outer.cond
  %minIndex.init = %i
  %j.init = add i32 %i, 1
  br label %inner.cond

inner.cond:                                       ; preds = %inner.inc, %outer.body
  %minIndex = phi i32 [ %minIndex.init, %outer.body ], [ %minIndex.next, %inner.inc ]
  %j = phi i32 [ %j.init, %outer.body ], [ %j.next, %inner.inc ]
  %cmp.inner = icmp slt i32 %j, %n
  br i1 %cmp.inner, label %inner.body, label %after.inner

inner.body:                                       ; preds = %inner.cond
  %j.idx64 = sext i32 %j to i64
  %j.ptr = getelementptr inbounds i32, i32* %a, i64 %j.idx64
  %j.val = load i32, i32* %j.ptr, align 4
  %min.idx64 = sext i32 %minIndex to i64
  %min.ptr = getelementptr inbounds i32, i32* %a, i64 %min.idx64
  %min.val = load i32, i32* %min.ptr, align 4
  %isLess = icmp slt i32 %j.val, %min.val
  %minIndex.next = select i1 %isLess, i32 %j, i32 %minIndex
  br label %inner.inc

inner.inc:                                        ; preds = %inner.body
  %j.next = add i32 %j, 1
  br label %inner.cond

after.inner:                                      ; preds = %inner.cond
  %i.idx64 = sext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %a, i64 %i.idx64
  %tmp.i = load i32, i32* %i.ptr, align 4
  %min.idx64.fin = sext i32 %minIndex to i64
  %min.ptr.fin = getelementptr inbounds i32, i32* %a, i64 %min.idx64.fin
  %min.val.fin = load i32, i32* %min.ptr.fin, align 4
  store i32 %min.val.fin, i32* %i.ptr, align 4
  store i32 %tmp.i, i32* %min.ptr.fin, align 4
  br label %outer.latch

outer.latch:                                      ; preds = %after.inner
  %i.next = add i32 %i, 1
  br label %outer.cond

exit:                                             ; preds = %outer.cond
  ret void
}