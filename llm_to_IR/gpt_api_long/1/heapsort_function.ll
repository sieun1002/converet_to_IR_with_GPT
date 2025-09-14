; ModuleID = 'heap_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: heap_sort  ; Address: 0x1189
; Intent: In-place ascending heapsort of i32 array (confidence=0.98). Evidence: heapify (2*i+1) child indexing and swap loops
; Preconditions: %a points to at least %n contiguous i32s; n is the element count.
; Postconditions: %a[0..n-1] sorted ascending (signed compare).

define dso_local void @heap_sort(i32* %a, i64 %n) local_unnamed_addr {
entry:
  %cmp1 = icmp ule i64 %n, 1
  br i1 %cmp1, label %exit, label %build_init

build_init:
  %half = lshr i64 %n, 1
  br label %build_header

build_header:
  %i_cur = phi i64 [ %half, %build_init ], [ %idx, %build_next ]
  %cond_i = icmp ne i64 %i_cur, 0
  br i1 %cond_i, label %build_body, label %build_done

build_body:
  %idx = add i64 %i_cur, -1
  br label %sift_loop

sift_loop:
  %i = phi i64 [ %idx, %build_body ], [ %largest_idx_loop, %sift_continue ]
  %tw = shl i64 %i, 1
  %left = add i64 %tw, 1
  %has_left = icmp ult i64 %left, %n
  br i1 %has_left, label %check_right, label %sift_break

check_right:
  %right = add i64 %left, 1
  %left_ptr = getelementptr inbounds i32, i32* %a, i64 %left
  %left_val = load i32, i32* %left_ptr
  %has_right = icmp ult i64 %right, %n
  br i1 %has_right, label %choose_right, label %largest_left

choose_right:
  %right_ptr = getelementptr inbounds i32, i32* %a, i64 %right
  %right_val = load i32, i32* %right_ptr
  %cmp_rl = icmp sgt i32 %right_val, %left_val
  br i1 %cmp_rl, label %largest_right, label %largest_left

largest_right:
  %largest_idx_r = %right
  %largest_val_r = %right_val
  br label %compare_parent

largest_left:
  %largest_idx_l = %left
  %largest_val_l = %left_val
  br label %compare_parent

compare_parent:
  %largest_idx = phi i64 [ %largest_idx_r, %largest_right ], [ %largest_idx_l, %largest_left ]
  %largest_val = phi i32 [ %largest_val_r, %largest_right ], [ %largest_val_l, %largest_left ]
  %i_ptr = getelementptr inbounds i32, i32* %a, i64 %i
  %i_val = load i32, i32* %i_ptr
  %ge = icmp sge i32 %i_val, %largest_val
  br i1 %ge, label %sift_break, label %do_swap

do_swap:
  store i32 %largest_val, i32* %i_ptr
  %l_ptr = getelementptr inbounds i32, i32* %a, i64 %largest_idx
  store i32 %i_val, i32* %l_ptr
  br label %sift_continue

sift_continue:
  %largest_idx_loop = phi i64 [ %largest_idx, %do_swap ]
  br label %sift_loop

sift_break:
  br label %build_next

build_next:
  br label %build_header

build_done:
  %j0 = add i64 %n, -1
  br label %extract_header

extract_header:
  %j_cur = phi i64 [ %j0, %build_done ], [ %j_next, %extract_after_sift ]
  %cond_j = icmp ne i64 %j_cur, 0
  br i1 %cond_j, label %extract_body, label %exit

extract_body:
  %zero_ptr = getelementptr inbounds i32, i32* %a, i64 0
  %root_val = load i32, i32* %zero_ptr
  %j_ptr = getelementptr inbounds i32, i32* %a, i64 %j_cur
  %j_val = load i32, i32* %j_ptr
  store i32 %j_val, i32* %zero_ptr
  store i32 %root_val, i32* %j_ptr
  br label %ex_sift_loop

ex_sift_loop:
  %i2 = phi i64 [ 0, %extract_body ], [ %largest_idx2_loop, %ex_sift_continue ]
  %tw2 = shl i64 %i2, 1
  %left2 = add i64 %tw2, 1
  %has_left2 = icmp ult i64 %left2, %j_cur
  br i1 %has_left2, label %ex_check_right, label %extract_after_sift

ex_check_right:
  %right2 = add i64 %left2, 1
  %left_ptr2 = getelementptr inbounds i32, i32* %a, i64 %left2
  %left_val2 = load i32, i32* %left_ptr2
  %has_right2 = icmp ult i64 %right2, %j_cur
  br i1 %has_right2, label %ex_choose_right, label %ex_largest_left

ex_choose_right:
  %right_ptr2 = getelementptr inbounds i32, i32* %a, i64 %right2
  %right_val2 = load i32, i32* %right_ptr2
  %cmp_rl2 = icmp sgt i32 %right_val2, %left_val2
  br i1 %cmp_rl2, label %ex_largest_right, label %ex_largest_left

ex_largest_right:
  %largest_idx2_r = %right2
  %largest_val2_r = %right_val2
  br label %ex_compare_parent

ex_largest_left:
  %largest_idx2_l = %left2
  %largest_val2_l = %left_val2
  br label %ex_compare_parent

ex_compare_parent:
  %largest_idx2 = phi i64 [ %largest_idx2_r, %ex_largest_right ], [ %largest_idx2_l, %ex_largest_left ]
  %largest_val2 = phi i32 [ %largest_val2_r, %ex_largest_right ], [ %largest_val2_l, %ex_largest_left ]
  %i_ptr2 = getelementptr inbounds i32, i32* %a, i64 %i2
  %i_val2 = load i32, i32* %i_ptr2
  %ge2 = icmp sge i32 %i_val2, %largest_val2
  br i1 %ge2, label %extract_after_sift, label %ex_do_swap

ex_do_swap:
  store i32 %largest_val2, i32* %i_ptr2
  %l_ptr2 = getelementptr inbounds i32, i32* %a, i64 %largest_idx2
  store i32 %i_val2, i32* %l_ptr2
  br label %ex_sift_continue

ex_sift_continue:
  %largest_idx2_loop = phi i64 [ %largest_idx2, %ex_do_swap ]
  br label %ex_sift_loop

extract_after_sift:
  %j_next = add i64 %j_cur, -1
  br label %extract_header

exit:
  ret void
}