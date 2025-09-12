; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: quick_sort  ; Address: 0x1240
; Intent: In-place quicksort partitioning and recursive sort on int32 array in [lo, hi] inclusive (confidence=0.95). Evidence: median-of-interval pivot, two-index partition loop with swaps, tail-recursive optimization on larger partition.
; Preconditions: %base points to an array of 32-bit integers; indices %lo and %hi are valid inclusive bounds with element size 4 bytes.

define dso_local void @quick_sort(i32* %base, i64 %lo, i64 %hi) local_unnamed_addr {
entry:
  %cmp0 = icmp sge i64 %lo, %hi
  br i1 %cmp0, label %ret, label %outer_header

outer_header:                                         ; preds = %outer_latch, %entry
  %l = phi i64 [ %lo, %entry ], [ %l.next, %outer_latch ]
  %r = phi i64 [ %hi, %entry ], [ %r.next, %outer_latch ]
  %cmp1 = icmp sge i64 %l, %r
  br i1 %cmp1, label %ret, label %partition_setup

partition_setup:                                      ; preds = %outer_header
  %diff = sub i64 %r, %l
  %half = ashr i64 %diff, 1
  %mid = add i64 %l, %half
  %piv.ptr = getelementptr inbounds i32, i32* %base, i64 %mid
  %piv = load i32, i32* %piv.ptr, align 4
  %i0 = add i64 %l, 0
  %j0 = add i64 %r, 0
  %nexti0 = add i64 %i0, 1
  br label %loop_header

loop_header:                                          ; preds = %after_swap_continue, %inc_left, %partition_setup
  %i = phi i64 [ %i0, %partition_setup ], [ %i.inc, %inc_left ], [ %i, %after_swap_continue ]
  %j = phi i64 [ %j0, %partition_setup ], [ %j.prime, %after_swap_continue ]
  %nexti = phi i64 [ %nexti0, %partition_setup ], [ %nexti.inc, %inc_left ], [ %nexti, %after_swap_continue ]
  ; bp (right-start candidate) is current i at loop top (matches rbp=rdi)
  %left.ptr = getelementptr inbounds i32, i32* %base, i64 %i
  %left = load i32, i32* %left.ptr, align 4
  %right.ptr0 = getelementptr inbounds i32, i32* %base, i64 %j
  %right0 = load i32, i32* %right.ptr0, align 4
  %left_lt_piv = icmp slt i32 %left, %piv
  br i1 %left_lt_piv, label %inc_left, label %check_right

inc_left:                                             ; preds = %loop_header
  %i.inc = add i64 %i, 1
  %nexti.inc = add i64 %nexti, 1
  br label %loop_header

check_right:                                          ; preds = %loop_header
  %piv_ge_right0 = icmp sge i32 %piv, %right0
  br i1 %piv_ge_right0, label %after_adjust, label %dec_cond

dec_cond:                                             ; preds = %check_right, %dec_iter
  %j.cur = phi i64 [ %j, %check_right ], [ %j.dec, %dec_iter ]
  %right.ptr.cur = getelementptr inbounds i32, i32* %base, i64 %j.cur
  %right.cur = load i32, i32* %right.ptr.cur, align 4
  %piv_lt_right = icmp slt i32 %piv, %right.cur
  br i1 %piv_lt_right, label %dec_iter, label %after_adjust_from_dec

dec_iter:                                             ; preds = %dec_cond
  %j.dec = add i64 %j.cur, -1
  br label %dec_cond

after_adjust_from_dec:                                ; preds = %dec_cond
  br label %after_adjust

after_adjust:                                         ; preds = %after_adjust_from_dec, %check_right
  %j.adj = phi i64 [ %j, %check_right ], [ %j.cur, %after_adjust_from_dec ]
  %right.adj = phi i32 [ %right0, %check_right ], [ %right.cur, %after_adjust_from_dec ]
  %i_le_j = icmp sle i64 %i, %j.adj
  br i1 %i_le_j, label %do_swap, label %partition_end_no_swap

do_swap:                                              ; preds = %after_adjust
  %j.prime = add i64 %j.adj, -1
  ; a[i] = right.adj
  store i32 %right.adj, i32* %left.ptr, align 4
  ; a[j.adj] = left
  %right.ptr.adj = getelementptr inbounds i32, i32* %base, i64 %j.adj
  store i32 %left, i32* %right.ptr.adj, align 4
  ; bp := nexti (i+1)
  %next_gt_jprime = icmp sgt i64 %nexti, %j.prime
  br i1 %next_gt_jprime, label %partition_end_from_swap, label %after_swap_continue

after_swap_continue:                                  ; preds = %do_swap
  ; continue inner loop with i same, j := j', nexti same
  br label %loop_header

partition_end_no_swap:                                ; preds = %after_adjust
  ; bp := i, j_end := j.adj
  br label %partition_end

partition_end_from_swap:                              ; preds = %do_swap
  ; bp := nexti, j_end := j'
  br label %partition_end

partition_end:                                        ; preds = %partition_end_from_swap, %partition_end_no_swap
  %bp = phi i64 [ %i, %partition_end_no_swap ], [ %nexti, %partition_end_from_swap ]
  %j.end = phi i64 [ %j.adj, %partition_end_no_swap ], [ %j.prime, %partition_end_from_swap ]
  %left_size = sub i64 %j.end, %l
  %right_size = sub i64 %r, %bp
  %left_ge_right = icmp sge i64 %left_size, %right_size
  br i1 %left_ge_right, label %right_first, label %left_first

right_first:                                          ; preds = %partition_end
  %has_right = icmp sgt i64 %r, %bp
  br i1 %has_right, label %do_right_call, label %skip_right_call

do_right_call:                                        ; preds = %right_first
  call void @quick_sort(i32* %base, i64 %bp, i64 %r)
  br label %skip_right_call

skip_right_call:                                      ; preds = %do_right_call, %right_first
  ; loop on left: l stays, r := j.end
  %l.next.rf = add i64 %l, 0
  %r.next.rf = add i64 %j.end, 0
  br label %outer_latch

left_first:                                           ; preds = %partition_end
  %has_left = icmp slt i64 %l, %j.end
  br i1 %has_left, label %do_left_call, label %skip_left_call

do_left_call:                                         ; preds = %left_first
  call void @quick_sort(i32* %base, i64 %l, i64 %j.end)
  br label %skip_left_call

skip_left_call:                                       ; preds = %do_left_call, %left_first
  ; loop on right: l := bp, r stays
  %l.next.lf = add i64 %bp, 0
  %r.next.lf = add i64 %r, 0
  br label %outer_latch

outer_latch:                                          ; preds = %skip_left_call, %skip_right_call
  %l.next = phi i64 [ %l.next.lf, %skip_left_call ], [ %l.next.rf, %skip_right_call ]
  %r.next = phi i64 [ %r.next.lf, %skip_left_call ], [ %r.next.rf, %skip_right_call ]
  br label %outer_header

ret:                                                  ; preds = %outer_header, %entry
  ret void
}