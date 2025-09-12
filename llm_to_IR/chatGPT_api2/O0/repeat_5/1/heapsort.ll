; ModuleID = 'heap_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: heap_sort  ; Address: 0x1189
; Intent: In-place ascending heap sort of i32 array (confidence=0.98). Evidence: sift-down with 2*i+1 children; build-heap then extract-max to end.
; Preconditions: a points to at least n elements (i32). n is the element count (non-negative).
; Postconditions: a[0..n-1] sorted ascending (signed i32 compare).

define dso_local void @heap_sort(i32* %a, i64 %n) local_unnamed_addr {
entry:
  %n_le1 = icmp ule i64 %n, 1
  br i1 %n_le1, label %ret, label %build_pre

build_pre:
  %half = lshr i64 %n, 1
  %half_is_zero = icmp eq i64 %half, 0
  %j_init = add i64 %half, -1
  br i1 %half_is_zero, label %after_build, label %build_outer

build_outer:
  %j = phi i64 [ %j_init, %build_pre ], [ %j_dec, %build_outer_latch ]
  br label %sift_entry

sift_entry:
  %j_inner = phi i64 [ %j, %build_outer ], [ %k, %sift_swap ]
  %j2x = add i64 %j_inner, %j_inner
  %l = add i64 %j2x, 1
  %l_ge_n = icmp uge i64 %l, %n
  br i1 %l_ge_n, label %build_outer_latch, label %child_select

child_select:
  %r = add i64 %l, 1
  %r_in_n = icmp ult i64 %r, %n
  br i1 %r_in_n, label %have_right, label %no_right

have_right:
  %left_ptr = getelementptr inbounds i32, i32* %a, i64 %l
  %left_val = load i32, i32* %left_ptr, align 4
  %right_ptr = getelementptr inbounds i32, i32* %a, i64 %r
  %right_val = load i32, i32* %right_ptr, align 4
  %right_gt_left = icmp sgt i32 %right_val, %left_val
  %k_from_right = select i1 %right_gt_left, i64 %r, i64 %l
  br label %have_k_join

no_right:
  br label %have_k_join

have_k_join:
  %k = phi i64 [ %l, %no_right ], [ %k_from_right, %have_right ]
  %j_ptr = getelementptr inbounds i32, i32* %a, i64 %j_inner
  %j_val = load i32, i32* %j_ptr, align 4
  %k_ptr = getelementptr inbounds i32, i32* %a, i64 %k
  %k_val = load i32, i32* %k_ptr, align 4
  %j_ge_k = icmp sge i32 %j_val, %k_val
  br i1 %j_ge_k, label %build_outer_latch, label %sift_swap

sift_swap:
  store i32 %k_val, i32* %j_ptr, align 4
  store i32 %j_val, i32* %k_ptr, align 4
  br label %sift_entry

build_outer_latch:
  %is_zero = icmp eq i64 %j, 0
  %j_dec = add i64 %j, -1
  br i1 %is_zero, label %after_build, label %build_outer

after_build:
  %heap_end_init = add i64 %n, -1
  br label %sort_cond

sort_cond:
  %heap_end = phi i64 [ %heap_end_init, %after_build ], [ %heap_end_dec, %sort_latch ]
  %cond_nz = icmp ne i64 %heap_end, 0
  br i1 %cond_nz, label %extract, label %ret

extract:
  %a0ptr = getelementptr inbounds i32, i32* %a, i64 0
  %a0 = load i32, i32* %a0ptr, align 4
  %end_ptr = getelementptr inbounds i32, i32* %a, i64 %heap_end
  %end_val = load i32, i32* %end_ptr, align 4
  store i32 %end_val, i32* %a0ptr, align 4
  store i32 %a0, i32* %end_ptr, align 4
  br label %sift2_entry

sift2_entry:
  %j2 = phi i64 [ 0, %extract ], [ %k2, %sift2_swap ]
  %j2dbl = add i64 %j2, %j2
  %l2 = add i64 %j2dbl, 1
  %l2_ge_sz = icmp uge i64 %l2, %heap_end
  br i1 %l2_ge_sz, label %sort_latch, label %child2_select

child2_select:
  %r2 = add i64 %l2, 1
  %r2_in = icmp ult i64 %r2, %heap_end
  br i1 %r2_in, label %have_right2, label %no_right2

have_right2:
  %left2_ptr = getelementptr inbounds i32, i32* %a, i64 %l2
  %left2_val = load i32, i32* %left2_ptr, align 4
  %right2_ptr = getelementptr inbounds i32, i32* %a, i64 %r2
  %right2_val = load i32, i32* %right2_ptr, align 4
  %r2_gt_l2 = icmp sgt i32 %right2_val, %left2_val
  %k2_right = select i1 %r2_gt_l2, i64 %r2, i64 %l2
  br label %have_k2_join

no_right2:
  br label %have_k2_join

have_k2_join:
  %k2 = phi i64 [ %l2, %no_right2 ], [ %k2_right, %have_right2 ]
  %j2_ptr = getelementptr inbounds i32, i32* %a, i64 %j2
  %j2_val = load i32, i32* %j2_ptr, align 4
  %k2_ptr = getelementptr inbounds i32, i32* %a, i64 %k2
  %k2_val = load i32, i32* %k2_ptr, align 4
  %j2_ge_k2 = icmp sge i32 %j2_val, %k2_val
  br i1 %j2_ge_k2, label %sort_latch, label %sift2_swap

sift2_swap:
  store i32 %k2_val, i32* %j2_ptr, align 4
  store i32 %j2_val, i32* %k2_ptr, align 4
  br label %sift2_entry

sort_latch:
  %heap_end_dec = add i64 %heap_end, -1
  br label %sort_cond

ret:
  ret void
}