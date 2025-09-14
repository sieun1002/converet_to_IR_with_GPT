; target triple may need adjustment for your environment
target triple = "x86_64-pc-linux-gnu"

define void @heap_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr nounwind {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %ret, label %build.init

build.init:
  %half = lshr i64 %n, 1
  br label %build.dec.test

build.dec.test:
  %i_old = phi i64 [ %half, %build.init ], [ %i_next_old, %build.sift.done ]
  %i_old.nz = icmp ne i64 %i_old, 0
  br i1 %i_old.nz, label %build.body.prep, label %phase2.init

build.body.prep:
  %i0 = add i64 %i_old, -1
  br label %sift1.header

sift1.header:
  %k = phi i64 [ %i0, %build.body.prep ], [ %k.next, %sift1.continue ]
  %k.twice = shl i64 %k, 1
  %left = add i64 %k.twice, 1
  %left.lt.n = icmp ult i64 %left, %n
  br i1 %left.lt.n, label %sift1.has.left, label %build.sift.done

sift1.has.left:
  %right = add i64 %left, 1
  %right.lt.n = icmp ult i64 %right, %n
  br i1 %right.lt.n, label %sift1.both.children, label %sift1.one.child

sift1.both.children:
  %ptr.r = getelementptr inbounds i32, i32* %arr, i64 %right
  %val.r = load i32, i32* %ptr.r, align 4
  %ptr.l = getelementptr inbounds i32, i32* %arr, i64 %left
  %val.l = load i32, i32* %ptr.l, align 4
  %r.gt.l = icmp sgt i32 %val.r, %val.l
  %m.idx = select i1 %r.gt.l, i64 %right, i64 %left
  br label %sift1.have.m

sift1.one.child:
  br label %sift1.have.m

sift1.have.m:
  %m = phi i64 [ %m.idx, %sift1.both.children ], [ %left, %sift1.one.child ]
  %ptr.k = getelementptr inbounds i32, i32* %arr, i64 %k
  %val.k = load i32, i32* %ptr.k, align 4
  %ptr.m = getelementptr inbounds i32, i32* %arr, i64 %m
  %val.m = load i32, i32* %ptr.m, align 4
  %k.ge.m = icmp sge i32 %val.k, %val.m
  br i1 %k.ge.m, label %build.sift.done, label %sift1.swap

sift1.swap:
  store i32 %val.m, i32* %ptr.k, align 4
  store i32 %val.k, i32* %ptr.m, align 4
  br label %sift1.continue

sift1.continue:
  %k.next = phi i64 [ %m, %sift1.swap ]
  br label %sift1.header

build.sift.done:
  %i_next_old = add i64 %i_old, -1
  br label %build.dec.test

phase2.init:
  %end.init = add i64 %n, -1
  br label %phase2.cond

phase2.cond:
  %end = phi i64 [ %end.init, %phase2.init ], [ %end.next, %phase2.sift.done ]
  %end.nz = icmp ne i64 %end, 0
  br i1 %end.nz, label %phase2.swap.root, label %ret

phase2.swap.root:
  %ptr.0 = getelementptr inbounds i32, i32* %arr, i64 0
  %v0 = load i32, i32* %ptr.0, align 4
  %ptr.end = getelementptr inbounds i32, i32* %arr, i64 %end
  %vend = load i32, i32* %ptr.end, align 4
  store i32 %vend, i32* %ptr.0, align 4
  store i32 %v0, i32* %ptr.end, align 4
  br label %sift2.header

sift2.header:
  %k2 = phi i64 [ 0, %phase2.swap.root ], [ %k2.next, %sift2.continue ]
  %k2.twice = shl i64 %k2, 1
  %left2 = add i64 %k2.twice, 1
  %left2.lt.end = icmp ult i64 %left2, %end
  br i1 %left2.lt.end, label %sift2.has.left, label %phase2.sift.done

sift2.has.left:
  %right2 = add i64 %left2, 1
  %right2.lt.end = icmp ult i64 %right2, %end
  br i1 %right2.lt.end, label %sift2.both.children, label %sift2.one.child

sift2.both.children:
  %ptr.r2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %val.r2 = load i32, i32* %ptr.r2, align 4
  %ptr.l2 = getelementptr inbounds i32, i32* %arr, i64 %left2
  %val.l2 = load i32, i32* %ptr.l2, align 4
  %r2.gt.l2 = icmp sgt i32 %val.r2, %val.l2
  %m2.idx = select i1 %r2.gt.l2, i64 %right2, i64 %left2
  br label %sift2.have.m

sift2.one.child:
  br label %sift2.have.m

sift2.have.m:
  %m2 = phi i64 [ %m2.idx, %sift2.both.children ], [ %left2, %sift2.one.child ]
  %ptr.k2 = getelementptr inbounds i32, i32* %arr, i64 %k2
  %val.k2 = load i32, i32* %ptr.k2, align 4
  %ptr.m2 = getelementptr inbounds i32, i32* %arr, i64 %m2
  %val.m2 = load i32, i32* %ptr.m2, align 4
  %k2.ge.m2 = icmp sge i32 %val.k2, %val.m2
  br i1 %k2.ge.m2, label %phase2.sift.done, label %sift2.swap

sift2.swap:
  store i32 %val.m2, i32* %ptr.k2, align 4
  store i32 %val.k2, i32* %ptr.m2, align 4
  br label %sift2.continue

sift2.continue:
  %k2.next = phi i64 [ %m2, %sift2.swap ]
  br label %sift2.header

phase2.sift.done:
  %end.next = add i64 %end, -1
  br label %phase2.cond

ret:
  ret void
}