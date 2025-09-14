target triple = "x86_64-pc-linux-gnu"

define void @selection_sort(i32* %arr, i32 %n) {
entry:
  br label %outer.cond

outer.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %nminus1 = add i32 %n, -1
  %cmp.outer = icmp slt i32 %i, %nminus1
  br i1 %cmp.outer, label %outer.body, label %ret

outer.body:
  %j.init = add nsw i32 %i, 1
  br label %inner.cond

inner.cond:
  %j = phi i32 [ %j.init, %outer.body ], [ %j.next, %inner.cont ]
  %minIndex = phi i32 [ %i, %outer.body ], [ %minIndex.new, %inner.cont ]
  %cmp.inner = icmp slt i32 %j, %n
  br i1 %cmp.inner, label %inner.body, label %outer.swap

inner.body:
  %j.idx64 = sext i32 %j to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.idx64
  %j.val = load i32, i32* %j.ptr, align 4
  %min.idx64 = sext i32 %minIndex to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.idx64
  %min.val = load i32, i32* %min.ptr, align 4
  %isLess = icmp slt i32 %j.val, %min.val
  br i1 %isLess, label %inner.update, label %inner.cont

inner.update:
  br label %inner.cont

inner.cont:
  %minIndex.new = phi i32 [ %j, %inner.update ], [ %minIndex, %inner.body ]
  %j.next = add nsw i32 %j, 1
  br label %inner.cond

outer.swap:
  %i.idx64 = sext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.idx64
  %tmp = load i32, i32* %i.ptr, align 4
  %min.idx64b = sext i32 %minIndex to i64
  %min.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %min.idx64b
  %min.val2 = load i32, i32* %min.ptr2, align 4
  store i32 %min.val2, i32* %i.ptr, align 4
  store i32 %tmp, i32* %min.ptr2, align 4
  br label %outer.latch

outer.latch:
  %i.next = add nsw i32 %i, 1
  br label %outer.cond

ret:
  ret void
}