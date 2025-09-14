; ModuleID = 'bubble_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bubble_sort ; Address: 0x1189
; Intent: In-place ascending bubble sort (optimized by last-swap boundary) (confidence=0.95). Evidence: adjacent i32 compares with signed jle, swap, last-swap index shrinks outer bound.
; Preconditions: If n > 0, arr points to at least n consecutive i32 elements.
; Postconditions: arr[0..n-1] sorted in non-decreasing (signed) order.

define dso_local void @bubble_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cond = icmp ule i64 %n, 1
  br i1 %cond, label %exit, label %outer_init

outer_init:
  br label %outer_cond

outer_cond:
  %limit = phi i64 [ %n, %outer_init ], [ %new_limit, %outer_update ]
  %gt1 = icmp ugt i64 %limit, 1
  br i1 %gt1, label %outer_body, label %exit

outer_body:
  br label %inner_cond

inner_cond:
  %i = phi i64 [ 1, %outer_body ], [ %i.next, %inner_update ]
  %last = phi i64 [ 0, %outer_body ], [ %last.next, %inner_update ]
  %cmp_i_limit = icmp ult i64 %i, %limit
  br i1 %cmp_i_limit, label %inner_body, label %after_inner

inner_body:
  %i_minus1 = add i64 %i, -1
  %ptr_left = getelementptr inbounds i32, i32* %arr, i64 %i_minus1
  %left = load i32, i32* %ptr_left, align 4
  %ptr_right = getelementptr inbounds i32, i32* %arr, i64 %i
  %right = load i32, i32* %ptr_right, align 4
  %need_swap = icmp sgt i32 %left, %right
  br i1 %need_swap, label %do_swap, label %no_swap

do_swap:
  store i32 %right, i32* %ptr_left, align 4
  store i32 %left, i32* %ptr_right, align 4
  br label %inner_update

no_swap:
  br label %inner_update

inner_update:
  %last.next = phi i64 [ %i, %do_swap ], [ %last, %no_swap ]
  %i.next = add i64 %i, 1
  br label %inner_cond

after_inner:
  %is_zero = icmp eq i64 %last, 0
  br i1 %is_zero, label %exit, label %outer_update

outer_update:
  %new_limit = phi i64 [ %last, %after_inner ]
  br label %outer_cond

exit:
  ret void
}