target triple = "x86_64-pc-windows-msvc"

define dso_local void @selection_sort(i32* %arr, i32 %n) {
entry:
  br label %outer.header

outer.header:
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %n_minus1 = add nsw i32 %n, -1
  %cmp.outer = icmp slt i32 %i, %n_minus1
  br i1 %cmp.outer, label %outer.body, label %exit

outer.body:
  %j.init = add nsw i32 %i, 1
  br label %inner.header

inner.header:
  %j = phi i32 [ %j.init, %outer.body ], [ %j.next, %inner.latch ]
  %min = phi i32 [ %i, %outer.body ], [ %min.updated, %inner.latch ]
  %cmp.inner = icmp slt i32 %j, %n
  br i1 %cmp.inner, label %inner.body, label %after.inner

inner.body:
  %j.ext = sext i32 %j to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.ext
  %val.j = load i32, i32* %j.ptr, align 4
  %min.ext = sext i32 %min to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.ext
  %val.min = load i32, i32* %min.ptr, align 4
  %cmp.swap = icmp slt i32 %val.j, %val.min
  br i1 %cmp.swap, label %update.min, label %inner.latch

update.min:
  br label %inner.latch

inner.latch:
  %min.updated = phi i32 [ %j, %update.min ], [ %min, %inner.body ]
  %j.next = add nsw i32 %j, 1
  br label %inner.header

after.inner:
  %min.final = phi i32 [ %min, %inner.header ]
  %i.ext = sext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %tmp = load i32, i32* %i.ptr, align 4
  %min.final.ext = sext i32 %min.final to i64
  %min.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %min.final.ext
  %min.val2 = load i32, i32* %min.ptr2, align 4
  store i32 %min.val2, i32* %i.ptr, align 4
  store i32 %tmp, i32* %min.ptr2, align 4
  br label %outer.latch

outer.latch:
  %i.next = add nsw i32 %i, 1
  br label %outer.header

exit:
  ret void
}