target triple = "x86_64-pc-windows-msvc"

define dso_local void @selection_sort(i32* %arr, i32 %n) {
entry:
  %arr.addr = alloca i32*, align 8
  %n.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %min = alloca i32, align 4
  %tmp = alloca i32, align 4
  store i32* %arr, i32** %arr.addr, align 8
  store i32 %n, i32* %n.addr, align 4
  store i32 0, i32* %i, align 4
  br label %outer.cond

outer.cond:                                        ; preds = %after.inner, %entry
  %i.load = load i32, i32* %i, align 4
  %n.load = load i32, i32* %n.addr, align 4
  %n.sub = add i32 %n.load, -1
  %cmp = icmp slt i32 %i.load, %n.sub
  br i1 %cmp, label %outer.body, label %outer.end

outer.body:                                        ; preds = %outer.cond
  %i.body.load = load i32, i32* %i, align 4
  store i32 %i.body.load, i32* %min, align 4
  %add1 = add i32 %i.body.load, 1
  store i32 %add1, i32* %j, align 4
  br label %inner.cond

inner.cond:                                        ; preds = %no.update, %outer.body
  %j.load = load i32, i32* %j, align 4
  %n.load2 = load i32, i32* %n.addr, align 4
  %cmpj = icmp slt i32 %j.load, %n.load2
  br i1 %cmpj, label %inner.body, label %after.inner

inner.body:                                        ; preds = %inner.cond
  %j.load2 = load i32, i32* %j, align 4
  %j.idx = sext i32 %j.load2 to i64
  %arr.ptr1 = load i32*, i32** %arr.addr, align 8
  %elem.j = getelementptr inbounds i32, i32* %arr.ptr1, i64 %j.idx
  %val.j = load i32, i32* %elem.j, align 4
  %min.load = load i32, i32* %min, align 4
  %min.idx = sext i32 %min.load to i64
  %arr.ptr2 = load i32*, i32** %arr.addr, align 8
  %elem.min = getelementptr inbounds i32, i32* %arr.ptr2, i64 %min.idx
  %val.min = load i32, i32* %elem.min, align 4
  %cmp2 = icmp slt i32 %val.j, %val.min
  br i1 %cmp2, label %update.min, label %no.update

update.min:                                        ; preds = %inner.body
  %j.load3 = load i32, i32* %j, align 4
  store i32 %j.load3, i32* %min, align 4
  br label %no.update

no.update:                                         ; preds = %update.min, %inner.body
  %j.load4 = load i32, i32* %j, align 4
  %j.inc = add i32 %j.load4, 1
  store i32 %j.inc, i32* %j, align 4
  br label %inner.cond

after.inner:                                       ; preds = %inner.cond
  %i.load2 = load i32, i32* %i, align 4
  %i.idx = sext i32 %i.load2 to i64
  %arr.ptr3 = load i32*, i32** %arr.addr, align 8
  %elem.i = getelementptr inbounds i32, i32* %arr.ptr3, i64 %i.idx
  %val.i = load i32, i32* %elem.i, align 4
  store i32 %val.i, i32* %tmp, align 4
  %min.load2 = load i32, i32* %min, align 4
  %min.idx2 = sext i32 %min.load2 to i64
  %arr.ptr4 = load i32*, i32** %arr.addr, align 8
  %elem.min2 = getelementptr inbounds i32, i32* %arr.ptr4, i64 %min.idx2
  %val.min2 = load i32, i32* %elem.min2, align 4
  store i32 %val.min2, i32* %elem.i, align 4
  %tmp.val = load i32, i32* %tmp, align 4
  store i32 %tmp.val, i32* %elem.min2, align 4
  %i.load3 = load i32, i32* %i, align 4
  %i.inc = add i32 %i.load3, 1
  store i32 %i.inc, i32* %i, align 4
  br label %outer.cond

outer.end:                                         ; preds = %outer.cond
  ret void
}