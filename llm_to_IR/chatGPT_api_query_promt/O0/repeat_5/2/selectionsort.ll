; ModuleID = 'selection_sort'
source_filename = "selection_sort"
target triple = "x86_64-unknown-linux-gnu"

define dso_local void @selection_sort(i32* %arr, i32 %n) {
entry:
  br label %outer.cond

outer.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %nminus1 = add i32 %n, -1
  %cond = icmp slt i32 %i, %nminus1
  br i1 %cond, label %outer.init, label %exit

outer.init:
  %j0 = add i32 %i, 1
  br label %inner.cond

inner.cond:
  %j = phi i32 [ %j0, %outer.init ], [ %j.next, %inner.latch ]
  %minidx = phi i32 [ %i, %outer.init ], [ %minidx.next, %inner.latch ]
  %cmpj = icmp slt i32 %j, %n
  br i1 %cmpj, label %inner.body, label %inner.end

inner.body:
  %j64 = sext i32 %j to i64
  %pj = getelementptr inbounds i32, i32* %arr, i64 %j64
  %vj = load i32, i32* %pj, align 4
  %min64 = sext i32 %minidx to i64
  %pmin = getelementptr inbounds i32, i32* %arr, i64 %min64
  %vmin = load i32, i32* %pmin, align 4
  %lt = icmp slt i32 %vj, %vmin
  %minidx.next = select i1 %lt, i32 %j, i32 %minidx
  br label %inner.latch

inner.latch:
  %j.next = add i32 %j, 1
  br label %inner.cond

inner.end:
  %i64 = sext i32 %i to i64
  %pi = getelementptr inbounds i32, i32* %arr, i64 %i64
  %vi = load i32, i32* %pi, align 4
  %min64.2 = sext i32 %minidx to i64
  %pmin2 = getelementptr inbounds i32, i32* %arr, i64 %min64.2
  %vmin2 = load i32, i32* %pmin2, align 4
  store i32 %vmin2, i32* %pi, align 4
  store i32 %vi, i32* %pmin2, align 4
  br label %outer.latch

outer.latch:
  %i.next = add i32 %i, 1
  br label %outer.cond

exit:
  ret void
}