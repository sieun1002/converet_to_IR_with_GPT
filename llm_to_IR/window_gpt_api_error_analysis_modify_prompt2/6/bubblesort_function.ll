target triple = "x86_64-pc-windows-msvc"

define void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %exit, label %outer_test_init

outer_test_init:
  br label %outer_test

outer_test:
  %var8 = phi i64 [ %n, %outer_test_init ], [ %var8_next, %outer_update ]
  %cmp_var8_gt1 = icmp ugt i64 %var8, 1
  br i1 %cmp_var8_gt1, label %outer_body, label %exit

outer_body:
  br label %inner_test

inner_test:
  %i = phi i64 [ 1, %outer_body ], [ %i_next, %inner_latch ]
  %var10_curr = phi i64 [ 0, %outer_body ], [ %var10_after, %inner_latch ]
  %cmp_i_lt_var8 = icmp ult i64 %i, %var8
  br i1 %cmp_i_lt_var8, label %inner_body, label %inner_done

inner_body:
  %i_minus1 = add i64 %i, -1
  %ptr_im1 = getelementptr inbounds i32, i32* %arr, i64 %i_minus1
  %v_im1 = load i32, i32* %ptr_im1, align 4
  %ptr_i = getelementptr inbounds i32, i32* %arr, i64 %i
  %v_i = load i32, i32* %ptr_i, align 4
  %cmp_gt = icmp sgt i32 %v_im1, %v_i
  br i1 %cmp_gt, label %do_swap, label %no_swap

do_swap:
  store i32 %v_i, i32* %ptr_im1, align 4
  store i32 %v_im1, i32* %ptr_i, align 4
  br label %inner_latch

no_swap:
  br label %inner_latch

inner_latch:
  %var10_after = phi i64 [ %i, %do_swap ], [ %var10_curr, %no_swap ]
  %i_next = add i64 %i, 1
  br label %inner_test

inner_done:
  %is_zero = icmp eq i64 %var10_curr, 0
  br i1 %is_zero, label %exit, label %outer_update

outer_update:
  %var8_next = phi i64 [ %var10_curr, %inner_done ]
  br label %outer_test

exit:
  ret void
}