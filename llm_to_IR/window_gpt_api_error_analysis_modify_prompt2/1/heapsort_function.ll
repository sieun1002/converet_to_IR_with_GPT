target triple = "x86_64-pc-windows-msvc"

define dso_local void @heap_sort(i32* %a, i64 %n) {
entry:
  %cmp_n_le_1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le_1, label %exit, label %build_init

build_init:
  %i.init = lshr i64 %n, 1
  br label %build_check

build_check:
  %i.cur = phi i64 [ %i.init, %build_init ], [ %i.dec, %build_after_sift ]
  %i.is.zero = icmp eq i64 %i.cur, 0
  br i1 %i.is.zero, label %after_build, label %build_prep

build_prep:
  %start = add i64 %i.cur, -1
  br label %sift1_loop_header

sift1_loop_header:
  %idx1 = phi i64 [ %start, %build_prep ], [ %child1, %sift1_continue ]
  %idx1.shl = shl i64 %idx1, 1
  %left1 = add i64 %idx1.shl, 1
  %left1.in = icmp ult i64 %left1, %n
  br i1 %left1.in, label %sift1_has_left, label %build_after_sift

sift1_has_left:
  %right1 = add i64 %left1, 1
  %right1.in = icmp ult i64 %right1, %n
  br i1 %right1.in, label %sift1_compare_children, label %sift1_child_is_left

sift1_compare_children:
  %ptr.right1 = getelementptr inbounds i32, i32* %a, i64 %right1
  %val.right1 = load i32, i32* %ptr.right1, align 4
  %ptr.left1 = getelementptr inbounds i32, i32* %a, i64 %left1
  %val.left1 = load i32, i32* %ptr.left1, align 4
  %right.gt.left1 = icmp sgt i32 %val.right1, %val.left1
  br i1 %right.gt.left1, label %sift1_child_right, label %sift1_child_is_left

sift1_child_right:
  br label %sift1_child_chosen

sift1_child_is_left:
  br label %sift1_child_chosen

sift1_child_chosen:
  %child1 = phi i64 [ %right1, %sift1_child_right ], [ %left1, %sift1_child_is_left ]
  %ptr.idx1 = getelementptr inbounds i32, i32* %a, i64 %idx1
  %val.idx1 = load i32, i32* %ptr.idx1, align 4
  %ptr.child1 = getelementptr inbounds i32, i32* %a, i64 %child1
  %val.child1 = load i32, i32* %ptr.child1, align 4
  %need.swap1 = icmp slt i32 %val.idx1, %val.child1
  br i1 %need.swap1, label %sift1_swap, label %build_after_sift

sift1_swap:
  store i32 %val.child1, i32* %ptr.idx1, align 4
  store i32 %val.idx1, i32* %ptr.child1, align 4
  br label %sift1_continue

sift1_continue:
  br label %sift1_loop_header

build_after_sift:
  %i.dec = add i64 %i.cur, -1
  br label %build_check

after_build:
  %k.init = add i64 %n, -1
  br label %extract_check

extract_check:
  %k.cur = phi i64 [ %k.init, %after_build ], [ %k.dec, %after_extract_inner ]
  %k.is.zero = icmp eq i64 %k.cur, 0
  br i1 %k.is.zero, label %exit, label %extract_swap

extract_swap:
  %ptr0 = getelementptr inbounds i32, i32* %a, i64 0
  %v0 = load i32, i32* %ptr0, align 4
  %ptrk = getelementptr inbounds i32, i32* %a, i64 %k.cur
  %vk = load i32, i32* %ptrk, align 4
  store i32 %vk, i32* %ptr0, align 4
  store i32 %v0, i32* %ptrk, align 4
  br label %sift2_loop_header

sift2_loop_header:
  %idx2 = phi i64 [ 0, %extract_swap ], [ %child2, %sift2_continue ]
  %idx2.shl = shl i64 %idx2, 1
  %left2 = add i64 %idx2.shl, 1
  %left2.in = icmp ult i64 %left2, %k.cur
  br i1 %left2.in, label %sift2_has_left, label %after_extract_inner

sift2_has_left:
  %right2 = add i64 %left2, 1
  %right2.in = icmp ult i64 %right2, %k.cur
  br i1 %right2.in, label %sift2_compare_children, label %sift2_child_is_left

sift2_compare_children:
  %ptr.right2 = getelementptr inbounds i32, i32* %a, i64 %right2
  %val.right2 = load i32, i32* %ptr.right2, align 4
  %ptr.left2 = getelementptr inbounds i32, i32* %a, i64 %left2
  %val.left2 = load i32, i32* %ptr.left2, align 4
  %right.gt.left2 = icmp sgt i32 %val.right2, %val.left2
  br i1 %right.gt.left2, label %sift2_child_right, label %sift2_child_is_left

sift2_child_right:
  br label %sift2_child_chosen

sift2_child_is_left:
  br label %sift2_child_chosen

sift2_child_chosen:
  %child2 = phi i64 [ %right2, %sift2_child_right ], [ %left2, %sift2_child_is_left ]
  %ptr.idx2 = getelementptr inbounds i32, i32* %a, i64 %idx2
  %val.idx2 = load i32, i32* %ptr.idx2, align 4
  %ptr.child2 = getelementptr inbounds i32, i32* %a, i64 %child2
  %val.child2 = load i32, i32* %ptr.child2, align 4
  %ge2 = icmp sge i32 %val.idx2, %val.child2
  br i1 %ge2, label %after_extract_inner, label %sift2_swap

sift2_swap:
  store i32 %val.child2, i32* %ptr.idx2, align 4
  store i32 %val.idx2, i32* %ptr.child2, align 4
  br label %sift2_continue

sift2_continue:
  br label %sift2_loop_header

after_extract_inner:
  %k.dec = add i64 %k.cur, -1
  br label %extract_check

exit:
  ret void
}