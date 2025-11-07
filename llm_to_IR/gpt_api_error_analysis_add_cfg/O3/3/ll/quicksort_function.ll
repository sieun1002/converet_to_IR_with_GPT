; ModuleID = 'quick_sort'
target triple = "x86_64-pc-linux-gnu"

define void @quick_sort(i32* %arr, i64 %l, i64 %r) {
entry_1220:
  %cmp_entry = icmp sge i64 %l, %r
  br i1 %cmp_entry, label %loc_1312, label %loc_123A

loc_123A:
  %L_123A = phi i64 [ %l, %entry_1220 ], [ %L_out, %loc_12B2 ]
  %R_123A = phi i64 [ %r, %entry_1220 ], [ %R_out, %loc_12B2 ]
  %diff = sub i64 %R_123A, %L_123A
  %half = ashr i64 %diff, 1
  %mid = add i64 %L_123A, %half
  %mid_ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %mid_ptr, align 4
  %iNext0 = add i64 %L_123A, 1
  br label %loc_1260

loc_1260:
  %L_cur = phi i64 [ %L_123A, %loc_123A ], [ %L_12DB, %loc_12DB ]
  %R_cur = phi i64 [ %R_123A, %loc_123A ], [ %R_12DB, %loc_12DB ]
  %i_cur = phi i64 [ %L_123A, %loc_123A ], [ %i_inc, %loc_12DB ]
  %iNext_cur = phi i64 [ %iNext0, %loc_123A ], [ %iNext_inc, %loc_12DB ]
  %j_cur = phi i64 [ %R_123A, %loc_123A ], [ %j_12DB, %loc_12DB ]
  %pivot_cur = phi i32 [ %pivot, %loc_123A ], [ %pivot_12DB, %loc_12DB ]
  %i_ptr = getelementptr inbounds i32, i32* %arr, i64 %i_cur
  %vi = load i32, i32* %i_ptr, align 4
  %j_ptr = getelementptr inbounds i32, i32* %arr, i64 %j_cur
  %vj = load i32, i32* %j_ptr, align 4
  %cmp_vi_pivot = icmp slt i32 %vi, %pivot_cur
  br i1 %cmp_vi_pivot, label %loc_12DB, label %loc_1260_cmp2

loc_1260_cmp2:
  %cmp_pivot_vj = icmp sge i32 %pivot_cur, %vj
  %j_ptr_minus1 = getelementptr inbounds i32, i32* %j_ptr, i64 -1
  %j_idx_minus1 = add i64 %j_cur, -1
  br i1 %cmp_pivot_vj, label %loc_1291, label %loc_1280

loc_1280:
  %L_1280 = phi i64 [ %L_cur, %loc_1260_cmp2 ], [ %L_1280, %loc_1280 ]
  %R_1280 = phi i64 [ %R_cur, %loc_1260_cmp2 ], [ %R_1280, %loc_1280 ]
  %i_1280 = phi i64 [ %i_cur, %loc_1260_cmp2 ], [ %i_1280, %loc_1280 ]
  %iNext_1280 = phi i64 [ %iNext_cur, %loc_1260_cmp2 ], [ %iNext_1280, %loc_1280 ]
  %pivot_1280 = phi i32 [ %pivot_cur, %loc_1260_cmp2 ], [ %pivot_1280, %loc_1280 ]
  %vi_1280 = phi i32 [ %vi, %loc_1260_cmp2 ], [ %vi_1280, %loc_1280 ]
  %jptr_1280 = phi i32* [ %j_ptr_minus1, %loc_1260_cmp2 ], [ %jptr_next, %loc_1280 ]
  %jidx_1280 = phi i64 [ %j_idx_minus1, %loc_1260_cmp2 ], [ %jidx_next, %loc_1280 ]
  %vj_iter = load i32, i32* %jptr_1280, align 4
  %jptr_next = getelementptr inbounds i32, i32* %jptr_1280, i64 -1
  %jidx_next = add i64 %jidx_1280, -1
  %cmp_iter = icmp sgt i32 %vj_iter, %pivot_1280
  br i1 %cmp_iter, label %loc_1280, label %loc_1291

loc_1291:
  %L_1291 = phi i64 [ %L_cur, %loc_1260_cmp2 ], [ %L_1280, %loc_1280 ]
  %R_1291 = phi i64 [ %R_cur, %loc_1260_cmp2 ], [ %R_1280, %loc_1280 ]
  %i_1291 = phi i64 [ %i_cur, %loc_1260_cmp2 ], [ %i_1280, %loc_1280 ]
  %iNext_1291 = phi i64 [ %iNext_cur, %loc_1260_cmp2 ], [ %iNext_1280, %loc_1280 ]
  %pivot_1291 = phi i32 [ %pivot_cur, %loc_1260_cmp2 ], [ %pivot_1280, %loc_1280 ]
  %j_1291 = phi i64 [ %j_cur, %loc_1260_cmp2 ], [ %jidx_1280, %loc_1280 ]
  %rcx_ptr_1291 = phi i32* [ %j_ptr, %loc_1260_cmp2 ], [ %jptr_1280, %loc_1280 ]
  %vj_1291 = phi i32 [ %vj, %loc_1260_cmp2 ], [ %vj_iter, %loc_1280 ]
  %vi_1291 = phi i32 [ %vi, %loc_1260_cmp2 ], [ %vi_1280, %loc_1280 ]
  %cmp_i_le_j = icmp sle i64 %i_1291, %j_1291
  br i1 %cmp_i_le_j, label %loc_12C0, label %loc_1299_from1291

loc_12C0:
  %j_dec = add i64 %j_1291, -1
  %i_ptr_c0 = getelementptr inbounds i32, i32* %arr, i64 %i_1291
  store i32 %vj_1291, i32* %i_ptr_c0, align 4
  store i32 %vi_1291, i32* %rcx_ptr_1291, align 4
  %cmp_r9_gt_jdec = icmp sgt i64 %iNext_1291, %j_dec
  br i1 %cmp_r9_gt_jdec, label %loc_1299_from12C0, label %loc_12DB

loc_12DB:
  %L_12DB = phi i64 [ %L_cur, %loc_1260 ], [ %L_1291, %loc_12C0 ]
  %R_12DB = phi i64 [ %R_cur, %loc_1260 ], [ %R_1291, %loc_12C0 ]
  %i_12DB = phi i64 [ %i_cur, %loc_1260 ], [ %i_1291, %loc_12C0 ]
  %iNext_12DB = phi i64 [ %iNext_cur, %loc_1260 ], [ %iNext_1291, %loc_12C0 ]
  %j_12DB = phi i64 [ %j_cur, %loc_1260 ], [ %j_dec, %loc_12C0 ]
  %pivot_12DB = phi i32 [ %pivot_cur, %loc_1260 ], [ %pivot_1291, %loc_12C0 ]
  %iNext_inc = add i64 %iNext_12DB, 1
  %i_inc = add i64 %i_12DB, 1
  br label %loc_1260

loc_1299_from1291:
  br label %loc_1299

loc_1299_from12C0:
  br label %loc_1299

loc_1299:
  %L_1299 = phi i64 [ %L_1291, %loc_1299_from1291 ], [ %L_1291, %loc_1299_from12C0 ]
  %R_1299 = phi i64 [ %R_1291, %loc_1299_from1291 ], [ %R_1291, %loc_1299_from12C0 ]
  %j_1299 = phi i64 [ %j_1291, %loc_1299_from1291 ], [ %j_dec, %loc_1299_from12C0 ]
  %r14_1299 = phi i64 [ %i_1291, %loc_1299_from1291 ], [ %iNext_1291, %loc_1299_from12C0 ]
  %left_size = sub i64 %j_1299, %L_1299
  %right_size = sub i64 %R_1299, %r14_1299
  %cmp_sizes = icmp sge i64 %left_size, %right_size
  br i1 %cmp_sizes, label %loc_12E8, label %bb_12AA

bb_12AA:
  %cmp_j_gt_L = icmp sgt i64 %j_1299, %L_1299
  br i1 %cmp_j_gt_L, label %loc_12F2, label %loc_12AF

loc_12AF:
  br label %loc_12B2

loc_12B2:
  %L_out = phi i64 [ %r14_1299, %loc_12AF ], [ %L_1299, %loc_12ED ]
  %R_out = phi i64 [ %R_1299, %loc_12AF ], [ %j_1299, %loc_12ED ]
  %cmp_R_gt_L = icmp sgt i64 %R_out, %L_out
  br i1 %cmp_R_gt_L, label %loc_123A, label %loc_1312

loc_12E8:
  %cmp_r14_lt_R = icmp slt i64 %r14_1299, %R_1299
  br i1 %cmp_r14_lt_R, label %loc_1302, label %loc_12ED

loc_12ED:
  br label %loc_12B2

loc_12F2:
  call void @quick_sort(i32* %arr, i64 %L_1299, i64 %j_1299)
  br label %loc_12AF

loc_1302:
  call void @quick_sort(i32* %arr, i64 %r14_1299, i64 %R_1299)
  br label %loc_12ED

loc_1312:
  ret void
}