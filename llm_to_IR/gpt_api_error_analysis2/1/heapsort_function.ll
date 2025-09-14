; ModuleID = 'heap_sort.ll'
target triple = "x86_64-pc-linux-gnu"

define void @heap_sort(i32* %arr, i64 %n) {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %ret, label %build_init

build_init:
  %half = lshr i64 %n, 1
  br label %build_loop_dec

build_loop_dec:
  %i_old = phi i64 [ %half, %build_init ], [ %i, %build_sift_done ]
  %i_old_nz = icmp ne i64 %i_old, 0
  br i1 %i_old_nz, label %build_iter, label %build_done

build_iter:
  %i = add i64 %i_old, -1
  br label %bs_head

bs_head:
  %cur = phi i64 [ %i, %build_iter ], [ %greater, %bs_swap ]
  %left_shl = shl i64 %cur, 1
  %left = add i64 %left_shl, 1
  %left_ge_n = icmp uge i64 %left, %n
  br i1 %left_ge_n, label %build_sift_done, label %bs_has_left

bs_has_left:
  %right = add i64 %left, 1
  %right_lt_n = icmp ult i64 %right, %n
  br i1 %right_lt_n, label %bs_cmp_lr, label %bs_have_greater

bs_cmp_lr:
  %lptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %lval = load i32, i32* %lptr, align 4
  %rptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %rval = load i32, i32* %rptr, align 4
  %r_gt_l = icmp sgt i32 %rval, %lval
  %greater_from_cmp = select i1 %r_gt_l, i64 %right, i64 %left
  br label %bs_have_greater

bs_have_greater:
  %greater = phi i64 [ %left, %bs_has_left ], [ %greater_from_cmp, %bs_cmp_lr ]
  %cur_ptr = getelementptr inbounds i32, i32* %arr, i64 %cur
  %cur_val = load i32, i32* %cur_ptr, align 4
  %g_ptr = getelementptr inbounds i32, i32* %arr, i64 %greater
  %g_val = load i32, i32* %g_ptr, align 4
  %cur_ge_g = icmp sge i32 %cur_val, %g_val
  br i1 %cur_ge_g, label %build_sift_done, label %bs_swap

bs_swap:
  store i32 %g_val, i32* %cur_ptr, align 4
  store i32 %cur_val, i32* %g_ptr, align 4
  br label %bs_head

build_sift_done:
  br label %build_loop_dec

build_done:
  %m_init = add i64 %n, -1
  br label %outer_cond

outer_cond:
  %m = phi i64 [ %m_init, %build_done ], [ %m_dec, %after_inner ]
  %m_nz = icmp ne i64 %m, 0
  br i1 %m_nz, label %outer_iter, label %ret

outer_iter:
  %root_ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %root_val = load i32, i32* %root_ptr, align 4
  %m_ptr = getelementptr inbounds i32, i32* %arr, i64 %m
  %m_val = load i32, i32* %m_ptr, align 4
  store i32 %m_val, i32* %root_ptr, align 4
  store i32 %root_val, i32* %m_ptr, align 4
  br label %inner_head

inner_head:
  %cur2 = phi i64 [ 0, %outer_iter ], [ %greater2, %inner_swap ]
  %left2_shl = shl i64 %cur2, 1
  %left2 = add i64 %left2_shl, 1
  %left2_ge_m = icmp uge i64 %left2, %m
  br i1 %left2_ge_m, label %after_inner, label %ih_has_left

ih_has_left:
  %right2 = add i64 %left2, 1
  %right2_lt_m = icmp ult i64 %right2, %m
  br i1 %right2_lt_m, label %ih_cmp_lr, label %ih_have_greater

ih_cmp_lr:
  %l2_ptr = getelementptr inbounds i32, i32* %arr, i64 %left2
  %l2_val = load i32, i32* %l2_ptr, align 4
  %r2_ptr = getelementptr inbounds i32, i32* %arr, i64 %right2
  %r2_val = load i32, i32* %r2_ptr, align 4
  %r2_gt_l2 = icmp sgt i32 %r2_val, %l2_val
  %greater2_from_cmp = select i1 %r2_gt_l2, i64 %right2, i64 %left2
  br label %ih_have_greater

ih_have_greater:
  %greater2 = phi i64 [ %left2, %ih_has_left ], [ %greater2_from_cmp, %ih_cmp_lr ]
  %cur2_ptr = getelementptr inbounds i32, i32* %arr, i64 %cur2
  %cur2_val = load i32, i32* %cur2_ptr, align 4
  %g2_ptr = getelementptr inbounds i32, i32* %arr, i64 %greater2
  %g2_val = load i32, i32* %g2_ptr, align 4
  %cur2_ge_g2 = icmp sge i32 %cur2_val, %g2_val
  br i1 %cur2_ge_g2, label %after_inner, label %inner_swap

inner_swap:
  store i32 %g2_val, i32* %cur2_ptr, align 4
  store i32 %cur2_val, i32* %g2_ptr, align 4
  br label %inner_head

after_inner:
  %m_dec = add i64 %m, -1
  br label %outer_cond

ret:
  ret void
}