; ModuleID = 'heap_sort'
target triple = "x86_64-pc-linux-gnu"

define void @heap_sort(i32* %arg_arr, i64 %arg_n) {
entry_1189:
  %arr.addr = alloca i32*, align 8
  %n.addr = alloca i64, align 8
  %var_50 = alloca i64, align 8
  %var_48 = alloca i64, align 8
  %var_18 = alloca i64, align 8
  %var_10 = alloca i64, align 8
  %var_8 = alloca i64, align 8
  %tmp_var_54 = alloca i32, align 4
  %var_40 = alloca i64, align 8
  %tmp_var_5C = alloca i32, align 4
  %var_38 = alloca i64, align 8
  %var_30 = alloca i64, align 8
  %var_28 = alloca i64, align 8
  %var_20 = alloca i64, align 8
  %tmp_var_58 = alloca i32, align 4
  store i32* %arg_arr, i32** %arr.addr, align 8
  store i64 %arg_n, i64* %n.addr, align 8
  %n0 = load i64, i64* %n.addr, align 8
  %cmp_n_le1 = icmp ule i64 %n0, 1
  br i1 %cmp_n_le1, label %loc_1448, label %block_11a4

block_11a4:
  %n1 = load i64, i64* %n.addr, align 8
  %shr = lshr i64 %n1, 1
  store i64 %shr, i64* %var_50, align 8
  br label %loc_12C4

loc_11B4:
  %v50_0 = load i64, i64* %var_50, align 8
  store i64 %v50_0, i64* %var_48, align 8
  br label %loc_11BC

loc_11BC:
  %v48_0 = load i64, i64* %var_48, align 8
  %mul2 = shl i64 %v48_0, 1
  %add1 = add i64 %mul2, 1
  store i64 %add1, i64* %var_18, align 8
  %v18_0 = load i64, i64* %var_18, align 8
  %n2 = load i64, i64* %n.addr, align 8
  %cmp_v18_ge_n = icmp uge i64 %v18_0, %n2
  br i1 %cmp_v18_ge_n, label %loc_12C0, label %block_11d9

block_11d9:
  %v18_1 = load i64, i64* %var_18, align 8
  %add1_v18 = add i64 %v18_1, 1
  store i64 %add1_v18, i64* %var_10, align 8
  %v10_0 = load i64, i64* %var_10, align 8
  %n3 = load i64, i64* %n.addr, align 8
  %cmp_v10_ge_n = icmp uge i64 %v10_0, %n3
  br i1 %cmp_v10_ge_n, label %loc_1223, label %block_11ef

block_11ef:
  %arr0 = load i32*, i32** %arr.addr, align 8
  %idx_v10 = load i64, i64* %var_10, align 8
  %ptr_v10 = getelementptr inbounds i32, i32* %arr0, i64 %idx_v10
  %val_v10 = load i32, i32* %ptr_v10, align 4
  %idx_v18 = load i64, i64* %var_18, align 8
  %ptr_v18 = getelementptr inbounds i32, i32* %arr0, i64 %idx_v18
  %val_v18 = load i32, i32* %ptr_v18, align 4
  %cmp_v10_le_v18 = icmp sle i32 %val_v10, %val_v18
  br i1 %cmp_v10_le_v18, label %loc_1223, label %bb_1221

bb_1221:
  %sel_v10 = load i64, i64* %var_10, align 8
  br label %loc_1227

loc_1223:
  %sel_v18 = load i64, i64* %var_18, align 8
  br label %loc_1227

loc_1227:
  %rax_sel = phi i64 [ %sel_v10, %bb_1221 ], [ %sel_v18, %loc_1223 ]
  store i64 %rax_sel, i64* %var_8, align 8
  %arr1 = load i32*, i32** %arr.addr, align 8
  %idx_v48 = load i64, i64* %var_48, align 8
  %ptr_v48 = getelementptr inbounds i32, i32* %arr1, i64 %idx_v48
  %val_v48 = load i32, i32* %ptr_v48, align 4
  %idx_v8 = load i64, i64* %var_8, align 8
  %ptr_v8 = getelementptr inbounds i32, i32* %arr1, i64 %idx_v8
  %val_v8 = load i32, i32* %ptr_v8, align 4
  %cmp_v48_ge_v8 = icmp sge i32 %val_v48, %val_v8
  br i1 %cmp_v48_ge_v8, label %loc_12C3, label %block_1259

block_1259:
  %arr2 = load i32*, i32** %arr.addr, align 8
  %i_v48 = load i64, i64* %var_48, align 8
  %p_v48 = getelementptr inbounds i32, i32* %arr2, i64 %i_v48
  %val48_2 = load i32, i32* %p_v48, align 4
  store i32 %val48_2, i32* %tmp_var_54, align 4
  %i_v8_2 = load i64, i64* %var_8, align 8
  %p_v8_2 = getelementptr inbounds i32, i32* %arr2, i64 %i_v8_2
  %val_v8_2 = load i32, i32* %p_v8_2, align 4
  store i32 %val_v8_2, i32* %p_v48, align 4
  %tmp54 = load i32, i32* %tmp_var_54, align 4
  store i32 %tmp54, i32* %p_v8_2, align 4
  store i64 %i_v8_2, i64* %var_48, align 8
  br label %loc_11BC

loc_12C0:
  br label %loc_12C4

loc_12C3:
  br label %loc_12C4

loc_12C4:
  %v50_pre = load i64, i64* %var_50, align 8
  %v50_dec = add i64 %v50_pre, -1
  store i64 %v50_dec, i64* %var_50, align 8
  %test_nonzero = icmp ne i64 %v50_pre, 0
  br i1 %test_nonzero, label %loc_11B4, label %block_12d9

block_12d9:
  %n4 = load i64, i64* %n.addr, align 8
  %n_minus1 = add i64 %n4, -1
  store i64 %n_minus1, i64* %var_40, align 8
  br label %loc_143B

loc_12EA:
  %arr3 = load i32*, i32** %arr.addr, align 8
  %p0 = getelementptr inbounds i32, i32* %arr3, i64 0
  %val0 = load i32, i32* %p0, align 4
  store i32 %val0, i32* %tmp_var_5C, align 4
  %i_v40 = load i64, i64* %var_40, align 8
  %p_v40 = getelementptr inbounds i32, i32* %arr3, i64 %i_v40
  %val_v40 = load i32, i32* %p_v40, align 4
  store i32 %val_v40, i32* %p0, align 4
  %tmp5c = load i32, i32* %tmp_var_5C, align 4
  store i32 %tmp5c, i32* %p_v40, align 4
  store i64 0, i64* %var_38, align 8
  br label %loc_132E

loc_132E:
  %v38 = load i64, i64* %var_38, align 8
  %mul2_v38 = shl i64 %v38, 1
  %add1_v38 = add i64 %mul2_v38, 1
  store i64 %add1_v38, i64* %var_30, align 8
  %v30 = load i64, i64* %var_30, align 8
  %v40_0 = load i64, i64* %var_40, align 8
  %cmp_v30_ge_v40 = icmp uge i64 %v30, %v40_0
  br i1 %cmp_v30_ge_v40, label %loc_1432, label %block_134b

block_134b:
  %v30_1 = load i64, i64* %var_30, align 8
  %add1_v30 = add i64 %v30_1, 1
  store i64 %add1_v30, i64* %var_28, align 8
  %v28_0 = load i64, i64* %var_28, align 8
  %v40_1 = load i64, i64* %var_40, align 8
  %cmp_v28_ge_v40 = icmp uge i64 %v28_0, %v40_1
  br i1 %cmp_v28_ge_v40, label %loc_1395, label %block_1361

block_1361:
  %arr4 = load i32*, i32** %arr.addr, align 8
  %i_v28 = load i64, i64* %var_28, align 8
  %p_v28 = getelementptr inbounds i32, i32* %arr4, i64 %i_v28
  %val_v28 = load i32, i32* %p_v28, align 4
  %i_v30 = load i64, i64* %var_30, align 8
  %p_v30 = getelementptr inbounds i32, i32* %arr4, i64 %i_v30
  %val_v30 = load i32, i32* %p_v30, align 4
  %cmp_v28_le_v30 = icmp sle i32 %val_v28, %val_v30
  br i1 %cmp_v28_le_v30, label %loc_1395, label %bb_138f

bb_138f:
  %sel_v28 = load i64, i64* %var_28, align 8
  br label %loc_1399

loc_1395:
  %sel_v30 = load i64, i64* %var_30, align 8
  br label %loc_1399

loc_1399:
  %rax_sel2 = phi i64 [ %sel_v28, %bb_138f ], [ %sel_v30, %loc_1395 ]
  store i64 %rax_sel2, i64* %var_20, align 8
  %arr5 = load i32*, i32** %arr.addr, align 8
  %i_v38_2 = load i64, i64* %var_38, align 8
  %p_v38 = getelementptr inbounds i32, i32* %arr5, i64 %i_v38_2
  %val_v38 = load i32, i32* %p_v38, align 4
  %i_v20 = load i64, i64* %var_20, align 8
  %p_v20 = getelementptr inbounds i32, i32* %arr5, i64 %i_v20
  %val_v20 = load i32, i32* %p_v20, align 4
  %cmp_v38_ge_v20 = icmp sge i32 %val_v38, %val_v20
  br i1 %cmp_v38_ge_v20, label %loc_1435, label %block_13cb

block_13cb:
  %arr6 = load i32*, i32** %arr.addr, align 8
  %i_v38_3 = load i64, i64* %var_38, align 8
  %p_v38_2 = getelementptr inbounds i32, i32* %arr6, i64 %i_v38_3
  %val_v38_2 = load i32, i32* %p_v38_2, align 4
  store i32 %val_v38_2, i32* %tmp_var_58, align 4
  %i_v20_2 = load i64, i64* %var_20, align 8
  %p_v20_2 = getelementptr inbounds i32, i32* %arr6, i64 %i_v20_2
  %val_v20_2 = load i32, i32* %p_v20_2, align 4
  store i32 %val_v20_2, i32* %p_v38_2, align 4
  %tmp58 = load i32, i32* %tmp_var_58, align 4
  store i32 %tmp58, i32* %p_v20_2, align 4
  store i64 %i_v20_2, i64* %var_38, align 8
  br label %loc_132E

loc_1432:
  br label %loc_1436

loc_1435:
  br label %loc_1436

loc_1436:
  %v40_2 = load i64, i64* %var_40, align 8
  %v40_dec = add i64 %v40_2, -1
  store i64 %v40_dec, i64* %var_40, align 8
  br label %loc_143B

loc_143B:
  %v40_3 = load i64, i64* %var_40, align 8
  %cmp_v40_ne0 = icmp ne i64 %v40_3, 0
  br i1 %cmp_v40_ne0, label %loc_12EA, label %bb_1446

bb_1446:
  br label %loc_1449

loc_1448:
  br label %loc_1449

loc_1449:
  ret void
}