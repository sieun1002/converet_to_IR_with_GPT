; ModuleID = 'bubble_sort_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

define void @bubble_sort(i32* %a, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %exit, label %outer_init

outer_init:
  br label %outer_cond

outer_cond:
  %limit = phi i64 [ %n, %outer_init ], [ %newlimit, %update_limit ]
  %limit_gt1 = icmp ugt i64 %limit, 1
  br i1 %limit_gt1, label %outer_body, label %exit

outer_body:
  br label %inner_cond

inner_cond:
  %i = phi i64 [ 1, %outer_body ], [ %i_next, %after_compare ]
  %lastswap = phi i64 [ 0, %outer_body ], [ %lastswap_updated, %after_compare ]
  %i_lt_limit = icmp ult i64 %i, %limit
  br i1 %i_lt_limit, label %inner_body, label %outer_update_after

inner_body:
  %idx_prev = add i64 %i, -1
  %ptr_prev = getelementptr inbounds i32, i32* %a, i64 %idx_prev
  %val_prev = load i32, i32* %ptr_prev, align 4
  %ptr_curr = getelementptr inbounds i32, i32* %a, i64 %i
  %val_curr = load i32, i32* %ptr_curr, align 4
  %need_swap = icmp sgt i32 %val_prev, %val_curr
  br i1 %need_swap, label %do_swap, label %no_swap

do_swap:
  store i32 %val_curr, i32* %ptr_prev, align 4
  store i32 %val_prev, i32* %ptr_curr, align 4
  br label %after_compare

no_swap:
  br label %after_compare

after_compare:
  %lastswap_updated = phi i64 [ %i, %do_swap ], [ %lastswap, %no_swap ]
  %i_next = add i64 %i, 1
  br label %inner_cond

outer_update_after:
  %lastswap_end = phi i64 [ %lastswap, %inner_cond ]
  %no_swaps = icmp eq i64 %lastswap_end, 0
  br i1 %no_swaps, label %exit, label %update_limit

update_limit:
  %newlimit = add i64 %lastswap_end, 0
  br label %outer_cond

exit:
  ret void
}