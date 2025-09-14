define void @selection_sort(i32* %arr, i32 %n) {
entry:
  %arr.addr = alloca i32*, align 8
  %n.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %min = alloca i32, align 4
  %j = alloca i32, align 4
  %tmp = alloca i32, align 4
  store i32* %arr, i32** %arr.addr, align 8
  store i32 %n, i32* %n.addr, align 4
  store i32 0, i32* %i, align 4
  br label %outer.cond

outer.cond:
  %i.val = load i32, i32* %i, align 4
  %n.val = load i32, i32* %n.addr, align 4
  %nminus1 = add nsw i32 %n.val, -1
  %cmp.outer = icmp slt i32 %i.val, %nminus1
  br i1 %cmp.outer, label %outer.body, label %exit

outer.body:
  %i.val2 = load i32, i32* %i, align 4
  store i32 %i.val2, i32* %min, align 4
  %inc.i = add nsw i32 %i.val2, 1
  store i32 %inc.i, i32* %j, align 4
  br label %inner.cond

inner.cond:
  %j.val = load i32, i32* %j, align 4
  %n.val2 = load i32, i32* %n.addr, align 4
  %cmp.inner = icmp slt i32 %j.val, %n.val2
  br i1 %cmp.inner, label %inner.body, label %after.inner

inner.body:
  %arr.ptr = load i32*, i32** %arr.addr, align 8
  %j64 = sext i32 %j.val to i64
  %j.gep = getelementptr inbounds i32, i32* %arr.ptr, i64 %j64
  %val.j = load i32, i32* %j.gep, align 4
  %min.idx = load i32, i32* %min, align 4
  %min64 = sext i32 %min.idx to i64
  %min.gep = getelementptr inbounds i32, i32* %arr.ptr, i64 %min64
  %val.min = load i32, i32* %min.gep, align 4
  %cmp = icmp slt i32 %val.j, %val.min
  br i1 %cmp, label %setmin, label %cont.inner

setmin:
  store i32 %j.val, i32* %min, align 4
  br label %cont.inner

cont.inner:
  %j.old = load i32, i32* %j, align 4
  %j.next = add nsw i32 %j.old, 1
  store i32 %j.next, i32* %j, align 4
  br label %inner.cond

after.inner:
  %arr.ptr2 = load i32*, i32** %arr.addr, align 8
  %i.val3 = load i32, i32* %i, align 4
  %i64 = sext i32 %i.val3 to i64
  %i.gep = getelementptr inbounds i32, i32* %arr.ptr2, i64 %i64
  %val.i = load i32, i32* %i.gep, align 4
  store i32 %val.i, i32* %tmp, align 4
  %min.idx2 = load i32, i32* %min, align 4
  %min64b = sext i32 %min.idx2 to i64
  %min.gep2 = getelementptr inbounds i32, i32* %arr.ptr2, i64 %min64b
  %val.min2 = load i32, i32* %min.gep2, align 4
  store i32 %val.min2, i32* %i.gep, align 4
  %tmp.val = load i32, i32* %tmp, align 4
  store i32 %tmp.val, i32* %min.gep2, align 4
  %i.next = add nsw i32 %i.val3, 1
  store i32 %i.next, i32* %i, align 4
  br label %outer.cond

exit:
  ret void
}