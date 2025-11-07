; ModuleID = 'quicksort'
target triple = "x86_64-pc-linux-gnu"

define void @quick_sort(i32* %arr, i64 %l, i64 %r) {
entry_1220:
  %cmp1220 = icmp sge i64 %l, %r
  br i1 %cmp1220, label %loc_1312, label %bb_1229

bb_1229:
  br label %loc_123A

loc_123A: ; 0x123A
  %r12_phi = phi i64 [ %l, %bb_1229 ], [ %r12_next_12B2, %loc_12B2 ]
  %r13_phi = phi i64 [ %r, %bb_1229 ], [ %r13_next_12B2, %loc_12B2 ]
  %tmp_sub = sub i64 %r13_phi, %r12_phi
  %tmp_shr = ashr i64 %tmp_sub, 1
  %mid = add i64 %tmp_shr, %r12_phi
  %mid_ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot_esi = load i32, i32* %mid_ptr, align 4
  %inext_init = add i64 %r12_phi, 1
  br label %loc_1260

loc_1260: ; 0x1260
  %i_phi = phi i64 [ %r12_phi, %loc_123A ], [ %i_inc_12DB, %loc_12DB ]
  %inext_phi = phi i64 [ %inext_init, %loc_123A ], [ %inext_inc_12DB, %loc_12DB ]
  %j_phi = phi i64 [ %r13_phi, %loc_123A ], [ %j_db, %loc_12DB ]
  %left_ptr = getelementptr inbounds i32, i32* %arr, i64 %i_phi
  %leftVal_r8d = load i32, i32* %left_ptr, align 4
  %rcx_ptr0 = getelementptr inbounds i32, i32* %arr, i64 %j_phi
  %rightVal0_edx = load i32, i32* %rcx_ptr0, align 4
  %cmp_126c = icmp slt i32 %leftVal_r8d, %pivot_esi
  br i1 %cmp_126c, label %loc_12DB, label %loc_1271

loc_1271: ; 0x1271
  %cmp_1271 = icmp sge i32 %pivot_esi, %rightVal0_edx
  br i1 %cmp_1271, label %loc_1291, label %bb_1275

bb_1275: ; 0x1275 (falls into 0x1280)
  %j1_1275 = add i64 %j_phi, -1
  %rcx1_1275 = getelementptr inbounds i32, i32* %arr, i64 %j1_1275
  %right1_1275 = load i32, i32* %rcx1_1275, align 4
  br label %loc_1280

loc_1280: ; 0x1280
  %j_loop = phi i64 [ %j1_1275, %bb_1275 ], [ %j_dec2, %loc_1280 ]
  %rcx_loop = phi i32* [ %rcx1_1275, %bb_1275 ], [ %rcx2, %loc_1280 ]
  %right_loop = phi i32 [ %right1_1275, %bb_1275 ], [ %right2, %loc_1280 ]
  %j_dec2 = add i64 %j_loop, -1
  %rcx2 = getelementptr inbounds i32, i32* %arr, i64 %j_dec2
  %right2 = load i32, i32* %rcx2, align 4
  %cmp_128d = icmp sgt i32 %right_loop, %pivot_esi
  br i1 %cmp_128d, label %loc_1280, label %loc_1291

loc_1291: ; 0x1291
  %j_at_1291 = phi i64 [ %j_phi, %loc_1271 ], [ %j_loop, %loc_1280 ]
  %rcx_at_1291 = phi i32* [ %rcx_ptr0, %loc_1271 ], [ %rcx_loop, %loc_1280 ]
  %right_at_1291 = phi i32 [ %rightVal0_edx, %loc_1271 ], [ %right_loop, %loc_1280 ]
  %cmp_1294 = icmp sle i64 %i_phi, %j_at_1291
  br i1 %cmp_1294, label %loc_12C0, label %loc_1299

loc_12C0: ; 0x12C0
  %j_decC = add i64 %j_at_1291, -1
  %iptr_store = getelementptr inbounds i32, i32* %arr, i64 %i_phi
  store i32 %right_at_1291, i32* %iptr_store, align 4
  store i32 %leftVal_r8d, i32* %rcx_at_1291, align 4
  %cmp_12ce = icmp sgt i64 %inext_phi, %j_decC
  br i1 %cmp_12ce, label %loc_1299, label %loc_12DB

loc_12DB: ; 0x12DB
  %i_db = phi i64 [ %i_phi, %loc_1260 ], [ %i_phi, %loc_12C0 ]
  %inext_db = phi i64 [ %inext_phi, %loc_1260 ], [ %inext_phi, %loc_12C0 ]
  %j_db = phi i64 [ %j_phi, %loc_1260 ], [ %j_decC, %loc_12C0 ]
  %inext_inc_12DB = add i64 %inext_db, 1
  %i_inc_12DB = add i64 %i_db, 1
  br label %loc_1260

loc_1299: ; 0x1299
  %j_for_1299 = phi i64 [ %j_at_1291, %loc_1291 ], [ %j_decC, %loc_12C0 ]
  %r14_for_1299 = phi i64 [ %i_phi, %loc_1291 ], [ %inext_phi, %loc_12C0 ]
  %left_size = sub i64 %j_for_1299, %r12_phi
  %right_size = sub i64 %r13_phi, %r14_for_1299
  %cmp_12a5 = icmp sge i64 %left_size, %right_size
  br i1 %cmp_12a5, label %loc_12E8, label %loc_12AA

loc_12AA: ; 0x12AA
  %cmp_12ad = icmp sgt i64 %j_for_1299, %r12_phi
  br i1 %cmp_12ad, label %loc_12F2, label %loc_12AF

loc_12F2: ; 0x12F2
  call void @quick_sort(i32* %arr, i64 %r12_phi, i64 %j_for_1299)
  br label %loc_12AF

loc_12AF: ; 0x12AF
  br label %loc_12B2

loc_12E8: ; 0x12E8
  %cmp_12eb = icmp slt i64 %r14_for_1299, %r13_phi
  br i1 %cmp_12eb, label %loc_1302, label %loc_12ED

loc_1302: ; 0x1302
  call void @quick_sort(i32* %arr, i64 %r14_for_1299, i64 %r13_phi)
  br label %loc_12ED

loc_12ED: ; 0x12ED
  br label %loc_12B2

loc_12B2: ; 0x12B2
  %r12_next_12B2 = phi i64 [ %r14_for_1299, %loc_12AF ], [ %r12_phi, %loc_12ED ]
  %r13_next_12B2 = phi i64 [ %r13_phi, %loc_12AF ], [ %j_for_1299, %loc_12ED ]
  %cmp_12b5 = icmp sgt i64 %r13_next_12B2, %r12_next_12B2
  br i1 %cmp_12b5, label %loc_123A, label %ret_12B7

ret_12B7: ; 0x12B7..0x12BF (epilogue)
  ret void

loc_1312: ; 0x1312
  ret void
}