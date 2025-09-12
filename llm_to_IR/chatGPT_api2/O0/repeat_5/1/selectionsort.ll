; ModuleID = 'selection_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: selection_sort  ; Address: 0x1169
; Intent: In-place selection sort of i32 array in ascending order (confidence=0.98). Evidence: nested scan for minimum index and swap using a[j] < a[minIdx].
; Preconditions: arr points to at least n i32 elements if n > 0.
; Postconditions: The first n elements at arr are sorted in nondecreasing order.

define dso_local void @selection_sort(i32* %arr, i32 %n) local_unnamed_addr {
entry:
  br label %outer.header

outer.header:                                      ; preds = %outer.latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %n_minus_1 = add i32 %n, -1
  %cmp.outer = icmp slt i32 %i, %n_minus_1
  br i1 %cmp.outer, label %outer.body, label %exit

outer.body:                                        ; preds = %outer.header
  %i.add1 = add i32 %i, 1
  br label %inner.header

inner.header:                                      ; preds = %inner.latch, %outer.body
  %min_idx = phi i32 [ %i, %outer.body ], [ %min_idx.next, %inner.latch ]
  %j = phi i32 [ %i.add1, %outer.body ], [ %j.next, %inner.latch ]
  %cmp.inner = icmp slt i32 %j, %n
  br i1 %cmp.inner, label %inner.body, label %inner.exit

inner.body:                                        ; preds = %inner.header
  %j64 = sext i32 %j to i64
  %min64 = sext i32 %min_idx to i64
  %pj = getelementptr inbounds i32, i32* %arr, i64 %j64
  %valj = load i32, i32* %pj, align 4
  %pmin = getelementptr inbounds i32, i32* %arr, i64 %min64
  %valmin = load i32, i32* %pmin, align 4
  %is_lt = icmp slt i32 %valj, %valmin
  %min_sel = select i1 %is_lt, i32 %j, i32 %min_idx
  br label %inner.latch

inner.latch:                                       ; preds = %inner.body
  %min_idx.next = phi i32 [ %min_sel, %inner.body ]
  %j.next = add i32 %j, 1
  br label %inner.header

inner.exit:                                        ; preds = %inner.header
  %i64 = sext i32 %i to i64
  %pi = getelementptr inbounds i32, i32* %arr, i64 %i64
  %tmp = load i32, i32* %pi, align 4
  %min64.exit = sext i32 %min_idx to i64
  %pmin.exit = getelementptr inbounds i32, i32* %arr, i64 %min64.exit
  %minval = load i32, i32* %pmin.exit, align 4
  store i32 %minval, i32* %pi, align 4
  store i32 %tmp, i32* %pmin.exit, align 4
  br label %outer.latch

outer.latch:                                       ; preds = %inner.exit
  %i.next = add i32 %i, 1
  br label %outer.header

exit:                                              ; preds = %outer.header
  ret void
}