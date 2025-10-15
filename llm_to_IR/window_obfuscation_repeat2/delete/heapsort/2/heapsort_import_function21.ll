; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

define void @sub_140001450(i32* %arg_0, i64 %arg_8) {
entry:
  %a = alloca i32*, align 8
  %n = alloca i64, align 8
  %var8 = alloca i64, align 8
  %var10 = alloca i64, align 8
  %var18 = alloca i64, align 8
  %var20 = alloca i64, align 8
  %var28 = alloca i64, align 8
  %var30 = alloca i64, align 8
  %var40 = alloca i64, align 8
  %var48 = alloca i64, align 8
  %var58 = alloca i64, align 8
  %var60 = alloca i64, align 8
  %var34 = alloca i32, align 4
  %var4C = alloca i32, align 4
  %var64 = alloca i32, align 4
  store i32* %arg_0, i32** %a, align 8
  store i64 %arg_8, i64* %n, align 8
  %n0 = load i64, i64* %n, align 8
  %cmp_init = icmp ule i64 %n0, 1
  br i1 %cmp_init, label %loc_1716, label %set_var8

set_var8:                                           ; preds = %entry
  %n1 = load i64, i64* %n, align 8
  %half = lshr i64 %n1, 1
  store i64 %half, i64* %var8, align 8
  br label %loc_158E

loc_147B:                                           ; preds = %loc_158E
  %v8_0 = load i64, i64* %var8, align 8
  store i64 %v8_0, i64* %var10, align 8
  br label %loc_1483

loc_1483:                                           ; preds = %loc_1527, %loc_147B
  %v10_a = load i64, i64* %var10, align 8
  %dbl = add i64 %v10_a, %v10_a
  %dblp1 = add i64 %dbl, 1
  store i64 %dblp1, i64* %var58, align 8
  %v58_a = load i64, i64* %var58, align 8
  %n2 = load i64, i64* %n, align 8
  %cond_1496 = icmp ult i64 %v58_a, %n2
  br i1 %cond_1496, label %loc_14A1, label %loc_158E

loc_14A1:                                           ; preds = %loc_1483
  %v58_b = load i64, i64* %var58, align 8
  %v60 = add i64 %v58_b, 1
  store i64 %v60, i64* %var60, align 8
  %v60_a = load i64, i64* %var60, align 8
  %n3 = load i64, i64* %n, align 8
  %cond_14B1 = icmp uge i64 %v60_a, %n3
  br i1 %cond_14B1, label %loc_14EF, label %loc_14B7

loc_14B7:                                           ; preds = %loc_14A1
  %v60_b = load i64, i64* %var60, align 8
  %a0 = load i32*, i32** %a, align 8
  %ptr60 = getelementptr inbounds i32, i32* %a0, i64 %v60_b
  %val60 = load i32, i32* %ptr60, align 4
  %v58_c = load i64, i64* %var58, align 8
  %a1 = load i32*, i32** %a, align 8
  %ptr58 = getelementptr inbounds i32, i32* %a1, i64 %v58_c
  %val58 = load i32, i32* %ptr58, align 4
  %cmp_children = icmp sle i32 %val60, %val58
  br i1 %cmp_children, label %loc_14EF, label %set_var18_60

set_var18_60:                                       ; preds = %loc_14B7
  %v60_c = load i64, i64* %var60, align 8
  store i64 %v60_c, i64* %var18, align 8
  br label %loc_14F7

loc_14EF:                                           ; preds = %loc_14B7, %loc_14A1
  %v58_d = load i64, i64* %var58, align 8
  store i64 %v58_d, i64* %var18, align 8
  br label %loc_14F7

loc_14F7:                                           ; preds = %loc_14EF, %set_var18_60
  %v10_b = load i64, i64* %var10, align 8
  %a2 = load i32*, i32** %a, align 8
  %ptr10 = getelementptr inbounds i32, i32* %a2, i64 %v10_b
  %val10 = load i32, i32* %ptr10, align 4
  %v18_a = load i64, i64* %var18, align 8
  %a3 = load i32*, i32** %a, align 8
  %ptr18 = getelementptr inbounds i32, i32* %a3, i64 %v18_a
  %val18 = load i32, i32* %ptr18, align 4
  %cmp_parent_child = icmp slt i32 %val10, %val18
  br i1 %cmp_parent_child, label %loc_1527, label %loc_158E

loc_1527:                                           ; preds = %loc_14F7
  %v10_c = load i64, i64* %var10, align 8
  %a4 = load i32*, i32** %a, align 8
  %p10 = getelementptr inbounds i32, i32* %a4, i64 %v10_c
  %tmp10 = load i32, i32* %p10, align 4
  store i32 %tmp10, i32* %var64, align 4
  %v18_b = load i64, i64* %var18, align 8
  %a5 = load i32*, i32** %a, align 8
  %p18 = getelementptr inbounds i32, i32* %a5, i64 %v18_b
  %val_from18 = load i32, i32* %p18, align 4
  %v10_d = load i64, i64* %var10, align 8
  %a6 = load i32*, i32** %a, align 8
  %p10b = getelementptr inbounds i32, i32* %a6, i64 %v10_d
  store i32 %val_from18, i32* %p10b, align 4
  %v18_c = load i64, i64* %var18, align 8
  %a7 = load i32*, i32** %a, align 8
  %p18b = getelementptr inbounds i32, i32* %a7, i64 %v18_c
  %tmp_saved = load i32, i32* %var64, align 4
  store i32 %tmp_saved, i32* %p18b, align 4
  %v18_d = load i64, i64* %var18, align 8
  store i64 %v18_d, i64* %var10, align 8
  br label %loc_1483

loc_158E:                                           ; preds = %loc_1483, %loc_14F7, %set_var8
  %old_v8 = load i64, i64* %var8, align 8
  %v8_minus1 = add i64 %old_v8, -1
  store i64 %v8_minus1, i64* %var8, align 8
  %test_old = icmp ne i64 %old_v8, 0
  br i1 %test_old, label %loc_147B, label %after_heapify

after_heapify:                                      ; preds = %loc_158E
  %n4 = load i64, i64* %n, align 8
  %n_minus1 = add i64 %n4, -1
  store i64 %n_minus1, i64* %var20, align 8
  br label %loc_1709

loc_15B4:                                           ; preds = %loc_1709
  %a8 = load i32*, i32** %a, align 8
  %first = load i32, i32* %a8, align 4
  store i32 %first, i32* %var34, align 4
  %v20_a = load i64, i64* %var20, align 8
  %a9 = load i32*, i32** %a, align 8
  %p20 = getelementptr inbounds i32, i32* %a9, i64 %v20_a
  %val20 = load i32, i32* %p20, align 4
  %a10 = load i32*, i32** %a, align 8
  store i32 %val20, i32* %a10, align 4
  %v20_b = load i64, i64* %var20, align 8
  %a11 = load i32*, i32** %a, align 8
  %p20b = getelementptr inbounds i32, i32* %a11, i64 %v20_b
  %saved_first = load i32, i32* %var34, align 4
  store i32 %saved_first, i32* %p20b, align 4
  store i64 0, i64* %var28, align 8
  br label %loc_15F8

loc_15F8:                                           ; preds = %loc_16FB, %loc_15B4
  %v28_a = load i64, i64* %var28, align 8
  %dbl28 = add i64 %v28_a, %v28_a
  %dbl28p1 = add i64 %dbl28, 1
  store i64 %dbl28p1, i64* %var40, align 8
  %v40_a = load i64, i64* %var40, align 8
  %v20_c = load i64, i64* %var20, align 8
  %cond_160B = icmp uge i64 %v40_a, %v20_c
  br i1 %cond_160B, label %loc_1700, label %loc_1615

loc_1615:                                           ; preds = %loc_15F8
  %v40_b = load i64, i64* %var40, align 8
  %v48 = add i64 %v40_b, 1
  store i64 %v48, i64* %var48, align 8
  %v48_a = load i64, i64* %var48, align 8
  %v20_d = load i64, i64* %var20, align 8
  %cond_1625 = icmp uge i64 %v48_a, %v20_d
  br i1 %cond_1625, label %loc_1663, label %loc_162B

loc_162B:                                           ; preds = %loc_1615
  %v48_b = load i64, i64* %var48, align 8
  %a12 = load i32*, i32** %a, align 8
  %p48 = getelementptr inbounds i32, i32* %a12, i64 %v48_b
  %val48 = load i32, i32* %p48, align 4
  %v40_c = load i64, i64* %var40, align 8
  %a13 = load i32*, i32** %a, align 8
  %p40 = getelementptr inbounds i32, i32* %a13, i64 %v40_c
  %val40 = load i32, i32* %p40, align 4
  %cmp_children2 = icmp sle i32 %val48, %val40
  br i1 %cmp_children2, label %loc_1663, label %set_var30_48

set_var30_48:                                       ; preds = %loc_162B
  %v48_c = load i64, i64* %var48, align 8
  store i64 %v48_c, i64* %var30, align 8
  br label %loc_166B

loc_1663:                                           ; preds = %loc_162B, %loc_1615
  %v40_d = load i64, i64* %var40, align 8
  store i64 %v40_d, i64* %var30, align 8
  br label %loc_166B

loc_166B:                                           ; preds = %loc_1663, %set_var30_48
  %v28_b = load i64, i64* %var28, align 8
  %a14 = load i32*, i32** %a, align 8
  %p28 = getelementptr inbounds i32, i32* %a14, i64 %v28_b
  %val28 = load i32, i32* %p28, align 4
  %v30_a = load i64, i64* %var30, align 8
  %a15 = load i32*, i32** %a, align 8
  %p30 = getelementptr inbounds i32, i32* %a15, i64 %v30_a
  %val30 = load i32, i32* %p30, align 4
  %cmp_parent_child2 = icmp sge i32 %val28, %val30
  br i1 %cmp_parent_child2, label %loc_1703, label %loc_1699

loc_1699:                                           ; preds = %loc_166B
  %v28_c = load i64, i64* %var28, align 8
  %a16 = load i32*, i32** %a, align 8
  %p28b = getelementptr inbounds i32, i32* %a16, i64 %v28_c
  %val28b = load i32, i32* %p28b, align 4
  store i32 %val28b, i32* %var4C, align 4
  %v30_b = load i64, i64* %var30, align 8
  %a17 = load i32*, i32** %a, align 8
  %p30b = getelementptr inbounds i32, i32* %a17, i64 %v30_b
  %val_from30 = load i32, i32* %p30b, align 4
  %v28_d = load i64, i64* %var28, align 8
  %a18 = load i32*, i32** %a, align 8
  %p28c = getelementptr inbounds i32, i32* %a18, i64 %v28_d
  store i32 %val_from30, i32* %p28c, align 4
  %v30_c = load i64, i64* %var30, align 8
  %a19 = load i32*, i32** %a, align 8
  %p30c = getelementptr inbounds i32, i32* %a19, i64 %v30_c
  %saved28 = load i32, i32* %var4C, align 4
  store i32 %saved28, i32* %p30c, align 4
  %v30_d = load i64, i64* %var30, align 8
  store i64 %v30_d, i64* %var28, align 8
  br label %loc_15F8

loc_1700:                                           ; preds = %loc_15F8
  br label %loc_1704

loc_1703:                                           ; preds = %loc_166B
  br label %loc_1704

loc_1704:                                           ; preds = %loc_1703, %loc_1700
  %v20_e = load i64, i64* %var20, align 8
  %v20_minus1 = add i64 %v20_e, -1
  store i64 %v20_minus1, i64* %var20, align 8
  br label %loc_1709

loc_1709:                                           ; preds = %after_heapify, %loc_1704
  %v20_f = load i64, i64* %var20, align 8
  %cond_1709 = icmp ne i64 %v20_f, 0
  br i1 %cond_1709, label %loc_15B4, label %loc_1717

loc_1716:                                           ; preds = %entry
  br label %loc_1717

loc_1717:                                           ; preds = %loc_1716, %loc_1709
  ret void
}