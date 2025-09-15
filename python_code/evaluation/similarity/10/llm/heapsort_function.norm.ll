; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/heapsort_function.ll'
source_filename = "heap_sort.c"
target triple = "x86_64-pc-linux-gnu"

define void @heap_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp_n = icmp ult i64 %n, 2
  br i1 %cmp_n, label %ret, label %build_init

build_init:                                       ; preds = %entry
  %half = lshr i64 %n, 1
  br label %build_loop

build_loop:                                       ; preds = %build_next, %build_init
  %i = phi i64 [ %half, %build_init ], [ %i_dec, %build_next ]
  %i_is_zero = icmp eq i64 %i, 0
  br i1 %i_is_zero, label %sort_loop, label %sift_loop

sift_loop:                                        ; preds = %build_loop, %do_swap
  %k = phi i64 [ %largest_idx2, %do_swap ], [ %i, %build_loop ]
  %child = shl i64 %k, 1
  %child_l = or i64 %child, 1
  %has_child = icmp ult i64 %child_l, %n
  br i1 %has_child, label %choose_right, label %build_next

choose_right:                                     ; preds = %sift_loop
  %right = add i64 %child, 2
  %has_right = icmp ult i64 %right, %n
  br i1 %has_right, label %cmp_children, label %after_choose

cmp_children:                                     ; preds = %choose_right
  %left_ptr = getelementptr inbounds i32, i32* %arr, i64 %child_l
  %left_val = load i32, i32* %left_ptr, align 4
  %right_ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right_val = load i32, i32* %right_ptr, align 4
  %cmp_rl = icmp sgt i32 %right_val, %left_val
  %largest_idx = select i1 %cmp_rl, i64 %right, i64 %child_l
  br label %after_choose

after_choose:                                     ; preds = %choose_right, %cmp_children
  %largest_idx2 = phi i64 [ %largest_idx, %cmp_children ], [ %child_l, %choose_right ]
  %k_ptr = getelementptr inbounds i32, i32* %arr, i64 %k
  %k_val = load i32, i32* %k_ptr, align 4
  %largest_ptr = getelementptr inbounds i32, i32* %arr, i64 %largest_idx2
  %largest_val = load i32, i32* %largest_ptr, align 4
  %k_ge_largest.not = icmp slt i32 %k_val, %largest_val
  br i1 %k_ge_largest.not, label %do_swap, label %build_next

do_swap:                                          ; preds = %after_choose
  store i32 %largest_val, i32* %k_ptr, align 4
  store i32 %k_val, i32* %largest_ptr, align 4
  br label %sift_loop

build_next:                                       ; preds = %after_choose, %sift_loop
  %i_dec = add i64 %i, -1
  br label %build_loop

sort_loop:                                        ; preds = %build_loop, %after_inner
  %last.in = phi i64 [ %last, %after_inner ], [ %n, %build_loop ]
  %last = add i64 %last.in, -1
  %last_is_zero = icmp eq i64 %last, 0
  br i1 %last_is_zero, label %ret, label %swap_root

swap_root:                                        ; preds = %sort_loop
  %root_val = load i32, i32* %arr, align 4
  %last_ptr = getelementptr inbounds i32, i32* %arr, i64 %last
  %last_val = load i32, i32* %last_ptr, align 4
  store i32 %last_val, i32* %arr, align 4
  store i32 %root_val, i32* %last_ptr, align 4
  br label %inner_loop

inner_loop:                                       ; preds = %inner_swap, %swap_root
  %k2 = phi i64 [ 0, %swap_root ], [ %largest_idx3, %inner_swap ]
  %child2 = shl i64 %k2, 1
  %left2 = or i64 %child2, 1
  %has_left2 = icmp ult i64 %left2, %last
  br i1 %has_left2, label %inner_choose_right, label %after_inner

inner_choose_right:                               ; preds = %inner_loop
  %right2 = add i64 %child2, 2
  %has_right2 = icmp ult i64 %right2, %last
  br i1 %has_right2, label %inner_cmp_children, label %inner_after_choose

inner_cmp_children:                               ; preds = %inner_choose_right
  %left_ptr2 = getelementptr inbounds i32, i32* %arr, i64 %left2
  %left_val2 = load i32, i32* %left_ptr2, align 4
  %right_ptr2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %right_val2 = load i32, i32* %right_ptr2, align 4
  %cmp_rl2 = icmp sgt i32 %right_val2, %left_val2
  %largest2 = select i1 %cmp_rl2, i64 %right2, i64 %left2
  br label %inner_after_choose

inner_after_choose:                               ; preds = %inner_choose_right, %inner_cmp_children
  %largest_idx3 = phi i64 [ %largest2, %inner_cmp_children ], [ %left2, %inner_choose_right ]
  %k2_ptr = getelementptr inbounds i32, i32* %arr, i64 %k2
  %k2_val = load i32, i32* %k2_ptr, align 4
  %largest_ptr3 = getelementptr inbounds i32, i32* %arr, i64 %largest_idx3
  %largest_val3 = load i32, i32* %largest_ptr3, align 4
  %k_ge_largest3.not = icmp slt i32 %k2_val, %largest_val3
  br i1 %k_ge_largest3.not, label %inner_swap, label %after_inner

inner_swap:                                       ; preds = %inner_after_choose
  store i32 %largest_val3, i32* %k2_ptr, align 4
  store i32 %k2_val, i32* %largest_ptr3, align 4
  br label %inner_loop

after_inner:                                      ; preds = %inner_after_choose, %inner_loop
  br label %sort_loop

ret:                                              ; preds = %sort_loop, %entry
  ret void
}
