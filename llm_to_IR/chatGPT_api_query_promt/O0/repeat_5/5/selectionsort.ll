; ModuleID = 'selection_sort'
source_filename = "selection_sort"

define void @selection_sort(i32* %arr, i32 %n) {
entry:
  %arr.addr = alloca i32*, align 8
  %n.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %minidx = alloca i32, align 4
  %j = alloca i32, align 4
  %tmp = alloca i32, align 4
  store i32* %arr, i32** %arr.addr, align 8
  store i32 %n, i32* %n.addr, align 4
  store i32 0, i32* %i, align 4
  br label %outer.cond

outer.cond:                                       ; preds = %after.inner, %entry
  %i.val = load i32, i32* %i, align 4
  %n.val = load i32, i32* %n.addr, align 4
  %nminus1 = add i32 %n.val, -1
  %cmp = icmp slt i32 %i.val, %nminus1
  br i1 %cmp, label %outer.body, label %return

outer.body:                                       ; preds = %outer.cond
  %i0 = load i32, i32* %i, align 4
  store i32 %i0, i32* %minidx, align 4
  %i1 = load i32, i32* %i, align 4
  %i.plus1 = add i32 %i1, 1
  store i32 %i.plus1, i32* %j, align 4
  br label %inner.cond

inner.cond:                                       ; preds = %no.update, %outer.body
  %j.val = load i32, i32* %j, align 4
  %n.val2 = load i32, i32* %n.addr, align 4
  %cmpj = icmp slt i32 %j.val, %n.val2
  br i1 %cmpj, label %inner.body, label %after.inner

inner.body:                                       ; preds = %inner.cond
  %arr1 = load i32*, i32** %arr.addr, align 8
  %j64 = sext i32 %j.val to i64
  %p.j = getelementptr inbounds i32, i32* %arr1, i64 %j64
  %v.j = load i32, i32* %p.j, align 4
  %minidx.val = load i32, i32* %minidx, align 4
  %min64 = sext i32 %minidx.val to i64
  %arr2 = load i32*, i32** %arr.addr, align 8
  %p.min = getelementptr inbounds i32, i32* %arr2, i64 %min64
  %v.min = load i32, i32* %p.min, align 4
  %cmpmin = icmp slt i32 %v.j, %v.min
  br i1 %cmpmin, label %update.min, label %no.update

update.min:                                       ; preds = %inner.body
  %j.now = load i32, i32* %j, align 4
  store i32 %j.now, i32* %minidx, align 4
  br label %no.update

no.update:                                        ; preds = %update.min, %inner.body
  %j.cur = load i32, i32* %j, align 4
  %j.next = add i32 %j.cur, 1
  store i32 %j.next, i32* %j, align 4
  br label %inner.cond

after.inner:                                      ; preds = %inner.cond
  %i2 = load i32, i32* %i, align 4
  %i64 = sext i32 %i2 to i64
  %arr3 = load i32*, i32** %arr.addr, align 8
  %p.i = getelementptr inbounds i32, i32* %arr3, i64 %i64
  %v.i = load i32, i32* %p.i, align 4
  store i32 %v.i, i32* %tmp, align 4
  %minidx2 = load i32, i32* %minidx, align 4
  %min64b = sext i32 %minidx2 to i64
  %arr4 = load i32*, i32** %arr.addr, align 8
  %p.min2 = getelementptr inbounds i32, i32* %arr4, i64 %min64b
  %v.min2 = load i32, i32* %p.min2, align 4
  store i32 %v.min2, i32* %p.i, align 4
  %tmp.val = load i32, i32* %tmp, align 4
  store i32 %tmp.val, i32* %p.min2, align 4
  %i3 = load i32, i32* %i, align 4
  %i.next = add i32 %i3, 1
  store i32 %i.next, i32* %i, align 4
  br label %outer.cond

return:                                           ; preds = %outer.cond
  ret void
}