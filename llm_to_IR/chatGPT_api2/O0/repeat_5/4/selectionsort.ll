; ModuleID = 'selection_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: selection_sort  ; Address: 0x1169
; Intent: In-place selection sort of a 32-bit integer array in ascending (signed) order (confidence=0.98). Evidence: nested loops tracking min index; final swap with current element.
; Preconditions: arr is valid for n elements if n > 1.
; Postconditions: Elements [0..n-1] sorted nondecreasing by signed i32 compare.

define dso_local void @selection_sort(i32* %arr, i32 %n) local_unnamed_addr {
entry:
  br label %outer.header

outer.header:                                      ; preds = %outer.latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %n_minus_1 = add i32 %n, -1
  %cond.outer = icmp slt i32 %i, %n_minus_1
  br i1 %cond.outer, label %outer.body, label %exit

outer.body:                                        ; preds = %outer.header
  %min.init = %i
  %k.init = add i32 %i, 1
  br label %inner.header

inner.header:                                      ; preds = %inner.latch, %outer.body
  %k = phi i32 [ %k.init, %outer.body ], [ %k.next, %inner.latch ]
  %min.cur = phi i32 [ %min.init, %outer.body ], [ %min.next, %inner.latch ]
  %cond.inner = icmp slt i32 %k, %n
  br i1 %cond.inner, label %inner.body, label %inner.exit

inner.body:                                        ; preds = %inner.header
  %k64 = sext i32 %k to i64
  %min64 = sext i32 %min.cur to i64
  %p.k = getelementptr inbounds i32, i32* %arr, i64 %k64
  %val.k = load i32, i32* %p.k, align 4
  %p.min = getelementptr inbounds i32, i32* %arr, i64 %min64
  %val.min = load i32, i32* %p.min, align 4
  %is.less = icmp slt i32 %val.k, %val.min
  %min.next = select i1 %is.less, i32 %k, i32 %min.cur
  br label %inner.latch

inner.latch:                                       ; preds = %inner.body
  %k.next = add i32 %k, 1
  br label %inner.header

inner.exit:                                        ; preds = %inner.header
  %min.final = phi i32 [ %min.cur, %inner.header ]
  %i64 = sext i32 %i to i64
  %p.i = getelementptr inbounds i32, i32* %arr, i64 %i64
  %tmp = load i32, i32* %p.i, align 4
  %min64.exit = sext i32 %min.final to i64
  %p.min2 = getelementptr inbounds i32, i32* %arr, i64 %min64.exit
  %val.min2 = load i32, i32* %p.min2, align 4
  store i32 %val.min2, i32* %p.i, align 4
  store i32 %tmp, i32* %p.min2, align 4
  br label %outer.latch

outer.latch:                                       ; preds = %inner.exit
  %i.next = add i32 %i, 1
  br label %outer.header

exit:                                              ; preds = %outer.header
  ret void
}