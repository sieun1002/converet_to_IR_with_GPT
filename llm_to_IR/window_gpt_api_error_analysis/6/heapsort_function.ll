; ModuleID = 'heapsort_module'
target triple = "x86_64-pc-windows-msvc"

define void @heap_sort(i32* %arr, i64 %n) local_unnamed_addr nounwind {
entry:
  %cmp = icmp ule i64 %n, 1
  br i1 %cmp, label %exit, label %build_init

build_init:
  %half = lshr i64 %n, 1
  br label %build_loop_header

build_loop_header:
  %i_curr = phi i64 [ %half, %build_init ], [ %i_next, %decrement_i ]
  br label %sift_inner

sift_inner:
  %pos = phi i64 [ %i_curr, %build_loop_header ], [ %pos_next, %did_swap ]
  %child2x = shl i64 %pos, 1
  %child_plus = or i64 %child2x, 1
  %cmp_child_in = icmp ult i64 %child_plus, %n
  br i1 %cmp_child_in, label %maybe_choose_child, label %after_heapify

maybe_choose_child:
  %right = add i64 %child_plus, 1
  %right_in = icmp ult i64 %right, %n
  br i1 %right_in, label %compare_children, label %use_left

compare_children:
  %right_ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right_val = load i32, i32* %right_ptr, align 4
  %left_ptr = getelementptr inbounds i32, i32* %arr, i64 %child_plus
  %left_val = load i32, i32* %left_ptr, align 4
  %cmp_rl = icmp sgt i32 %right_val, %left_val
  br i1 %cmp_rl, label %select_right, label %use_left

select_right:
  br label %selected_child

use_left:
  br label %selected_child

selected_child:
  %sel_idx = phi i64 [ %right, %select_right ], [ %child_plus, %use_left ]
  %pos_ptr = getelementptr inbounds i32, i32* %arr, i64 %pos
  %pos_val = load i32, i32* %pos_ptr, align 4
  %sel_ptr = getelementptr inbounds i32, i32* %arr, i64 %sel_idx
  %sel_val = load i32, i32* %sel_ptr, align 4
  %cmp_lt = icmp slt i32 %pos_val, %sel_val
  br i1 %cmp_lt, label %do_swap, label %after_heapify

do_swap:
  store i32 %sel_val, i32* %pos_ptr, align 4
  store i32 %pos_val, i32* %sel_ptr, align 4
  %pos_next = add i64 %sel_idx, 0
  br label %did_swap

did_swap:
  br label %sift_inner

after_heapify:
  %is_zero = icmp eq i64 %i_curr, 0
  br i1 %is_zero, label %sort_prep, label %decrement_i

decrement_i:
  %i_next = add i64 %i_curr, -1
  br label %build_loop_header

sort_prep:
  %m_init = add i64 %n, -1
  br label %sort_check

sort_check:
  %m = phi i64 [ %m_init, %sort_prep ], [ %m_dec, %after_inner_sift_or_done ]
  %cond = icmp ne i64 %m, 0
  br i1 %cond, label %sort_body, label %exit

sort_body:
  %arr0_ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %arr0 = load i32, i32* %arr0_ptr, align 4
  %arrm_ptr = getelementptr inbounds i32, i32* %arr, i64 %m
  %arrm = load i32, i32* %arrm_ptr, align 4
  store i32 %arrm, i32* %arr0_ptr, align 4
  store i32 %arr0, i32* %arrm_ptr, align 4
  br label %inner_sift

inner_sift:
  %pos2 = phi i64 [ 0, %sort_body ], [ %pos2_next, %did_swap2 ]
  %child2x2 = shl i64 %pos2, 1
  %child_plus2 = or i64 %child2x2, 1
  %cmp_child_in2 = icmp ult i64 %child_plus2, %m
  br i1 %cmp_child_in2, label %maybe_choose_child2, label %after_inner_sift_or_done

maybe_choose_child2:
  %right2 = add i64 %child_plus2, 1
  %right_in2 = icmp ult i64 %right2, %m
  br i1 %right_in2, label %compare_children2, label %use_left2

compare_children2:
  %right_ptr2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %right_val2 = load i32, i32* %right_ptr2, align 4
  %left_ptr2 = getelementptr inbounds i32, i32* %arr, i64 %child_plus2
  %left_val2 = load i32, i32* %left_ptr2, align 4
  %cmp_rl2 = icmp sgt i32 %right_val2, %left_val2
  br i1 %cmp_rl2, label %select_right2, label %use_left2

select_right2:
  br label %selected_child2

use_left2:
  br label %selected_child2

selected_child2:
  %sel_idx2 = phi i64 [ %right2, %select_right2 ], [ %child_plus2, %use_left2 ]
  %pos_ptr2 = getelementptr inbounds i32, i32* %arr, i64 %pos2
  %pos_val2 = load i32, i32* %pos_ptr2, align 4
  %sel_ptr2 = getelementptr inbounds i32, i32* %arr, i64 %sel_idx2
  %sel_val2 = load i32, i32* %sel_ptr2, align 4
  %cmp_lt2 = icmp slt i32 %pos_val2, %sel_val2
  br i1 %cmp_lt2, label %do_swap2, label %after_inner_sift_or_done

do_swap2:
  store i32 %sel_val2, i32* %pos_ptr2, align 4
  store i32 %pos_val2, i32* %sel_ptr2, align 4
  %pos2_next = add i64 %sel_idx2, 0
  br label %did_swap2

did_swap2:
  br label %inner_sift

after_inner_sift_or_done:
  %m_dec = add i64 %m, -1
  br label %sort_check

exit:
  ret void
}