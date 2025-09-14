; ModuleID = 'selection_sort'
source_filename = "selection_sort.c"

define dso_local void @selection_sort(i32* nocapture %arr, i32 %n) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %n_minus_1 = add i32 %n, -1
  %cmp.outer = icmp slt i32 %i, %n_minus_1
  br i1 %cmp.outer, label %outer.body, label %exit

outer.body:
  %min.init = phi i32 [ %i, %outer.cond ]
  %j.start = add nsw i32 %i, 1
  br label %inner.cond

inner.cond:
  %j = phi i32 [ %j.start, %outer.body ], [ %j.next, %inner.latch ]
  %min.cur = phi i32 [ %min.init, %outer.body ], [ %min.next, %inner.latch ]
  %cmp.inner = icmp slt i32 %j, %n
  br i1 %cmp.inner, label %inner.body, label %after.inner

inner.body:
  %j.idx64 = sext i32 %j to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.idx64
  %j.val = load i32, i32* %j.ptr, align 4
  %min.idx64 = sext i32 %min.cur to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.idx64
  %min.val = load i32, i32* %min.ptr, align 4
  %lt = icmp slt i32 %j.val, %min.val
  br i1 %lt, label %inner.then, label %inner.latch

inner.then:
  br label %inner.latch

inner.latch:
  %min.next = phi i32 [ %j, %inner.then ], [ %min.cur, %inner.body ]
  %j.next = add nsw i32 %j, 1
  br label %inner.cond

after.inner:
  %min.final = phi i32 [ %min.cur, %inner.cond ]
  %i.idx64 = sext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.idx64
  %tmp = load i32, i32* %i.ptr, align 4
  %min.final64 = sext i32 %min.final to i64
  %min.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %min.final64
  %min.val2 = load i32, i32* %min.ptr2, align 4
  store i32 %min.val2, i32* %i.ptr, align 4
  store i32 %tmp, i32* %min.ptr2, align 4
  br label %outer.inc

outer.inc:
  %i.next = add nsw i32 %i, 1
  br label %outer.cond

exit:
  ret void
}