; LLVM IR for: void heap_sort(int* arr, uint64_t n)
; Compatible with LLVM 14

define dso_local void @heap_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp_le_1 = icmp ule i64 %n, 1
  br i1 %cmp_le_1, label %ret, label %build_init

build_init:                                           ; heapify phase init
  %i.init = lshr i64 %n, 1
  br label %build_loop_header

build_loop_header:
  %i.ph = phi i64 [ %i.init, %build_init ], [ %i.dec, %build_after_sift ]
  %i.ne.zero = icmp ne i64 %i.ph, 0
  br i1 %i.ne.zero, label %build_setj, label %sort_init

build_setj:
  br label %build_sift_header

; Sift-down in heapify phase
build_sift_header:
  %j.cur = phi i64 [ %i.ph, %build_setj ], [ %child.idx, %build_sift_swap ]
  %i.carry = phi i64 [ %i.ph, %build_setj ], [ %i.carry, %build_sift_swap ]
  %j2 = add i64 %j.cur, %j.cur
  %left = add i64 %j2, 1
  %left_ge_n = icmp uge i64 %left, %n
  br i1 %left_ge_n, label %build_after_sift, label %build_have_left

build_have_left:
  %right = add i64 %left, 1
  %right_ge_n = icmp uge i64 %right, %n
  br i1 %right_ge_n, label %build_choose_left, label %build_compare_children

build_compare_children:
  %left.ptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %left.val = load i32, i32* %left.ptr, align 4
  %right.ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right.val = load i32, i32* %right.ptr, align 4
  %right_gt_left = icmp sgt i32 %right.val, %left.val
  %child.idx.sel = select i1 %right_gt_left, i64 %right, i64 %left
  br label %build_child_chosen

build_choose_left:
  br label %build_child_chosen

build_child_chosen:
  %child.idx = phi i64 [ %child.idx.sel, %build_compare_children ], [ %left, %build_choose_left ]
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %j.val = load i32, i32* %j.ptr, align 4
  %child.ptr = getelementptr inbounds i32, i32* %arr, i64 %child.idx
  %child.val = load i32, i32* %child.ptr, align 4
  %j_ge_child = icmp sge i32 %j.val, %child.val
  br i1 %j_ge_child, label %build_after_sift, label %build_sift_swap

build_sift_swap:
  store i32 %child.val, i32* %j.ptr, align 4
  store i32 %j.val, i32* %child.ptr, align 4
  br label %build_sift_header

build_after_sift:
  %i.for.dec = phi i64 [ %i.carry, %build_sift_header ], [ %i.carry, %build_child_chosen ]
  %i.dec = add i64 %i.for.dec, -1
  br label %build_loop_header

; Extraction (sort-down) phase
sort_init:
  %end.init = add i64 %n, -1
  br label %sort_loop_header

sort_loop_header:
  %end.ph = phi i64 [ %end.init, %sort_init ], [ %end.dec, %sort_after_sift ]
  %end.ne.zero = icmp ne i64 %end.ph, 0
  br i1 %end.ne.zero, label %sort_swap_root, label %ret

sort_swap_root:
  %root.val = load i32, i32* %arr, align 4
  %end.ptr = getelementptr inbounds i32, i32* %arr, i64 %end.ph
  %end.val = load i32, i32* %end.ptr, align 4
  store i32 %end.val, i32* %arr, align 4
  store i32 %root.val, i32* %end.ptr, align 4
  br label %sort_sift_header

; Sift-down in extraction phase (heap size = end.ph)
sort_sift_header:
  %j2.cur = phi i64 [ 0, %sort_swap_root ], [ %child2.idx, %sort_sift_swap ]
  %end.carry = phi i64 [ %end.ph, %sort_swap_root ], [ %end.carry, %sort_sift_swap ]
  %j2b = add i64 %j2.cur, %j2.cur
  %left2 = add i64 %j2b, 1
  %left2_ge_end = icmp uge i64 %left2, %end.carry
  br i1 %left2_ge_end, label %sort_after_sift, label %sort_have_left

sort_have_left:
  %right2 = add i64 %left2, 1
  %right2_ge_end = icmp uge i64 %right2, %end.carry
  br i1 %right2_ge_end, label %sort_choose_left, label %sort_compare_children

sort_compare_children:
  %left2.ptr = getelementptr inbounds i32, i32* %arr, i64 %left2
  %left2.val = load i32, i32* %left2.ptr, align 4
  %right2.ptr = getelementptr inbounds i32, i32* %arr, i64 %right2
  %right2.val = load i32, i32* %right2.ptr, align 4
  %right2_gt_left2 = icmp sgt i32 %right2.val, %left2.val
  %child2.idx.sel = select i1 %right2_gt_left2, i64 %right2, i64 %left2
  br label %sort_child_chosen

sort_choose_left:
  br label %sort_child_chosen

sort_child_chosen:
  %child2.idx = phi i64 [ %child2.idx.sel, %sort_compare_children ], [ %left2, %sort_choose_left ]
  %j2.ptr = getelementptr inbounds i32, i32* %arr, i64 %j2.cur
  %j2.val = load i32, i32* %j2.ptr, align 4
  %child2.ptr = getelementptr inbounds i32, i32* %arr, i64 %child2.idx
  %child2.val = load i32, i32* %child2.ptr, align 4
  %j2_ge_child2 = icmp sge i32 %j2.val, %child2.val
  br i1 %j2_ge_child2, label %sort_after_sift, label %sort_sift_swap

sort_sift_swap:
  store i32 %child2.val, i32* %j2.ptr, align 4
  store i32 %j2.val, i32* %child2.ptr, align 4
  br label %sort_sift_header

sort_after_sift:
  %end.for.dec = phi i64 [ %end.carry, %sort_sift_header ], [ %end.carry, %sort_child_chosen ]
  %end.dec = add i64 %end.for.dec, -1
  br label %sort_loop_header

ret:
  ret void
}