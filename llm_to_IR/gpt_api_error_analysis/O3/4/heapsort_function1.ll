; ModuleID = 'heap_sort.ll'
target triple = "x86_64-pc-linux-gnu"

define void @heap_sort(i32* %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  %n.half = lshr i64 %n, 1
  br i1 %cmp.n.le1, label %ret, label %build.header

build.header:
  %i.curr = phi i64 [ %n.half, %entry ], [ %i.next, %build.body.exit ]
  %i.curr.ne0 = icmp ne i64 %i.curr, 0
  br i1 %i.curr.ne0, label %build.prep, label %after.build

build.prep:
  %i.dec = add i64 %i.curr, -1
  br label %build.inner

build.inner:
  %curr.idx = phi i64 [ %i.dec, %build.prep ], [ %child.idx.next, %build.swap ]
  %curr.idx.shl1 = shl i64 %curr.idx, 1
  %left.idx = add i64 %curr.idx.shl1, 1
  %left.ge.n = icmp uge i64 %left.idx, %n
  br i1 %left.ge.n, label %build.body.exit, label %build.has.left

build.has.left:
  %right.idx = add i64 %left.idx, 1
  %right.lt.n = icmp ult i64 %right.idx, %n
  br i1 %right.lt.n, label %build.cmp.two, label %build.child.left.only

build.cmp.two:
  %gep.right = getelementptr i32, i32* %arr, i64 %right.idx
  %val.right = load i32, i32* %gep.right, align 4
  %gep.left = getelementptr i32, i32* %arr, i64 %left.idx
  %val.left = load i32, i32* %gep.left, align 4
  %right.gt.left = icmp sgt i32 %val.right, %val.left
  br i1 %right.gt.left, label %build.choose.right, label %build.choose.left.two

build.choose.right:
  %child.idx.r = add i64 %right.idx, 0
  br label %build.child.chosen

build.choose.left.two:
  %child.idx.l2 = add i64 %left.idx, 0
  br label %build.child.chosen

build.child.left.only:
  %child.idx.l1 = add i64 %left.idx, 0
  br label %build.child.chosen

build.child.chosen:
  %child.idx = phi i64 [ %child.idx.r, %build.choose.right ], [ %child.idx.l2, %build.choose.left.two ], [ %child.idx.l1, %build.child.left.only ]
  %gep.curr = getelementptr i32, i32* %arr, i64 %curr.idx
  %val.curr = load i32, i32* %gep.curr, align 4
  %gep.child = getelementptr i32, i32* %arr, i64 %child.idx
  %val.child = load i32, i32* %gep.child, align 4
  %curr.ge.child = icmp sge i32 %val.curr, %val.child
  br i1 %curr.ge.child, label %build.body.exit, label %build.swap

build.swap:
  store i32 %val.child, i32* %gep.curr, align 4
  store i32 %val.curr, i32* %gep.child, align 4
  %child.idx.next = add i64 %child.idx, 0
  br label %build.inner

build.body.exit:
  %i.next = phi i64 [ %i.dec, %build.inner ], [ %i.dec, %build.child.chosen ]
  br label %build.header

after.build:
  %end.start = add i64 %n, -1
  br label %outer.header

outer.header:
  %end.curr = phi i64 [ %end.start, %after.build ], [ %end.next, %dec.end ]
  %end.ne0 = icmp ne i64 %end.curr, 0
  br i1 %end.ne0, label %outer.body, label %ret

outer.body:
  %gep.root0 = getelementptr i32, i32* %arr, i64 0
  %val.root0 = load i32, i32* %gep.root0, align 4
  %gep.end = getelementptr i32, i32* %arr, i64 %end.curr
  %val.end = load i32, i32* %gep.end, align 4
  store i32 %val.end, i32* %gep.root0, align 4
  store i32 %val.root0, i32* %gep.end, align 4
  br label %outer.inner

outer.inner:
  %root.idx = phi i64 [ 0, %outer.body ], [ %child2.idx.next, %outer.swap ]
  %root.shl1 = shl i64 %root.idx, 1
  %left2.idx = add i64 %root.shl1, 1
  %left.ge.end = icmp uge i64 %left2.idx, %end.curr
  br i1 %left.ge.end, label %dec.end, label %outer.has.left

outer.has.left:
  %right2.idx = add i64 %left2.idx, 1
  %right.lt.end = icmp ult i64 %right2.idx, %end.curr
  br i1 %right.lt.end, label %outer.cmp.two, label %outer.child.left.only

outer.cmp.two:
  %gep.right2 = getelementptr i32, i32* %arr, i64 %right2.idx
  %val.right2 = load i32, i32* %gep.right2, align 4
  %gep.left2 = getelementptr i32, i32* %arr, i64 %left2.idx
  %val.left2 = load i32, i32* %gep.left2, align 4
  %right.gt.left2 = icmp sgt i32 %val.right2, %val.left2
  br i1 %right.gt.left2, label %outer.choose.right, label %outer.choose.left.two

outer.choose.right:
  %child2.idx.r = add i64 %right2.idx, 0
  br label %outer.child.chosen

outer.choose.left.two:
  %child2.idx.l2 = add i64 %left2.idx, 0
  br label %outer.child.chosen

outer.child.left.only:
  %child2.idx.l1 = add i64 %left2.idx, 0
  br label %outer.child.chosen

outer.child.chosen:
  %child2.idx = phi i64 [ %child2.idx.r, %outer.choose.right ], [ %child2.idx.l2, %outer.choose.left.two ], [ %child2.idx.l1, %outer.child.left.only ]
  %gep.root = getelementptr i32, i32* %arr, i64 %root.idx
  %val.root = load i32, i32* %gep.root, align 4
  %gep.child2 = getelementptr i32, i32* %arr, i64 %child2.idx
  %val.child2 = load i32, i32* %gep.child2, align 4
  %root.ge.child2 = icmp sge i32 %val.root, %val.child2
  br i1 %root.ge.child2, label %dec.end, label %outer.swap

outer.swap:
  store i32 %val.child2, i32* %gep.root, align 4
  store i32 %val.root, i32* %gep.child2, align 4
  %child2.idx.next = add i64 %child2.idx, 0
  br label %outer.inner

dec.end:
  %end.next = add i64 %end.curr, -1
  br label %outer.header

ret:
  ret void
}