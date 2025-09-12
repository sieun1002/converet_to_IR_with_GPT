; ModuleID = 'bubble_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bubble_sort  ; Address: 0x1189
; Intent: In-place ascending bubble sort with last-swap optimization (confidence=0.95). Evidence: adjacent 32-bit comparisons/swaps; outer bound set to last swap index.
; Preconditions: a points to at least n i32 elements; n is the number of elements (treated as non-negative).
; Postconditions: a[0..n) sorted in non-decreasing order in place.

define dso_local void @bubble_sort(i32* %a, i64 %n) local_unnamed_addr {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %ret, label %outer.init

outer.init:                                        ; preds = %entry
  br label %outer.cond

outer.cond:                                        ; preds = %outer.update, %outer.init
  %end = phi i64 [ %n, %outer.init ], [ %new_end, %outer.update ]
  %end_gt1 = icmp ugt i64 %end, 1
  br i1 %end_gt1, label %inner.init, label %ret

inner.init:                                        ; preds = %outer.cond
  br label %inner.cond

inner.cond:                                        ; preds = %inner.body_end, %inner.init
  %i = phi i64 [ 1, %inner.init ], [ %i.next, %inner.body_end ]
  %last = phi i64 [ 0, %inner.init ], [ %last.next, %inner.body_end ]
  %i_lt_end = icmp ult i64 %i, %end
  br i1 %i_lt_end, label %inner.body, label %inner.exit

inner.body:                                        ; preds = %inner.cond
  %i_minus1 = add i64 %i, -1
  %p_left = getelementptr inbounds i32, i32* %a, i64 %i_minus1
  %p_right = getelementptr inbounds i32, i32* %a, i64 %i
  %left = load i32, i32* %p_left, align 4
  %right = load i32, i32* %p_right, align 4
  %need_swap = icmp sgt i32 %left, %right
  br i1 %need_swap, label %do_swap, label %no_swap

do_swap:                                           ; preds = %inner.body
  store i32 %right, i32* %p_left, align 4
  store i32 %left, i32* %p_right, align 4
  br label %inner.body_end

no_swap:                                           ; preds = %inner.body
  br label %inner.body_end

inner.body_end:                                    ; preds = %no_swap, %do_swap
  %last.updated = phi i64 [ %i, %do_swap ], [ %last, %no_swap ]
  %i.next = add i64 %i, 1
  %last.next = %last.updated
  br label %inner.cond

inner.exit:                                        ; preds = %inner.cond
  %no_swaps = icmp eq i64 %last, 0
  br i1 %no_swaps, label %ret, label %outer.update

outer.update:                                      ; preds = %inner.exit
  %new_end = %last
  br label %outer.cond

ret:                                               ; preds = %inner.exit, %outer.cond, %entry
  ret void
}