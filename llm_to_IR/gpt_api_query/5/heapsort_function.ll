; LLVM 14 IR for: void heap_sort(int* arr, uint64_t n)
define void @heap_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %build_init

build_init:
  %half = lshr i64 %n, 1
  %half_minus1 = add i64 %half, -1
  %half_is_zero = icmp eq i64 %half, 0
  br i1 %half_is_zero, label %after_build, label %build_outer

; Build-max-heap phase: for (i = (n>>1)-1; i >= 0; --i) siftDown(i, n)
build_outer:
  %i = phi i64 [ %half_minus1, %build_init ], [ %i_dec, %build_outer_cont ]

  ; start sifting with cur = i
  br label %sift_cond

sift_cond:
  %cur = phi i64 [ %i, %build_outer ], [ %childAfter, %after_swap ]
  %cur_x2 = shl i64 %cur, 1
  %left = add i64 %cur_x2, 1
  %has_left = icmp ult i64 %left, %n
  br i1 %has_left, label %choose_right, label %build_outer_end

choose_right:
  %right = add i64 %left, 1
  %has_right = icmp ult i64 %right, %n
  br i1 %has_right, label %load_right, label %take_left

load_right:
  %ptr_right = getelementptr inbounds i32, i32* %arr, i64 %right
  %val_right = load i32, i32* %ptr_right, align 4
  %ptr_left = getelementptr inbounds i32, i32* %arr, i64 %left
  %val_left = load i32, i32* %ptr_left, align 4
  %right_gt_left = icmp sgt i32 %val_right, %val_left
  br i1 %right_gt_left, label %child_is_right, label %take_left

child_is_right:
  br label %child_decided

take_left:
  br label %child_decided

child_decided:
  %childIdx = phi i64 [ %right, %child_is_right ], [ %left, %take_left ]
  %ptr_parent = getelementptr inbounds i32, i32* %arr, i64 %cur
  %val_parent = load i32, i32* %ptr_parent, align 4
  %ptr_child = getelementptr inbounds i32, i32* %arr, i64 %childIdx
  %val_child = load i32, i32* %ptr_child, align 4
  %parent_ge_child = icmp sge i32 %val_parent, %val_child
  br i1 %parent_ge_child, label %build_outer_end, label %after_swap

after_swap:
  ; swap parent and child
  store i32 %val_child, i32* %ptr_parent, align 4
  store i32 %val_parent, i32* %ptr_child, align 4
  %childAfter = %childIdx
  br label %sift_cond

build_outer_end:
  ; finished sifting for this i
  %i_is_zero = icmp eq i64 %i, 0
  br i1 %i_is_zero, label %after_build, label %build_outer_cont

build_outer_cont:
  %i_dec = add i64 %i, -1
  br label %build_outer

after_build:
  ; Sorting phase
  %end_init = add i64 %n, -1
  br label %sort_loop

; Main sort loop: for (end = n-1; end != 0; --end)
sort_loop:
  %end = phi i64 [ %end_init, %after_build ], [ %end_dec, %after_sift2 ]
  %end_is_zero = icmp eq i64 %end, 0
  br i1 %end_is_zero, label %ret, label %sort_iter

sort_iter:
  ; swap arr[0] and arr[end]
  %ptr0 = getelementptr inbounds i32, i32* %arr, i64 0
  %val0 = load i32, i32* %ptr0, align 4
  %ptr_end = getelementptr inbounds i32, i32* %arr, i64 %end
  %val_end = load i32, i32* %ptr_end, align 4
  store i32 %val_end, i32* %ptr0, align 4
  store i32 %val0, i32* %ptr_end, align 4
  br label %sift2_cond

; Sift-down with limit = end
sift2_cond:
  %cur2 = phi i64 [ 0, %sort_iter ], [ %childAfter2, %after_swap2 ]
  %cur2_x2 = shl i64 %cur2, 1
  %left2 = add i64 %cur2_x2, 1
  %has_left2 = icmp ult i64 %left2, %end
  br i1 %has_left2, label %choose_right2, label %after_sift2

choose_right2:
  %right2 = add i64 %left2, 1
  %has_right2 = icmp ult i64 %right2, %end
  br i1 %has_right2, label %load_right2, label %take_left2

load_right2:
  %ptr_right2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %val_right2 = load i32, i32* %ptr_right2, align 4
  %ptr_left2 = getelementptr inbounds i32, i32* %arr, i64 %left2
  %val_left2 = load i32, i32* %ptr_left2, align 4
  %right_gt_left2 = icmp sgt i32 %val_right2, %val_left2
  br i1 %right_gt_left2, label %child_is_right2, label %take_left2

child_is_right2:
  br label %child_decided2

take_left2:
  br label %child_decided2

child_decided2:
  %childIdx2 = phi i64 [ %right2, %child_is_right2 ], [ %left2, %take_left2 ]
  %ptr_parent2 = getelementptr inbounds i32, i32* %arr, i64 %cur2
  %val_parent2 = load i32, i32* %ptr_parent2, align 4
  %ptr_child2 = getelementptr inbounds i32, i32* %arr, i64 %childIdx2
  %val_child2 = load i32, i32* %ptr_child2, align 4
  %parent_ge_child2 = icmp sge i32 %val_parent2, %val_child2
  br i1 %parent_ge_child2, label %after_sift2, label %after_swap2

after_swap2:
  ; swap parent and child
  store i32 %val_child2, i32* %ptr_parent2, align 4
  store i32 %val_parent2, i32* %ptr_child2, align 4
  %childAfter2 = %childIdx2
  br label %sift2_cond

after_sift2:
  %end_dec = add i64 %end, -1
  br label %sort_loop

ret:
  ret void
}