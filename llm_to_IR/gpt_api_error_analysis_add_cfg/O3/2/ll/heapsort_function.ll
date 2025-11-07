; ModuleID = 'heap_sort_module'
target triple = "x86_64-unknown-linux-gnu"

define void @heap_sort(i32* %arr, i64 %n) {
L1189:
  %arr.addr = alloca i32*, align 8
  %n.addr = alloca i64, align 8
  %var_50 = alloca i64, align 8
  %var_48 = alloca i64, align 8
  %var_18 = alloca i64, align 8
  %var_10 = alloca i64, align 8
  %var_8 = alloca i64, align 8
  %var_40 = alloca i64, align 8
  %var_38 = alloca i64, align 8
  %var_30 = alloca i64, align 8
  %var_28 = alloca i64, align 8
  %var_20 = alloca i64, align 8
  %var_54 = alloca i32, align 4
  %var_5C = alloca i32, align 4
  %var_58 = alloca i32, align 4
  store i32* %arr, i32** %arr.addr, align 8
  store i64 %n, i64* %n.addr, align 8
  %n0 = load i64, i64* %n.addr, align 8
  %cmp_n_le_1 = icmp ule i64 %n0, 1
  br i1 %cmp_n_le_1, label %L1448, label %L11A4

L11A4:
  %n1 = load i64, i64* %n.addr, align 8
  %shr = lshr i64 %n1, 1
  store i64 %shr, i64* %var_50, align 8
  br label %L12C4

L11B4:
  %v50_ld0 = load i64, i64* %var_50, align 8
  store i64 %v50_ld0, i64* %var_48, align 8
  br label %L11BC

L11BC:
  %v48_ld0 = load i64, i64* %var_48, align 8
  %mul2_0 = shl i64 %v48_ld0, 1
  %add1_0 = add i64 %mul2_0, 1
  store i64 %add1_0, i64* %var_18, align 8
  %v18_ld0 = load i64, i64* %var_18, align 8
  %n2 = load i64, i64* %n.addr, align 8
  %cmp_v18_uge_n = icmp uge i64 %v18_ld0, %n2
  br i1 %cmp_v18_uge_n, label %L12C0, label %L11D9

L12C0:
  br label %L12C4

L11D9:
  %v18_ld1 = load i64, i64* %var_18, align 8
  %add1_1 = add i64 %v18_ld1, 1
  store i64 %add1_1, i64* %var_10, align 8
  %v10_ld0 = load i64, i64* %var_10, align 8
  %n3 = load i64, i64* %n.addr, align 8
  %cmp_v10_uge_n = icmp uge i64 %v10_ld0, %n3
  br i1 %cmp_v10_uge_n, label %L1223, label %L11EF

L11EF:
  %idx_r = load i64, i64* %var_10, align 8
  %base0 = load i32*, i32** %arr.addr, align 8
  %gep_r = getelementptr inbounds i32, i32* %base0, i64 %idx_r
  %val_r = load i32, i32* %gep_r, align 4
  %idx_l = load i64, i64* %var_18, align 8
  %base1 = load i32*, i32** %arr.addr, align 8
  %gep_l = getelementptr inbounds i32, i32* %base1, i64 %idx_l
  %val_l = load i32, i32* %gep_l, align 4
  %cmp_r_le_l = icmp sle i32 %val_r, %val_l
  br i1 %cmp_r_le_l, label %L1223, label %L121D

L121D:
  %v10_ld1 = load i64, i64* %var_10, align 8
  br label %L1227

L1223:
  %v18_ld2 = load i64, i64* %var_18, align 8
  br label %L1227

L1227:
  %sel_child = phi i64 [ %v10_ld1, %L121D ], [ %v18_ld2, %L1223 ]
  store i64 %sel_child, i64* %var_8, align 8
  br label %L122B

L122B:
  %i_idx = load i64, i64* %var_48, align 8
  %base2 = load i32*, i32** %arr.addr, align 8
  %gep_i = getelementptr inbounds i32, i32* %base2, i64 %i_idx
  %val_i = load i32, i32* %gep_i, align 4
  %c_idx = load i64, i64* %var_8, align 8
  %base3 = load i32*, i32** %arr.addr, align 8
  %gep_c = getelementptr inbounds i32, i32* %base3, i64 %c_idx
  %val_c = load i32, i32* %gep_c, align 4
  %cmp_i_ge_c = icmp sge i32 %val_i, %val_c
  br i1 %cmp_i_ge_c, label %L12C3, label %L1259

L12C3:
  br label %L12C4

L1259:
  %i_idx2 = load i64, i64* %var_48, align 8
  %base4 = load i32*, i32** %arr.addr, align 8
  %gep_i2 = getelementptr inbounds i32, i32* %base4, i64 %i_idx2
  %val_i2 = load i32, i32* %gep_i2, align 4
  store i32 %val_i2, i32* %var_54, align 4
  %c_idx2 = load i64, i64* %var_8, align 8
  %base5 = load i32*, i32** %arr.addr, align 8
  %gep_c2 = getelementptr inbounds i32, i32* %base5, i64 %c_idx2
  %val_c2 = load i32, i32* %gep_c2, align 4
  %i_idx3 = load i64, i64* %var_48, align 8
  %base6 = load i32*, i32** %arr.addr, align 8
  %gep_i3 = getelementptr inbounds i32, i32* %base6, i64 %i_idx3
  store i32 %val_c2, i32* %gep_i3, align 4
  %c_idx3 = load i64, i64* %var_8, align 8
  %base7 = load i32*, i32** %arr.addr, align 8
  %gep_c3 = getelementptr inbounds i32, i32* %base7, i64 %c_idx3
  %tmp_i = load i32, i32* %var_54, align 4
  store i32 %tmp_i, i32* %gep_c3, align 4
  %c_as_new_i = load i64, i64* %var_8, align 8
  store i64 %c_as_new_i, i64* %var_48, align 8
  br label %L11BC

L12C4:
  %old_v50 = load i64, i64* %var_50, align 8
  %dec_v50 = add i64 %old_v50, -1
  store i64 %dec_v50, i64* %var_50, align 8
  %test_old_v50_nz = icmp ne i64 %old_v50, 0
  br i1 %test_old_v50_nz, label %L11B4, label %L12D9

L12D9:
  %n4 = load i64, i64* %n.addr, align 8
  %n_minus_1 = add i64 %n4, -1
  store i64 %n_minus_1, i64* %var_40, align 8
  br label %L143B

L12EA:
  %base8 = load i32*, i32** %arr.addr, align 8
  %root_ptr = getelementptr inbounds i32, i32* %base8, i64 0
  %root_val = load i32, i32* %root_ptr, align 4
  store i32 %root_val, i32* %var_5C, align 4
  %last_idx = load i64, i64* %var_40, align 8
  %base9 = load i32*, i32** %arr.addr, align 8
  %last_ptr = getelementptr inbounds i32, i32* %base9, i64 %last_idx
  %last_val = load i32, i32* %last_ptr, align 4
  %base10 = load i32*, i32** %arr.addr, align 8
  %root_ptr2 = getelementptr inbounds i32, i32* %base10, i64 0
  store i32 %last_val, i32* %root_ptr2, align 4
  %last_idx2 = load i64, i64* %var_40, align 8
  %base11 = load i32*, i32** %arr.addr, align 8
  %last_ptr2 = getelementptr inbounds i32, i32* %base11, i64 %last_idx2
  %saved_root = load i32, i32* %var_5C, align 4
  store i32 %saved_root, i32* %last_ptr2, align 4
  store i64 0, i64* %var_38, align 8
  br label %L132E

L132E:
  %g_idx = load i64, i64* %var_38, align 8
  %mul2_g = shl i64 %g_idx, 1
  %add1_g = add i64 %mul2_g, 1
  store i64 %add1_g, i64* %var_30, align 8
  %lc_idx = load i64, i64* %var_30, align 8
  %limit = load i64, i64* %var_40, align 8
  %cmp_lc_uge_lim = icmp uge i64 %lc_idx, %limit
  br i1 %cmp_lc_uge_lim, label %L1432, label %L134B

L1432:
  br label %L1436

L134B:
  %lc_idx2 = load i64, i64* %var_30, align 8
  %rc_idx = add i64 %lc_idx2, 1
  store i64 %rc_idx, i64* %var_28, align 8
  %rc_idx2 = load i64, i64* %var_28, align 8
  %limit2 = load i64, i64* %var_40, align 8
  %cmp_rc_uge_lim = icmp uge i64 %rc_idx2, %limit2
  br i1 %cmp_rc_uge_lim, label %L1395, label %L1361

L1361:
  %r_idx3 = load i64, i64* %var_28, align 8
  %base12 = load i32*, i32** %arr.addr, align 8
  %r_ptr = getelementptr inbounds i32, i32* %base12, i64 %r_idx3
  %r_val = load i32, i32* %r_ptr, align 4
  %l_idx3 = load i64, i64* %var_30, align 8
  %base13 = load i32*, i32** %arr.addr, align 8
  %l_ptr = getelementptr inbounds i32, i32* %base13, i64 %l_idx3
  %l_val = load i32, i32* %l_ptr, align 4
  %cmp_r_le_l_2 = icmp sle i32 %r_val, %l_val
  br i1 %cmp_r_le_l_2, label %L1395, label %L138F

L1395:
  %lc_idx3 = load i64, i64* %var_30, align 8
  br label %L1399

L138F:
  %rc_idx3 = load i64, i64* %var_28, align 8
  br label %L1399

L1399:
  %sel_child2 = phi i64 [ %lc_idx3, %L1395 ], [ %rc_idx3, %L138F ]
  store i64 %sel_child2, i64* %var_20, align 8
  br label %L139D

L139D:
  %g_idx2 = load i64, i64* %var_38, align 8
  %base14 = load i32*, i32** %arr.addr, align 8
  %g_ptr = getelementptr inbounds i32, i32* %base14, i64 %g_idx2
  %g_val = load i32, i32* %g_ptr, align 4
  %c_idx4 = load i64, i64* %var_20, align 8
  %base15 = load i32*, i32** %arr.addr, align 8
  %c_ptr4 = getelementptr inbounds i32, i32* %base15, i64 %c_idx4
  %c_val4 = load i32, i32* %c_ptr4, align 4
  %cmp_g_ge_c = icmp sge i32 %g_val, %c_val4
  br i1 %cmp_g_ge_c, label %L1435, label %L13CB

L1435:
  br label %L1436

L13CB:
  %g_idx3 = load i64, i64* %var_38, align 8
  %base16 = load i32*, i32** %arr.addr, align 8
  %g_ptr2 = getelementptr inbounds i32, i32* %base16, i64 %g_idx3
  %g_val2 = load i32, i32* %g_ptr2, align 4
  store i32 %g_val2, i32* %var_58, align 4
  %c_idx5 = load i64, i64* %var_20, align 8
  %base17 = load i32*, i32** %arr.addr, align 8
  %c_ptr5 = getelementptr inbounds i32, i32* %base17, i64 %c_idx5
  %c_val5 = load i32, i32* %c_ptr5, align 4
  %g_idx4 = load i64, i64* %var_38, align 8
  %base18 = load i32*, i32** %arr.addr, align 8
  %g_ptr3 = getelementptr inbounds i32, i32* %base18, i64 %g_idx4
  store i32 %c_val5, i32* %g_ptr3, align 4
  %c_idx6 = load i64, i64* %var_20, align 8
  %base19 = load i32*, i32** %arr.addr, align 8
  %c_ptr6 = getelementptr inbounds i32, i32* %base19, i64 %c_idx6
  %g_saved = load i32, i32* %var_58, align 4
  store i32 %g_saved, i32* %c_ptr6, align 4
  %new_g = load i64, i64* %var_20, align 8
  store i64 %new_g, i64* %var_38, align 8
  br label %L132E

L1436:
  %v40_ld = load i64, i64* %var_40, align 8
  %v40_dec = add i64 %v40_ld, -1
  store i64 %v40_dec, i64* %var_40, align 8
  br label %L143B

L143B:
  %v40_now = load i64, i64* %var_40, align 8
  %cmp_v40_nz = icmp ne i64 %v40_now, 0
  br i1 %cmp_v40_nz, label %L12EA, label %L1449

L1448:
  br label %L1449

L1449:
  ret void
}