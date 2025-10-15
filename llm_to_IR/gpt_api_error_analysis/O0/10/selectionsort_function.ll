; ModuleID = 'selection_sort_module'
target triple = "x86_64-pc-linux-gnu"

define dso_local void @selection_sort(i32* nocapture %arr, i32 %n) {
entry:
  br label %outer.cond

outer.cond:
  %i.phi = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %n.minus1 = add nsw i32 %n, -1
  %cmp.outer = icmp slt i32 %i.phi, %n.minus1
  br i1 %cmp.outer, label %outer.body, label %exit

outer.body:
  %j.init = add nsw i32 %i.phi, 1
  br label %inner.cond

inner.cond:
  %j.phi = phi i32 [ %j.init, %outer.body ], [ %j.next, %inner.latch ]
  %min.phi = phi i32 [ %i.phi, %outer.body ], [ %min.next, %inner.latch ]
  %cmp.inner = icmp slt i32 %j.phi, %n
  br i1 %cmp.inner, label %inner.body, label %inner.exit

inner.body:
  %j.idx.ext = sext i32 %j.phi to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.idx.ext
  %j.val = load i32, i32* %j.ptr, align 4
  %min.idx.ext = sext i32 %min.phi to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.idx.ext
  %min.val = load i32, i32* %min.ptr, align 4
  %cmp.sel = icmp slt i32 %j.val, %min.val
  br i1 %cmp.sel, label %if.then, label %if.else

if.then:
  br label %inner.latch

if.else:
  br label %inner.latch

inner.latch:
  %min.next = phi i32 [ %j.phi, %if.then ], [ %min.phi, %if.else ]
  %j.next = add nsw i32 %j.phi, 1
  br label %inner.cond

inner.exit:
  %min.final = phi i32 [ %min.phi, %inner.cond ]
  %i.idx.ext = sext i32 %i.phi to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.idx.ext
  %tmp = load i32, i32* %i.ptr, align 4
  %minf.idx.ext = sext i32 %min.final to i64
  %minf.ptr = getelementptr inbounds i32, i32* %arr, i64 %minf.idx.ext
  %minf.val = load i32, i32* %minf.ptr, align 4
  store i32 %minf.val, i32* %i.ptr, align 4
  store i32 %tmp, i32* %minf.ptr, align 4
  br label %outer.latch

outer.latch:
  %i.next = add nsw i32 %i.phi, 1
  br label %outer.cond

exit:
  ret void
}