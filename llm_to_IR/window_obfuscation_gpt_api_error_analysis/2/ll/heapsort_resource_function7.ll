; ModuleID = 'heapsort'
target triple = "x86_64-pc-windows-msvc"

define void @sub_140001450(i32* %arr, i64 %n) #0 {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %heapify_init

heapify_init:
  %n_shr = lshr i64 %n, 1
  %i0 = sub i64 %n_shr, 1
  br label %heapify_outer

heapify_outer:
  %i = phi i64 [ %i0, %heapify_init ], [ %i_next, %heapify_after_inner ]
  br label %heapify_inner

heapify_inner:
  %j = phi i64 [ %i, %heapify_outer ], [ %k, %heapify_swap ]
  %j2 = add i64 %j, %j
  %left = add i64 %j2, 1
  %left_lt_n = icmp ult i64 %left, %n
  br i1 %left_lt_n, label %choose_child, label %heapify_after_inner

choose_child:
  %right = add i64 %left, 1
  %right_lt_n = icmp ult i64 %right, %n
  br i1 %right_lt_n, label %cmp_children, label %use_left

cmp_children:
  %left_ptr1 = getelementptr inbounds i32, i32* %arr, i64 %left
  %left_val1 = load i32, i32* %left_ptr1, align 4
  %right_ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right_val = load i32, i32* %right_ptr, align 4
  %right_gt_left = icmp sgt i32 %right_val, %left_val1
  br i1 %right_gt_left, label %select_right, label %select_left_from_cmp

select_right:
  br label %after_select_k

select_left_from_cmp:
  br label %after_select_k

use_left:
  br label %after_select_k

after_select_k:
  %k = phi i64 [ %right, %select_right ], [ %left, %select_left_from_cmp ], [ %left, %use_left ]
  %j_ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %j_val = load i32, i32* %j_ptr, align 4
  %k_ptr = getelementptr inbounds i32, i32* %arr, i64 %k
  %k_val = load i32, i32* %k_ptr, align 4
  %j_lt_k = icmp slt i32 %j_val, %k_val
  br i1 %j_lt_k, label %heapify_swap, label %heapify_after_inner

heapify_swap:
  store i32 %k_val, i32* %j_ptr, align 4
  store i32 %j_val, i32* %k_ptr, align 4
  br label %heapify_inner

heapify_after_inner:
  %i_next = sub i64 %i, 1
  %i_next_ge0 = icmp sge i64 %i_next, 0
  br i1 %i_next_ge0, label %heapify_outer, label %extract_init

extract_init:
  %end0 = sub i64 %n, 1
  br label %extract_loop

extract_loop:
  %end = phi i64 [ %end0, %extract_init ], [ %end_next, %extract_decrement ]
  %end_is_zero = icmp eq i64 %end, 0
  br i1 %end_is_zero, label %ret, label %extract_body

extract_body:
  %root_ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %root_val = load i32, i32* %root_ptr, align 4
  %end_ptr = getelementptr inbounds i32, i32* %arr, i64 %end
  %end_val = load i32, i32* %end_ptr, align 4
  store i32 %end_val, i32* %root_ptr, align 4
  store i32 %root_val, i32* %end_ptr, align 4
  br label %sift_inner

sift_inner:
  %j2_i = phi i64 [ 0, %extract_body ], [ %k2, %sift_swap ]
  %j2_times2 = add i64 %j2_i, %j2_i
  %left2 = add i64 %j2_times2, 1
  %left_lt_end = icmp ult i64 %left2, %end
  br i1 %left_lt_end, label %choose_child2, label %sift_done

choose_child2:
  %right2 = add i64 %left2, 1
  %right_lt_end = icmp ult i64 %right2, %end
  br i1 %right_lt_end, label %cmp_children2, label %use_left2

cmp_children2:
  %left_ptr2a = getelementptr inbounds i32, i32* %arr, i64 %left2
  %left_val2a = load i32, i32* %left_ptr2a, align 4
  %right_ptr2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %right_val2 = load i32, i32* %right_ptr2, align 4
  %right_gt_left2 = icmp sgt i32 %right_val2, %left_val2a
  br i1 %right_gt_left2, label %select_right2, label %select_left2_from_cmp

select_right2:
  br label %after_select_k2

select_left2_from_cmp:
  br label %after_select_k2

use_left2:
  br label %after_select_k2

after_select_k2:
  %k2 = phi i64 [ %right2, %select_right2 ], [ %left2, %select_left2_from_cmp ], [ %left2, %use_left2 ]
  %j2_ptr = getelementptr inbounds i32, i32* %arr, i64 %j2_i
  %j2_val = load i32, i32* %j2_ptr, align 4
  %k2_ptr = getelementptr inbounds i32, i32* %arr, i64 %k2
  %k2_val = load i32, i32* %k2_ptr, align 4
  %j2_lt_k2 = icmp slt i32 %j2_val, %k2_val
  br i1 %j2_lt_k2, label %sift_swap, label %sift_done

sift_swap:
  store i32 %k2_val, i32* %j2_ptr, align 4
  store i32 %j2_val, i32* %k2_ptr, align 4
  br label %sift_inner

sift_done:
  br label %extract_decrement

extract_decrement:
  %end_next = sub i64 %end, 1
  br label %extract_loop

ret:
  ret void
}

attributes #0 = { nounwind uwtable "frame-pointer"="none" }