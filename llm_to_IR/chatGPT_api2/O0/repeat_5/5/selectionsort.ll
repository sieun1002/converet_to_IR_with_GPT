; ModuleID = 'selection_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: selection_sort  ; Address: 0x1169
; Intent: In-place ascending selection sort of i32 array (confidence=0.95). Evidence: min-index scan with j<i<n and swap of 4-byte elements
; Preconditions: a points to at least n i32 elements (n may be <= 0)
; Postconditions: first n elements of a sorted in nondecreasing order

define dso_local void @selection_sort(i32* %a, i32 %n) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.swap ]
  %n_minus1 = add i32 %n, -1
  %cmp.outer = icmp slt i32 %i, %n_minus1
  br i1 %cmp.outer, label %outer.body, label %exit

outer.body:
  %min.init = %i
  %j.init = add i32 %i, 1
  br label %inner.cond

inner.cond:
  %min.cur = phi i32 [ %min.init, %outer.body ], [ %min.next, %inner.body ]
  %j.cur = phi i32 [ %j.init, %outer.body ], [ %j.next, %inner.body ]
  %cmp.inner = icmp slt i32 %j.cur, %n
  br i1 %cmp.inner, label %inner.body, label %outer.swap

inner.body:
  %j.idx64 = sext i32 %j.cur to i64
  %min.idx64 = sext i32 %min.cur to i64
  %j.ptr = getelementptr inbounds i32, i32* %a, i64 %j.idx64
  %min.ptr = getelementptr inbounds i32, i32* %a, i64 %min.idx64
  %j.val = load i32, i32* %j.ptr, align 4
  %min.val = load i32, i32* %min.ptr, align 4
  %lt = icmp slt i32 %j.val, %min.val
  %min.next = select i1 %lt, i32 %j.cur, i32 %min.cur
  %j.next = add i32 %j.cur, 1
  br label %inner.cond

outer.swap:
  ; swap a[i] and a[min.cur]
  %i.idx64 = sext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %a, i64 %i.idx64
  %tmp = load i32, i32* %i.ptr, align 4
  %min.cur.lcssa = phi i32 [ %min.cur, %inner.cond ]
  %min.swap.idx64 = sext i32 %min.cur.lcssa to i64
  %min.swap.ptr = getelementptr inbounds i32, i32* %a, i64 %min.swap.idx64
  %min.val2 = load i32, i32* %min.swap.ptr, align 4
  store i32 %min.val2, i32* %i.ptr, align 4
  store i32 %tmp, i32* %min.swap.ptr, align 4
  %i.next = add i32 %i, 1
  br label %outer.cond

exit:
  ret void
}