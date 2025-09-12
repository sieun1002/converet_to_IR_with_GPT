; ModuleID = 'bubble_sort.ll'
source_filename = "bubble_sort"
target triple = "x86_64-pc-linux-gnu"

define void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %exit, label %outer_check

outer_check:                                           ; preds = %set_limit, %entry
  %limit = phi i64 [ %n, %entry ], [ %limit.next, %set_limit ]
  %cond.limit.gt1 = icmp ugt i64 %limit, 1
  br i1 %cond.limit.gt1, label %init_inner, label %exit

init_inner:                                            ; preds = %outer_check
  br label %inner_check

inner_check:                                           ; preds = %cont_block, %init_inner
  %i = phi i64 [ 1, %init_inner ], [ %i.next, %cont_block ]
  %lastswap = phi i64 [ 0, %init_inner ], [ %lastswap.new, %cont_block ]
  %cmp.i.limit = icmp ult i64 %i, %limit
  br i1 %cmp.i.limit, label %inner_body, label %after_inner

inner_body:                                            ; preds = %inner_check
  %im1 = add i64 %i, -1
  %p_im1 = getelementptr inbounds i32, i32* %arr, i64 %im1
  %val_im1 = load i32, i32* %p_im1, align 4
  %p_i = getelementptr inbounds i32, i32* %arr, i64 %i
  %val_i = load i32, i32* %p_i, align 4
  %need_swap = icmp sgt i32 %val_im1, %val_i
  br i1 %need_swap, label %do_swap, label %no_swap

do_swap:                                               ; preds = %inner_body
  store i32 %val_i, i32* %p_im1, align 4
  store i32 %val_im1, i32* %p_i, align 4
  br label %cont_block

no_swap:                                               ; preds = %inner_body
  br label %cont_block

cont_block:                                            ; preds = %no_swap, %do_swap
  %lastswap.new = phi i64 [ %i, %do_swap ], [ %lastswap, %no_swap ]
  %i.next = add i64 %i, 1
  br label %inner_check

after_inner:                                           ; preds = %inner_check
  %no_swaps = icmp eq i64 %lastswap, 0
  br i1 %no_swaps, label %exit, label %set_limit

set_limit:                                             ; preds = %after_inner
  %limit.next = add i64 %lastswap, 0
  br label %outer_check

exit:                                                  ; preds = %after_inner, %outer_check, %entry
  ret void
}