; ModuleID = 'heap_sort_module'
target triple = "x86_64-pc-linux-gnu"

define void @heap_sort(i32* %arr, i64 %n) {
loc_1189:
  %var_68 = alloca i32*, align 8
  %var_70 = alloca i64, align 8
  %var_50 = alloca i64, align 8
  %var_48 = alloca i64, align 8
  %var_18 = alloca i64, align 8
  %var_10 = alloca i64, align 8
  %var_8 = alloca i64, align 8
  %var_54 = alloca i32, align 4
  %var_5C = alloca i32, align 4
  %var_40 = alloca i64, align 8
  %var_38 = alloca i64, align 8
  %var_30 = alloca i64, align 8
  %var_28 = alloca i64, align 8
  %var_20 = alloca i64, align 8
  %var_58 = alloca i32, align 4
  store i32* %arr, i32** %var_68, align 8
  store i64 %n, i64* %var_70, align 8
  %len0 = load i64, i64* %var_70, align 8
  %cmp_init = icmp ule i64 %len0, 1
  br i1 %cmp_init, label %loc_1448, label %loc_11A4

loc_11A4:
  %len1 = load i64, i64* %var_70, align 8
  %half = lshr i64 %len1, 1
  store i64 %half, i64* %var_50, align 8
  br label %loc_12C4

loc_11B4:
  %v50_0 = load i64, i64* %var_50, align 8
  store i64 %v50_0, i64* %var_48, align 8
  br label %loc_11BC

loc_11BC:
  %v48_0 = load i64, i64* %var_48, align 8
  %dbl48 = add i64 %v48_0, %v48_0
  %plus1_48 = add i64 %dbl48, 1
  store i64 %plus1_48, i64* %var_18, align 8
  %v18_0 = load i64, i64* %var_18, align 8
  %len2 = load i64, i64* %var_70, align 8
  %cmp_12C0 = icmp uge i64 %v18_0, %len2
  br i1 %cmp_12C0, label %loc_12C0, label %loc_11D9

loc_11D9:
  %v18_1 = load i64, i64* %var_18, align 8
  %v18p1 = add i64 %v18_1, 1
  store i64 %v18p1, i64* %var_10, align 8
  %v10_0 = load i64, i64* %var_10, align 8
  %len3 = load i64, i64* %var_70, align 8
  %cmp_1223 = icmp uge i64 %v10_0, %len3
  br i1 %cmp_1223, label %loc_1223, label %loc_11EF

loc_11EF:
  %arr_p1 = load i32*, i32** %var_68, align 8
  %idx10 = load i64, i64* %var_10, align 8
  %ptr10 = getelementptr inbounds i32, i32* %arr_p1, i64 %idx10
  %val10 = load i32, i32* %ptr10, align 4
  %arr_p2 = load i32*, i32** %var_68, align 8
  %idx18 = load i64, i64* %var_18, align 8
  %ptr18 = getelementptr inbounds i32, i32* %arr_p2, i64 %idx18
  %val18 = load i32, i32* %ptr18, align 4
  %cmp_1223_jle = icmp sle i32 %val10, %val18
  br i1 %cmp_1223_jle, label %loc_1223, label %loc_1227

loc_1223:
  %v18_forphi = load i64, i64* %var_18, align 8
  br label %loc_1227

loc_1227:
  %selected_child = phi i64 [ %idx10, %loc_11EF ], [ %v18_forphi, %loc_1223 ]
  store i64 %selected_child, i64* %var_8, align 8
  %arr_p3 = load i32*, i32** %var_68, align 8
  %idx48 = load i64, i64* %var_48, align 8
  %ptr48 = getelementptr inbounds i32, i32* %arr_p3, i64 %idx48
  %val48 = load i32, i32* %ptr48, align 4
  %arr_p4 = load i32*, i32** %var_68, align 8
  %idx8 = load i64, i64* %var_8, align 8
  %ptr8 = getelementptr inbounds i32, i32* %arr_p4, i64 %idx8
  %val8 = load i32, i32* %ptr8, align 4
  %cmp_12C3_jge = icmp sge i32 %val48, %val8
  br i1 %cmp_12C3_jge, label %loc_12C3, label %loc_1259

loc_1259:
  %arr_p5 = load i32*, i32** %var_68, align 8
  %idx48_2 = load i64, i64* %var_48, align 8
  %ptr48_2 = getelementptr inbounds i32, i32* %arr_p5, i64 %idx48_2
  %val48_2 = load i32, i32* %ptr48_2, align 4
  store i32 %val48_2, i32* %var_54, align 4
  %arr_p6 = load i32*, i32** %var_68, align 8
  %idx8_2 = load i64, i64* %var_8, align 8
  %ptr8_2 = getelementptr inbounds i32, i32* %arr_p6, i64 %idx8_2
  %val8_2 = load i32, i32* %ptr8_2, align 4
  store i32 %val8_2, i32* %ptr48_2, align 4
  %tmp54 = load i32, i32* %var_54, align 4
  store i32 %tmp54, i32* %ptr8_2, align 4
  %new48 = load i64, i64* %var_8, align 8
  store i64 %new48, i64* %var_48, align 8
  br label %loc_11BC

loc_12C0:
  br label %loc_12C4

loc_12C3:
  br label %loc_12C4

loc_12C4:
  %v50_1 = load i64, i64* %var_50, align 8
  %v50m1 = add i64 %v50_1, -1
  store i64 %v50m1, i64* %var_50, align 8
  %cond_v50 = icmp ne i64 %v50_1, 0
  br i1 %cond_v50, label %loc_11B4, label %loc_12D9

loc_12D9:
  %len4 = load i64, i64* %var_70, align 8
  %lenm1 = add i64 %len4, -1
  store i64 %lenm1, i64* %var_40, align 8
  br label %loc_143B

loc_12EA:
  %arr_root = load i32*, i32** %var_68, align 8
  %ptr0 = getelementptr inbounds i32, i32* %arr_root, i64 0
  %root = load i32, i32* %ptr0, align 4
  store i32 %root, i32* %var_5C, align 4
  %idx40_0 = load i64, i64* %var_40, align 8
  %arr_p7 = load i32*, i32** %var_68, align 8
  %ptr40 = getelementptr inbounds i32, i32* %arr_p7, i64 %idx40_0
  %val_last = load i32, i32* %ptr40, align 4
  %arr_p8 = load i32*, i32** %var_68, align 8
  %ptr0b = getelementptr inbounds i32, i32* %arr_p8, i64 0
  store i32 %val_last, i32* %ptr0b, align 4
  %root2 = load i32, i32* %var_5C, align 4
  store i32 %root2, i32* %ptr40, align 4
  store i64 0, i64* %var_38, align 8
  br label %loc_132E

loc_132E:
  %v38_0 = load i64, i64* %var_38, align 8
  %dbl38 = add i64 %v38_0, %v38_0
  %plus1_38 = add i64 %dbl38, 1
  store i64 %plus1_38, i64* %var_30, align 8
  %v30_0 = load i64, i64* %var_30, align 8
  %v40_0 = load i64, i64* %var_40, align 8
  %cmp_1432 = icmp uge i64 %v30_0, %v40_0
  br i1 %cmp_1432, label %loc_1432, label %loc_134B

loc_134B:
  %v30_1 = load i64, i64* %var_30, align 8
  %v28_0 = add i64 %v30_1, 1
  store i64 %v28_0, i64* %var_28, align 8
  %v28_chk = load i64, i64* %var_28, align 8
  %v40_1 = load i64, i64* %var_40, align 8
  %cmp_1395 = icmp uge i64 %v28_chk, %v40_1
  br i1 %cmp_1395, label %loc_1395, label %loc_1361

loc_1361:
  %arr_p9 = load i32*, i32** %var_68, align 8
  %idx28 = load i64, i64* %var_28, align 8
  %ptr28 = getelementptr inbounds i32, i32* %arr_p9, i64 %idx28
  %val28 = load i32, i32* %ptr28, align 4
  %arr_p10 = load i32*, i32** %var_68, align 8
  %idx30 = load i64, i64* %var_30, align 8
  %ptr30 = getelementptr inbounds i32, i32* %arr_p10, i64 %idx30
  %val30 = load i32, i32* %ptr30, align 4
  %cmp_1395_jle = icmp sle i32 %val28, %val30
  br i1 %cmp_1395_jle, label %loc_1395, label %loc_1399

loc_1395:
  %v30_forphi = load i64, i64* %var_30, align 8
  br label %loc_1399

loc_1399:
  %v28_forphi = phi i64 [ %idx28, %loc_1361 ], [ %v30_forphi, %loc_1395 ]
  store i64 %v28_forphi, i64* %var_20, align 8
  %arr_p11 = load i32*, i32** %var_68, align 8
  %idx38 = load i64, i64* %var_38, align 8
  %ptr38 = getelementptr inbounds i32, i32* %arr_p11, i64 %idx38
  %val38 = load i32, i32* %ptr38, align 4
  %arr_p12 = load i32*, i32** %var_68, align 8
  %idx20 = load i64, i64* %var_20, align 8
  %ptr20 = getelementptr inbounds i32, i32* %arr_p12, i64 %idx20
  %val20 = load i32, i32* %ptr20, align 4
  %cmp_1435_jge = icmp sge i32 %val38, %val20
  br i1 %cmp_1435_jge, label %loc_1435, label %loc_13CB

loc_13CB:
  %arr_p13 = load i32*, i32** %var_68, align 8
  %idx38_2 = load i64, i64* %var_38, align 8
  %ptr38_2 = getelementptr inbounds i32, i32* %arr_p13, i64 %idx38_2
  %val38_2 = load i32, i32* %ptr38_2, align 4
  store i32 %val38_2, i32* %var_58, align 4
  %arr_p14 = load i32*, i32** %var_68, align 8
  %idx20_2 = load i64, i64* %var_20, align 8
  %ptr20_2 = getelementptr inbounds i32, i32* %arr_p14, i64 %idx20_2
  %val20_2 = load i32, i32* %ptr20_2, align 4
  store i32 %val20_2, i32* %ptr38_2, align 4
  %tmp58 = load i32, i32* %var_58, align 4
  store i32 %tmp58, i32* %ptr20_2, align 4
  %new38 = load i64, i64* %var_20, align 8
  store i64 %new38, i64* %var_38, align 8
  br label %loc_132E

loc_1432:
  br label %loc_1436

loc_1435:
  br label %loc_1436

loc_1436:
  %v40_2 = load i64, i64* %var_40, align 8
  %v40m1 = add i64 %v40_2, -1
  store i64 %v40m1, i64* %var_40, align 8
  br label %loc_143B

loc_143B:
  %v40_3 = load i64, i64* %var_40, align 8
  %cond_12EA = icmp ne i64 %v40_3, 0
  br i1 %cond_12EA, label %loc_12EA, label %loc_1449

loc_1448:
  br label %loc_1449

loc_1449:
  ret void
}