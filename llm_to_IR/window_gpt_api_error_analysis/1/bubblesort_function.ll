; ModuleID = 'bubble_sort_module'
source_filename = "bubble_sort_module"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %exit, label %outer_check

outer_check:
  %m = phi i64 [ %n, %entry ], [ %new_m, %outer_after ]
  %m_gt1 = icmp ugt i64 %m, 1
  br i1 %m_gt1, label %outer_body, label %exit

outer_body:
  br label %inner_check

inner_check:
  %i = phi i64 [ 1, %outer_body ], [ %i_next, %after_inner_iteration ]
  %last = phi i64 [ 0, %outer_body ], [ %last_next, %after_inner_iteration ]
  %i_lt_m = icmp ult i64 %i, %m
  br i1 %i_lt_m, label %inner_body, label %after_pass

inner_body:
  %idx_prev = add i64 %i, -1
  %ptr_prev = getelementptr inbounds i32, i32* %arr, i64 %idx_prev
  %val_prev = load i32, i32* %ptr_prev, align 4
  %ptr_i = getelementptr inbounds i32, i32* %arr, i64 %i
  %val_i = load i32, i32* %ptr_i, align 4
  %need_swap = icmp sgt i32 %val_prev, %val_i
  br i1 %need_swap, label %do_swap, label %no_swap

do_swap:
  store i32 %val_i, i32* %ptr_prev, align 4
  store i32 %val_prev, i32* %ptr_i, align 4
  br label %after_inner_iteration

no_swap:
  br label %after_inner_iteration

after_inner_iteration:
  %last_next = phi i64 [ %i, %do_swap ], [ %last, %no_swap ]
  %i_next = add i64 %i, 1
  br label %inner_check

after_pass:
  %no_swaps = icmp eq i64 %last, 0
  br i1 %no_swaps, label %exit, label %outer_after

outer_after:
  %new_m = add i64 %last, 0
  br label %outer_check

exit:
  ret void
}