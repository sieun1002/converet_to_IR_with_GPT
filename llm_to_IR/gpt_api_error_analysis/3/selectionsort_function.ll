; Function: selection_sort

define void @selection_sort(i32* %arr, i32 %n) {
entry:
  br label %outer.header

outer.header:
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %nminus1 = add nsw i32 %n, -1
  %cmp.outer = icmp slt i32 %i, %nminus1
  br i1 %cmp.outer, label %outer.body, label %exit

outer.body:
  %j.start = add nsw i32 %i, 1
  br label %inner.header

inner.header:
  %j = phi i32 [ %j.start, %outer.body ], [ %j.next, %inner.inc ]
  %minIndex = phi i32 [ %i, %outer.body ], [ %minIndex.next, %inner.inc ]
  %cmp.inner = icmp slt i32 %j, %n
  br i1 %cmp.inner, label %inner.body, label %inner.exit

inner.body:
  %j64 = sext i32 %j to i64
  %ptrj = getelementptr inbounds i32, i32* %arr, i64 %j64
  %valj = load i32, i32* %ptrj, align 4
  %min64 = sext i32 %minIndex to i64
  %ptrmin = getelementptr inbounds i32, i32* %arr, i64 %min64
  %valmin = load i32, i32* %ptrmin, align 4
  %is_less = icmp slt i32 %valj, %valmin
  %minIndex.next = select i1 %is_less, i32 %j, i32 %minIndex
  br label %inner.inc

inner.inc:
  %j.next = add nsw i32 %j, 1
  br label %inner.header

inner.exit:
  %i64 = sext i32 %i to i64
  %ptri = getelementptr inbounds i32, i32* %arr, i64 %i64
  %tmp = load i32, i32* %ptri, align 4
  %min64b = sext i32 %minIndex to i64
  %ptrmin2 = getelementptr inbounds i32, i32* %arr, i64 %min64b
  %valmin2 = load i32, i32* %ptrmin2, align 4
  store i32 %valmin2, i32* %ptri, align 4
  store i32 %tmp, i32* %ptrmin2, align 4
  br label %outer.latch

outer.latch:
  %i.next = add nsw i32 %i, 1
  br label %outer.header

exit:
  ret void
}