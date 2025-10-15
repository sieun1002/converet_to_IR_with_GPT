; ModuleID = 'quick_sort_module'
target triple = "x86_64-pc-windows-msvc"

define void @quick_sort(i32* %arg0, i32 %arg8, i32 %arg10) {
entry:
  %arg0.addr = alloca i32*, align 8
  %arg8.addr = alloca i32, align 4
  %arg10.addr = alloca i32, align 4
  %var4 = alloca i32, align 4
  %var8 = alloca i32, align 4
  %varC = alloca i32, align 4
  %var10 = alloca i32, align 4
  store i32* %arg0, i32** %arg0.addr, align 8
  store i32 %arg8, i32* %arg8.addr, align 4
  store i32 %arg10, i32* %arg10.addr, align 4
  br label %b15B7

b1468:                                            ; preds = %b15B7
  %low1 = load i32, i32* %arg8.addr, align 4
  store i32 %low1, i32* %var4, align 4
  %high1 = load i32, i32* %arg10.addr, align 4
  store i32 %high1, i32* %var8, align 4
  %h2 = load i32, i32* %arg10.addr, align 4
  %l2 = load i32, i32* %arg8.addr, align 4
  %d = sub i32 %h2, %l2
  %msb = lshr i32 %d, 31
  %sum = add i32 %d, %msb
  %half = ashr i32 %sum, 1
  %mid = add i32 %l2, %half
  %mid64 = sext i32 %mid to i64
  %base = load i32*, i32** %arg0.addr, align 8
  %elem = getelementptr inbounds i32, i32* %base, i64 %mid64
  %pivot = load i32, i32* %elem, align 4
  store i32 %pivot, i32* %varC, align 4
  br label %b14A6

b14A2:                                            ; preds = %b14A6
  %i_lo = load i32, i32* %var4, align 4
  %i_inc = add i32 %i_lo, 1
  store i32 %i_inc, i32* %var4, align 4
  br label %b14A6

b14A6:                                            ; preds = %b1551, %b14A2, %b1468
  %i2 = load i32, i32* %var4, align 4
  %i2_64 = sext i32 %i2 to i64
  %base2 = load i32*, i32** %arg0.addr, align 8
  %ptr_i = getelementptr inbounds i32, i32* %base2, i64 %i2_64
  %ai = load i32, i32* %ptr_i, align 4
  %pivot2 = load i32, i32* %varC, align 4
  %cmp_i = icmp sgt i32 %pivot2, %ai
  br i1 %cmp_i, label %b14A2, label %b14C7

b14C3:                                            ; preds = %b14C7
  %j_lo = load i32, i32* %var8, align 4
  %j_dec = add i32 %j_lo, -1
  store i32 %j_dec, i32* %var8, align 4
  br label %b14C7

b14C7:                                            ; preds = %b14A6, %b14C3
  %j2 = load i32, i32* %var8, align 4
  %j2_64 = sext i32 %j2 to i64
  %base3 = load i32*, i32** %arg0.addr, align 8
  %ptr_j = getelementptr inbounds i32, i32* %base3, i64 %j2_64
  %aj = load i32, i32* %ptr_j, align 4
  %pivot3 = load i32, i32* %varC, align 4
  %cmp_j = icmp slt i32 %pivot3, %aj
  br i1 %cmp_j, label %b14C3, label %bAfterCmpJ

bAfterCmpJ:                                       ; preds = %b14C7
  %i3 = load i32, i32* %var4, align 4
  %j3 = load i32, i32* %var8, align 4
  %cmp_i_gt_j = icmp sgt i32 %i3, %j3
  br i1 %cmp_i_gt_j, label %b1551, label %b14EA

b14EA:                                            ; preds = %bAfterCmpJ
  %i4 = load i32, i32* %var4, align 4
  %i4_64 = sext i32 %i4 to i64
  %base4 = load i32*, i32** %arg0.addr, align 8
  %ptr_i4 = getelementptr inbounds i32, i32* %base4, i64 %i4_64
  %ai4 = load i32, i32* %ptr_i4, align 4
  store i32 %ai4, i32* %var10, align 4
  %j4 = load i32, i32* %var8, align 4
  %j4_64 = sext i32 %j4 to i64
  %base5 = load i32*, i32** %arg0.addr, align 8
  %ptr_j4 = getelementptr inbounds i32, i32* %base5, i64 %j4_64
  %aj4 = load i32, i32* %ptr_j4, align 4
  %i5 = load i32, i32* %var4, align 4
  %i5_64 = sext i32 %i5 to i64
  %base6 = load i32*, i32** %arg0.addr, align 8
  %ptr_i5 = getelementptr inbounds i32, i32* %base6, i64 %i5_64
  store i32 %aj4, i32* %ptr_i5, align 4
  %j5 = load i32, i32* %var8, align 4
  %j5_64 = sext i32 %j5 to i64
  %base7 = load i32*, i32** %arg0.addr, align 8
  %ptr_j5 = getelementptr inbounds i32, i32* %base7, i64 %j5_64
  %temp = load i32, i32* %var10, align 4
  store i32 %temp, i32* %ptr_j5, align 4
  %i6 = load i32, i32* %var4, align 4
  %i6_inc = add i32 %i6, 1
  store i32 %i6_inc, i32* %var4, align 4
  %j6 = load i32, i32* %var8, align 4
  %j6_dec = add i32 %j6, -1
  store i32 %j6_dec, i32* %var8, align 4
  br label %b1551

b1551:                                            ; preds = %b14EA, %bAfterCmpJ
  %i7 = load i32, i32* %var4, align 4
  %j7 = load i32, i32* %var8, align 4
  %cmp_le_ij = icmp sle i32 %i7, %j7
  br i1 %cmp_le_ij, label %b14A6, label %b155D

b155D:                                            ; preds = %b1551
  %j8 = load i32, i32* %var8, align 4
  %low8 = load i32, i32* %arg8.addr, align 4
  %edx = sub i32 %j8, %low8
  %high8 = load i32, i32* %arg10.addr, align 4
  %i8 = load i32, i32* %var4, align 4
  %eax = sub i32 %high8, %i8
  %cmp_sizes = icmp sge i32 %edx, %eax
  br i1 %cmp_sizes, label %b1594, label %b156F

b156F:                                            ; preds = %b155D
  %low9 = load i32, i32* %arg8.addr, align 4
  %j9 = load i32, i32* %var8, align 4
  %cmp_low_ge_j = icmp sge i32 %low9, %j9
  br i1 %cmp_low_ge_j, label %b158C, label %b1577

b1577:                                            ; preds = %b156F
  %ecx_call1 = load i32, i32* %var8, align 4
  %edx_call1 = load i32, i32* %arg8.addr, align 4
  %base_call1 = load i32*, i32** %arg0.addr, align 8
  call void @quick_sort(i32* %base_call1, i32 %edx_call1, i32 %ecx_call1)
  br label %b158C

b158C:                                            ; preds = %b1577, %b156F
  %i10 = load i32, i32* %var4, align 4
  store i32 %i10, i32* %arg8.addr, align 4
  br label %b15B7

b1594:                                            ; preds = %b155D
  %i11 = load i32, i32* %var4, align 4
  %high11 = load i32, i32* %arg10.addr, align 4
  %cmp_i_ge_high = icmp sge i32 %i11, %high11
  br i1 %cmp_i_ge_high, label %b15B1, label %b159C

b159C:                                            ; preds = %b1594
  %ecx_call2 = load i32, i32* %arg10.addr, align 4
  %edx_call2 = load i32, i32* %var4, align 4
  %base_call2 = load i32*, i32** %arg0.addr, align 8
  call void @quick_sort(i32* %base_call2, i32 %edx_call2, i32 %ecx_call2)
  br label %b15B1

b15B1:                                            ; preds = %b159C, %b1594
  %j12 = load i32, i32* %var8, align 4
  store i32 %j12, i32* %arg10.addr, align 4
  br label %b15B7

b15B7:                                            ; preds = %b15B1, %b158C, %entry
  %low_top = load i32, i32* %arg8.addr, align 4
  %high_top = load i32, i32* %arg10.addr, align 4
  %cmp_top = icmp slt i32 %low_top, %high_top
  br i1 %cmp_top, label %b1468, label %bRet

bRet:                                             ; preds = %b15B7
  ret void
}