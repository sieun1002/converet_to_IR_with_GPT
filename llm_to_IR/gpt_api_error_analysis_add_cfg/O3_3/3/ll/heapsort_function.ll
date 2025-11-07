; ModuleID = 'heap_sort_module'
target triple = "x86_64-pc-linux-gnu"

define void @heap_sort(i32* %arg_arr, i64 %arg_len) {
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
  %var_58 = alloca i32, align 4
  %var_40 = alloca i64, align 8
  %var_38 = alloca i64, align 8
  %var_30 = alloca i64, align 8
  %var_28 = alloca i64, align 8
  %var_20 = alloca i64, align 8
  store i32* %arg_arr, i32** %var_68, align 8
  store i64 %arg_len, i64* %var_70, align 8
  %len0 = load i64, i64* %var_70, align 8
  %cmp_entry = icmp ule i64 %len0, 1
  br i1 %cmp_entry, label %loc_1448, label %bb_1189_cont

bb_1189_cont:
  %len1 = load i64, i64* %var_70, align 8
  %half = lshr i64 %len1, 1
  store i64 %half, i64* %var_50, align 8
  br label %loc_12C4

loc_11B4:
  %t11 = load i64, i64* %var_50, align 8
  store i64 %t11, i64* %var_48, align 8
  br label %loc_11BC

loc_11BC:
  %t12 = load i64, i64* %var_48, align 8
  %t13 = add i64 %t12, %t12
  %t14 = add i64 %t13, 1
  store i64 %t14, i64* %var_18, align 8
  %child = load i64, i64* %var_18, align 8
  %len2 = load i64, i64* %var_70, align 8
  %cmp_11cf = icmp uge i64 %child, %len2
  br i1 %cmp_11cf, label %loc_12C0, label %bb_11BC_cont

bb_11BC_cont:
  %v18_a = load i64, i64* %var_18, align 8
  %v10_new = add i64 %v18_a, 1
  store i64 %v10_new, i64* %var_10, align 8
  %v10_b = load i64, i64* %var_10, align 8
  %len3 = load i64, i64* %var_70, align 8
  %cmp_11e9 = icmp uge i64 %v10_b, %len3
  br i1 %cmp_11e9, label %loc_1223, label %bb_11BC_cont2

bb_11BC_cont2:
  %base_a = load i32*, i32** %var_68, align 8
  %idx10 = load i64, i64* %var_10, align 8
  %p10 = getelementptr inbounds i32, i32* %base_a, i64 %idx10
  %edx_1202 = load i32, i32* %p10, align 4
  %idx18 = load i64, i64* %var_18, align 8
  %p18 = getelementptr inbounds i32, i32* %base_a, i64 %idx18
  %eax_1217 = load i32, i32* %p18, align 4
  %cmp_1219 = icmp sle i32 %edx_1202, %eax_1217
  br i1 %cmp_1219, label %loc_1223, label %bb_1221

bb_1221:
  %rax_from10 = load i64, i64* %var_10, align 8
  br label %loc_1227

loc_1223:
  %rax_from18 = load i64, i64* %var_18, align 8
  br label %loc_1227

loc_1227:
  %sel_1227 = phi i64 [ %rax_from18, %loc_1223 ], [ %rax_from10, %bb_1221 ]
  store i64 %sel_1227, i64* %var_8, align 8
  %base_b = load i32*, i32** %var_68, align 8
  %idx48 = load i64, i64* %var_48, align 8
  %p48 = getelementptr inbounds i32, i32* %base_b, i64 %idx48
  %edx_123e = load i32, i32* %p48, align 4
  %idx8 = load i64, i64* %var_8, align 8
  %p8 = getelementptr inbounds i32, i32* %base_b, i64 %idx8
  %eax_1253 = load i32, i32* %p8, align 4
  %cmp_1255 = icmp sge i32 %edx_123e, %eax_1253
  br i1 %cmp_1255, label %loc_12C3, label %bb_1259

bb_1259:
  %base_c = load i32*, i32** %var_68, align 8
  %idx48_c = load i64, i64* %var_48, align 8
  %p48_c = getelementptr inbounds i32, i32* %base_c, i64 %idx48_c
  %val48 = load i32, i32* %p48_c, align 4
  store i32 %val48, i32* %var_54, align 4
  %idx8_c = load i64, i64* %var_8, align 8
  %p8_c = getelementptr inbounds i32, i32* %base_c, i64 %idx8_c
  %val8 = load i32, i32* %p8_c, align 4
  store i32 %val8, i32* %p48_c, align 4
  %tmp54 = load i32, i32* %var_54, align 4
  store i32 %tmp54, i32* %p8_c, align 4
  %new48 = load i64, i64* %var_8, align 8
  store i64 %new48, i64* %var_48, align 8
  br label %loc_11BC

loc_12C0:
  br label %loc_12C4

loc_12C3:
  br label %loc_12C4

loc_12C4:
  %v50 = load i64, i64* %var_50, align 8
  %dec50 = add i64 %v50, -1
  store i64 %dec50, i64* %var_50, align 8
  %tst_12d0 = icmp ne i64 %v50, 0
  br i1 %tst_12d0, label %loc_11B4, label %bb_12C4_cont

bb_12C4_cont:
  %len4 = load i64, i64* %var_70, align 8
  %lenm1 = add i64 %len4, -1
  store i64 %lenm1, i64* %var_40, align 8
  br label %loc_143B

loc_12EA:
  %base_d = load i32*, i32** %var_68, align 8
  %first = load i32, i32* %base_d, align 4
  store i32 %first, i32* %var_5C, align 4
  %i40 = load i64, i64* %var_40, align 8
  %p40 = getelementptr inbounds i32, i32* %base_d, i64 %i40
  %val40 = load i32, i32* %p40, align 4
  store i32 %val40, i32* %base_d, align 4
  %tmp5C = load i32, i32* %var_5C, align 4
  store i32 %tmp5C, i32* %p40, align 4
  store i64 0, i64* %var_38, align 8
  br label %loc_132E

loc_132E:
  %v38 = load i64, i64* %var_38, align 8
  %twice = add i64 %v38, %v38
  %plus1 = add i64 %twice, 1
  store i64 %plus1, i64* %var_30, align 8
  %v30 = load i64, i64* %var_30, align 8
  %v40 = load i64, i64* %var_40, align 8
  %cmp_1341 = icmp uge i64 %v30, %v40
  br i1 %cmp_1341, label %loc_1432, label %bb_134B

bb_134B:
  %v30_b = load i64, i64* %var_30, align 8
  %v28_new = add i64 %v30_b, 1
  store i64 %v28_new, i64* %var_28, align 8
  %v28 = load i64, i64* %var_28, align 8
  %v40_b = load i64, i64* %var_40, align 8
  %cmp_135b = icmp uge i64 %v28, %v40_b
  br i1 %cmp_135b, label %loc_1395, label %bb_1361

bb_1361:
  %base_e = load i32*, i32** %var_68, align 8
  %i28 = load i64, i64* %var_28, align 8
  %p28 = getelementptr inbounds i32, i32* %base_e, i64 %i28
  %edx_1374 = load i32, i32* %p28, align 4
  %i30 = load i64, i64* %var_30, align 8
  %p30 = getelementptr inbounds i32, i32* %base_e, i64 %i30
  %eax_1389 = load i32, i32* %p30, align 4
  %cmp_138b = icmp sle i32 %edx_1374, %eax_1389
  br i1 %cmp_138b, label %loc_1395, label %bb_138f

bb_138f:
  %r_from28 = load i64, i64* %var_28, align 8
  br label %loc_1399

loc_1395:
  %r_from30 = load i64, i64* %var_30, align 8
  br label %loc_1399

loc_1399:
  %sel_1399 = phi i64 [ %r_from30, %loc_1395 ], [ %r_from28, %bb_138f ]
  store i64 %sel_1399, i64* %var_20, align 8
  %base_f = load i32*, i32** %var_68, align 8
  %i38_b = load i64, i64* %var_38, align 8
  %p38 = getelementptr inbounds i32, i32* %base_f, i64 %i38_b
  %edx_13b0 = load i32, i32* %p38, align 4
  %i20 = load i64, i64* %var_20, align 8
  %p20 = getelementptr inbounds i32, i32* %base_f, i64 %i20
  %eax_13c5 = load i32, i32* %p20, align 4
  %cmp_13c7 = icmp sge i32 %edx_13b0, %eax_13c5
  br i1 %cmp_13c7, label %loc_1435, label %bb_13CB

bb_13CB:
  %base_g = load i32*, i32** %var_68, align 8
  %i38_c = load i64, i64* %var_38, align 8
  %p38_c = getelementptr inbounds i32, i32* %base_g, i64 %i38_c
  %val38 = load i32, i32* %p38_c, align 4
  store i32 %val38, i32* %var_58, align 4
  %i20_b = load i64, i64* %var_20, align 8
  %p20_b = getelementptr inbounds i32, i32* %base_g, i64 %i20_b
  %val20 = load i32, i32* %p20_b, align 4
  store i32 %val20, i32* %p38_c, align 4
  %tmp58 = load i32, i32* %var_58, align 4
  store i32 %tmp58, i32* %p20_b, align 4
  %to38 = load i64, i64* %var_20, align 8
  store i64 %to38, i64* %var_38, align 8
  br label %loc_132E

loc_1432:
  br label %loc_1436

loc_1435:
  br label %loc_1436

loc_1436:
  %v40_c = load i64, i64* %var_40, align 8
  %v40_dec = add i64 %v40_c, -1
  store i64 %v40_dec, i64* %var_40, align 8
  br label %loc_143B

loc_143B:
  %v40_d = load i64, i64* %var_40, align 8
  %cmp_1440 = icmp ne i64 %v40_d, 0
  br i1 %cmp_1440, label %loc_12EA, label %bb_1446

bb_1446:
  br label %loc_1449

loc_1448:
  br label %loc_1449

loc_1449:
  ret void
}