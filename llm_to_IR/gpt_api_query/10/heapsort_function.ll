; ModuleID = 'heap_sort_module'
source_filename = "heap_sort.ll"

define dso_local void @heap_sort(i32* noundef %arr, i64 noundef %len) local_unnamed_addr {
entry:
  %cmp_len = icmp ule i64 %len, 1
  br i1 %cmp_len, label %ret, label %build_heap

build_heap:                                        ; preds = %entry
  %i0 = lshr i64 %len, 1
  br label %heap_loop_head

heap_loop_head:                                    ; preds = %heap_after_sift, %build_heap
  %i = phi i64 [ %i0, %build_heap ], [ %i.dec, %heap_after_sift ]
  %i_zero = icmp eq i64 %i, 0
  br i1 %i_zero, label %heap_done, label %heap_do

heap_do:                                           ; preds = %heap_loop_head
  %node = add i64 %i, -1
  br label %sift_head

sift_head:                                         ; preds = %sift_swapped, %heap_do
  %k = phi i64 [ %node, %heap_do ], [ %child, %sift_swapped ]
  %k2 = shl i64 %k, 1
  %left = add i64 %k2, 1
  %cond1 = icmp uge i64 %left, %len
  br i1 %cond1, label %heap_after_sift, label %check_right

check_right:                                       ; preds = %sift_head
  %right = add i64 %left, 1
  %has_right = icmp ult i64 %right, %len
  %left_ptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %left_val = load i32, i32* %left_ptr, align 4
  br i1 %has_right, label %load_right, label %choose_left

load_right:                                        ; preds = %check_right
  %right_ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right_val = load i32, i32* %right_ptr, align 4
  %cmp_gt = icmp sgt i32 %right_val, %left_val
  br i1 %cmp_gt, label %choose_right, label %choose_left

choose_right:                                      ; preds = %load_right
  br label %after_choose

choose_left:                                       ; preds = %load_right, %check_right
  br label %after_choose

after_choose:                                      ; preds = %choose_left, %choose_right
  %child = phi i64 [ %right, %choose_right ], [ %left, %choose_left ]
  %k_ptr = getelementptr inbounds i32, i32* %arr, i64 %k
  %k_val = load i32, i32* %k_ptr, align 4
  %child_ptr = getelementptr inbounds i32, i32* %arr, i64 %child
  %child_val = load i32, i32* %child_ptr, align 4
  %cmp_ge = icmp sge i32 %k_val, %child_val
  br i1 %cmp_ge, label %heap_after_sift, label %sift_swap

sift_swap:                                         ; preds = %after_choose
  store i32 %child_val, i32* %k_ptr, align 4
  store i32 %k_val, i32* %child_ptr, align 4
  br label %sift_swapped

sift_swapped:                                      ; preds = %sift_swap
  br label %sift_head

heap_after_sift:                                   ; preds = %after_choose, %sift_head
  %i.dec = add i64 %i, -1
  br label %heap_loop_head

heap_done:                                         ; preds = %heap_loop_head
  %end0 = add i64 %len, -1
  br label %outer_loop_head

outer_loop_head:                                   ; preds = %outer_after_sift, %heap_done
  %end = phi i64 [ %end0, %heap_done ], [ %end.dec, %outer_after_sift ]
  %end_is_zero = icmp eq i64 %end, 0
  br i1 %end_is_zero, label %ret, label %extract_max

extract_max:                                       ; preds = %outer_loop_head
  %root0 = getelementptr inbounds i32, i32* %arr, i64 0
  %root_val0 = load i32, i32* %root0, align 4
  %end_ptr0 = getelementptr inbounds i32, i32* %arr, i64 %end
  %end_val0 = load i32, i32* %end_ptr0, align 4
  store i32 %end_val0, i32* %root0, align 4
  store i32 %root_val0, i32* %end_ptr0, align 4
  br label %sift2_head

sift2_head:                                        ; preds = %sift2_swapped, %extract_max
  %root = phi i64 [ 0, %extract_max ], [ %child2, %sift2_swapped ]
  %root2 = shl i64 %root, 1
  %left2 = add i64 %root2, 1
  %cond1b = icmp uge i64 %left2, %end
  br i1 %cond1b, label %outer_after_sift, label %check_right2

check_right2:                                      ; preds = %sift2_head
  %right2 = add i64 %left2, 1
  %has_right2 = icmp ult i64 %right2, %end
  %left_ptr2 = getelementptr inbounds i32, i32* %arr, i64 %left2
  %left_val2 = load i32, i32* %left_ptr2, align 4
  br i1 %has_right2, label %load_right2, label %choose_left2

load_right2:                                       ; preds = %check_right2
  %right_ptr2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %right_val2 = load i32, i32* %right_ptr2, align 4
  %cmp_gt2 = icmp sgt i32 %right_val2, %left_val2
  br i1 %cmp_gt2, label %choose_right2, label %choose_left2

choose_right2:                                     ; preds = %load_right2
  br label %after_choose2

choose_left2:                                      ; preds = %load_right2, %check_right2
  br label %after_choose2

after_choose2:                                     ; preds = %choose_left2, %choose_right2
  %child2 = phi i64 [ %right2, %choose_right2 ], [ %left2, %choose_left2 ]
  %root_ptr2 = getelementptr inbounds i32, i32* %arr, i64 %root
  %root_val2 = load i32, i32* %root_ptr2, align 4
  %child_ptr2 = getelementptr inbounds i32, i32* %arr, i64 %child2
  %child_val2 = load i32, i32* %child_ptr2, align 4
  %cmp_ge2 = icmp sge i32 %root_val2, %child_val2
  br i1 %cmp_ge2, label %outer_after_sift, label %sift2_swap

sift2_swap:                                        ; preds = %after_choose2
  store i32 %child_val2, i32* %root_ptr2, align 4
  store i32 %root_val2, i32* %child_ptr2, align 4
  br label %sift2_swapped

sift2_swapped:                                     ; preds = %sift2_swap
  br label %sift2_head

outer_after_sift:                                  ; preds = %after_choose2, %sift2_head
  %end.dec = add i64 %end, -1
  br label %outer_loop_head

ret:                                               ; preds = %outer_loop_head, %entry
  ret void
}