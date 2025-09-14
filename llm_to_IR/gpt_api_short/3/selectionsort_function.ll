; ModuleID = 'selection_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: selection_sort ; Address: 0x1169
; Intent: In-place selection sort ascending on an int array (confidence=0.98). Evidence: inner loop finds minimum (cmp jl) and swaps with position i using 4-byte indexing.
; Preconditions: arr points to at least n 32-bit integers; n treated as signed 32-bit.
; Postconditions: For n > 1, arr is sorted in nondecreasing order.

define dso_local void @selection_sort(i32* %arr, i32 %n) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:                                       ; i-loop condition
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %n.minus1 = add i32 %n, -1
  %outer.cmp = icmp slt i32 %i, %n.minus1
  br i1 %outer.cmp, label %outer.body, label %return

outer.body:                                        ; initialize min and j
  %min0 = %i
  %j0 = add i32 %i, 1
  br label %inner.cond

inner.cond:                                        ; j-loop condition
  %min.cur = phi i32 [ %min0, %outer.body ], [ %min.next, %inner.latch ]
  %j = phi i32 [ %j0, %outer.body ], [ %j.next, %inner.latch ]
  %j.cmp = icmp slt i32 %j, %n
  br i1 %j.cmp, label %inner.body, label %after.inner

inner.body:                                        ; if (arr[j] < arr[min]) min = j
  %j64 = sext i32 %j to i64
  %min64 = sext i32 %min.cur to i64
  %pj = getelementptr inbounds i32, i32* %arr, i64 %j64
  %pmin = getelementptr inbounds i32, i32* %arr, i64 %min64
  %vj = load i32, i32* %pj, align 4
  %vmin = load i32, i32* %pmin, align 4
  %lt = icmp slt i32 %vj, %vmin
  %min.new = select i1 %lt, i32 %j, i32 %min.cur
  br label %inner.latch

inner.latch:
  %min.next = phi i32 [ %min.new, %inner.body ]
  %j.next = add i32 %j, 1
  br label %inner.cond

after.inner:                                       ; swap arr[i] and arr[min.cur]
  %i64 = sext i32 %i to i64
  %pi = getelementptr inbounds i32, i32* %arr, i64 %i64
  %tmp = load i32, i32* %pi, align 4
  %min.final = %min.cur
  %min64b = sext i32 %min.final to i64
  %pmin2 = getelementptr inbounds i32, i32* %arr, i64 %min64b
  %vmin2 = load i32, i32* %pmin2, align 4
  store i32 %vmin2, i32* %pi, align 4
  store i32 %tmp, i32* %pmin2, align 4
  br label %outer.inc

outer.inc:
  %i.next = add i32 %i, 1
  br label %outer.cond

return:
  ret void
}