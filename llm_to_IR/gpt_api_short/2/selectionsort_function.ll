; ModuleID = 'selection_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: selection_sort ; Address: 0x1169
; Intent: in-place ascending selection sort for 32-bit int array (confidence=0.98). Evidence: inner loop selects index of minimum; swap with arr[i]
; Preconditions: arr != NULL; n >= 0
; Postconditions: arr[0..n-1] sorted ascending (in-place)

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local void @selection_sort(i32* nocapture noundef %arr, i32 noundef %n) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %n.minus1 = add i32 %n, -1
  %cmp.outer = icmp slt i32 %i, %n.minus1
  br i1 %cmp.outer, label %outer.body, label %return

outer.body:
  %min.init = %i
  %j.init = add nsw i32 %i, 1
  br label %inner.cond

inner.cond:
  %min.cur = phi i32 [ %min.init, %outer.body ], [ %min.next, %inner.inc ]
  %j = phi i32 [ %j.init, %outer.body ], [ %j.next, %inner.inc ]
  %cmp.j = icmp slt i32 %j, %n
  br i1 %cmp.j, label %inner.body, label %after.inner

inner.body:
  %j.idx64 = sext i32 %j to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.idx64
  %valj = load i32, i32* %j.ptr, align 4
  %min.idx64 = sext i32 %min.cur to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.idx64
  %valmin = load i32, i32* %min.ptr, align 4
  %cmp = icmp slt i32 %valj, %valmin
  %min.next = select i1 %cmp, i32 %j, i32 %min.cur
  br label %inner.inc

inner.inc:
  %j.next = add nsw i32 %j, 1
  br label %inner.cond

after.inner:
  %i.idx64 = sext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.idx64
  %tmp = load i32, i32* %i.ptr, align 4
  %min.final.idx64 = sext i32 %min.cur to i64
  %min.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %min.final.idx64
  %min.val2 = load i32, i32* %min.ptr2, align 4
  store i32 %min.val2, i32* %i.ptr, align 4
  store i32 %tmp, i32* %min.ptr2, align 4
  br label %outer.inc

outer.inc:
  %i.next = add nsw i32 %i, 1
  br label %outer.cond

return:
  ret void
}