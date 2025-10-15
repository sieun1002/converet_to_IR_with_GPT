; ModuleID = 'sub_140001450'
target triple = "x86_64-pc-windows-msvc"

define void @sub_140001450(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %build_heap_entry

build_heap_entry:
  %i_init = lshr i64 %n, 1
  %i_init_is_zero = icmp eq i64 %i_init, 0
  br i1 %i_init_is_zero, label %heap_built, label %heap_outer

heap_outer:
  %i_phi = phi i64 [ %i_init, %build_heap_entry ], [ %i_next, %heap_outer_done ]
  %i_dec = add i64 %i_phi, -1
  br label %sift_loop

sift_loop:
  %j = phi i64 [ %i_dec, %heap_outer ], [ %j_next, %sift_swapped ]
  %j_shl1 = shl i64 %j, 1
  %l = add i64 %j_shl1, 1
  %l_inbound = icmp ult i64 %l, %n
  br i1 %l_inbound, label %maybe_right, label %heap_outer_done

maybe_right:
  %r = add i64 %l, 1
  %r_inbound = icmp ult i64 %r, %n
  %l_ptr = getelementptr inbounds i32, i32* %arr, i64 %l
  %l_val = load i32, i32* %l_ptr, align 4
  br i1 %r_inbound, label %load_r, label %choose_l

load_r:
  %r_ptr = getelementptr inbounds i32, i32* %arr, i64 %r
  %r_val = load i32, i32* %r_ptr, align 4
  %r_gt_l = icmp sgt i32 %r_val, %l_val
  br i1 %r_gt_l, label %choose_r, label %choose_l

choose_r:
  %m_r = phi i64 [ %r, %load_r ]
  br label %have_m

choose_l:
  %m_l = phi i64 [ %l, %maybe_right ], [ %l, %load_r ]
  br label %have_m

have_m:
  %m = phi i64 [ %m_r, %choose_r ], [ %m_l, %choose_l ]
  %j_ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %j_val = load i32, i32* %j_ptr, align 4
  %m_ptr = getelementptr inbounds i32, i32* %arr, i64 %m
  %m_val = load i32, i32* %m_ptr, align 4
  %j_lt_m = icmp slt i32 %j_val, %m_val
  br i1 %j_lt_m, label %sift_swapped, label %heap_outer_done

sift_swapped:
  store i32 %m_val, i32* %j_ptr, align 4
  store i32 %j_val, i32* %m_ptr, align 4
  %j_next = add i64 %m, 0
  br label %sift_loop

heap_outer_done:
  %i_dec_phi = phi i64 [ %i_dec, %sift_loop ], [ %i_dec, %have_m ]
  %i_next = add i64 %i_dec_phi, 0
  %i_nonzero = icmp ne i64 %i_next, 0
  br i1 %i_nonzero, label %heap_outer, label %heap_built

heap_built:
  %k_init = add i64 %n, -1
  %k_is_zero = icmp eq i64 %k_init, 0
  br i1 %k_is_zero, label %ret, label %extract_loop

extract_loop:
  %k = phi i64 [ %k_init, %heap_built ], [ %k_next, %after_sift2 ]
  %root_ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %root_val = load i32, i32* %root_ptr, align 4
  %k_ptr = getelementptr inbounds i32, i32* %arr, i64 %k
  %k_val = load i32, i32* %k_ptr, align 4
  store i32 %k_val, i32* %root_ptr, align 4
  store i32 %root_val, i32* %k_ptr, align 4
  br label %sift2_loop

sift2_loop:
  %j2 = phi i64 [ 0, %extract_loop ], [ %j2_next, %sift2_swapped ]
  %j2_shl1 = shl i64 %j2, 1
  %l2 = add i64 %j2_shl1, 1
  %l2_inbound = icmp ult i64 %l2, %k
  br i1 %l2_inbound, label %maybe_right2, label %after_sift2

maybe_right2:
  %r2 = add i64 %l2, 1
  %r2_inbound = icmp ult i64 %r2, %k
  %l2_ptr = getelementptr inbounds i32, i32* %arr, i64 %l2
  %l2_val = load i32, i32* %l2_ptr, align 4
  br i1 %r2_inbound, label %load_r2, label %choose_l2

load_r2:
  %r2_ptr = getelementptr inbounds i32, i32* %arr, i64 %r2
  %r2_val = load i32, i32* %r2_ptr, align 4
  %r2_gt_l2 = icmp sgt i32 %r2_val, %l2_val
  br i1 %r2_gt_l2, label %choose_r2, label %choose_l2

choose_r2:
  %m2_r = phi i64 [ %r2, %load_r2 ]
  br label %have_m2

choose_l2:
  %m2_l = phi i64 [ %l2, %maybe_right2 ], [ %l2, %load_r2 ]
  br label %have_m2

have_m2:
  %m2 = phi i64 [ %m2_r, %choose_r2 ], [ %m2_l, %choose_l2 ]
  %j2_ptr = getelementptr inbounds i32, i32* %arr, i64 %j2
  %j2_val = load i32, i32* %j2_ptr, align 4
  %m2_ptr = getelementptr inbounds i32, i32* %arr, i64 %m2
  %m2_val = load i32, i32* %m2_ptr, align 4
  %j2_lt_m2 = icmp slt i32 %j2_val, %m2_val
  br i1 %j2_lt_m2, label %sift2_swapped, label %after_sift2

sift2_swapped:
  store i32 %m2_val, i32* %j2_ptr, align 4
  store i32 %j2_val, i32* %m2_ptr, align 4
  %j2_next = add i64 %m2, 0
  br label %sift2_loop

after_sift2:
  %k_dec = add i64 %k, -1
  %k_next = add i64 %k_dec, 0
  %k_nonzero = icmp ne i64 %k_next, 0
  br i1 %k_nonzero, label %extract_loop, label %ret

ret:
  ret void
}