; ModuleID = 'heap_sort'
source_filename = "heap_sort.ll"

define void @heap_sort(i32* %arr, i64 %n) {
entry:
  %cmp = icmp ule i64 %n, 1
  br i1 %cmp, label %ret, label %build_init

build_init:
  %half = lshr i64 %n, 1
  br label %build_outer.loop

build_outer.loop:
  %i = phi i64 [ %half, %build_init ], [ %i_next, %after_inner_dec ]
  br label %sift1

sift1:
  %j = phi i64 [ %i, %build_outer.loop ], [ %child, %do_swap1 ]
  %twj = shl i64 %j, 1
  %left = add i64 %twj, 1
  %has_left = icmp ult i64 %left, %n
  br i1 %has_left, label %check_right1, label %after_inner

check_right1:
  %right = add i64 %left, 1
  %has_right = icmp ult i64 %right, %n
  br i1 %has_right, label %cmp_children1, label %pick_left1

cmp_children1:
  %left_ptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %left_val = load i32, i32* %left_ptr, align 4
  %right_ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right_val = load i32, i32* %right_ptr, align 4
  %right_gt_left = icmp sgt i32 %right_val, %left_val
  br i1 %right_gt_left, label %pick_right1, label %pick_left1

pick_right1:
  br label %picked1

pick_left1:
  br label %picked1

picked1:
  %child = phi i64 [ %right, %pick_right1 ], [ %left, %pick_left1 ]
  %j_ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %j_val = load i32, i32* %j_ptr, align 4
  %child_ptr = getelementptr inbounds i32, i32* %arr, i64 %child
  %child_val = load i32, i32* %child_ptr, align 4
  %need_swap = icmp slt i32 %j_val, %child_val
  br i1 %need_swap, label %do_swap1, label %after_inner

do_swap1:
  store i32 %child_val, i32* %j_ptr, align 4
  store i32 %j_val, i32* %child_ptr, align 4
  br label %sift1

after_inner:
  %is_i_zero = icmp eq i64 %i, 0
  br i1 %is_i_zero, label %after_build, label %after_inner_dec

after_inner_dec:
  %i_next = add i64 %i, -1
  br label %build_outer.loop

after_build:
  %last = add i64 %n, -1
  br label %sort_loop

sort_loop:
  %m = phi i64 [ %last, %after_build ], [ %m_next, %decrement_m ]
  %m_not_zero = icmp ne i64 %m, 0
  br i1 %m_not_zero, label %extract_max, label %ret

extract_max:
  %root_val = load i32, i32* %arr, align 4
  %m_ptr = getelementptr inbounds i32, i32* %arr, i64 %m
  %m_val = load i32, i32* %m_ptr, align 4
  store i32 %m_val, i32* %arr, align 4
  store i32 %root_val, i32* %m_ptr, align 4
  br label %sift2

sift2:
  %j2 = phi i64 [ 0, %extract_max ], [ %child2, %do_swap2 ]
  %twj2 = shl i64 %j2, 1
  %left2 = add i64 %twj2, 1
  %has_left2 = icmp ult i64 %left2, %m
  br i1 %has_left2, label %check_right2, label %after_inner2

check_right2:
  %right2 = add i64 %left2, 1
  %has_right2 = icmp ult i64 %right2, %m
  br i1 %has_right2, label %cmp_children2, label %pick_left2

cmp_children2:
  %left2_ptr = getelementptr inbounds i32, i32* %arr, i64 %left2
  %left2_val = load i32, i32* %left2_ptr, align 4
  %right2_ptr = getelementptr inbounds i32, i32* %arr, i64 %right2
  %right2_val = load i32, i32* %right2_ptr, align 4
  %right_gt_left2 = icmp sgt i32 %right2_val, %left2_val
  br i1 %right_gt_left2, label %pick_right2, label %pick_left2

pick_right2:
  br label %picked2

pick_left2:
  br label %picked2

picked2:
  %child2 = phi i64 [ %right2, %pick_right2 ], [ %left2, %pick_left2 ]
  %j2_ptr = getelementptr inbounds i32, i32* %arr, i64 %j2
  %j2_val = load i32, i32* %j2_ptr, align 4
  %child2_ptr = getelementptr inbounds i32, i32* %arr, i64 %child2
  %child2_val = load i32, i32* %child2_ptr, align 4
  %need_swap2 = icmp slt i32 %j2_val, %child2_val
  br i1 %need_swap2, label %do_swap2, label %after_inner2

do_swap2:
  store i32 %child2_val, i32* %j2_ptr, align 4
  store i32 %j2_val, i32* %child2_ptr, align 4
  br label %sift2

after_inner2:
  br label %decrement_m

decrement_m:
  %m_next = add i64 %m, -1
  br label %sort_loop

ret:
  ret void
}