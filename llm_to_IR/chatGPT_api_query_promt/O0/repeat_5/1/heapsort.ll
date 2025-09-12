; ModuleID = 'heap_sort_module'
source_filename = "heap_sort"

define void @heap_sort(i32* %a, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %build_init

build_init:
  %half = lshr i64 %n, 1
  %half_is_zero = icmp eq i64 %half, 0
  br i1 %half_is_zero, label %after_build, label %build_outer

build_outer:
  %i0 = add i64 %half, -1
  br label %build_loop

build_loop:
  %outer_i = phi i64 [ %i0, %build_outer ], [ %outer_i_dec, %build_iter_end ]
  br label %sift_head

sift_head:
  %i_s = phi i64 [ %outer_i, %build_loop ], [ %m, %swap ]
  %outer_keep = phi i64 [ %outer_i, %build_loop ], [ %outer_keep, %swap ]
  %i_s_shl = shl i64 %i_s, 1
  %j = add i64 %i_s_shl, 1
  %j_ge_n = icmp uge i64 %j, %n
  br i1 %j_ge_n, label %j_break, label %choose_right

choose_right:
  %k = add i64 %j, 1
  %k_lt_n = icmp ult i64 %k, %n
  br i1 %k_lt_n, label %load_kj, label %m_is_j

load_kj:
  %ptr_k = getelementptr inbounds i32, i32* %a, i64 %k
  %val_k = load i32, i32* %ptr_k, align 4
  %ptr_j = getelementptr inbounds i32, i32* %a, i64 %j
  %val_j = load i32, i32* %ptr_j, align 4
  %k_gt_j = icmp sgt i32 %val_k, %val_j
  %m_sel = select i1 %k_gt_j, i64 %k, i64 %j
  br label %have_m

m_is_j:
  br label %have_m

have_m:
  %m = phi i64 [ %m_sel, %load_kj ], [ %j, %m_is_j ]
  %ptr_i_s = getelementptr inbounds i32, i32* %a, i64 %i_s
  %val_i_s = load i32, i32* %ptr_i_s, align 4
  %ptr_m = getelementptr inbounds i32, i32* %a, i64 %m
  %val_m = load i32, i32* %ptr_m, align 4
  %i_ge_m = icmp sge i32 %val_i_s, %val_m
  br i1 %i_ge_m, label %cmp_break, label %swap

swap:
  store i32 %val_m, i32* %ptr_i_s, align 4
  store i32 %val_i_s, i32* %ptr_m, align 4
  br label %sift_head

j_break:
  br label %build_iter_end

cmp_break:
  br label %build_iter_end

build_iter_end:
  %outer_i_end = phi i64 [ %outer_keep, %j_break ], [ %outer_keep, %cmp_break ]
  %outer_i_is_zero = icmp eq i64 %outer_i_end, 0
  %outer_i_dec = add i64 %outer_i_end, -1
  br i1 %outer_i_is_zero, label %after_build, label %build_loop

after_build:
  %end_init = add i64 %n, -1
  br label %sort_cond

sort_cond:
  %end = phi i64 [ %end_init, %after_build ], [ %end_dec, %after_sift ]
  %end_is_zero = icmp eq i64 %end, 0
  br i1 %end_is_zero, label %ret, label %extract

extract:
  %root_val = load i32, i32* %a, align 4
  %ptr_end = getelementptr inbounds i32, i32* %a, i64 %end
  %end_val = load i32, i32* %ptr_end, align 4
  store i32 %end_val, i32* %a, align 4
  store i32 %root_val, i32* %ptr_end, align 4
  br label %sift2_head

sift2_head:
  %i2 = phi i64 [ 0, %extract ], [ %m2, %swap2 ]
  %i2_shl = shl i64 %i2, 1
  %j2 = add i64 %i2_shl, 1
  %j2_ge_end = icmp uge i64 %j2, %end
  br i1 %j2_ge_end, label %after_sift, label %choose_right2

choose_right2:
  %k2 = add i64 %j2, 1
  %k2_lt_end = icmp ult i64 %k2, %end
  br i1 %k2_lt_end, label %load_kj2, label %m2_is_j

load_kj2:
  %ptr_k2 = getelementptr inbounds i32, i32* %a, i64 %k2
  %val_k2 = load i32, i32* %ptr_k2, align 4
  %ptr_j2 = getelementptr inbounds i32, i32* %a, i64 %j2
  %val_j2 = load i32, i32* %ptr_j2, align 4
  %k2_gt_j2 = icmp sgt i32 %val_k2, %val_j2
  %m2_sel = select i1 %k2_gt_j2, i64 %k2, i64 %j2
  br label %have_m2

m2_is_j:
  br label %have_m2

have_m2:
  %m2 = phi i64 [ %m2_sel, %load_kj2 ], [ %j2, %m2_is_j ]
  %ptr_i2 = getelementptr inbounds i32, i32* %a, i64 %i2
  %val_i2 = load i32, i32* %ptr_i2, align 4
  %ptr_m2 = getelementptr inbounds i32, i32* %a, i64 %m2
  %val_m2 = load i32, i32* %ptr_m2, align 4
  %i2_ge_m2 = icmp sge i32 %val_i2, %val_m2
  br i1 %i2_ge_m2, label %after_sift, label %swap2

swap2:
  store i32 %val_m2, i32* %ptr_i2, align 4
  store i32 %val_i2, i32* %ptr_m2, align 4
  br label %sift2_head

after_sift:
  %end_dec = add i64 %end, -1
  br label %sort_cond

ret:
  ret void
}