; ModuleID = 'quick_sort_module'
target triple = "x86_64-pc-windows-msvc"

define void @quick_sort(i32* %arr, i32 %left, i32 %right) {
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

outer.cond:
  %l.cur = load i32, i32* %left.addr, align 4
  %r.cur = load i32, i32* %right.addr, align 4
  %cmp.outer = icmp slt i32 %l.cur, %r.cur
  br i1 %cmp.outer, label %outer.body, label %return

outer.body:
  store i32 %l.cur, i32* %i, align 4
  store i32 %r.cur, i32* %j, align 4
  %arr.ptr = load i32*, i32** %arr.addr, align 8
  %diff = sub i32 %r.cur, %l.cur
  %sign = lshr i32 %diff, 31
  %tmpadd = add i32 %diff, %sign
  %half = ashr i32 %tmpadd, 1
  %mid = add i32 %l.cur, %half
  %mid64 = sext i32 %mid to i64
  %midptr = getelementptr inbounds i32, i32* %arr.ptr, i64 %mid64
  %midval = load i32, i32* %midptr, align 4
  store i32 %midval, i32* %pivot, align 4
  br label %left.scan

left.scan:
  %i.val = load i32, i32* %i, align 4
  %i64 = sext i32 %i.val to i64
  %arr.ptr2 = load i32*, i32** %arr.addr, align 8
  %iptr = getelementptr inbounds i32, i32* %arr.ptr2, i64 %i64
  %ival = load i32, i32* %iptr, align 4
  %pivot.val = load i32, i32* %pivot, align 4
  %cmp.left = icmp slt i32 %ival, %pivot.val
  br i1 %cmp.left, label %inc.i, label %right.scan

inc.i:
  %i.val1 = load i32, i32* %i, align 4
  %i.inc = add i32 %i.val1, 1
  store i32 %i.inc, i32* %i, align 4
  br label %left.scan

right.scan:
  %j.val = load i32, i32* %j, align 4
  %j64 = sext i32 %j.val to i64
  %arr.ptr3 = load i32*, i32** %arr.addr, align 8
  %jptr = getelementptr inbounds i32, i32* %arr.ptr3, i64 %j64
  %jval = load i32, i32* %jptr, align 4
  %pivot.val2 = load i32, i32* %pivot, align 4
  %cmp.right = icmp sgt i32 %jval, %pivot.val2
  br i1 %cmp.right, label %dec.j, label %compare.ij

dec.j:
  %j.val1 = load i32, i32* %j, align 4
  %j.dec = add i32 %j.val1, -1
  store i32 %j.dec, i32* %j, align 4
  br label %right.scan

compare.ij:
  %i.val2 = load i32, i32* %i, align 4
  %j.val2 = load i32, i32* %j, align 4
  %cmp.ij = icmp sgt i32 %i.val2, %j.val2
  br i1 %cmp.ij, label %partition.decide, label %do.swap

do.swap:
  %i.val3 = load i32, i32* %i, align 4
  %i64b = sext i32 %i.val3 to i64
  %arr.ptr4 = load i32*, i32** %arr.addr, align 8
  %iptr2 = getelementptr inbounds i32, i32* %arr.ptr4, i64 %i64b
  %ival2 = load i32, i32* %iptr2, align 4
  store i32 %ival2, i32* %tmp, align 4
  %j.val3 = load i32, i32* %j, align 4
  %j64b = sext i32 %j.val3 to i64
  %arr.ptr5 = load i32*, i32** %arr.addr, align 8
  %jptr2 = getelementptr inbounds i32, i32* %arr.ptr5, i64 %j64b
  %jval2 = load i32, i32* %jptr2, align 4
  store i32 %jval2, i32* %iptr2, align 4
  %tmp.val = load i32, i32* %tmp, align 4
  store i32 %tmp.val, i32* %jptr2, align 4
  %i.val4 = load i32, i32* %i, align 4
  %i.inc2 = add i32 %i.val4, 1
  store i32 %i.inc2, i32* %i, align 4
  %j.val4 = load i32, i32* %j, align 4
  %j.dec2 = add i32 %j.val4, -1
  store i32 %j.dec2, i32* %j, align 4
  br label %recheck

recheck:
  %i.val5 = load i32, i32* %i, align 4
  %j.val5 = load i32, i32* %j, align 4
  %cmp.re = icmp sle i32 %i.val5, %j.val5
  br i1 %cmp.re, label %left.scan, label %partition.decide

partition.decide:
  %l.cur2 = load i32, i32* %left.addr, align 4
  %r.cur2 = load i32, i32* %right.addr, align 4
  %j.end = load i32, i32* %j, align 4
  %i.end = load i32, i32* %i, align 4
  %leftSize = sub i32 %j.end, %l.cur2
  %rightSize = sub i32 %r.cur2, %i.end
  %cmp.side = icmp sge i32 %leftSize, %rightSize
  br i1 %cmp.side, label %right.first, label %left.first

left.first:
  %l.cur3 = load i32, i32* %left.addr, align 4
  %j.end2 = load i32, i32* %j, align 4
  %need.left = icmp slt i32 %l.cur3, %j.end2
  br i1 %need.left, label %call.left, label %skip.left

call.left:
  %arr.callL = load i32*, i32** %arr.addr, align 8
  call void @quick_sort(i32* %arr.callL, i32 %l.cur3, i32 %j.end2)
  br label %after.leftcall

skip.left:
  br label %after.leftcall

after.leftcall:
  %i.end2 = load i32, i32* %i, align 4
  store i32 %i.end2, i32* %left.addr, align 4
  br label %outer.cond

right.first:
  %i.end3 = load i32, i32* %i, align 4
  %r.cur3 = load i32, i32* %right.addr, align 4
  %need.right = icmp slt i32 %i.end3, %r.cur3
  br i1 %need.right, label %call.right, label %skip.right

call.right:
  %arr.callR = load i32*, i32** %arr.addr, align 8
  call void @quick_sort(i32* %arr.callR, i32 %i.end3, i32 %r.cur3)
  br label %after.rightcall

skip.right:
  br label %after.rightcall

after.rightcall:
  %j.end3 = load i32, i32* %j, align 4
  store i32 %j.end3, i32* %right.addr, align 4
  br label %outer.cond

return:
  ret void
}