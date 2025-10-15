target triple = "x86_64-pc-windows-msvc"

define void @heap_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n = icmp ule i64 %n, 1
  br i1 %cmp_n, label %ret, label %build_init

build_init:                                        ; preds = %entry
  %half = lshr i64 %n, 1
  br label %build_dec

build_dec:                                         ; preds = %build_after_body, %build_init
  %i_old = phi i64 [ %half, %build_init ], [ %i_dec, %build_after_body ]
  %is_zero = icmp eq i64 %i_old, 0
  br i1 %is_zero, label %after_build, label %build_body_entry

build_body_entry:                                  ; preds = %build_dec
  %i_dec = add i64 %i_old, -1
  br label %sift_header

sift_header:                                       ; preds = %after_swap, %build_body_entry
  %j = phi i64 [ %i_dec, %build_body_entry ], [ %max_idx, %after_swap ]
  %twice = add i64 %j, %j
  %child = add i64 %twice, 1
  %has_child = icmp ult i64 %child, %n
  br i1 %has_child, label %sift_choose, label %build_after_body

sift_choose:                                       ; preds = %sift_header
  %right = add i64 %child, 1
  %right_in = icmp ult i64 %right, %n
  %left_ptr = getelementptr inbounds i32, i32* %arr, i64 %child
  %left_val = load i32, i32* %left_ptr, align 4
  br i1 %right_in, label %cmp_right, label %choose_left

cmp_right:                                         ; preds = %sift_choose
  %right_ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right_val = load i32, i32* %right_ptr, align 4
  %right_gt_left = icmp sgt i32 %right_val, %left_val
  br i1 %right_gt_left, label %choose_right, label %choose_left_b

choose_right:                                      ; preds = %cmp_right
  br label %after_choose

choose_left:                                       ; preds = %sift_choose
  br label %after_choose

choose_left_b:                                     ; preds = %cmp_right
  br label %after_choose

after_choose:                                      ; preds = %choose_left_b, %choose_left, %choose_right
  %max_idx = phi i64 [ %right, %choose_right ], [ %child, %choose_left ], [ %child, %choose_left_b ]
  %parent_ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %parent_val = load i32, i32* %parent_ptr, align 4
  %max_ptr = getelementptr inbounds i32, i32* %arr, i64 %max_idx
  %max_val = load i32, i32* %max_ptr, align 4
  %parent_lt = icmp slt i32 %parent_val, %max_val
  br i1 %parent_lt, label %after_swap, label %build_after_body

after_swap:                                        ; preds = %after_choose
  store i32 %max_val, i32* %parent_ptr, align 4
  store i32 %parent_val, i32* %max_ptr, align 4
  br label %sift_header

build_after_body:                                  ; preds = %after_choose, %sift_header
  br label %build_dec

after_build:                                       ; preds = %build_dec
  %end0 = add i64 %n, -1
  br label %outer2_header

outer2_header:                                     ; preds = %after_extract, %after_build
  %end = phi i64 [ %end0, %after_build ], [ %end_next, %after_extract ]
  %end_is_zero = icmp eq i64 %end, 0
  br i1 %end_is_zero, label %ret, label %extract

extract:                                           ; preds = %outer2_header
  %root_ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %root_val = load i32, i32* %root_ptr, align 4
  %end_ptr = getelementptr inbounds i32, i32* %arr, i64 %end
  %end_val = load i32, i32* %end_ptr, align 4
  store i32 %end_val, i32* %root_ptr, align 4
  store i32 %root_val, i32* %end_ptr, align 4
  br label %sift2_header

sift2_header:                                      ; preds = %swap2, %extract
  %j2 = phi i64 [ 0, %extract ], [ %max_idx2, %swap2 ]
  %twice2 = add i64 %j2, %j2
  %child2 = add i64 %twice2, 1
  %has_child2 = icmp ult i64 %child2, %end
  br i1 %has_child2, label %choose2, label %after_extract

choose2:                                           ; preds = %sift2_header
  %right2 = add i64 %child2, 1
  %right_in2 = icmp ult i64 %right2, %end
  %left_ptr2 = getelementptr inbounds i32, i32* %arr, i64 %child2
  %left_val2 = load i32, i32* %left_ptr2, align 4
  br i1 %right_in2, label %cmp_right2, label %choose_left2

cmp_right2:                                        ; preds = %choose2
  %right_ptr2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %right_val2 = load i32, i32* %right_ptr2, align 4
  %right_gt_left2 = icmp sgt i32 %right_val2, %left_val2
  br i1 %right_gt_left2, label %choose_right2, label %choose_left2b

choose_right2:                                     ; preds = %cmp_right2
  br label %after_choose2

choose_left2:                                      ; preds = %choose2
  br label %after_choose2

choose_left2b:                                     ; preds = %cmp_right2
  br label %after_choose2

after_choose2:                                     ; preds = %choose_left2b, %choose_left2, %choose_right2
  %max_idx2 = phi i64 [ %right2, %choose_right2 ], [ %child2, %choose_left2 ], [ %child2, %choose_left2b ]
  %parent_ptr2 = getelementptr inbounds i32, i32* %arr, i64 %j2
  %parent_val2 = load i32, i32* %parent_ptr2, align 4
  %max_ptr2 = getelementptr inbounds i32, i32* %arr, i64 %max_idx2
  %max_val2 = load i32, i32* %max_ptr2, align 4
  %parent_ge2 = icmp sge i32 %parent_val2, %max_val2
  br i1 %parent_ge2, label %after_extract, label %swap2

swap2:                                             ; preds = %after_choose2
  store i32 %max_val2, i32* %parent_ptr2, align 4
  store i32 %parent_val2, i32* %max_ptr2, align 4
  br label %sift2_header

after_extract:                                     ; preds = %after_choose2, %sift2_header
  %end_next = add i64 %end, -1
  br label %outer2_header

ret:                                               ; preds = %outer2_header, %entry
  ret void
}