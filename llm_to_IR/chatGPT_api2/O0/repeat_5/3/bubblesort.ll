; ModuleID = 'bubble_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bubble_sort  ; Address: 0x1189
; Intent: Bubble sort ascending i32 array with last-swap boundary optimization (confidence=0.98). Evidence: adjacent compare/swap of a[i-1] and a[i]; outer bound updated to last swap index.
; Preconditions: a points to at least n contiguous i32 elements.

define dso_local void @bubble_sort(i32* %a, i64 %n) local_unnamed_addr {
entry:
  %cmp_entry = icmp ule i64 %n, 1
  br i1 %cmp_entry, label %ret, label %outer_check

outer_check:                                      ; preds = %after_inner_cont, %entry
  %bound = phi i64 [ %n, %entry ], [ %last_exit, %after_inner_cont ]
  %cmp_bound = icmp ugt i64 %bound, 1
  br i1 %cmp_bound, label %inner_init, label %ret

inner_init:                                       ; preds = %outer_check
  br label %inner_loop_header

inner_loop_header:                                ; preds = %inner_latch, %inner_init
  %i = phi i64 [ 1, %inner_init ], [ %i.next, %inner_latch ]
  %last.cur = phi i64 [ 0, %inner_init ], [ %last.next, %inner_latch ]
  %cond_i = icmp ult i64 %i, %bound
  br i1 %cond_i, label %inner_body, label %after_inner

inner_body:                                       ; preds = %inner_loop_header
  %idx_prev = add i64 %i, -1
  %ptr_prev = getelementptr inbounds i32, i32* %a, i64 %idx_prev
  %left = load i32, i32* %ptr_prev, align 4
  %ptr_i = getelementptr inbounds i32, i32* %a, i64 %i
  %right = load i32, i32* %ptr_i, align 4
  %le = icmp sle i32 %left, %right
  br i1 %le, label %no_swap, label %do_swap

no_swap:                                          ; preds = %inner_body
  br label %inner_latch

do_swap:                                          ; preds = %inner_body
  store i32 %right, i32* %ptr_prev, align 4
  store i32 %left, i32* %ptr_i, align 4
  br label %inner_latch

inner_latch:                                      ; preds = %do_swap, %no_swap
  %last.updated = phi i64 [ %last.cur, %no_swap ], [ %i, %do_swap ]
  %i.next = add i64 %i, 1
  %last.next = %last.updated
  br label %inner_loop_header

after_inner:                                      ; preds = %inner_loop_header
  %no_swaps = icmp eq i64 %last.cur, 0
  br i1 %no_swaps, label %ret, label %after_inner_cont

after_inner_cont:                                 ; preds = %after_inner
  %last_exit = phi i64 [ %last.cur, %after_inner ]
  br label %outer_check

ret:                                              ; preds = %after_inner, %outer_check, %entry
  ret void
}