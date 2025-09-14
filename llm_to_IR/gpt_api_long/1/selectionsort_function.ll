; ModuleID = 'selection_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: selection_sort  ; Address: 0x1169
; Intent: In-place ascending selection sort on i32 array (confidence=0.98). Evidence: nested loops selecting min index; 4-byte element swaps.
; Preconditions: arr points to at least n i32 elements; n >= 0.
; Postconditions: arr[0..n) sorted in non-decreasing order.

define dso_local void @selection_sort(i32* %arr, i32 %n) local_unnamed_addr {
entry:
  br label %outer.loop

outer.loop:                                       ; i loop
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %n_minus1 = add i32 %n, -1
  %cmp_outer = icmp slt i32 %i, %n_minus1
  br i1 %cmp_outer, label %outer.body, label %exit

outer.body:
  %min0 = add i32 %i, 0
  %j0 = add i32 %i, 1
  br label %inner.loop

inner.loop:                                       ; j loop
  %j = phi i32 [ %j0, %outer.body ], [ %j.next, %inner.latch ]
  %min = phi i32 [ %min0, %outer.body ], [ %min.next, %inner.latch ]
  %cond_inner = icmp slt i32 %j, %n
  br i1 %cond_inner, label %inner.body, label %after.inner

inner.body:
  %j64 = sext i32 %j to i64
  %pj = getelementptr inbounds i32, i32* %arr, i64 %j64
  %vj = load i32, i32* %pj, align 4
  %min64 = sext i32 %min to i64
  %pmin = getelementptr inbounds i32, i32* %arr, i64 %min64
  %vmin = load i32, i32* %pmin, align 4
  %lt = icmp slt i32 %vj, %vmin
  %min.sel = select i1 %lt, i32 %j, i32 %min
  %j.next = add i32 %j, 1
  br label %inner.latch

inner.latch:
  %min.next = phi i32 [ %min.sel, %inner.body ]
  br label %inner.loop

after.inner:
  %i64 = sext i32 %i to i64
  %pi = getelementptr inbounds i32, i32* %arr, i64 %i64
  %vi = load i32, i32* %pi, align 4
  %min_end64 = sext i32 %min to i64
  %pmin.end = getelementptr inbounds i32, i32* %arr, i64 %min_end64
  %vmin.end = load i32, i32* %pmin.end, align 4
  store i32 %vmin.end, i32* %pi, align 4
  store i32 %vi, i32* %pmin.end, align 4
  br label %outer.latch

outer.latch:
  %i.next = add i32 %i, 1
  br label %outer.loop

exit:
  ret void
}