; ModuleID = 'bubble_sort'
source_filename = "bubble_sort"

define dso_local void @bubble_sort(i32* nocapture %arr, i64 %n) {
entry:
  %cmp_n_le_1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le_1, label %ret, label %outer_init

outer_init:
  br label %outer_header

outer_header:
  %bound = phi i64 [ %n, %outer_init ], [ %lastSwap, %outer_latch ]
  %cmp_bound_gt_1 = icmp ugt i64 %bound, 1
  br i1 %cmp_bound_gt_1, label %outer_body_init, label %ret

outer_body_init:
  br label %inner_header

inner_header:
  %i = phi i64 [ 1, %outer_body_init ], [ %i.next, %inner_latch ]
  %lastSwap = phi i64 [ 0, %outer_body_init ], [ %lastSwap.upd, %inner_latch ]
  %cmp_i_lt_bound = icmp ult i64 %i, %bound
  br i1 %cmp_i_lt_bound, label %inner_body, label %after_inner

inner_body:
  %im1 = sub i64 %i, 1
  %ptr_im1 = getelementptr inbounds i32, i32* %arr, i64 %im1
  %val_im1 = load i32, i32* %ptr_im1, align 4
  %ptr_i = getelementptr inbounds i32, i32* %arr, i64 %i
  %val_i = load i32, i32* %ptr_i, align 4
  %cmp_gt = icmp sgt i32 %val_im1, %val_i
  br i1 %cmp_gt, label %do_swap, label %no_swap

do_swap:
  store i32 %val_i, i32* %ptr_im1, align 4
  store i32 %val_im1, i32* %ptr_i, align 4
  br label %inner_latch

no_swap:
  br label %inner_latch

inner_latch:
  %lastSwap.upd = phi i64 [ %i, %do_swap ], [ %lastSwap, %no_swap ]
  %i.next = add i64 %i, 1
  br label %inner_header

after_inner:
  %no_swaps = icmp eq i64 %lastSwap, 0
  br i1 %no_swaps, label %ret, label %outer_latch

outer_latch:
  br label %outer_header

ret:
  ret void
}