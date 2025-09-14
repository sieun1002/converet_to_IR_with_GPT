; ModuleID = 'heapsort_module'
target triple = "x86_64-pc-linux-gnu"

define void @heap_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %build_init

build_init:
  %half = lshr i64 %n, 1
  br label %build_loop_head

build_loop_head:
  %i_prev = phi i64 [ %half, %build_init ], [ %i_next, %build_loop_latch ]
  %i_dec = add i64 %i_prev, -1
  %i_prev_nonzero = icmp ne i64 %i_prev, 0
  br i1 %i_prev_nonzero, label %sift_down_build.entry, label %extract_init

sift_down_build.entry:
  br label %sift_build

sift_build:
  %j = phi i64 [ %i_dec, %sift_down_build.entry ], [ %child, %sift_swap ]
  %j2 = shl i64 %j, 1
  %left = add i64 %j2, 1
  %left_ge_n = icmp uge i64 %left, %n
  br i1 %left_ge_n, label %build_loop_latch, label %sift_choose_child

sift_choose_child:
  %right = add i64 %left, 1
  %right_in = icmp ult i64 %right, %n
  br i1 %right_in, label %cmp_children, label %child_is_left

child_is_left:
  br label %child_merge

cmp_children:
  %left_ptr0 = getelementptr inbounds i32, i32* %arr, i64 %left
  %left_val0 = load i32, i32* %left_ptr0, align 4
  %right_ptr0 = getelementptr inbounds i32, i32* %arr, i64 %right
  %right_val0 = load i32, i32* %right_ptr0, align 4
  %right_gt_left = icmp sgt i32 %right_val0, %left_val0
  br i1 %right_gt_left, label %child_is_right, label %child_is_left

child_is_right:
  br label %child_merge

child_merge:
  %child = phi i64 [ %left, %child_is_left ], [ %right, %child_is_right ]
  %j_ptr0 = getelementptr inbounds i32, i32* %arr, i64 %j
  %j_val0 = load i32, i32* %j_ptr0, align 4
  %child_ptr0 = getelementptr inbounds i32, i32* %arr, i64 %child
  %child_val0 = load i32, i32* %child_ptr0, align 4
  %j_ge_child = icmp sge i32 %j_val0, %child_val0
  br i1 %j_ge_child, label %build_loop_latch, label %sift_swap

sift_swap:
  %tmp = load i32, i32* %j_ptr0, align 4
  %tmp2 = load i32, i32* %child_ptr0, align 4
  store i32 %tmp2, i32* %j_ptr0, align 4
  store i32 %tmp, i32* %child_ptr0, align 4
  br label %sift_build

build_loop_latch:
  %i_next = add i64 %i_dec, 0
  br label %build_loop_head

extract_init:
  %last = add i64 %n, -1
  br label %extract_cond

extract_cond:
  %heap_end = phi i64 [ %last, %extract_init ], [ %heap_end_next, %extract_latch ]
  %cond_nonzero = icmp ne i64 %heap_end, 0
  br i1 %cond_nonzero, label %extract_body, label %ret

extract_body:
  %root_ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %root_val = load i32, i32* %root_ptr, align 4
  %end_ptr = getelementptr inbounds i32, i32* %arr, i64 %heap_end
  %end_val = load i32, i32* %end_ptr, align 4
  store i32 %end_val, i32* %root_ptr, align 4
  store i32 %root_val, i32* %end_ptr, align 4
  br label %sift_extract

sift_extract:
  %k = phi i64 [ 0, %extract_body ], [ %childE, %siftE_swap ]
  %k2 = shl i64 %k, 1
  %leftE = add i64 %k2, 1
  %left_ge_end = icmp uge i64 %leftE, %heap_end
  br i1 %left_ge_end, label %extract_latch, label %siftE_choose

siftE_choose:
  %rightE = add i64 %leftE, 1
  %right_inE = icmp ult i64 %rightE, %heap_end
  br i1 %right_inE, label %cmp_childrenE, label %child_is_leftE

child_is_leftE:
  br label %child_mergeE

cmp_childrenE:
  %left_ptrE = getelementptr inbounds i32, i32* %arr, i64 %leftE
  %left_valE = load i32, i32* %left_ptrE, align 4
  %right_ptrE = getelementptr inbounds i32, i32* %arr, i64 %rightE
  %right_valE = load i32, i32* %right_ptrE, align 4
  %right_gt_leftE = icmp sgt i32 %right_valE, %left_valE
  br i1 %right_gt_leftE, label %child_is_rightE, label %child_is_leftE

child_is_rightE:
  br label %child_mergeE

child_mergeE:
  %childE = phi i64 [ %leftE, %child_is_leftE ], [ %rightE, %child_is_rightE ]
  %k_ptr = getelementptr inbounds i32, i32* %arr, i64 %k
  %k_val = load i32, i32* %k_ptr, align 4
  %child_ptrE = getelementptr inbounds i32, i32* %arr, i64 %childE
  %child_valE = load i32, i32* %child_ptrE, align 4
  %k_ge_childE = icmp sge i32 %k_val, %child_valE
  br i1 %k_ge_childE, label %extract_latch, label %siftE_swap

siftE_swap:
  %tmpE1 = load i32, i32* %k_ptr, align 4
  %tmpE2 = load i32, i32* %child_ptrE, align 4
  store i32 %tmpE2, i32* %k_ptr, align 4
  store i32 %tmpE1, i32* %child_ptrE, align 4
  br label %sift_extract

extract_latch:
  %heap_end_next = add i64 %heap_end, -1
  br label %extract_cond

ret:
  ret void
}