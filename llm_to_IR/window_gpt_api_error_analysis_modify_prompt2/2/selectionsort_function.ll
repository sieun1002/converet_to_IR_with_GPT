; ModuleID = 'selection_sort_module'
target triple = "x86_64-pc-windows-msvc"

define void @selection_sort(i32* %arr, i32 %n) {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %min = alloca i32, align 4
  %tmp = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %outer.cond

outer.cond:                                       ; preds = %after.inner, %entry
  %i.val = load i32, i32* %i, align 4
  %nm1 = add i32 %n, -1
  %cmp.outer = icmp slt i32 %i.val, %nm1
  br i1 %cmp.outer, label %outer.body, label %exit

outer.body:                                       ; preds = %outer.cond
  %i.curr = load i32, i32* %i, align 4
  store i32 %i.curr, i32* %min, align 4
  %i.plus1 = add i32 %i.curr, 1
  store i32 %i.plus1, i32* %j, align 4
  br label %inner.cond

inner.cond:                                       ; preds = %inc.j, %outer.body
  %j.val = load i32, i32* %j, align 4
  %cmp.inner = icmp slt i32 %j.val, %n
  br i1 %cmp.inner, label %inner.body, label %after.inner

inner.body:                                       ; preds = %inner.cond
  %j.load = load i32, i32* %j, align 4
  %j.idx64 = sext i32 %j.load to i64
  %ptr.j = getelementptr i32, i32* %arr, i64 %j.idx64
  %val.j = load i32, i32* %ptr.j, align 4
  %min.load = load i32, i32* %min, align 4
  %min.idx64 = sext i32 %min.load to i64
  %ptr.min = getelementptr i32, i32* %arr, i64 %min.idx64
  %val.min = load i32, i32* %ptr.min, align 4
  %lt = icmp slt i32 %val.j, %val.min
  br i1 %lt, label %update.min, label %no.update

update.min:                                       ; preds = %inner.body
  %j.to.store = load i32, i32* %j, align 4
  store i32 %j.to.store, i32* %min, align 4
  br label %inc.j

no.update:                                        ; preds = %inner.body
  br label %inc.j

inc.j:                                            ; preds = %no.update, %update.min
  %j.cur = load i32, i32* %j, align 4
  %j.next = add i32 %j.cur, 1
  store i32 %j.next, i32* %j, align 4
  br label %inner.cond

after.inner:                                      ; preds = %inner.cond
  %i.load = load i32, i32* %i, align 4
  %i.idx64 = sext i32 %i.load to i64
  %ptr.i = getelementptr i32, i32* %arr, i64 %i.idx64
  %val.i = load i32, i32* %ptr.i, align 4
  store i32 %val.i, i32* %tmp, align 4
  %min.load2 = load i32, i32* %min, align 4
  %min.idx64.2 = sext i32 %min.load2 to i64
  %ptr.min.2 = getelementptr i32, i32* %arr, i64 %min.idx64.2
  %val.min.2 = load i32, i32* %ptr.min.2, align 4
  store i32 %val.min.2, i32* %ptr.i, align 4
  %tmp.load = load i32, i32* %tmp, align 4
  store i32 %tmp.load, i32* %ptr.min.2, align 4
  %i.inc0 = load i32, i32* %i, align 4
  %i.inc1 = add i32 %i.inc0, 1
  store i32 %i.inc1, i32* %i, align 4
  br label %outer.cond

exit:                                             ; preds = %outer.cond
  ret void
}