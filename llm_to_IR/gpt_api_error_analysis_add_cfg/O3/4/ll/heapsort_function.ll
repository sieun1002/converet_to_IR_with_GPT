; ModuleID = 'heapsort_module'
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
  %n0 = load i64, i64* %n.addr, align 8
  %cmp_n_le1 = icmp ule i64 %n0, 1
  br i1 %cmp_n_le1, label %loc_1448, label %entry.cont

entry.cont:                                        ; 0x11a4 .. 0x11af
  %t0 = lshr i64 %n0, 1
  store i64 %t0, i64* %var50, align 8
  br label %loc_12C4

loc_11B4:                                          ; 0x11b4
  %v50 = load i64, i64* %var50, align 8
  store i64 %v50, i64* %var48, align 8
  br label %loc_11BC

loc_11BC:                                          ; 0x11bc
  %v48 = load i64, i64* %var48, align 8
  %double = add i64 %v48, %v48
  %plus1 = add i64 %double, 1
  store i64 %plus1, i64* %var18, align 8
  %v18 = load i64, i64* %var18, align 8
  %n1 = load i64, i64* %n.addr, align 8
  %cmp18_n = icmp uge i64 %v18, %n1
  br i1 %cmp18_n, label %loc_12C0, label %b_11d9

b_11d9:                                            ; 0x11d9
  %v18b = load i64, i64* %var18, align 8
  %add1 = add i64 %v18b, 1
  store i64 %add1, i64* %var10, align 8
  %v10 = load i64, i64* %var10, align 8
  %n2 = load i64, i64* %n.addr, align 8
  %cmp10_n = icmp uge i64 %v10, %n2
  br i1 %cmp10_n, label %loc_1223, label %b_11ef

b_11ef:                                            ; 0x11ef
  %base1 = load i32*, i32** %arr.addr, align 8
  %v10a = load i64, i64* %var10, align 8
  %ptr10 = getelementptr inbounds i32, i32* %base1, i64 %v10a
  %val10 = load i32, i32* %ptr10, align 4
  %base2 = load i32*, i32** %arr.addr, align 8
  %v18a = load i64, i64* %var18, align 8
  %ptr18 = getelementptr inbounds i32, i32* %base2, i64 %v18a
  %val18 = load i32, i32* %ptr18, align 4
  %cmp_le = icmp sle i32 %val10, %val18
  br i1 %cmp_le, label %loc_1223, label %b_121d

b_121d:                                            ; 0x121d
  %v10b = load i64, i64* %var10, align 8
  br label %loc_1227

loc_1223:                                          ; 0x1223
  %v18c = load i64, i64* %var18, align 8
  br label %loc_1227

loc_1227:                                          ; 0x1227
  %sel = phi i64 [ %v10b, %b_121d ], [ %v18c, %loc_1223 ]
  store i64 %sel, i64* %var8, align 8
  %base3 = load i32*, i32** %arr.addr, align 8
  %v48a = load i64, i64* %var48, align 8
  %ptr48 = getelementptr inbounds i32, i32* %base3, i64 %v48a
  %val48 = load i32, i32* %ptr48, align 4
  %base4 = load i32*, i32** %arr.addr, align 8
  %v8a = load i64, i64* %var8, align 8
  %ptr8 = getelementptr inbounds i32, i32* %base4, i64 %v8a
  %val8 = load i32, i32* %ptr8, align 4
  %cmp_ge = icmp sge i32 %val48, %val8
  br i1 %cmp_ge, label %loc_12C3, label %b_1259

b_1259:                                            ; 0x1259
  %base5 = load i32*, i32** %arr.addr, align 8
  %v48b = load i64, i64* %var48, align 8
  %ptr48b = getelementptr inbounds i32, i32* %base5, i64 %v48b
  %val48b = load i32, i32* %ptr48b, align 4
  store i32 %val48b, i32* %var54, align 4
  %base6 = load i32*, i32** %arr.addr, align 8
  %v8b = load i64, i64* %var8, align 8
  %ptr8b = getelementptr inbounds i32, i32* %base6, i64 %v8b
  %val8b = load i32, i32* %ptr8b, align 4
  %base7 = load i32*, i32** %arr.addr, align 8
  %v48c = load i64, i64* %var48, align 8
  %ptr48c = getelementptr inbounds i32, i32* %base7, i64 %v48c
  store i32 %val8b, i32* %ptr48c, align 4
  %base8 = load i32*, i32** %arr.addr, align 8
  %v8c = load i64, i64* %var8, align 8
  %ptr8c = getelementptr inbounds i32, i32* %base8, i64 %v8c
  %tmp54 = load i32, i32* %var54, align 4
  store i32 %tmp54, i32* %ptr8c, align 4
  %new48 = load i64, i64* %var8, align 8
  store i64 %new48, i64* %var48, align 8
  br label %loc_11BC

loc_12C0:                                          ; 0x12c0
  br label %loc_12C4

loc_12C3:                                          ; 0x12c3
  br label %loc_12C4

loc_12C4:                                          ; 0x12c4
  %v50a = load i64, i64* %var50, align 8
  %dec = add i64 %v50a, -1
  store i64 %dec, i64* %var50, align 8
  %tst = icmp ne i64 %v50a, 0
  br i1 %tst, label %loc_11B4, label %bb_12d9

bb_12d9:                                           ; 0x12d9
  %n3 = load i64, i64* %n.addr, align 8
  %minus1 = add i64 %n3, -1
  store i64 %minus1, i64* %var40, align 8
  br label %loc_143B

loc_12EA:                                          ; 0x12ea
  %base9 = load i32*, i32** %arr.addr, align 8
  %ptr0 = getelementptr inbounds i32, i32* %base9, i64 0
  %val0 = load i32, i32* %ptr0, align 4
  store i32 %val0, i32* %var5C, align 4
  %v40a = load i64, i64* %var40, align 8
  %base10 = load i32*, i32** %arr.addr, align 8
  %ptr40 = getelementptr inbounds i32, i32* %base10, i64 %v40a
  %val40 = load i32, i32* %ptr40, align 4
  %base11 = load i32*, i32** %arr.addr, align 8
  %ptr0b = getelementptr inbounds i32, i32* %base11, i64 0
  store i32 %val40, i32* %ptr0b, align 4
  %base12 = load i32*, i32** %arr.addr, align 8
  %v40b = load i64, i64* %var40, align 8
  %ptr40b = getelementptr inbounds i32, i32* %base12, i64 %v40b
  %tmp5C = load i32, i32* %var5C, align 4
  store i32 %tmp5C, i32* %ptr40b, align 4
  store i64 0, i64* %var38, align 8
  br label %loc_132E

loc_132E:                                          ; 0x132e
  %v38 = load i64, i64* %var38, align 8
  %dbl38 = add i64 %v38, %v38
  %plus1b = add i64 %dbl38, 1
  store i64 %plus1b, i64* %var30, align 8
  %v30 = load i64, i64* %var30, align 8
  %v40 = load i64, i64* %var40, align 8
  %cmp30_40 = icmp uge i64 %v30, %v40
  br i1 %cmp30_40, label %loc_1432, label %b_134b

b_134b:                                            ; 0x134b
  %v30b = load i64, i64* %var30, align 8
  %add1b = add i64 %v30b, 1
  store i64 %add1b, i64* %var28, align 8
  %v28 = load i64, i64* %var28, align 8
  %v40b2 = load i64, i64* %var40, align 8
  %cmp28_40 = icmp uge i64 %v28, %v40b2
  br i1 %cmp28_40, label %loc_1395, label %b_1361

b_1361:                                            ; 0x1361
  %base13 = load i32*, i32** %arr.addr, align 8
  %v28a = load i64, i64* %var28, align 8
  %ptr28 = getelementptr inbounds i32, i32* %base13, i64 %v28a
  %val28 = load i32, i32* %ptr28, align 4
  %base14 = load i32*, i32** %arr.addr, align 8
  %v30a = load i64, i64* %var30, align 8
  %ptr30 = getelementptr inbounds i32, i32* %base14, i64 %v30a
  %val30 = load i32, i32* %ptr30, align 4
  %cmp_le2 = icmp sle i32 %val28, %val30
  br i1 %cmp_le2, label %loc_1395, label %b_138f

b_138f:                                            ; 0x138f
  %v28b = load i64, i64* %var28, align 8
  br label %loc_1399

loc_1395:                                          ; 0x1395
  %v30c = load i64, i64* %var30, align 8
  br label %loc_1399

loc_1399:                                          ; 0x1399
  %sel2 = phi i64 [ %v28b, %b_138f ], [ %v30c, %loc_1395 ]
  store i64 %sel2, i64* %var20, align 8
  %base15 = load i32*, i32** %arr.addr, align 8
  %v38a = load i64, i64* %var38, align 8
  %ptr38 = getelementptr inbounds i32, i32* %base15, i64 %v38a
  %val38 = load i32, i32* %ptr38, align 4
  %base16 = load i32*, i32** %arr.addr, align 8
  %v20a = load i64, i64* %var20, align 8
  %ptr20 = getelementptr inbounds i32, i32* %base16, i64 %v20a
  %val20 = load i32, i32* %ptr20, align 4
  %cmp_ge2 = icmp sge i32 %val38, %val20
  br i1 %cmp_ge2, label %loc_1435, label %b_13cb

b_13cb:                                            ; 0x13cb
  %base17 = load i32*, i32** %arr.addr, align 8
  %v38b = load i64, i64* %var38, align 8
  %ptr38b = getelementptr inbounds i32, i32* %base17, i64 %v38b
  %val38b = load i32, i32* %ptr38b, align 4
  store i32 %val38b, i32* %var58, align 4
  %base18 = load i32*, i32** %arr.addr, align 8
  %v20b = load i64, i64* %var20, align 8
  %ptr20b = getelementptr inbounds i32, i32* %base18, i64 %v20b
  %val20b = load i32, i32* %ptr20b, align 4
  %base19 = load i32*, i32** %arr.addr, align 8
  %v38c = load i64, i64* %var38, align 8
  %ptr38c = getelementptr inbounds i32, i32* %base19, i64 %v38c
  store i32 %val20b, i32* %ptr38c, align 4
  %base20 = load i32*, i32** %arr.addr, align 8
  %v20c = load i64, i64* %var20, align 8
  %ptr20c = getelementptr inbounds i32, i32* %base20, i64 %v20c
  %tmp58 = load i32, i32* %var58, align 4
  store i32 %tmp58, i32* %ptr20c, align 4
  %new38 = load i64, i64* %var20, align 8
  store i64 %new38, i64* %var38, align 8
  br label %loc_132E

loc_1432:                                          ; 0x1432
  br label %loc_1436

loc_1435:                                          ; 0x1435
  br label %loc_1436

loc_1436:                                          ; 0x1436
  %v40c = load i64, i64* %var40, align 8
  %dec40 = add i64 %v40c, -1
  store i64 %dec40, i64* %var40, align 8
  %v40d = load i64, i64* %var40, align 8
  %cond40 = icmp ne i64 %v40d, 0
  br i1 %cond40, label %loc_12EA, label %loc_1449

loc_143B:                                          ; 0x143b
  %v40e = load i64, i64* %var40, align 8
  %cmpv40z = icmp ne i64 %v40e, 0
  br i1 %cmpv40z, label %loc_12EA, label %loc_1449

loc_1448:                                          ; 0x1448
  br label %loc_1449

loc_1449:                                          ; 0x1449
  ret void
}