; ModuleID = 'bubble_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bubble_sort  ; Address: 0x1189
; Intent: optimized bubble sort with last-swap boundary (confidence=0.95). Evidence: adjacent int32 comparisons/swaps; outer bound set to last swap index
; Preconditions: a points to at least n contiguous i32 elements (undefined behavior otherwise).
; Postconditions: a[0..n) sorted in nondecreasing (signed) order.

; Only the needed extern declarations:

define dso_local void @bubble_sort(i32* %a, i64 %n) local_unnamed_addr {
entry:
  %cmp_n_le_1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le_1, label %ret, label %outer.bodyinit

outer.bodyinit:                                      ; preds = %entry, %outer.check
  %hi = phi i64 [ %n, %entry ], [ %hi.new, %outer.check ]
  br label %inner.cond

inner.cond:                                          ; preds = %inner.inc, %outer.bodyinit
  %i = phi i64 [ 1, %outer.bodyinit ], [ %i.next, %inner.inc ]
  %last = phi i64 [ 0, %outer.bodyinit ], [ %last.upd, %inner.inc ]
  %cmp_i_lt_hi = icmp ult i64 %i, %hi
  br i1 %cmp_i_lt_hi, label %inner.body, label %after.inner

inner.body:                                          ; preds = %inner.cond
  %idxm1 = add i64 %i, -1
  %ptr.left = getelementptr inbounds i32, i32* %a, i64 %idxm1
  %ptr.right = getelementptr inbounds i32, i32* %a, i64 %i
  %left = load i32, i32* %ptr.left, align 4
  %right = load i32, i32* %ptr.right, align 4
  %cmp_swap = icmp sgt i32 %left, %right
  br i1 %cmp_swap, label %inner.swap, label %inner.noswap

inner.swap:                                          ; preds = %inner.body
  store i32 %right, i32* %ptr.left, align 4
  store i32 %left, i32* %ptr.right, align 4
  %last.new = add i64 %i, 0
  br label %inner.inc

inner.noswap:                                        ; preds = %inner.body
  %last.new2 = add i64 %last, 0
  br label %inner.inc

inner.inc:                                           ; preds = %inner.noswap, %inner.swap
  %last.upd = phi i64 [ %last.new, %inner.swap ], [ %last.new2, %inner.noswap ]
  %i.next = add i64 %i, 1
  br label %inner.cond

after.inner:                                         ; preds = %inner.cond
  %last.end = phi i64 [ %last, %inner.cond ]
  %noSwap = icmp eq i64 %last.end, 0
  br i1 %noSwap, label %ret, label %outer.check

outer.check:                                         ; preds = %after.inner
  %hi.new = add i64 %last.end, 0
  %gt1 = icmp ugt i64 %hi.new, 1
  br i1 %gt1, label %outer.bodyinit, label %ret

ret:                                                 ; preds = %outer.check, %after.inner, %entry
  ret void
}