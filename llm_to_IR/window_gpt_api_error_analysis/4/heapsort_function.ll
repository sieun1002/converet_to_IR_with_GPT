; ModuleID = 'heapsort'
target triple = "x86_64-pc-windows-msvc"

define void @heap_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %build_init

build_init:
  %half = lshr i64 %n, 1
  br label %build_loop

build_loop:
  %i = phi i64 [ %half, %build_init ], [ %i_dec, %after_sift ]
  %i_is_zero = icmp eq i64 %i, 0
  br i1 %i_is_zero, label %build_done, label %do_sift

do_sift:
  %j = add i64 %i, -1
  br label %sift_loop

sift_loop:
  %root = phi i64 [ %j, %do_sift ], [ %child, %swap_cont ]
  %root_shl = shl i64 %root, 1
  %left = add i64 %root_shl, 1
  %left_lt_n = icmp ult i64 %left, %n
  br i1 %left_lt_n, label %compute_child, label %after_sift

compute_child:
  %right = add i64 %left, 1
  %right_lt_n = icmp ult i64 %right, %n
  br i1 %right_lt_n, label %cmp_children, label %child_is_left

cmp_children:
  %left_ptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %left_val = load i32, i32* %left_ptr, align 4
  %right_ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right_val = load i32, i32* %right_ptr, align 4
  %right_gt_left = icmp sgt i32 %right_val, %left_val
  br i1 %right_gt_left, label %child_is_right, label %child_is_left

child_is_right:
  br label %have_child

child_is_left:
  br label %have_child

have_child:
  %child = phi i64 [ %right, %child_is_right ], [ %left, %child_is_left ]
  %root_ptr = getelementptr inbounds i32, i32* %arr, i64 %root
  %root_val = load i32, i32* %root_ptr, align 4
  %child_ptr = getelementptr inbounds i32, i32* %arr, i64 %child
  %child_val = load i32, i32* %child_ptr, align 4
  %root_lt_child = icmp slt i32 %root_val, %child_val
  br i1 %root_lt_child, label %do_swap, label %after_sift

do_swap:
  store i32 %child_val, i32* %root_ptr, align 4
  store i32 %root_val, i32* %child_ptr, align 4
  br label %swap_cont

swap_cont:
  br label %sift_loop

after_sift:
  %i_dec = add i64 %i, -1
  br label %build_loop

build_done:
  %end_init = add i64 %n, -1
  br label %sort_outer

sort_outer:
  %end = phi i64 [ %end_init, %build_done ], [ %end_dec, %sort_post_inner ]
  %end_zero = icmp eq i64 %end, 0
  br i1 %end_zero, label %ret, label %do_swap_root_end

do_swap_root_end:
  %p0 = getelementptr inbounds i32, i32* %arr, i64 0
  %v0 = load i32, i32* %p0, align 4
  %pend = getelementptr inbounds i32, i32* %arr, i64 %end
  %vend = load i32, i32* %pend, align 4
  store i32 %vend, i32* %p0, align 4
  store i32 %v0, i32* %pend, align 4
  br label %inner_loop

inner_loop:
  %root2 = phi i64 [ 0, %do_swap_root_end ], [ %child2, %inner_swap_cont ]
  %root2_shl = shl i64 %root2, 1
  %left2 = add i64 %root2_shl, 1
  %left2_lt_end = icmp ult i64 %left2, %end
  br i1 %left2_lt_end, label %compute_child2, label %sort_post_inner

compute_child2:
  %right2 = add i64 %left2, 1
  %right2_lt_end = icmp ult i64 %right2, %end
  br i1 %right2_lt_end, label %cmp_children2, label %child_is_left2

cmp_children2:
  %left2_ptr = getelementptr inbounds i32, i32* %arr, i64 %left2
  %left2_val = load i32, i32* %left2_ptr, align 4
  %right2_ptr = getelementptr inbounds i32, i32* %arr, i64 %right2
  %right2_val = load i32, i32* %right2_ptr, align 4
  %right2_gt_left2 = icmp sgt i32 %right2_val, %left2_val
  br i1 %right2_gt_left2, label %child_is_right2, label %child_is_left2

child_is_right2:
  br label %have_child2

child_is_left2:
  br label %have_child2

have_child2:
  %child2 = phi i64 [ %right2, %child_is_right2 ], [ %left2, %child_is_left2 ]
  %root2_ptr = getelementptr inbounds i32, i32* %arr, i64 %root2
  %root2_val = load i32, i32* %root2_ptr, align 4
  %child2_ptr = getelementptr inbounds i32, i32* %arr, i64 %child2
  %child2_val = load i32, i32* %child2_ptr, align 4
  %root2_lt_child2 = icmp slt i32 %root2_val, %child2_val
  br i1 %root2_lt_child2, label %inner_do_swap, label %sort_post_inner

inner_do_swap:
  store i32 %child2_val, i32* %root2_ptr, align 4
  store i32 %root2_val, i32* %child2_ptr, align 4
  br label %inner_swap_cont

inner_swap_cont:
  br label %inner_loop

sort_post_inner:
  %end_dec = add i64 %end, -1
  br label %sort_outer

ret:
  ret void
}