; ModuleID = 'selection_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: selection_sort ; Address: 0x1169
; Intent: In-place selection sort (ascending) on int array (a, n) (confidence=0.99). Evidence: nested j loop updating min index on a[j] < a[min], then swapping a[i] and a[min].
; Preconditions: a must be a valid pointer to at least n 32-bit ints; n >= 0.
; Postconditions: a[0..n-1] sorted in nondecreasing order.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

; Use the IDA symbol here (e.g., @heap_sort or @main)
define dso_local void @selection_sort(i32* nocapture noundef %a, i32 noundef %n) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:                                       ; i loop condition
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %n.minus1 = add nsw i32 %n, -1
  %cmp.outer = icmp slt i32 %i, %n.minus1
  br i1 %cmp.outer, label %outer.body, label %return

outer.body:                                       ; set min=i, j=i+1
  %min0 = add i32 %i, 0
  %j0 = add nsw i32 %i, 1
  br label %inner.cond

inner.cond:                                       ; j/min loop condition
  %j = phi i32 [ %j0, %outer.body ], [ %j.next, %inner.update ]
  %min = phi i32 [ %min0, %outer.body ], [ %min.next, %inner.update ]
  %cmp.inner = icmp slt i32 %j, %n
  br i1 %cmp.inner, label %inner.body, label %inner.exit

inner.body:                                       ; if (a[j] < a[min]) min=j
  %j.idx64 = sext i32 %j to i64
  %j.ptr = getelementptr inbounds i32, i32* %a, i64 %j.idx64
  %j.val = load i32, i32* %j.ptr, align 4
  %min.idx64 = sext i32 %min to i64
  %min.ptr = getelementptr inbounds i32, i32* %a, i64 %min.idx64
  %min.val = load i32, i32* %min.ptr, align 4
  %isless = icmp slt i32 %j.val, %min.val
  %min.sel = select i1 %isless, i32 %j, i32 %min
  br label %inner.update

inner.update:
  %min.next = phi i32 [ %min.sel, %inner.body ]
  %j.next = add nsw i32 %j, 1
  br label %inner.cond

inner.exit:                                       ; swap a[i] and a[min]
  %min.final = phi i32 [ %min, %inner.cond ]
  %i.idx64 = sext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %a, i64 %i.idx64
  %tmp = load i32, i32* %i.ptr, align 4
  %min.final.idx64 = sext i32 %min.final to i64
  %min.final.ptr = getelementptr inbounds i32, i32* %a, i64 %min.final.idx64
  %min.final.val = load i32, i32* %min.final.ptr, align 4
  store i32 %min.final.val, i32* %i.ptr, align 4
  store i32 %tmp, i32* %min.final.ptr, align 4
  %i.next = add nsw i32 %i, 1
  br label %outer.latch

outer.latch:
  br label %outer.cond

return:
  ret void
}