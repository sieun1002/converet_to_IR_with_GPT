; ModuleID = 'heap_sort_module'
target triple = "x86_64-pc-linux-gnu"

define void @heap_sort(i32* %arr, i64 %n) {
entry:
  %arr.addr = alloca i32*, align 8
  %n.addr = alloca i64, align 8
  %var_50 = alloca i64, align 8
  %var_48 = alloca i64, align 8
  %var_18 = alloca i64, align 8
  %var_10 = alloca i64, align 8
  %var_8 = alloca i64, align 8
  %var_54 = alloca i32, align 4
  %var_40 = alloca i64, align 8
  %var_5C = alloca i32, align 4
  %var_38 = alloca i64, align 8
  %var_30 = alloca i64, align 8
  %var_28 = alloca i64, align 8
  %var_20 = alloca i64, align 8
  %var_58 = alloca i32, align 4
  store i32* %arr, i32** %arr.addr, align 8
  store i64 %n, i64* %n.addr, align 8
  %n0 = load i64, i64* %n.addr, align 8
  %cmp_n_le1 = icmp ule i64 %n0, 1
  br i1 %cmp_n_le1, label %loc_1448, label %entry.cont

entry.cont:
  %n1 = load i64, i64* %n.addr, align 8
  %half = lshr i64 %n1, 1
  store i64 %half, i64* %var_50, align 8
  br label %loc_12C4

loc_11B4:                                            ; preds = %loc_12C4
  %v50_1 = load i64, i64* %var_50, align 8
  store i64 %v50_1, i64* %var_48, align 8
  br label %loc_11BC

loc_11BC:                                            ; preds = %loc_11B4, %bb_1227_swap
  %v48_1 = load i64, i64* %var_48, align 8
  %twice = add i64 %v48_1, %v48_1
  %plus1 = add i64 %twice, 1
  store i64 %plus1, i64* %var_18, align 8
  %v18_1 = load i64, i64* %var_18, align 8
  %n2 = load i64, i64* %n.addr, align 8
  %cmp_jnb_12C0 = icmp uge i64 %v18_1, %n2
  br i1 %cmp_jnb_12C0, label %loc_12C0, label %loc_11BC.cont1

loc_11BC.cont1:                                      ; preds = %loc_11BC
  %v18_2 = load i64, i64* %var_18, align 8
  %add1 = add i64 %v18_2, 1
  store i64 %add1, i64* %var_10, align 8
  %v10_1 = load i64, i64* %var_10, align 8
  %n3 = load i64, i64* %n.addr, align 8
  %cmp_jnb_1223 = icmp uge i64 %v10_1, %n3
  br i1 %cmp_jnb_1223, label %loc_1223, label %bb_11bc_compare_children

bb_11bc_compare_children:                            ; preds = %loc_11BC.cont1
  %arr0 = load i32*, i32** %arr.addr, align 8
  %v10_2 = load i64, i64* %var_10, align 8
  %ptr_v10 = getelementptr inbounds i32, i32* %arr0, i64 %v10_2
  %val_v10 = load i32, i32* %ptr_v10, align 4
  %arr1 = load i32*, i32** %arr.addr, align 8
  %v18_3 = load i64, i64* %var_18, align 8
  %ptr_v18 = getelementptr inbounds i32, i32* %arr1, i64 %v18_3
  %val_v18 = load i32, i32* %ptr_v18, align 4
  %cmp_jle_1223 = icmp sle i32 %val_v10, %val_v18
  br i1 %cmp_jle_1223, label %loc_1223, label %loc_1227

loc_1223:                                            ; preds = %bb_11bc_compare_children, %loc_11BC.cont1
  %v18_to_store = load i64, i64* %var_18, align 8
  br label %loc_1227

loc_1227:                                            ; preds = %bb_11bc_compare_children, %loc_1223
  %selected = phi i64 [ %v10_2, %bb_11bc_compare_children ], [ %v18_to_store, %loc_1223 ]
  store i64 %selected, i64* %var_8, align 8
  %v48_2 = load i64, i64* %var_48, align 8
  %arr2 = load i32*, i32** %arr.addr, align 8
  %ptr_v48 = getelementptr inbounds i32, i32* %arr2, i64 %v48_2
  %val_v48 = load i32, i32* %ptr_v48, align 4
  %v8_1 = load i64, i64* %var_8, align 8
  %arr3 = load i32*, i32** %arr.addr, align 8
  %ptr_v8 = getelementptr inbounds i32, i32* %arr3, i64 %v8_1
  %val_v8 = load i32, i32* %ptr_v8, align 4
  %cmp_jge_12C3 = icmp sge i32 %val_v48, %val_v8
  br i1 %cmp_jge_12C3, label %loc_12C3, label %bb_1227_swap

bb_1227_swap:                                        ; preds = %loc_1227
  store i32 %val_v48, i32* %var_54, align 4
  store i32 %val_v8, i32* %ptr_v48, align 4
  %saved54 = load i32, i32* %var_54, align 4
  store i32 %saved54, i32* %ptr_v8, align 4
  store i64 %v8_1, i64* %var_48, align 8
  br label %loc_11BC

loc_12C0:                                            ; preds = %loc_11BC
  br label %loc_12C4

loc_12C3:                                            ; preds = %loc_1227
  br label %loc_12C4

loc_12C4:                                            ; preds = %loc_12C3, %loc_12C0, %entry.cont
  %v50_old = load i64, i64* %var_50, align 8
  %v50_dec = add i64 %v50_old, -1
  store i64 %v50_dec, i64* %var_50, align 8
  %tst = icmp ne i64 %v50_old, 0
  br i1 %tst, label %loc_11B4, label %bb_12d9

bb_12d9:                                             ; preds = %loc_12C4
  %n4 = load i64, i64* %n.addr, align 8
  %n_minus1 = add i64 %n4, -1
  store i64 %n_minus1, i64* %var_40, align 8
  br label %loc_143B

loc_12EA:                                            ; preds = %loc_143B, %loc_1436
  %arr4 = load i32*, i32** %arr.addr, align 8
  %root_val = load i32, i32* %arr4, align 4
  store i32 %root_val, i32* %var_5C, align 4
  %v40_1 = load i64, i64* %var_40, align 8
  %arr5 = load i32*, i32** %arr.addr, align 8
  %ptr_v40 = getelementptr inbounds i32, i32* %arr5, i64 %v40_1
  %val_v40 = load i32, i32* %ptr_v40, align 4
  %arr6 = load i32*, i32** %arr.addr, align 8
  store i32 %val_v40, i32* %arr6, align 4
  %saved0 = load i32, i32* %var_5C, align 4
  store i32 %saved0, i32* %ptr_v40, align 4
  store i64 0, i64* %var_38, align 8
  br label %loc_132E

loc_132E:                                            ; preds = %bb_1399_swap, %loc_12EA
  %v38_1 = load i64, i64* %var_38, align 8
  %twice38 = add i64 %v38_1, %v38_1
  %plus1_38 = add i64 %twice38, 1
  store i64 %plus1_38, i64* %var_30, align 8
  %v30_1 = load i64, i64* %var_30, align 8
  %v40_2 = load i64, i64* %var_40, align 8
  %cmp_jnb_1432 = icmp uge i64 %v30_1, %v40_2
  br i1 %cmp_jnb_1432, label %loc_1432, label %bb_132e_child

bb_132e_child:                                       ; preds = %loc_132E
  %v30_2 = load i64, i64* %var_30, align 8
  %v28 = add i64 %v30_2, 1
  store i64 %v28, i64* %var_28, align 8
  %v28_1 = load i64, i64* %var_28, align 8
  %v40_3 = load i64, i64* %var_40, align 8
  %cmp_jnb_1395 = icmp uge i64 %v28_1, %v40_3
  br i1 %cmp_jnb_1395, label %loc_1395, label %bb_132e_compare_children2

bb_132e_compare_children2:                           ; preds = %bb_132e_child
  %arr7 = load i32*, i32** %arr.addr, align 8
  %ptr_v28 = getelementptr inbounds i32, i32* %arr7, i64 %v28_1
  %val_v28 = load i32, i32* %ptr_v28, align 4
  %arr8 = load i32*, i32** %arr.addr, align 8
  %v30_3 = load i64, i64* %var_30, align 8
  %ptr_v30 = getelementptr inbounds i32, i32* %arr8, i64 %v30_3
  %val_v30 = load i32, i32* %ptr_v30, align 4
  %cmp_jle_1395 = icmp sle i32 %val_v28, %val_v30
  br i1 %cmp_jle_1395, label %loc_1395, label %loc_1399

loc_1395:                                            ; preds = %bb_132e_compare_children2, %bb_132e_child
  %v30_4 = load i64, i64* %var_30, align 8
  br label %loc_1399

loc_1399:                                            ; preds = %bb_132e_compare_children2, %loc_1395
  %sel_child = phi i64 [ %v28_1, %bb_132e_compare_children2 ], [ %v30_4, %loc_1395 ]
  store i64 %sel_child, i64* %var_20, align 8
  %v38_2 = load i64, i64* %var_38, align 8
  %arr9 = load i32*, i32** %arr.addr, align 8
  %ptr_v38 = getelementptr inbounds i32, i32* %arr9, i64 %v38_2
  %val_v38 = load i32, i32* %ptr_v38, align 4
  %v20_1 = load i64, i64* %var_20, align 8
  %arr10 = load i32*, i32** %arr.addr, align 8
  %ptr_v20 = getelementptr inbounds i32, i32* %arr10, i64 %v20_1
  %val_v20 = load i32, i32* %ptr_v20, align 4
  %cmp_jge_1435 = icmp sge i32 %val_v38, %val_v20
  br i1 %cmp_jge_1435, label %loc_1435, label %bb_1399_swap

bb_1399_swap:                                        ; preds = %loc_1399
  store i32 %val_v38, i32* %var_58, align 4
  store i32 %val_v20, i32* %ptr_v38, align 4
  %saved58 = load i32, i32* %var_58, align 4
  store i32 %saved58, i32* %ptr_v20, align 4
  store i64 %v20_1, i64* %var_38, align 8
  br label %loc_132E

loc_1432:                                            ; preds = %loc_132E
  br label %loc_1436

loc_1435:                                            ; preds = %loc_1399
  br label %loc_1436

loc_1436:                                            ; preds = %loc_1432, %loc_1435
  %v40_4 = load i64, i64* %var_40, align 8
  %v40_dec = add i64 %v40_4, -1
  store i64 %v40_dec, i64* %var_40, align 8
  %v40_now = load i64, i64* %var_40, align 8
  %cmp_nz = icmp ne i64 %v40_now, 0
  br i1 %cmp_nz, label %loc_12EA, label %loc_1449

loc_143B:                                            ; preds = %bb_12d9
  %v40_init = load i64, i64* %var_40, align 8
  %cmp_nz2 = icmp ne i64 %v40_init, 0
  br i1 %cmp_nz2, label %loc_12EA, label %loc_1449

loc_1448:                                            ; preds = %entry
  br label %loc_1449

loc_1449:                                            ; preds = %loc_1436, %loc_143B, %loc_1448
  ret void
}