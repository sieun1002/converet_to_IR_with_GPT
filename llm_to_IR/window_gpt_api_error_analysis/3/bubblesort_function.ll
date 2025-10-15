; ModuleID = 'bubble_sort_module'
target triple = "x86_64-pc-windows-msvc"

define void @bubble_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp_le = icmp ule i64 %n, 1
  br i1 %cmp_le, label %exit, label %outer_test

outer_test:
  %bound = phi i64 [ %n, %entry ], [ %next_bound, %outer_check_back ]
  %cmp_outer = icmp ugt i64 %bound, 1
  br i1 %cmp_outer, label %outer_pre, label %exit

outer_pre:
  br label %inner_cond

inner_cond:
  %i = phi i64 [ 1, %outer_pre ], [ %i.next, %inner_body_end ]
  %lastSwap = phi i64 [ 0, %outer_pre ], [ %lastSwap.upd, %inner_body_end ]
  %cmp_i = icmp ult i64 %i, %bound
  br i1 %cmp_i, label %inner_body, label %after_inner

inner_body:
  %i_minus1 = add i64 %i, -1
  %ptr_prev = getelementptr inbounds i32, i32* %arr, i64 %i_minus1
  %val_prev = load i32, i32* %ptr_prev, align 4
  %ptr_curr = getelementptr inbounds i32, i32* %arr, i64 %i
  %val_curr = load i32, i32* %ptr_curr, align 4
  %cmp_swap = icmp sgt i32 %val_prev, %val_curr
  br i1 %cmp_swap, label %do_swap, label %no_swap

do_swap:
  store i32 %val_prev, i32* %ptr_curr, align 4
  store i32 %val_curr, i32* %ptr_prev, align 4
  br label %inner_body_end

no_swap:
  br label %inner_body_end

inner_body_end:
  %lastSwap.upd = phi i64 [ %i, %do_swap ], [ %lastSwap, %no_swap ]
  %i.next = add i64 %i, 1
  br label %inner_cond

after_inner:
  %no_swaps = icmp eq i64 %lastSwap, 0
  br i1 %no_swaps, label %exit, label %outer_check_back

outer_check_back:
  %next_bound = add i64 %lastSwap, 0
  br label %outer_test

exit:
  ret void
}