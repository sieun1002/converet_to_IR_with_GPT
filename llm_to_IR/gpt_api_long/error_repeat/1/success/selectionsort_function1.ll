; ModuleID = 'selection_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: selection_sort  ; Address: 0x1169
; Intent: In-place selection sort of i32 array in ascending order (confidence=0.98). Evidence: nested i/j loops selecting min index and swapping.
; Preconditions: a points to at least n 32-bit elements; n >= 0
; Postconditions: a[0..n-1] sorted in nondecreasing order in-place

; Only the needed extern declarations:

define dso_local void @selection_sort(i32* %a, i32 %n) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %n.minus1 = add i32 %n, -1
  %cmp.outer = icmp slt i32 %i, %n.minus1
  br i1 %cmp.outer, label %outer.body, label %exit

outer.body:
  %min.init = add i32 %i, 0
  %j.init = add i32 %i, 1
  br label %inner.cond

inner.cond:
  %j = phi i32 [ %j.init, %outer.body ], [ %j.next, %inner.latch ]
  %min.cur = phi i32 [ %min.init, %outer.body ], [ %min.next, %inner.latch ]
  %cmp.inner = icmp slt i32 %j, %n
  br i1 %cmp.inner, label %inner.body, label %afterInner

inner.body:
  %j64 = sext i32 %j to i64
  %min64 = sext i32 %min.cur to i64
  %j.ptr = getelementptr inbounds i32, i32* %a, i64 %j64
  %min.ptr = getelementptr inbounds i32, i32* %a, i64 %min64
  %vj = load i32, i32* %j.ptr, align 4
  %vmin = load i32, i32* %min.ptr, align 4
  %islt = icmp slt i32 %vj, %vmin
  %min.next = select i1 %islt, i32 %j, i32 %min.cur
  br label %inner.latch

inner.latch:
  %j.next = add i32 %j, 1
  br label %inner.cond

afterInner:
  %i64 = sext i32 %i to i64
  %iptr = getelementptr inbounds i32, i32* %a, i64 %i64
  %min.cur64 = sext i32 %min.cur to i64
  %minptr2 = getelementptr inbounds i32, i32* %a, i64 %min.cur64
  %tmp = load i32, i32* %iptr, align 4
  %val = load i32, i32* %minptr2, align 4
  store i32 %val, i32* %iptr, align 4
  store i32 %tmp, i32* %minptr2, align 4
  br label %outer.latch

outer.latch:
  %i.next = add i32 %i, 1
  br label %outer.cond

exit:
  ret void
}