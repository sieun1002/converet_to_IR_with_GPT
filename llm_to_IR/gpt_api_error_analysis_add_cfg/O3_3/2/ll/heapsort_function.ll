; ModuleID = 'heap_sort_module'
target triple = "x86_64-pc-linux-gnu"

define dso_local void @heap_sort(i32* %arr, i64 %n) {
entry:
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
  %n0 = load i64, i64* %n.addr, align 8
  %cmp_le1 = icmp ule i64 %n0, 1
  br i1 %cmp_le1, label %loc_1448, label %entry.not_small

entry.not_small:                                    ; 0x11a4..0x11af
  %n1 = load i64, i64* %n.addr, align 8
  %shr = lshr i64 %n1, 1
  store i64 %shr, i64* %var50, align 8
  br label %loc_12C4

loc_11B4:                                            ; 0x11b4
  %v50_0 = load i64, i64* %var50, align 8
  store i64 %v50_0, i64* %var48, align 8
  br label %loc_11BC

loc_11BC:                                            ; 0x11bc
  %v48_a = load i64, i64* %var48, align 8
  %dbl = add i64 %v48_a, %v48_a
  %plus1 = add i64 %dbl, 1
  store i64 %plus1, i64* %var18, align 8
  %v18_a = load i64, i64* %var18, align 8
  %n2 = load i64, i64* %n.addr, align 8
  %cmp_v18_ge_n = icmp uge i64 %v18_a, %n2
  br i1 %cmp_v18_ge_n, label %loc_12C0, label %loc_11BC.cont1

loc_11BC.cont1:                                      ; 0x11d9..0x11ed and following
  %v18_b = load i64, i64* %var18, align 8
  %v10_calc = add i64 %v18_b, 1
  store i64 %v10_calc, i64* %var10, align 8
  %v10_a = load i64, i64* %var10, align 8
  %n3 = load i64, i64* %n.addr, align 8
  %cmp_v10_ge_n = icmp uge i64 %v10_a, %n3
  br i1 %cmp_v10_ge_n, label %loc_1223, label %loc_11BC.compare_children

loc_11BC.compare_children:                           ; 0x11ef..0x121b
  %arr0 = load i32*, i32** %arr.addr, align 8
  %v10_b = load i64, i64* %var10, align 8
  %ptr_v10 = getelementptr inbounds i32, i32* %arr0, i64 %v10_b
  %val_v10 = load i32, i32* %ptr_v10, align 4
  %arr1 = load i32*, i32** %arr.addr, align 8
  %v18_c = load i64, i64* %var18, align 8
  %ptr_v18 = getelementptr inbounds i32, i32* %arr1, i64 %v18_c
  %val_v18 = load i32, i32* %ptr_v18, align 4
  %cmp_v10_le_v18 = icmp sle i32 %val_v10, %val_v18
  br i1 %cmp_v10_le_v18, label %loc_1223, label %loc_1227.pre

loc_1223:                                            ; 0x1223
  %v18_d = load i64, i64* %var18, align 8
  br label %loc_1227

loc_1227.pre:                                       ; 0x1221 -> 0x1227 via jmp
  %v10_c = load i64, i64* %var10, align 8
  br label %loc_1227

loc_1227:                                            ; 0x1227..0x1257
  %phi_childidx = phi i64 [ %v18_d, %loc_1223 ], [ %v10_c, %loc_1227.pre ]
  store i64 %phi_childidx, i64* %var8, align 8
  %arr2 = load i32*, i32** %arr.addr, align 8
  %v48_b = load i64, i64* %var48, align 8
  %ptr_v48 = getelementptr inbounds i32, i32* %arr2, i64 %v48_b
  %val_v48 = load i32, i32* %ptr_v48, align 4
  %arr3 = load i32*, i32** %arr.addr, align 8
  %v8_a = load i64, i64* %var8, align 8
  %ptr_v8 = getelementptr inbounds i32, i32* %arr3, i64 %v8_a
  %val_v8 = load i32, i32* %ptr_v8, align 4
  %cmp_parent_ge_child = icmp sge i32 %val_v48, %val_v8
  br i1 %cmp_parent_ge_child, label %loc_12C3, label %loc_11BC.swap

loc_11BC.swap:                                       ; 0x1259..0x12bb
  %arr4 = load i32*, i32** %arr.addr, align 8
  %v48_c = load i64, i64* %var48, align 8
  %ptr_v48_b = getelementptr inbounds i32, i32* %arr4, i64 %v48_c
  %val_parent = load i32, i32* %ptr_v48_b, align 4
  store i32 %val_parent, i32* %var54, align 4
  %arr5 = load i32*, i32** %arr.addr, align 8
  %v8_b = load i64, i64* %var8, align 8
  %ptr_v8_b = getelementptr inbounds i32, i32* %arr5, i64 %v8_b
  %val_at_child = load i32, i32* %ptr_v8_b, align 4
  %arr6 = load i32*, i32** %arr.addr, align 8
  %v48_d = load i64, i64* %var48, align 8
  %ptr_v48_c = getelementptr inbounds i32, i32* %arr6, i64 %v48_d
  store i32 %val_at_child, i32* %ptr_v48_c, align 4
  %arr7 = load i32*, i32** %arr.addr, align 8
  %v8_c = load i64, i64* %var8, align 8
  %ptr_v8_c = getelementptr inbounds i32, i32* %arr7, i64 %v8_c
  %tmp_parent_saved = load i32, i32* %var54, align 4
  store i32 %tmp_parent_saved, i32* %ptr_v8_c, align 4
  %v8_d = load i64, i64* %var8, align 8
  store i64 %v8_d, i64* %var48, align 8
  br label %loc_11BC

loc_12C0:                                            ; 0x12c0
  br label %loc_12C4

loc_12C3:                                            ; 0x12c3
  br label %loc_12C4

loc_12C4:                                            ; 0x12c4..0x12d3
  %old50 = load i64, i64* %var50, align 8
  %dec = add i64 %old50, -1
  store i64 %dec, i64* %var50, align 8
  %cond_old50_nz = icmp ne i64 %old50, 0
  br i1 %cond_old50_nz, label %loc_11B4, label %after_heap_build

after_heap_build:                                    ; 0x12d9..0x12e5
  %n4 = load i64, i64* %n.addr, align 8
  %nminus1 = add i64 %n4, -1
  store i64 %nminus1, i64* %var40, align 8
  br label %loc_143B

loc_12EA:                                            ; 0x12ea..0x1326
  %arr8 = load i32*, i32** %arr.addr, align 8
  %val_root = load i32, i32* %arr8, align 4
  store i32 %val_root, i32* %var5C, align 4
  %v40_a = load i64, i64* %var40, align 8
  %arr9 = load i32*, i32** %arr.addr, align 8
  %ptr_last = getelementptr inbounds i32, i32* %arr9, i64 %v40_a
  %val_last = load i32, i32* %ptr_last, align 4
  %arr10 = load i32*, i32** %arr.addr, align 8
  store i32 %val_last, i32* %arr10, align 4
  %arr11 = load i32*, i32** %arr.addr, align 8
  %v40_b = load i64, i64* %var40, align 8
  %ptr_last_b = getelementptr inbounds i32, i32* %arr11, i64 %v40_b
  %saved_root = load i32, i32* %var5C, align 4
  store i32 %saved_root, i32* %ptr_last_b, align 4
  store i64 0, i64* %var38, align 8
  br label %loc_132E

loc_132E:                                            ; 0x132e..0x1345
  %v38_a = load i64, i64* %var38, align 8
  %dbl2 = add i64 %v38_a, %v38_a
  %plus1_2 = add i64 %dbl2, 1
  store i64 %plus1_2, i64* %var30, align 8
  %v30_a = load i64, i64* %var30, align 8
  %v40_c = load i64, i64* %var40, align 8
  %cmp_v30_ge_v40 = icmp uge i64 %v30_a, %v40_c
  br i1 %cmp_v30_ge_v40, label %loc_1432, label %loc_132E.cont1

loc_132E.cont1:                                      ; 0x134b..0x138d
  %v30_b = load i64, i64* %var30, align 8
  %v28_calc = add i64 %v30_b, 1
  store i64 %v28_calc, i64* %var28, align 8
  %v28_a = load i64, i64* %var28, align 8
  %v40_d = load i64, i64* %var40, align 8
  %cmp_v28_ge_v40 = icmp uge i64 %v28_a, %v40_d
  br i1 %cmp_v28_ge_v40, label %loc_1395, label %loc_132E.compare_children2

loc_132E.compare_children2:
  %arr12 = load i32*, i32** %arr.addr, align 8
  %v28_b = load i64, i64* %var28, align 8
  %ptr_v28 = getelementptr inbounds i32, i32* %arr12, i64 %v28_b
  %val_v28 = load i32, i32* %ptr_v28, align 4
  %arr13 = load i32*, i32** %arr.addr, align 8
  %v30_c = load i64, i64* %var30, align 8
  %ptr_v30 = getelementptr inbounds i32, i32* %arr13, i64 %v30_c
  %val_v30 = load i32, i32* %ptr_v30, align 4
  %cmp_v28_le_v30 = icmp sle i32 %val_v28, %val_v30
  br i1 %cmp_v28_le_v30, label %loc_1395, label %loc_1399.pre

loc_1395:                                            ; 0x1395
  %v30_d = load i64, i64* %var30, align 8
  br label %loc_1399

loc_1399.pre:                                        ; 0x1393 -> 0x1399 via jmp
  %v28_c = load i64, i64* %var28, align 8
  br label %loc_1399

loc_1399:                                            ; 0x1399..0x13c9
  %phi_maxchild = phi i64 [ %v30_d, %loc_1395 ], [ %v28_c, %loc_1399.pre ]
  store i64 %phi_maxchild, i64* %var20, align 8
  %arr14 = load i32*, i32** %arr.addr, align 8
  %v38_b = load i64, i64* %var38, align 8
  %ptr_v38 = getelementptr inbounds i32, i32* %arr14, i64 %v38_b
  %val_v38 = load i32, i32* %ptr_v38, align 4
  %arr15 = load i32*, i32** %arr.addr, align 8
  %v20_a = load i64, i64* %var20, align 8
  %ptr_v20 = getelementptr inbounds i32, i32* %arr15, i64 %v20_a
  %val_v20 = load i32, i32* %ptr_v20, align 4
  %cmp_v38_ge_v20 = icmp sge i32 %val_v38, %val_v20
  br i1 %cmp_v38_ge_v20, label %loc_1435, label %loc_1399.swap

loc_1399.swap:                                       ; 0x13cb..0x142d
  %arr16 = load i32*, i32** %arr.addr, align 8
  %v38_c = load i64, i64* %var38, align 8
  %ptr_v38_b = getelementptr inbounds i32, i32* %arr16, i64 %v38_c
  %val_v38_b = load i32, i32* %ptr_v38_b, align 4
  store i32 %val_v38_b, i32* %var58, align 4
  %arr17 = load i32*, i32** %arr.addr, align 8
  %v20_b = load i64, i64* %var20, align 8
  %ptr_v20_b = getelementptr inbounds i32, i32* %arr17, i64 %v20_b
  %val_at_v20 = load i32, i32* %ptr_v20_b, align 4
  %arr18 = load i32*, i32** %arr.addr, align 8
  %v38_d = load i64, i64* %var38, align 8
  %ptr_v38_c = getelementptr inbounds i32, i32* %arr18, i64 %v38_d
  store i32 %val_at_v20, i32* %ptr_v38_c, align 4
  %arr19 = load i32*, i32** %arr.addr, align 8
  %v20_c = load i64, i64* %var20, align 8
  %ptr_v20_c = getelementptr inbounds i32, i32* %arr19, i64 %v20_c
  %saved_v38 = load i32, i32* %var58, align 4
  store i32 %saved_v38, i32* %ptr_v20_c, align 4
  %v20_d = load i64, i64* %var20, align 8
  store i64 %v20_d, i64* %var38, align 8
  br label %loc_132E

loc_1432:                                            ; 0x1432
  br label %loc_1436

loc_1435:                                            ; 0x1435
  br label %loc_1436

loc_1436:                                            ; 0x1436
  %v40_e = load i64, i64* %var40, align 8
  %v40_dec = add i64 %v40_e, -1
  store i64 %v40_dec, i64* %var40, align 8
  br label %loc_143B

loc_143B:                                            ; 0x143b..0x1446
  %v40_f = load i64, i64* %var40, align 8
  %cmp_v40_nz = icmp ne i64 %v40_f, 0
  br i1 %cmp_v40_nz, label %loc_12EA, label %loc_1449

loc_1448:                                            ; 0x1448
  br label %loc_1449

loc_1449:                                            ; 0x1449
  ret void
}