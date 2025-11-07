; ModuleID = 'selection_sort'
define dso_local void @selection_sort(i32* nocapture %arr, i32 %n) local_unnamed_addr {
entry:
  %cmp0 = icmp sle i32 %n, 1
  br i1 %cmp0, label %ret, label %outer.pre

ret:
  ret void

outer.pre:
  br label %outer.header

outer.header:
  %i = phi i32 [ 0, %outer.pre ], [ %i.next, %outer.latch ]
  %pi = phi i32* [ %arr, %outer.pre ], [ %pi.next, %outer.latch ]
  %nminus1 = add i32 %n, -1
  %cond.outer = icmp slt i32 %i, %nminus1
  br i1 %cond.outer, label %outer.body, label %exit

outer.body:
  %old_ai = load i32, i32* %pi, align 4
  %j.init = add i32 %i, 1
  %jcmp = icmp slt i32 %j.init, %n
  br i1 %jcmp, label %inner.header, label %inner.exit

inner.header:
  %j = phi i32 [ %j.init, %outer.body ], [ %j.next, %inner.latch ]
  %min_val = phi i32 [ %old_ai, %outer.body ], [ %min_val.next, %inner.latch ]
  %min_ptr = phi i32* [ %pi, %outer.body ], [ %min_ptr.next, %inner.latch ]
  %j64 = sext i32 %j to i64
  %eltptr = getelementptr inbounds i32, i32* %arr, i64 %j64
  %val = load i32, i32* %eltptr, align 4
  %lt = icmp slt i32 %val, %min_val
  br i1 %lt, label %found.newmin, label %no.newmin

found.newmin:
  br label %inner.latch

no.newmin:
  br label %inner.latch

inner.latch:
  %min_val.next = phi i32 [ %val, %found.newmin ], [ %min_val, %no.newmin ]
  %min_ptr.next = phi i32* [ %eltptr, %found.newmin ], [ %min_ptr, %no.newmin ]
  %j.next = add i32 %j, 1
  %cont = icmp slt i32 %j.next, %n
  br i1 %cont, label %inner.header, label %inner.exit

inner.exit:
  %min_val.exit = phi i32 [ %old_ai, %outer.body ], [ %min_val.next, %inner.latch ]
  %min_ptr.exit = phi i32* [ %pi, %outer.body ], [ %min_ptr.next, %inner.latch ]
  %i64 = sext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i64
  store i32 %min_val.exit, i32* %i.ptr, align 4
  store i32 %old_ai, i32* %min_ptr.exit, align 4
  br label %outer.latch

outer.latch:
  %pi.next = getelementptr inbounds i32, i32* %pi, i64 1
  %i.next = add i32 %i, 1
  br label %outer.header

exit:
  ret void
}