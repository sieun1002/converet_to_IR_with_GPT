; ModuleID = 'heap_sort'
target triple = "x86_64-pc-linux-gnu"

define void @heap_sort(i32* %arr, i64 %n) {
entry:
  %arr.slot = alloca i32*, align 8
  %n.slot = alloca i64, align 8
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
  store i32* %arr, i32** %arr.slot, align 8
  store i64 %n, i64* %n.slot, align 8
  %n.cmp1 = icmp ule i64 %n, 1
  br i1 %n.cmp1, label %loc_1448, label %init

init:
  %n.load1 = load i64, i64* %n.slot, align 8
  %shr = lshr i64 %n.load1, 1
  store i64 %shr, i64* %var50, align 8
  br label %loc_12C4

loc_11B4:
  %i.load = load i64, i64* %var50, align 8
  store i64 %i.load, i64* %var48, align 8
  br label %loc_11BC

loc_11BC:
  %j.load = load i64, i64* %var48, align 8
  %twice = shl i64 %j.load, 1
  %childL = add i64 %twice, 1
  store i64 %childL, i64* %var18, align 8
  %childL.load = load i64, i64* %var18, align 8
  %n.load2 = load i64, i64* %n.slot, align 8
  %cmp_child_in = icmp uge i64 %childL.load, %n.load2
  br i1 %cmp_child_in, label %loc_12C0, label %cont_11D9

cont_11D9:
  %leftidx = load i64, i64* %var18, align 8
  %rightidx = add i64 %leftidx, 1
  store i64 %rightidx, i64* %var10, align 8
  %rightidx2 = load i64, i64* %var10, align 8
  %n.load3 = load i64, i64* %n.slot, align 8
  %cmp_right_in = icmp uge i64 %rightidx2, %n.load3
  br i1 %cmp_right_in, label %loc_1223, label %cont_11EF

cont_11EF:
  %arr.ptr1 = load i32*, i32** %arr.slot, align 8
  %rightidx3 = load i64, i64* %var10, align 8
  %gep.right = getelementptr inbounds i32, i32* %arr.ptr1, i64 %rightidx3
  %val.right = load i32, i32* %gep.right, align 4
  %arr.ptr2 = load i32*, i32** %arr.slot, align 8
  %leftidx2 = load i64, i64* %var18, align 8
  %gep.left = getelementptr inbounds i32, i32* %arr.ptr2, i64 %leftidx2
  %val.left = load i32, i32* %gep.left, align 4
  %cmp_right_gt_left = icmp sgt i32 %val.right, %val.left
  br i1 %cmp_right_gt_left, label %loc_1227, label %loc_1223

loc_1223:
  %lidx = load i64, i64* %var18, align 8
  br label %loc_1227

loc_1227:
  %selidx = phi i64 [ %rightidx2, %cont_11EF ], [ %lidx, %loc_1223 ]
  store i64 %selidx, i64* %var8, align 8
  %arr.ptr3 = load i32*, i32** %arr.slot, align 8
  %jidx = load i64, i64* %var48, align 8
  %gep.j = getelementptr inbounds i32, i32* %arr.ptr3, i64 %jidx
  %val.j = load i32, i32* %gep.j, align 4
  %arr.ptr4 = load i32*, i32** %arr.slot, align 8
  %selidx2 = load i64, i64* %var8, align 8
  %gep.sel = getelementptr inbounds i32, i32* %arr.ptr4, i64 %selidx2
  %val.sel = load i32, i32* %gep.sel, align 4
  %cmp_j_ge_sel = icmp sge i32 %val.j, %val.sel
  br i1 %cmp_j_ge_sel, label %loc_12C3, label %do_swap_1259

do_swap_1259:
  store i32 %val.j, i32* %var54, align 4
  %arr.ptr5 = load i32*, i32** %arr.slot, align 8
  %jidx2 = load i64, i64* %var48, align 8
  %gep.j2 = getelementptr inbounds i32, i32* %arr.ptr5, i64 %jidx2
  store i32 %val.sel, i32* %gep.j2, align 4
  %arr.ptr6 = load i32*, i32** %arr.slot, align 8
  %selidx3 = load i64, i64* %var8, align 8
  %gep.sel2 = getelementptr inbounds i32, i32* %arr.ptr6, i64 %selidx3
  %saved = load i32, i32* %var54, align 4
  store i32 %saved, i32* %gep.sel2, align 4
  %selidx4 = load i64, i64* %var8, align 8
  store i64 %selidx4, i64* %var48, align 8
  br label %loc_11BC

loc_12C0:
  br label %loc_12C4

loc_12C3:
  br label %loc_12C4

loc_12C4:
  %old = load i64, i64* %var50, align 8
  %dec = add i64 %old, -1
  store i64 %dec, i64* %var50, align 8
  %cond = icmp ne i64 %old, 0
  br i1 %cond, label %loc_11B4, label %after_heapify

after_heapify:
  %n.load4 = load i64, i64* %n.slot, align 8
  %nminus1 = add i64 %n.load4, -1
  store i64 %nminus1, i64* %var40, align 8
  br label %loc_143B

loc_12EA:
  %arr.base = load i32*, i32** %arr.slot, align 8
  %a0ptr = getelementptr inbounds i32, i32* %arr.base, i64 0
  %a0 = load i32, i32* %a0ptr, align 4
  store i32 %a0, i32* %var5C, align 4
  %hsize = load i64, i64* %var40, align 8
  %arr.base2 = load i32*, i32** %arr.slot, align 8
  %endptr = getelementptr inbounds i32, i32* %arr.base2, i64 %hsize
  %endval = load i32, i32* %endptr, align 4
  %arr.base3 = load i32*, i32** %arr.slot, align 8
  store i32 %endval, i32* %arr.base3, align 4
  %arr.base4 = load i32*, i32** %arr.slot, align 8
  %endptr2 = getelementptr inbounds i32, i32* %arr.base4, i64 %hsize
  %saved0 = load i32, i32* %var5C, align 4
  store i32 %saved0, i32* %endptr2, align 4
  store i64 0, i64* %var38, align 8
  br label %loc_132E

loc_132E:
  %i0 = load i64, i64* %var38, align 8
  %twice2 = shl i64 %i0, 1
  %child = add i64 %twice2, 1
  store i64 %child, i64* %var30, align 8
  %child.load = load i64, i64* %var30, align 8
  %hsize2 = load i64, i64* %var40, align 8
  %cmp_child_out = icmp uge i64 %child.load, %hsize2
  br i1 %cmp_child_out, label %loc_1432, label %cont_134B

cont_134B:
  %childL2 = load i64, i64* %var30, align 8
  %right2 = add i64 %childL2, 1
  store i64 %right2, i64* %var28, align 8
  %right.load = load i64, i64* %var28, align 8
  %hsize3 = load i64, i64* %var40, align 8
  %cmp_right_out = icmp uge i64 %right.load, %hsize3
  br i1 %cmp_right_out, label %loc_1395, label %cont_1361

cont_1361:
  %arr.p1 = load i32*, i32** %arr.slot, align 8
  %ridx = load i64, i64* %var28, align 8
  %gep.r = getelementptr inbounds i32, i32* %arr.p1, i64 %ridx
  %v.r = load i32, i32* %gep.r, align 4
  %arr.p2 = load i32*, i32** %arr.slot, align 8
  %lidx2 = load i64, i64* %var30, align 8
  %gep.l = getelementptr inbounds i32, i32* %arr.p2, i64 %lidx2
  %v.l = load i32, i32* %gep.l, align 4
  %cmp_r_gt_l = icmp sgt i32 %v.r, %v.l
  br i1 %cmp_r_gt_l, label %loc_1399, label %loc_1395

loc_1395:
  %lidx3 = load i64, i64* %var30, align 8
  br label %loc_1399

loc_1399:
  %sel2 = phi i64 [ %right.load, %cont_1361 ], [ %lidx3, %loc_1395 ]
  store i64 %sel2, i64* %var20, align 8
  %arr.p3 = load i32*, i32** %arr.slot, align 8
  %iidx = load i64, i64* %var38, align 8
  %gep.i = getelementptr inbounds i32, i32* %arr.p3, i64 %iidx
  %v.i = load i32, i32* %gep.i, align 4
  %arr.p4 = load i32*, i32** %arr.slot, align 8
  %selidx5 = load i64, i64* %var20, align 8
  %gep.s2 = getelementptr inbounds i32, i32* %arr.p4, i64 %selidx5
  %v.s = load i32, i32* %gep.s2, align 4
  %cmp_i_ge_s = icmp sge i32 %v.i, %v.s
  br i1 %cmp_i_ge_s, label %loc_1435, label %do_swap_13CB

do_swap_13CB:
  store i32 %v.i, i32* %var58, align 4
  %arr.p5 = load i32*, i32** %arr.slot, align 8
  %selidx6 = load i64, i64* %var20, align 8
  %gep.sel3 = getelementptr inbounds i32, i32* %arr.p5, i64 %selidx6
  %val.sel3 = load i32, i32* %gep.sel3, align 4
  %arr.p6 = load i32*, i32** %arr.slot, align 8
  %iidx2 = load i64, i64* %var38, align 8
  %gep.i2 = getelementptr inbounds i32, i32* %arr.p6, i64 %iidx2
  store i32 %val.sel3, i32* %gep.i2, align 4
  %arr.p7 = load i32*, i32** %arr.slot, align 8
  %selidx7 = load i64, i64* %var20, align 8
  %gep.sel4 = getelementptr inbounds i32, i32* %arr.p7, i64 %selidx7
  %saved2 = load i32, i32* %var58, align 4
  store i32 %saved2, i32* %gep.sel4, align 4
  %newi = load i64, i64* %var20, align 8
  store i64 %newi, i64* %var38, align 8
  br label %loc_132E

loc_1432:
  br label %loc_1436

loc_1435:
  br label %loc_1436

loc_1436:
  %hsize4 = load i64, i64* %var40, align 8
  %hdec = add i64 %hsize4, -1
  store i64 %hdec, i64* %var40, align 8
  br label %loc_143B

loc_143B:
  %hsize5 = load i64, i64* %var40, align 8
  %cmp_h_nonzero = icmp ne i64 %hsize5, 0
  br i1 %cmp_h_nonzero, label %loc_12EA, label %loc_1449

loc_1448:
  br label %loc_1449

loc_1449:
  ret void
}