; ModuleID = 'quicksort_module'
source_filename = "quicksort_module"
target triple = "x86_64-pc-windows-msvc"

define dso_local void @quick_sort(i32* %arr, i32 %left, i32 %right) {
entry:
  %arr.addr = alloca i32*, align 8
  %left.addr = alloca i32, align 4
  %right.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %pivot = alloca i32, align 4
  %tmp = alloca i32, align 4
  store i32* %arr, i32** %arr.addr, align 8
  store i32 %left, i32* %left.addr, align 4
  store i32 %right, i32* %right.addr, align 4
  br label %outer.cond

outer.cond:                                         ; preds = %skip.right, %skip.left, %entry
  %left1 = load i32, i32* %left.addr, align 4
  %right1 = load i32, i32* %right.addr, align 4
  %cmp0 = icmp slt i32 %left1, %right1
  br i1 %cmp0, label %outer.body, label %exit

outer.body:                                         ; preds = %outer.cond
  store i32 %left1, i32* %i, align 4
  store i32 %right1, i32* %j, align 4
  %right2 = load i32, i32* %right.addr, align 4
  %left2 = load i32, i32* %left.addr, align 4
  %diff = sub nsw i32 %right2, %left2
  %half = sdiv i32 %diff, 2
  %mid = add nsw i32 %left2, %half
  %arrp = load i32*, i32** %arr.addr, align 8
  %mid.ext = sext i32 %mid to i64
  %gepp = getelementptr inbounds i32, i32* %arrp, i64 %mid.ext
  %midval = load i32, i32* %gepp, align 4
  store i32 %midval, i32* %pivot, align 4
  br label %partition.header

partition.header:                                   ; preds = %do.swap, %outer.body
  %i0 = load i32, i32* %i, align 4
  %j0 = load i32, i32* %j, align 4
  %cmpij = icmp sle i32 %i0, %j0
  br i1 %cmpij, label %scan.i.head, label %after.partition

scan.i.head:                                        ; preds = %inc.i, %partition.header
  %i1 = load i32, i32* %i, align 4
  %arrp2 = load i32*, i32** %arr.addr, align 8
  %i1ext = sext i32 %i1 to i64
  %ptr_i = getelementptr inbounds i32, i32* %arrp2, i64 %i1ext
  %vi = load i32, i32* %ptr_i, align 4
  %piv = load i32, i32* %pivot, align 4
  %cmplt = icmp slt i32 %vi, %piv
  br i1 %cmplt, label %inc.i, label %scan.j.head

inc.i:                                              ; preds = %scan.i.head
  %i2 = load i32, i32* %i, align 4
  %i3 = add nsw i32 %i2, 1
  store i32 %i3, i32* %i, align 4
  br label %scan.i.head

scan.j.head:                                        ; preds = %scan.i.head, %dec.j
  %j1 = load i32, i32* %j, align 4
  %arrp3 = load i32*, i32** %arr.addr, align 8
  %j1ext = sext i32 %j1 to i64
  %ptr_j = getelementptr inbounds i32, i32* %arrp3, i64 %j1ext
  %vj = load i32, i32* %ptr_j, align 4
  %piv2 = load i32, i32* %pivot, align 4
  %cmpgt = icmp sgt i32 %vj, %piv2
  br i1 %cmpgt, label %dec.j, label %check.swap

dec.j:                                              ; preds = %scan.j.head
  %j2 = load i32, i32* %j, align 4
  %j3 = add nsw i32 %j2, -1
  store i32 %j3, i32* %j, align 4
  br label %scan.j.head

check.swap:                                         ; preds = %scan.j.head
  %i4 = load i32, i32* %i, align 4
  %j4 = load i32, i32* %j, align 4
  %cmpij2 = icmp sle i32 %i4, %j4
  br i1 %cmpij2, label %do.swap, label %after.partition

do.swap:                                            ; preds = %check.swap
  %arrps = load i32*, i32** %arr.addr, align 8
  %i4ext = sext i32 %i4 to i64
  %ptr_i2 = getelementptr inbounds i32, i32* %arrps, i64 %i4ext
  %vali = load i32, i32* %ptr_i2, align 4
  store i32 %vali, i32* %tmp, align 4
  %j4ext = sext i32 %j4 to i64
  %ptr_j2 = getelementptr inbounds i32, i32* %arrps, i64 %j4ext
  %valj = load i32, i32* %ptr_j2, align 4
  store i32 %valj, i32* %ptr_i2, align 4
  %tmpv = load i32, i32* %tmp, align 4
  store i32 %tmpv, i32* %ptr_j2, align 4
  %i5 = add nsw i32 %i4, 1
  store i32 %i5, i32* %i, align 4
  %j5 = add nsw i32 %j4, -1
  store i32 %j5, i32* %j, align 4
  br label %partition.header

after.partition:                                    ; preds = %check.swap, %partition.header
  %j6 = load i32, i32* %j, align 4
  %left3 = load i32, i32* %left.addr, align 4
  %left_size = sub nsw i32 %j6, %left3
  %right3 = load i32, i32* %right.addr, align 4
  %i6 = load i32, i32* %i, align 4
  %right_size = sub nsw i32 %right3, %i6
  %cmpSizes = icmp sge i32 %left_size, %right_size
  br i1 %cmpSizes, label %recurse.right.first, label %recurse.left.first

recurse.left.first:                                 ; preds = %after.partition
  %left4 = load i32, i32* %left.addr, align 4
  %j7 = load i32, i32* %j, align 4
  %condL = icmp slt i32 %left4, %j7
  br i1 %condL, label %call.left, label %skip.left

call.left:                                          ; preds = %recurse.left.first
  %arrL = load i32*, i32** %arr.addr, align 8
  call void @quick_sort(i32* %arrL, i32 %left4, i32 %j7)
  br label %skip.left

skip.left:                                          ; preds = %call.left, %recurse.left.first
  %i7 = load i32, i32* %i, align 4
  store i32 %i7, i32* %left.addr, align 4
  br label %outer.cond

recurse.right.first:                                ; preds = %after.partition
  %i8 = load i32, i32* %i, align 4
  %right4 = load i32, i32* %right.addr, align 4
  %condR = icmp slt i32 %i8, %right4
  br i1 %condR, label %call.right, label %skip.right

call.right:                                         ; preds = %recurse.right.first
  %arrR = load i32*, i32** %arr.addr, align 8
  call void @quick_sort(i32* %arrR, i32 %i8, i32 %right4)
  br label %skip.right

skip.right:                                         ; preds = %call.right, %recurse.right.first
  %j8 = load i32, i32* %j, align 4
  store i32 %j8, i32* %right.addr, align 4
  br label %outer.cond

exit:                                               ; preds = %outer.cond
  ret void
}