target triple = "x86_64-pc-windows-msvc"

define void @selection_sort(i32* %arr, i32 %n) {
entry:
  br label %outer.cond

outer.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %n_minus1 = add nsw i32 %n, -1
  %cmp.outer = icmp slt i32 %i, %n_minus1
  br i1 %cmp.outer, label %outer.body, label %exit

outer.body:
  %j.start = add nsw i32 %i, 1
  br label %inner.cond

inner.cond:
  %min.cur = phi i32 [ %i, %outer.body ], [ %min.sel, %inner.latch ]
  %j.cur = phi i32 [ %j.start, %outer.body ], [ %j.plus, %inner.latch ]
  %cmp.inner = icmp slt i32 %j.cur, %n
  br i1 %cmp.inner, label %inner.body, label %inner.end

inner.body:
  %j64 = sext i32 %j.cur to i64
  %ptrj = getelementptr inbounds i32, i32* %arr, i64 %j64
  %valj = load i32, i32* %ptrj, align 4
  %min64 = sext i32 %min.cur to i64
  %ptrmin = getelementptr inbounds i32, i32* %arr, i64 %min64
  %valmin = load i32, i32* %ptrmin, align 4
  %isless = icmp slt i32 %valj, %valmin
  %min.sel = select i1 %isless, i32 %j.cur, i32 %min.cur
  br label %inner.latch

inner.latch:
  %j.plus = add nsw i32 %j.cur, 1
  br label %inner.cond

inner.end:
  %i64 = sext i32 %i to i64
  %ptri = getelementptr inbounds i32, i32* %arr, i64 %i64
  %val_i = load i32, i32* %ptri, align 4
  %min64.end = sext i32 %min.cur to i64
  %ptrmin.end = getelementptr inbounds i32, i32* %arr, i64 %min64.end
  %val_min = load i32, i32* %ptrmin.end, align 4
  store i32 %val_min, i32* %ptri, align 4
  store i32 %val_i, i32* %ptrmin.end, align 4
  br label %outer.latch

outer.latch:
  %i.next = add nsw i32 %i, 1
  br label %outer.cond

exit:
  ret void
}