; ModuleID = 'bubble_sort_module'
target triple = "x86_64-pc-windows-msvc"

define void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %exit, label %outer_check

outer_check:
  %limit = phi i64 [ %n, %entry ], [ %lastSwap, %outer_latch ]
  %cond = icmp ugt i64 %limit, 1
  br i1 %cond, label %outer_body, label %exit

outer_body:
  br label %inner_check

inner_check:
  %i = phi i64 [ 1, %outer_body ], [ %i_next, %inner_latch ]
  %lastSwap = phi i64 [ 0, %outer_body ], [ %lastSwap_updated, %inner_latch ]
  %cmp_i = icmp ult i64 %i, %limit
  br i1 %cmp_i, label %inner_body, label %after_inner

inner_body:
  %im1 = add i64 %i, -1
  %ptr_im1 = getelementptr inbounds i32, i32* %arr, i64 %im1
  %val_im1 = load i32, i32* %ptr_im1, align 4
  %ptr_i = getelementptr inbounds i32, i32* %arr, i64 %i
  %val_i = load i32, i32* %ptr_i, align 4
  %cmp_swap = icmp sgt i32 %val_im1, %val_i
  br i1 %cmp_swap, label %do_swap, label %no_swap

do_swap:
  store i32 %val_im1, i32* %ptr_i, align 4
  store i32 %val_i, i32* %ptr_im1, align 4
  br label %inner_latch

no_swap:
  br label %inner_latch

inner_latch:
  %lastSwap_updated = phi i64 [ %i, %do_swap ], [ %lastSwap, %no_swap ]
  %i_next = add i64 %i, 1
  br label %inner_check

after_inner:
  %no_swaps = icmp eq i64 %lastSwap, 0
  br i1 %no_swaps, label %exit, label %outer_latch

outer_latch:
  br label %outer_check

exit:
  ret void
}