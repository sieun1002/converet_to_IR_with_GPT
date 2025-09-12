; ModuleID = 'selection_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: selection_sort ; Address: 0x1169
; Intent: In-place ascending selection sort of an int array (confidence=0.99). Evidence: nested min-search loop with 4-byte indexing and final swap.
; Preconditions: arr != NULL; n >= 0
; Postconditions: arr[0..n-1] is sorted in nondecreasing order; in-place

; Only the necessary external declarations:
; (none)

define dso_local void @selection_sort(i32* %arr, i32 %n) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:                                      ; i-loop condition
  %i = phi i32 [ 0, %entry ], [ %i.next, %after.swap ]
  %n_minus1 = add i32 %n, -1
  %cont = icmp slt i32 %i, %n_minus1
  br i1 %cont, label %outer.body, label %exit

outer.body:                                      ; setup for inner loop
  %min0 = %i
  %j0 = add i32 %i, 1
  br label %inner.cond

inner.cond:                                      ; j-loop condition
  %j = phi i32 [ %j0, %outer.body ], [ %j.next, %inner.body.end ]
  %min.cur = phi i32 [ %min0, %outer.body ], [ %min.next, %inner.body.end ]
  %j_lt_n = icmp slt i32 %j, %n
  br i1 %j_lt_n, label %inner.body, label %after.inner

inner.body:                                      ; compare arr[j] and arr[min]
  %j64 = sext i32 %j to i64
  %min64 = sext i32 %min.cur to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min64
  %val.j = load i32, i32* %j.ptr, align 4
  %val.min = load i32, i32* %min.ptr, align 4
  %lt = icmp slt i32 %val.j, %val.min
  %min.select = select i1 %lt, i32 %j, i32 %min.cur
  br label %inner.body.end

inner.body.end:
  %min.next = phi i32 [ %min.select, %inner.body ]
  %j.next = add i32 %j, 1
  br label %inner.cond

after.inner:                                     ; swap arr[i] and arr[min]
  %i64 = sext i32 %i to i64
  %min2_64 = sext i32 %min.cur to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i64
  %min2.ptr = getelementptr inbounds i32, i32* %arr, i64 %min2_64
  %tmp = load i32, i32* %i.ptr, align 4
  %val.min2 = load i32, i32* %min2.ptr, align 4
  store i32 %val.min2, i32* %i.ptr, align 4
  store i32 %tmp, i32* %min2.ptr, align 4
  br label %after.swap

after.swap:
  %i.next = add i32 %i, 1
  br label %outer.cond

exit:
  ret void
}