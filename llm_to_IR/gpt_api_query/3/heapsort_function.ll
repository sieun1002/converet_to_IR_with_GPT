; ModuleID = 'heap_sort.ll'
source_filename = "heap_sort"

define void @heap_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %build_init

build_init:
  %half = lshr i64 %n, 1
  %has_heap = icmp ne i64 %half, 0
  br i1 %has_heap, label %bh_header, label %bh_done

bh_header:
  %i = phi i64 [ %i.next, %bh_latch ], [ %i.init, %build_init ]
  %i.init = add i64 %half, -1
  br label %bh_body

bh_body:
  %j0 = %i
  br label %sift_loop

sift_loop:
  %j = phi i64 [ %j0, %bh_body ], [ %j.next, %sift_swap ]
  %left.mul = shl i64 %j, 1
  %left = add i64 %left.mul, 1
  %left.inrange = icmp ult i64 %left, %n
  br i1 %left.inrange, label %choose_child, label %after_sift

choose_child:
  %right = add i64 %left, 1
  %right.inrange = icmp ult i64 %right, %n
  br i1 %right.inrange, label %cmp_children, label %cmp_parent_from_left

cmp_children:
  %left.ptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %left.val = load i32, i32* %left.ptr, align 4
  %right.ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right.val = load i32, i32* %right.ptr, align 4
  %right_gt_left = icmp sgt i32 %right.val, %left.val
  br i1 %right_gt_left, label %cmp_parent_from_right, label %cmp_parent_from_left

cmp_parent_from_left:
  %idx_l = %left
  %idx_l.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx_l
  br label %cmp_parent

cmp_parent_from_right:
  %idx_r = %right
  %idx_r.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx_r
  br label %cmp_parent

cmp_parent:
  %idx = phi i64 [ %idx_l, %cmp_parent_from_left ], [ %idx_r, %cmp_parent_from_right ]
  %idx.ptr = phi i32* [ %idx_l.ptr, %cmp_parent_from_left ], [ %idx_r.ptr, %cmp_parent_from_right ]
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %j.val = load i32, i32* %j.ptr, align 4
  %idx.val = load i32, i32* %idx.ptr, align 4
  %parent_ge_child = icmp sge i32 %j.val, %idx.val
  br i1 %parent_ge_child, label %after_sift, label %sift_swap

sift_swap:
  store i32 %idx.val, i32* %j.ptr, align 4
  store i32 %j.val, i32* %idx.ptr, align 4
  %j.next = %idx
  br label %sift_loop

after_sift:
  br label %bh_latch

bh_latch:
  %is_zero = icmp eq i64 %i, 0
  %i.next = add i64 %i, -1
  br i1 %is_zero, label %bh_done, label %bh_header

bh_done:
  %k0 = add i64 %n, -1
  br label %sort_cond

sort_cond:
  %k = phi i64 [ %k0, %bh_done ], [ %k.next, %sort_latch ]
  %k_ne0 = icmp ne i64 %k, 0
  br i1 %k_ne0, label %extract, label %ret

extract:
  %root.ptr = %arr
  %root.val = load i32, i32* %root.ptr, align 4
  %k.ptr = getelementptr inbounds i32, i32* %arr, i64 %k
  %k.val = load i32, i32* %k.ptr, align 4
  store i32 %k.val, i32* %root.ptr, align 4
  store i32 %root.val, i32* %k.ptr, align 4
  %j0.sort = add i64 0, 0
  br label %sort_sift_loop

sort_sift_loop:
  %j.sort = phi i64 [ %j0.sort, %extract ], [ %j.next.sort, %sort_sift_swap ]
  %left.mul.sort = shl i64 %j.sort, 1
  %left.sort = add i64 %left.mul.sort, 1
  %left.inrange.sort = icmp ult i64 %left.sort, %k
  br i1 %left.inrange.sort, label %sort_choose_child, label %sort_after_sift

sort_choose_child:
  %right.sort = add i64 %left.sort, 1
  %right.inrange.sort = icmp ult i64 %right.sort, %k
  br i1 %right.inrange.sort, label %sort_cmp_children, label %sort_cmp_parent_from_left

sort_cmp_children:
  %left.ptr.sort = getelementptr inbounds i32, i32* %arr, i64 %left.sort
  %left.val.sort = load i32, i32* %left.ptr.sort, align 4
  %right.ptr.sort = getelementptr inbounds i32, i32* %arr, i64 %right.sort
  %right.val.sort = load i32, i32* %right.ptr.sort, align 4
  %right_gt_left.sort = icmp sgt i32 %right.val.sort, %left.val.sort
  br i1 %right_gt_left.sort, label %sort_cmp_parent_from_right, label %sort_cmp_parent_from_left

sort_cmp_parent_from_left:
  %idx_l.sort = %left.sort
  %idx_l.ptr.sort = getelementptr inbounds i32, i32* %arr, i64 %idx_l.sort
  br label %sort_cmp_parent

sort_cmp_parent_from_right:
  %idx_r.sort = %right.sort
  %idx_r.ptr.sort = getelementptr inbounds i32, i32* %arr, i64 %idx_r.sort
  br label %sort_cmp_parent

sort_cmp_parent:
  %idx.sort = phi i64 [ %idx_l.sort, %sort_cmp_parent_from_left ], [ %idx_r.sort, %sort_cmp_parent_from_right ]
  %idx.ptr.sort = phi i32* [ %idx_l.ptr.sort, %sort_cmp_parent_from_left ], [ %idx_r.ptr.sort, %sort_cmp_parent_from_right ]
  %j.ptr.sort = getelementptr inbounds i32, i32* %arr, i64 %j.sort
  %j.val.sort = load i32, i32* %j.ptr.sort, align 4
  %idx.val.sort = load i32, i32* %idx.ptr.sort, align 4
  %parent_ge_child.sort = icmp sge i32 %j.val.sort, %idx.val.sort
  br i1 %parent_ge_child.sort, label %sort_after_sift, label %sort_sift_swap

sort_sift_swap:
  store i32 %idx.val.sort, i32* %j.ptr.sort, align 4
  store i32 %j.val.sort, i32* %idx.ptr.sort, align 4
  %j.next.sort = %idx.sort
  br label %sort_sift_loop

sort_after_sift:
  br label %sort_latch

sort_latch:
  %k.next = add i64 %k, -1
  br label %sort_cond

ret:
  ret void
}