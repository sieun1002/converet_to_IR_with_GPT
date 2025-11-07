; ModuleID = 'heap_sort'
target triple = "x86_64-pc-linux-gnu"

define void @heap_sort(i32* %arr, i64 %n) {
loc_1189:
  %arr.addr = alloca i32*, align 8
  %n.addr = alloca i64, align 8
  %var50 = alloca i64, align 8
  %var48 = alloca i64, align 8
  %var18 = alloca i64, align 8
  %var10 = alloca i64, align 8
  %var8 = alloca i64, align 8
  %var54 = alloca i32, align 4
  %var40 = alloca i64, align 8
  %var5C = alloca i32, align 4
  %var38 = alloca i64, align 8
  %var30 = alloca i64, align 8
  %var28 = alloca i64, align 8
  %var20 = alloca i64, align 8
  %var58 = alloca i32, align 4
  store i32* %arr, i32** %arr.addr, align 8
  store i64 %n, i64* %n.addr, align 8
  %n1 = load i64, i64* %n.addr, align 8
  %cmp_start = icmp ule i64 %n1, 1
  br i1 %cmp_start, label %loc_1448, label %loc_11A4

loc_11A4:
  %n2 = load i64, i64* %n.addr, align 8
  %half = lshr i64 %n2, 1
  store i64 %half, i64* %var50, align 8
  br label %loc_12C4

loc_11B4:
  %v50 = load i64, i64* %var50, align 8
  store i64 %v50, i64* %var48, align 8
  br label %loc_11BC

loc_11BC:
  %v48_1 = load i64, i64* %var48, align 8
  %add1 = add i64 %v48_1, %v48_1
  %add2 = add i64 %add1, 1
  store i64 %add2, i64* %var18, align 8
  %left1 = load i64, i64* %var18, align 8
  %n3 = load i64, i64* %n.addr, align 8
  %cmp_left_n = icmp uge i64 %left1, %n3
  br i1 %cmp_left_n, label %loc_12C0, label %loc_11D9

loc_11D9:
  %left2 = load i64, i64* %var18, align 8
  %right1 = add i64 %left2, 1
  store i64 %right1, i64* %var10, align 8
  %right2 = load i64, i64* %var10, align 8
  %n4 = load i64, i64* %n.addr, align 8
  %cmp_right_n = icmp uge i64 %right2, %n4
  br i1 %cmp_right_n, label %loc_1223, label %loc_11EF

loc_11EF:
  %arr_ld1 = load i32*, i32** %arr.addr, align 8
  %ridx = load i64, i64* %var10, align 8
  %rptr = getelementptr inbounds i32, i32* %arr_ld1, i64 %ridx
  %val_right = load i32, i32* %rptr, align 4
  %lidx = load i64, i64* %var18, align 8
  %lptr = getelementptr inbounds i32, i32* %arr_ld1, i64 %lidx
  %val_left = load i32, i32* %lptr, align 4
  %cmp_r_le_l = icmp sle i32 %val_right, %val_left
  br i1 %cmp_r_le_l, label %loc_1223, label %loc_121D

loc_121D:
  %right_idx_for_phi = load i64, i64* %var10, align 8
  br label %loc_1227

loc_1223:
  %left_idx_for_phi = load i64, i64* %var18, align 8
  br label %loc_1227

loc_1227:
  %chosen_child = phi i64 [ %right_idx_for_phi, %loc_121D ], [ %left_idx_for_phi, %loc_1223 ]
  store i64 %chosen_child, i64* %var8, align 8
  %arr_ld2 = load i32*, i32** %arr.addr, align 8
  %iidx = load i64, i64* %var48, align 8
  %iptr = getelementptr inbounds i32, i32* %arr_ld2, i64 %iidx
  %ival = load i32, i32* %iptr, align 4
  %jidx = load i64, i64* %var8, align 8
  %jptr = getelementptr inbounds i32, i32* %arr_ld2, i64 %jidx
  %jval = load i32, i32* %jptr, align 4
  %cmp_i_ge_j = icmp sge i32 %ival, %jval
  br i1 %cmp_i_ge_j, label %loc_12C3, label %loc_1259

loc_1259:
  %arr_ld3 = load i32*, i32** %arr.addr, align 8
  %iidx2 = load i64, i64* %var48, align 8
  %iptr2 = getelementptr inbounds i32, i32* %arr_ld3, i64 %iidx2
  %ival2 = load i32, i32* %iptr2, align 4
  store i32 %ival2, i32* %var54, align 4
  %jidx2 = load i64, i64* %var8, align 8
  %jptr2 = getelementptr inbounds i32, i32* %arr_ld3, i64 %jidx2
  %jval2 = load i32, i32* %jptr2, align 4
  store i32 %jval2, i32* %iptr2, align 4
  %tmp_store = load i32, i32* %var54, align 4
  store i32 %tmp_store, i32* %jptr2, align 4
  store i64 %jidx2, i64* %var48, align 8
  br label %loc_11BC

loc_12C0:
  br label %loc_12C4

loc_12C3:
  br label %loc_12C4

loc_12C4:
  %old_v50 = load i64, i64* %var50, align 8
  %dec_v50 = add i64 %old_v50, -1
  store i64 %dec_v50, i64* %var50, align 8
  %test_old_nonzero = icmp ne i64 %old_v50, 0
  br i1 %test_old_nonzero, label %loc_11B4, label %loc_12D9

loc_12D9:
  %n5 = load i64, i64* %n.addr, align 8
  %end_init = add i64 %n5, -1
  store i64 %end_init, i64* %var40, align 8
  br label %loc_143B

loc_12EA:
  %arr_ld4 = load i32*, i32** %arr.addr, align 8
  %root_val = load i32, i32* %arr_ld4, align 4
  store i32 %root_val, i32* %var5C, align 4
  %end_idx1 = load i64, i64* %var40, align 8
  %end_ptr1 = getelementptr inbounds i32, i32* %arr_ld4, i64 %end_idx1
  %end_val1 = load i32, i32* %end_ptr1, align 4
  store i32 %end_val1, i32* %arr_ld4, align 4
  %root_saved = load i32, i32* %var5C, align 4
  store i32 %root_saved, i32* %end_ptr1, align 4
  store i64 0, i64* %var38, align 8
  br label %loc_132E

loc_132E:
  %iidx3 = load i64, i64* %var38, align 8
  %twice_i = add i64 %iidx3, %iidx3
  %left_i = add i64 %twice_i, 1
  store i64 %left_i, i64* %var30, align 8
  %left_i_ld = load i64, i64* %var30, align 8
  %end_ld2 = load i64, i64* %var40, align 8
  %cmp_left_end = icmp uge i64 %left_i_ld, %end_ld2
  br i1 %cmp_left_end, label %loc_1432, label %loc_134B

loc_134B:
  %left_i_ld2 = load i64, i64* %var30, align 8
  %right_i2 = add i64 %left_i_ld2, 1
  store i64 %right_i2, i64* %var28, align 8
  %right_ld3 = load i64, i64* %var28, align 8
  %end_ld3 = load i64, i64* %var40, align 8
  %cmp_right_end = icmp uge i64 %right_ld3, %end_ld3
  br i1 %cmp_right_end, label %loc_1395, label %loc_1361

loc_1361:
  %arr_ld5 = load i32*, i32** %arr.addr, align 8
  %right_idx3 = load i64, i64* %var28, align 8
  %right_ptr3 = getelementptr inbounds i32, i32* %arr_ld5, i64 %right_idx3
  %right_val3 = load i32, i32* %right_ptr3, align 4
  %left_idx3 = load i64, i64* %var30, align 8
  %left_ptr3 = getelementptr inbounds i32, i32* %arr_ld5, i64 %left_idx3
  %left_val3 = load i32, i32* %left_ptr3, align 4
  %cmp_right_le_left = icmp sle i32 %right_val3, %left_val3
  br i1 %cmp_right_le_left, label %loc_1395, label %loc_138F

loc_138F:
  %right_idx_for_phi2 = load i64, i64* %var28, align 8
  br label %loc_1399

loc_1395:
  %left_idx_for_phi2 = load i64, i64* %var30, align 8
  br label %loc_1399

loc_1399:
  %chosen_child2 = phi i64 [ %left_idx_for_phi2, %loc_1395 ], [ %right_idx_for_phi2, %loc_138F ]
  store i64 %chosen_child2, i64* %var20, align 8
  %arr_ld6 = load i32*, i32** %arr.addr, align 8
  %iidx4 = load i64, i64* %var38, align 8
  %iptr4 = getelementptr inbounds i32, i32* %arr_ld6, i64 %iidx4
  %ival4 = load i32, i32* %iptr4, align 4
  %jidx4 = load i64, i64* %var20, align 8
  %jptr4 = getelementptr inbounds i32, i32* %arr_ld6, i64 %jidx4
  %jval4 = load i32, i32* %jptr4, align 4
  %cmp_i_ge_j2 = icmp sge i32 %ival4, %jval4
  br i1 %cmp_i_ge_j2, label %loc_1435, label %loc_13CB

loc_13CB:
  %arr_ld7 = load i32*, i32** %arr.addr, align 8
  %iidx5 = load i64, i64* %var38, align 8
  %iptr5 = getelementptr inbounds i32, i32* %arr_ld7, i64 %iidx5
  %ival5 = load i32, i32* %iptr5, align 4
  store i32 %ival5, i32* %var58, align 4
  %jidx5 = load i64, i64* %var20, align 8
  %jptr5 = getelementptr inbounds i32, i32* %arr_ld7, i64 %jidx5
  %jval5 = load i32, i32* %jptr5, align 4
  store i32 %jval5, i32* %iptr5, align 4
  %tmp_store2 = load i32, i32* %var58, align 4
  store i32 %tmp_store2, i32* %jptr5, align 4
  store i64 %jidx5, i64* %var38, align 8
  br label %loc_132E

loc_1432:
  br label %loc_1436

loc_1435:
  br label %loc_1436

loc_1436:
  %end_ld4 = load i64, i64* %var40, align 8
  %end_dec = add i64 %end_ld4, -1
  store i64 %end_dec, i64* %var40, align 8
  %cmp_end_nz = icmp ne i64 %end_dec, 0
  br i1 %cmp_end_nz, label %loc_12EA, label %loc_1449

loc_143B:
  %end_ld1 = load i64, i64* %var40, align 8
  %cmp_end_nz2 = icmp ne i64 %end_ld1, 0
  br i1 %cmp_end_nz2, label %loc_12EA, label %loc_1449

loc_1448:
  br label %loc_1449

loc_1449:
  ret void
}