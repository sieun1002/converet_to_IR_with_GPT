; ModuleID = 'selection_sort.ll'
target triple = "x86_64-pc-linux-gnu"

define dso_local void @selection_sort(i32* nocapture noundef %arr, i32 noundef %n) local_unnamed_addr {
entry:
  %cmp.n.le1 = icmp sle i32 %n, 1
  br i1 %cmp.n.le1, label %ret, label %outer.preheader

outer.preheader:
  br label %outer.header

outer.header:
  %i = phi i32 [ 0, %outer.preheader ], [ %i.next, %after.swap ]
  %n.minus1 = add i32 %n, -1
  %cmp.i.lt.nm1 = icmp slt i32 %i, %n.minus1
  br i1 %cmp.i.lt.nm1, label %outer.body, label %ret

outer.body:
  %i.ext = sext i32 %i to i64
  %ptr.i = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %ai = load i32, i32* %ptr.i, align 4
  %j.start = add i32 %i, 1
  br label %inner.header

inner.header:
  %minV = phi i32 [ %ai, %outer.body ], [ %minV.next, %inner.body ]
  %minI = phi i32 [ %i, %outer.body ], [ %minI.next, %inner.body ]
  %j = phi i32 [ %j.start, %outer.body ], [ %j.inc, %inner.body ]
  %cmp.j.lt.n = icmp slt i32 %j, %n
  br i1 %cmp.j.lt.n, label %inner.body, label %end.inner

inner.body:
  %j.ext = sext i32 %j to i64
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j.ext
  %vj = load i32, i32* %ptr.j, align 4
  %vj.lt.minV = icmp slt i32 %vj, %minV
  %minV.next = select i1 %vj.lt.minV, i32 %vj, i32 %minV
  %minI.next = select i1 %vj.lt.minV, i32 %j, i32 %minI
  %j.inc = add i32 %j, 1
  br label %inner.header

end.inner:
  %minV.final = phi i32 [ %minV, %inner.header ]
  %minI.final = phi i32 [ %minI, %inner.header ]
  store i32 %minV.final, i32* %ptr.i, align 4
  %minI.ext = sext i32 %minI.final to i64
  %ptr.min = getelementptr inbounds i32, i32* %arr, i64 %minI.ext
  store i32 %ai, i32* %ptr.min, align 4
  br label %after.swap

after.swap:
  %i.next = add i32 %i, 1
  br label %outer.header

ret:
  ret void
}