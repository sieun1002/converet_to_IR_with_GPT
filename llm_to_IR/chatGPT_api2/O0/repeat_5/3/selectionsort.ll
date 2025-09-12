; ModuleID = 'selection_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: selection_sort  ; Address: 0x1169
; Intent: In-place selection sort of i32 array ascending (confidence=0.99). Evidence: nested loops scanning min index; 4-byte element accesses and unconditional swap.
; Preconditions: a points to at least n i32 elements; n can be any 32-bit signed int (effective work occurs if n >= 2).
; Postconditions: If n >= 0, a[0..n-1] is sorted in non-decreasing order.

define dso_local void @selection_sort(i32* %a, i32 %n) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:                                       ; i loop condition: i < n-1
  %i = phi i32 [ 0, entry ], [ %i.next, %outer.latch ]
  %n_minus1 = add i32 %n, -1
  %outer.cmp = icmp slt i32 %i, %n_minus1
  br i1 %outer.cmp, label %outer.body, label %return

outer.body:                                       ; initialize min index and j
  %minidx0 = phi i32 [ %i, %outer.cond ]
  %j0 = add i32 %i, 1
  br label %inner.cond

inner.cond:                                       ; j loop condition: j < n
  %j = phi i32 [ %j0, %outer.body ], [ %j.next, %inner.body ]
  %minidx = phi i32 [ %minidx0, %outer.body ], [ %minidx.next, %inner.body ]
  %j.cmp = icmp slt i32 %j, %n
  br i1 %j.cmp, label %inner.body, label %after.inner

inner.body:                                       ; if a[j] < a[minidx], update minidx
  %j64 = sext i32 %j to i64
  %aptrj = getelementptr inbounds i32, i32* %a, i64 %j64
  %v_j = load i32, i32* %aptrj, align 4
  %min64 = sext i32 %minidx to i64
  %aptrmin = getelementptr inbounds i32, i32* %a, i64 %min64
  %v_min = load i32, i32* %aptrmin, align 4
  %is_less = icmp slt i32 %v_j, %v_min
  %minidx.next = select i1 %is_less, i32 %j, i32 %minidx
  %j.next = add i32 %j, 1
  br label %inner.cond

after.inner:                                      ; swap a[i] and a[minidx]
  %i64 = sext i32 %i to i64
  %aptri = getelementptr inbounds i32, i32* %a, i64 %i64
  %tmp = load i32, i32* %aptri, align 4
  %min64b = sext i32 %minidx to i64
  %aptrminb = getelementptr inbounds i32, i32* %a, i64 %min64b
  %val_min = load i32, i32* %aptrminb, align 4
  store i32 %val_min, i32* %aptri, align 4
  store i32 %tmp, i32* %aptrminb, align 4
  br label %outer.latch

outer.latch:
  %i.next = add i32 %i, 1
  br label %outer.cond

return:
  ret void
}