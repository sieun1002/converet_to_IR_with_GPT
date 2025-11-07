; ModuleID = 'heap_sort'
source_filename = "heap_sort"
target triple = "x86_64-pc-linux-gnu"

define void @heap_sort(i32* %arr, i64 %n) {
loc_1189:
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
  br i1 %cmp_n_le1, label %loc_1448, label %block_11a4

block_11a4:                                         ; 0x11a4..0x11af
  %n1 = load i64, i64* %n.addr, align 8
  %half = lshr i64 %n1, 1
  store i64 %half, i64* %var_50, align 8
  br label %loc_12C4

loc_1448:                                           ; 0x1448
  br label %loc_1449

loc_11B4:                                           ; 0x11b4
  %v50a = load i64, i64* %var_50, align 8
  store i64 %v50a, i64* %var_48, align 8
  br label %loc_11BC

loc_11BC:                                           ; 0x11bc
  %v48a = load i64, i64* %var_48, align 8
  %twice = add i64 %v48a, %v48a
  %left = add i64 %twice, 1
  store i64 %left, i64* %var_18, align 8
  %left2 = load i64, i64* %var_18, align 8
  %n2 = load i64, i64* %n.addr, align 8
  %cond = icmp uge i64 %left2, %n2
  br i1 %cond, label %loc_12C0, label %block_11d9

block_11d9:                                         ; 0x11d9
  %lch = load i64, i64* %var_18, align 8
  %right = add i64 %lch, 1
  store i64 %right, i64* %var_10, align 8
  %right2 = load i64, i64* %var_10, align 8
  %n3 = load i64, i64* %n.addr, align 8
  %cond2 = icmp uge i64 %right2, %n3
  br i1 %cond2, label %loc_1223, label %block_11ef

block_11ef:                                         ; 0x11ef..0x121b
  %base0 = load i32*, i32** %arr.addr, align 8
  %ridx = load i64, i64* %var_10, align 8
  %rptr = getelementptr inbounds i32, i32* %base0, i64 %ridx
  %rval = load i32, i32* %rptr, align 4
  %base1 = load i32*, i32** %arr.addr, align 8
  %lidx = load i64, i64* %var_18, align 8
  %lptr = getelementptr inbounds i32, i32* %base1, i64 %lidx
  %lval = load i32, i32* %lptr, align 4
  %cmp_le = icmp sle i32 %rval, %lval
  br i1 %cmp_le, label %loc_1223, label %block_121d

block_121d:                                         ; 0x121d..0x1221
  %v10_forphi = load i64, i64* %var_10, align 8
  br label %loc_1227

loc_1223:                                           ; 0x1223
  %v18_forphi = load i64, i64* %var_18, align 8
  br label %loc_1227

loc_1227:                                           ; 0x1227
  %phi_child = phi i64 [ %v10_forphi, %block_121d ], [ %v18_forphi, %loc_1223 ]
  store i64 %phi_child, i64* %var_8, align 8
  br label %block_122b

block_122b:                                         ; 0x122b..0x1257
  %base2 = load i32*, i32** %arr.addr, align 8
  %idxi = load i64, i64* %var_48, align 8
  %ppar = getelementptr inbounds i32, i32* %base2, i64 %idxi
  %parval = load i32, i32* %ppar, align 4
  %base3 = load i32*, i32** %arr.addr, align 8
  %idxc = load i64, i64* %var_8, align 8
  %cptr = getelementptr inbounds i32, i32* %base3, i64 %idxc
  %cval = load i32, i32* %cptr, align 4
  %cmp_ge = icmp sge i32 %parval, %cval
  br i1 %cmp_ge, label %loc_12C3, label %block_1259

block_1259:                                         ; 0x1259..0x12bb
  store i32 %parval, i32* %var_54, align 4
  store i32 %cval, i32* %ppar, align 4
  %tmp54 = load i32, i32* %var_54, align 4
  store i32 %tmp54, i32* %cptr, align 4
  store i64 %idxc, i64* %var_48, align 8
  br label %loc_11BC

loc_12C0:                                           ; 0x12c0
  br label %loc_12C4

loc_12C3:                                           ; 0x12c3
  br label %loc_12C4

loc_12C4:                                           ; 0x12c4
  %v50b = load i64, i64* %var_50, align 8
  %v50b_minus1 = add i64 %v50b, -1
  store i64 %v50b_minus1, i64* %var_50, align 8
  %test = icmp ne i64 %v50b, 0
  br i1 %test, label %loc_11B4, label %block_12d9

block_12d9:                                         ; 0x12d9..0x12e5
  %n4 = load i64, i64* %n.addr, align 8
  %lastidx = add i64 %n4, -1
  store i64 %lastidx, i64* %var_40, align 8
  br label %loc_143B

loc_12EA:                                           ; 0x12ea
  %base4 = load i32*, i32** %arr.addr, align 8
  %p0 = getelementptr inbounds i32, i32* %base4, i64 0
  %val0 = load i32, i32* %p0, align 4
  store i32 %val0, i32* %var_5C, align 4
  %v40_0 = load i64, i64* %var_40, align 8
  %base5a = load i32*, i32** %arr.addr, align 8
  %plast = getelementptr inbounds i32, i32* %base5a, i64 %v40_0
  %lastval = load i32, i32* %plast, align 4
  %base6a = load i32*, i32** %arr.addr, align 8
  %p0b = getelementptr inbounds i32, i32* %base6a, i64 0
  store i32 %lastval, i32* %p0b, align 4
  %val0_saved = load i32, i32* %var_5C, align 4
  store i32 %val0_saved, i32* %plast, align 4
  store i64 0, i64* %var_38, align 8
  br label %loc_132E

loc_132E:                                           ; 0x132e
  %v38 = load i64, i64* %var_38, align 8
  %twice2 = add i64 %v38, %v38
  %leftA = add i64 %twice2, 1
  store i64 %leftA, i64* %var_30, align 8
  %leftA2 = load i64, i64* %var_30, align 8
  %v40A = load i64, i64* %var_40, align 8
  %condA = icmp uge i64 %leftA2, %v40A
  br i1 %condA, label %loc_1432, label %block_134b

block_134b:                                         ; 0x134b
  %v30 = load i64, i64* %var_30, align 8
  %v28 = add i64 %v30, 1
  store i64 %v28, i64* %var_28, align 8
  %v28_2 = load i64, i64* %var_28, align 8
  %v40B = load i64, i64* %var_40, align 8
  %condB = icmp uge i64 %v28_2, %v40B
  br i1 %condB, label %loc_1395, label %block_1361

block_1361:                                         ; 0x1361..0x138d
  %base7 = load i32*, i32** %arr.addr, align 8
  %ridx2 = load i64, i64* %var_28, align 8
  %rptr2 = getelementptr inbounds i32, i32* %base7, i64 %ridx2
  %rval2 = load i32, i32* %rptr2, align 4
  %base8 = load i32*, i32** %arr.addr, align 8
  %lidx2 = load i64, i64* %var_30, align 8
  %lptr2 = getelementptr inbounds i32, i32* %base8, i64 %lidx2
  %lval2 = load i32, i32* %lptr2, align 4
  %cmp_le2 = icmp sle i32 %rval2, %lval2
  br i1 %cmp_le2, label %loc_1395, label %block_138f

block_138f:                                         ; 0x138f..0x1393
  %v28_forphi = load i64, i64* %var_28, align 8
  br label %loc_1399

loc_1395:                                           ; 0x1395
  %v30_forphi = load i64, i64* %var_30, align 8
  br label %loc_1399

loc_1399:                                           ; 0x1399
  %chosen2 = phi i64 [ %v28_forphi, %block_138f ], [ %v30_forphi, %loc_1395 ]
  store i64 %chosen2, i64* %var_20, align 8
  %base9 = load i32*, i32** %arr.addr, align 8
  %idx38 = load i64, i64* %var_38, align 8
  %p38 = getelementptr inbounds i32, i32* %base9, i64 %idx38
  %val38 = load i32, i32* %p38, align 4
  %base10 = load i32*, i32** %arr.addr, align 8
  %idx20 = load i64, i64* %var_20, align 8
  %p20 = getelementptr inbounds i32, i32* %base10, i64 %idx20
  %val20 = load i32, i32* %p20, align 4
  %cmp_ge3 = icmp sge i32 %val38, %val20
  br i1 %cmp_ge3, label %loc_1435, label %block_13cb

block_13cb:                                         ; 0x13cb..0x142d
  store i32 %val38, i32* %var_58, align 4
  store i32 %val20, i32* %p38, align 4
  %tmp58 = load i32, i32* %var_58, align 4
  store i32 %tmp58, i32* %p20, align 4
  store i64 %idx20, i64* %var_38, align 8
  br label %loc_132E

loc_1432:                                           ; 0x1432
  br label %loc_1436

loc_1435:                                           ; 0x1435
  br label %loc_1436

loc_1436:                                           ; 0x1436
  %v40C = load i64, i64* %var_40, align 8
  %dec = add i64 %v40C, -1
  store i64 %dec, i64* %var_40, align 8
  br label %loc_143B

loc_143B:                                           ; 0x143b
  %v40D = load i64, i64* %var_40, align 8
  %cond_end = icmp ne i64 %v40D, 0
  br i1 %cond_end, label %loc_12EA, label %addr_1446

addr_1446:                                          ; 0x1446
  br label %loc_1449

loc_1449:                                           ; 0x1449
  ret void
}