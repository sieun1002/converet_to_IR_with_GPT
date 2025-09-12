; ModuleID = 'bubble_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bubble_sort  ; Address: 0x1189
; Intent: Optimized bubble sort over int32 array with last-swap boundary (confidence=0.95). Evidence: adjacent 32-bit compares/swaps; loop bound updated to last swap index.
; Preconditions: %a points to at least %n 32-bit elements; %n is nonnegative.
; Postconditions: %a is sorted in nondecreasing order by signed 32-bit comparison.

define dso_local void @bubble_sort(i32* %a, i64 %n) local_unnamed_addr {
entry:
  %cond0 = icmp ule i64 %n, 1
  br i1 %cond0, label %ret, label %outer_check

outer_check:
  %limit = phi i64 [ %n, %entry ], [ %limit_next, %set_limit ]
  %cond1 = icmp ugt i64 %limit, 1
  br i1 %cond1, label %outer_body, label %ret

outer_body:
  br label %inner_loop

inner_loop:
  %i = phi i64 [ 1, %outer_body ], [ %i_next, %inner_inc ]
  %last = phi i64 [ 0, %outer_body ], [ %last_next, %inner_inc ]
  %cond2 = icmp ult i64 %i, %limit
  br i1 %cond2, label %inner_body, label %after_inner

inner_body:
  %im1 = add i64 %i, -1
  %p_prev = getelementptr inbounds i32, i32* %a, i64 %im1
  %p_cur = getelementptr inbounds i32, i32* %a, i64 %i
  %x = load i32, i32* %p_prev
  %y = load i32, i32* %p_cur
  %gt = icmp sgt i32 %x, %y
  br i1 %gt, label %swap, label %noswap

swap:
  store i32 %y, i32* %p_prev
  store i32 %x, i32* %p_cur
  br label %inner_inc

noswap:
  br label %inner_inc

inner_inc:
  %last_next = phi i64 [ %i, %swap ], [ %last, %noswap ]
  %i_next = add i64 %i, 1
  br label %inner_loop

after_inner:
  %last_final = phi i64 [ %last, %inner_loop ]
  %no_swaps = icmp eq i64 %last_final, 0
  br i1 %no_swaps, label %ret, label %set_limit

set_limit:
  %limit_next = add i64 %last_final, 0
  br label %outer_check

ret:
  ret void
}