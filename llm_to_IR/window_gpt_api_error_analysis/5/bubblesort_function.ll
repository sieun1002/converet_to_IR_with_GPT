; ModuleID = 'bubble_sort'
target triple = "x86_64-pc-windows-msvc"

define void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %exit, label %outer_header_init

outer_header_init:
  br label %outer_check

outer_check:
  %bound = phi i64 [ %n, %outer_header_init ], [ %last_phi, %after_inner ]
  %bound_gt1 = icmp ugt i64 %bound, 1
  br i1 %bound_gt1, label %outer_body, label %exit

outer_body:
  br label %inner_cond

inner_cond:
  %i_phi = phi i64 [ 1, %outer_body ], [ %i_next, %inner_inc ]
  %last_phi = phi i64 [ 0, %outer_body ], [ %last_next, %inner_inc ]
  %i_lt_bound = icmp ult i64 %i_phi, %bound
  br i1 %i_lt_bound, label %inner_body, label %after_inner

inner_body:
  %im1 = add i64 %i_phi, -1
  %ptr_prev = getelementptr inbounds i32, i32* %arr, i64 %im1
  %ptr_cur = getelementptr inbounds i32, i32* %arr, i64 %i_phi
  %vprev = load i32, i32* %ptr_prev, align 4
  %vcur = load i32, i32* %ptr_cur, align 4
  %need_swap = icmp sgt i32 %vprev, %vcur
  br i1 %need_swap, label %do_swap, label %no_swap

do_swap:
  store i32 %vcur, i32* %ptr_prev, align 4
  store i32 %vprev, i32* %ptr_cur, align 4
  br label %inner_inc

no_swap:
  br label %inner_inc

inner_inc:
  %last_next = phi i64 [ %i_phi, %do_swap ], [ %last_phi, %no_swap ]
  %i_next = add i64 %i_phi, 1
  br label %inner_cond

after_inner:
  %no_swaps = icmp eq i64 %last_phi, 0
  br i1 %no_swaps, label %exit, label %outer_check

exit:
  ret void
}