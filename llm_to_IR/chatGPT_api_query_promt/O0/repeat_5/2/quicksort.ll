; LLVM IR for quick_sort (LLVM 14)

define dso_local void @quick_sort(i32* %arr, i64 %left, i64 %right) {
entry:
  %i.addr = alloca i64, align 8
  %j.addr = alloca i64, align 8
  %pivot.addr = alloca i32, align 4
  %left.addr = alloca i64, align 8
  %right.addr = alloca i64, align 8
  store i64 %left, i64* %left.addr, align 8
  store i64 %right, i64* %right.addr, align 8
  br label %loop.check

loop.check:                                         ; corresponds to loc_1313
  %left.cur = load i64, i64* %left.addr, align 8
  %right.cur = load i64, i64* %right.addr, align 8
  %cond = icmp slt i64 %left.cur, %right.cur
  br i1 %cond, label %partition.init, label %ret

partition.init:                                     ; corresponds to loc_11A6
  store i64 %left.cur, i64* %i.addr, align 8
  store i64 %right.cur, i64* %j.addr, align 8
  ; mid = left + ((right - left + ((right - left) >> 63)) >> 1)
  %diff = sub i64 %right.cur, %left.cur
  %shr63 = lshr i64 %diff, 63
  %add = add i64 %diff, %shr63
  %half = ashr i64 %add, 1
  %mid = add i64 %left.cur, %half
  %mid.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %mid.ptr, align 4
  store i32 %pivot, i32* %pivot.addr, align 4
  br label %scan.i

scan.i:                                              ; corresponds to loc_11F0 loop
  %i.cur = load i64, i64* %i.addr, align 8
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %ival = load i32, i32* %i.ptr, align 4
  %pivot1 = load i32, i32* %pivot.addr, align 4
  %cmp.i = icmp slt i32 %ival, %pivot1
  br i1 %cmp.i, label %scan.i.inc, label %scan.j

scan.i.inc:                                          ; corresponds to loc_11EB
  %i.cur2 = load i64, i64* %i.addr, align 8
  %i.next = add i64 %i.cur2, 1
  store i64 %i.next, i64* %i.addr, align 8
  br label %scan.i

scan.j:                                              ; corresponds to loc_1211 loop
  %j.cur = load i64, i64* %j.addr, align 8
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %jval = load i32, i32* %j.ptr, align 4
  %pivot2 = load i32, i32* %pivot.addr, align 4
  %cmp.j = icmp sgt i32 %jval, %pivot2
  br i1 %cmp.j, label %scan.j.dec, label %compare.ij

scan.j.dec:                                          ; corresponds to loc_120C
  %j.cur2 = load i64, i64* %j.addr, align 8
  %j.prev = add i64 %j.cur2, -1
  store i64 %j.prev, i64* %j.addr, align 8
  br label %scan.j

compare.ij:                                          ; corresponds to 0x122B..0x1233
  %i.now = load i64, i64* %i.addr, align 8
  %j.now = load i64, i64* %j.addr, align 8
  %le.ij = icmp sle i64 %i.now, %j.now
  br i1 %le.ij, label %do.swap, label %after.partition

do.swap:                                             ; corresponds to 0x1235..0x1294
  %i.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %i.now
  %tmp = load i32, i32* %i.ptr2, align 4
  %j.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %j.now
  %jval2 = load i32, i32* %j.ptr2, align 4
  store i32 %jval2, i32* %i.ptr2, align 4
  store i32 %tmp, i32* %j.ptr2, align 4
  %i.plus = add i64 %i.now, 1
  store i64 %i.plus, i64* %i.addr, align 8
  %j.minus = add i64 %j.now, -1
  store i64 %j.minus, i64* %j.addr, align 8
  ; corresponds to 0x1299 test
  %i.new = load i64, i64* %i.addr, align 8
  %j.new = load i64, i64* %j.addr, align 8
  %le.again = icmp sle i64 %i.new, %j.new
  br i1 %le.again, label %scan.i, label %after.partition

after.partition:                                     ; corresponds to 0x12A7..0x1313 decision
  %i.final = load i64, i64* %i.addr, align 8
  %j.final = load i64, i64* %j.addr, align 8
  %left.cur3 = load i64, i64* %left.addr, align 8
  %right.cur3 = load i64, i64* %right.addr, align 8
  %left.size = sub i64 %j.final, %left.cur3
  %right.size = sub i64 %right.cur3, %i.final
  %left.smaller = icmp slt i64 %left.size, %right.size
  br i1 %left.smaller, label %recurse.left.first, label %recurse.right.first

recurse.left.first:                                  ; corresponds to 0x12BF..0x12E8
  %need.left = icmp slt i64 %left.cur3, %j.final
  br i1 %need.left, label %call.left, label %skip.left

call.left:
  call void @quick_sort(i32* %arr, i64 %left.cur3, i64 %j.final)
  br label %skip.left

skip.left:
  store i64 %i.final, i64* %left.addr, align 8
  br label %loop.after

recurse.right.first:                                 ; corresponds to 0x12EA..0x130F
  %need.right = icmp slt i64 %i.final, %right.cur3
  br i1 %need.right, label %call.right, label %skip.right

call.right:
  call void @quick_sort(i32* %arr, i64 %i.final, i64 %right.cur3)
  br label %skip.right

skip.right:
  store i64 %j.final, i64* %right.addr, align 8
  br label %loop.after

loop.after:
  br label %loop.check

ret:
  ret void
}