; ModuleID = 'quick_sort.ll'
target triple = "x86_64-pc-linux-gnu"

define dso_local void @quick_sort(i32* %arr, i64 %left, i64 %right) {
entry:
  %arr.addr = alloca i32*, align 8
  %left.addr = alloca i64, align 8
  %right.addr = alloca i64, align 8
  %i.addr = alloca i64, align 8
  %j.addr = alloca i64, align 8
  %pivot = alloca i32, align 4
  %tmp = alloca i32, align 4
  store i32* %arr, i32** %arr.addr, align 8
  store i64 %left, i64* %left.addr, align 8
  store i64 %right, i64* %right.addr, align 8
  br label %while.header

while.header:                                    ; preds = %skip.right, %skip.left, %entry
  %left.cur = load i64, i64* %left.addr, align 8
  %right.cur = load i64, i64* %right.addr, align 8
  %cmp = icmp slt i64 %left.cur, %right.cur
  br i1 %cmp, label %loop.body, label %exit

loop.body:                                       ; preds = %while.header
  store i64 %left.cur, i64* %i.addr, align 8
  store i64 %right.cur, i64* %j.addr, align 8
  %diff = sub i64 %right.cur, %left.cur
  %sign = lshr i64 %diff, 63
  %sum = add i64 %diff, %sign
  %half = ashr i64 %sum, 1
  %mid = add i64 %left.cur, %half
  %arr.ptr0 = load i32*, i32** %arr.addr, align 8
  %pivot.ptr = getelementptr inbounds i32, i32* %arr.ptr0, i64 %mid
  %pivot.val = load i32, i32* %pivot.ptr, align 4
  store i32 %pivot.val, i32* %pivot, align 4
  br label %part.l1

part.l1:                                          ; preds = %inc.i, %loop.body
  %i.val0 = load i64, i64* %i.addr, align 8
  %arr.ptr1 = load i32*, i32** %arr.addr, align 8
  %elem.ptr.i = getelementptr inbounds i32, i32* %arr.ptr1, i64 %i.val0
  %elem.i = load i32, i32* %elem.ptr.i, align 4
  %pivot.cur0 = load i32, i32* %pivot, align 4
  %cmp.piv.gt = icmp sgt i32 %pivot.cur0, %elem.i
  br i1 %cmp.piv.gt, label %inc.i, label %part.l2

inc.i:                                            ; preds = %part.l1
  %i.next = add i64 %i.val0, 1
  store i64 %i.next, i64* %i.addr, align 8
  br label %part.l1

part.l2:                                          ; preds = %part.l1, %dec.j
  %j.val0 = load i64, i64* %j.addr, align 8
  %arr.ptr2 = load i32*, i32** %arr.addr, align 8
  %elem.ptr.j = getelementptr inbounds i32, i32* %arr.ptr2, i64 %j.val0
  %elem.j = load i32, i32* %elem.ptr.j, align 4
  %pivot.cur1 = load i32, i32* %pivot, align 4
  %cmp.piv.lt = icmp slt i32 %pivot.cur1, %elem.j
  br i1 %cmp.piv.lt, label %dec.j, label %part.compare

dec.j:                                            ; preds = %part.l2
  %j.next = add i64 %j.val0, -1
  store i64 %j.next, i64* %j.addr, align 8
  br label %part.l2

part.compare:                                     ; preds = %part.l2
  %i.val1 = load i64, i64* %i.addr, align 8
  %j.val1 = load i64, i64* %j.addr, align 8
  %cmp.ilej = icmp sle i64 %i.val1, %j.val1
  br i1 %cmp.ilej, label %do.swap, label %part.done

do.swap:                                          ; preds = %part.compare
  %arr.ptr3 = load i32*, i32** %arr.addr, align 8
  %iptr = getelementptr inbounds i32, i32* %arr.ptr3, i64 %i.val1
  %ival = load i32, i32* %iptr, align 4
  store i32 %ival, i32* %tmp, align 4
  %arr.ptr4 = load i32*, i32** %arr.addr, align 8
  %jptr = getelementptr inbounds i32, i32* %arr.ptr4, i64 %j.val1
  %jval = load i32, i32* %jptr, align 4
  store i32 %jval, i32* %iptr, align 4
  %tmpval = load i32, i32* %tmp, align 4
  store i32 %tmpval, i32* %jptr, align 4
  %i.inc2 = add i64 %i.val1, 1
  store i64 %i.inc2, i64* %i.addr, align 8
  %j.dec2 = add i64 %j.val1, -1
  store i64 %j.dec2, i64* %j.addr, align 8
  br label %part.l1

part.done:                                        ; preds = %part.compare
  %i.end = load i64, i64* %i.addr, align 8
  %j.end = load i64, i64* %j.addr, align 8
  %left.now = load i64, i64* %left.addr, align 8
  %right.now = load i64, i64* %right.addr, align 8
  %left.size = sub i64 %j.end, %left.now
  %right.size = sub i64 %right.now, %i.end
  %cmp.leftlt = icmp slt i64 %left.size, %right.size
  br i1 %cmp.leftlt, label %recurse.left, label %recurse.right

recurse.left:                                     ; preds = %part.done
  %need.left = icmp slt i64 %left.now, %j.end
  br i1 %need.left, label %call.left, label %skip.left

call.left:                                        ; preds = %recurse.left
  %arr.ptr5 = load i32*, i32** %arr.addr, align 8
  call void @quick_sort(i32* %arr.ptr5, i64 %left.now, i64 %j.end)
  br label %skip.left

skip.left:                                        ; preds = %call.left, %recurse.left
  store i64 %i.end, i64* %left.addr, align 8
  br label %while.header

recurse.right:                                    ; preds = %part.done
  %need.right = icmp slt i64 %i.end, %right.now
  br i1 %need.right, label %call.right, label %skip.right

call.right:                                       ; preds = %recurse.right
  %arr.ptr6 = load i32*, i32** %arr.addr, align 8
  call void @quick_sort(i32* %arr.ptr6, i64 %i.end, i64 %right.now)
  br label %skip.right

skip.right:                                       ; preds = %call.right, %recurse.right
  store i64 %j.end, i64* %right.addr, align 8
  br label %while.header

exit:                                            ; preds = %while.header
  ret void
}