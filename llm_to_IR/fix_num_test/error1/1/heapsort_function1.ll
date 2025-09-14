; ModuleID = 'heap_sort'
source_filename = "heap_sort.ll"

define void @heap_sort(i32* nocapture %a, i64 %n) local_unnamed_addr {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %ret, label %build.init

build.init:
  %half = lshr i64 %n, 1
  %half.is0 = icmp eq i64 %half, 0
  br i1 %half.is0, label %after.build, label %build.start

build.start:
  %i.init = add i64 %half, -1
  br label %build.sift.entry

build.sift.entry:
  %i.cur = phi i64 [ %i.init, %build.start ], [ %i.dec, %build.next ]
  br label %build.sift.loop

build.sift.loop:
  %k.cur = phi i64 [ %i.cur, %build.sift.entry ], [ %k.next, %build.sift.swap ]
  %k2 = shl i64 %k.cur, 1
  %child = add i64 %k2, 1
  %child.ge.n = icmp uge i64 %child, %n
  br i1 %child.ge.n, label %build.after.sift, label %build.has.child

build.has.child:
  %child.ptr = getelementptr inbounds i32, i32* %a, i64 %child
  %child.val = load i32, i32* %child.ptr, align 4
  %right = add i64 %child, 1
  %right.lt.n = icmp ult i64 %right, %n
  br i1 %right.lt.n, label %build.check.right, label %build.choose.left

build.check.right:
  %right.ptr = getelementptr inbounds i32, i32* %a, i64 %right
  %right.val = load i32, i32* %right.ptr, align 4
  %right.gt.left = icmp sgt i32 %right.val, %child.val
  br i1 %right.gt.left, label %build.choose.right, label %build.choose.left

build.choose.right:
  %largest.idx.r = phi i64 [ %right, %build.check.right ]
  %largest.val.r = phi i32 [ %right.val, %build.check.right ]
  br label %build.after.choose

build.choose.left:
  %largest.idx.l = phi i64 [ %child, %build.has.child ], [ %child, %build.check.right ]
  %largest.val.l = phi i32 [ %child.val, %build.has.child ], [ %child.val, %build.check.right ]
  br label %build.after.choose

build.after.choose:
  %largest.idx = phi i64 [ %largest.idx.r, %build.choose.right ], [ %largest.idx.l, %build.choose.left ]
  %largest.val = phi i32 [ %largest.val.r, %build.choose.right ], [ %largest.val.l, %build.choose.left ]
  %k.ptr = getelementptr inbounds i32, i32* %a, i64 %k.cur
  %k.val = load i32, i32* %k.ptr, align 4
  %parent.ge.child = icmp sge i32 %k.val, %largest.val
  br i1 %parent.ge.child, label %build.after.sift, label %build.sift.swap

build.sift.swap:
  %largest.ptr = getelementptr inbounds i32, i32* %a, i64 %largest.idx
  store i32 %largest.val, i32* %k.ptr, align 4
  store i32 %k.val, i32* %largest.ptr, align 4
  %k.next = %largest.idx
  br label %build.sift.loop

build.after.sift:
  %i.is0 = icmp eq i64 %i.cur, 0
  br i1 %i.is0, label %after.build, label %build.next

build.next:
  %i.dec = add i64 %i.cur, -1
  br label %build.sift.entry

after.build:
  %m.init = add i64 %n, -1
  br label %sort.loop.check

sort.loop.check:
  %m.cur = phi i64 [ %m.init, %after.build ], [ %m.next, %sort.after.sift ]
  %m.is0 = icmp eq i64 %m.cur, 0
  br i1 %m.is0, label %ret, label %sort.body

sort.body:
  %a0.ptr = getelementptr inbounds i32, i32* %a, i64 0
  %a0.val = load i32, i32* %a0.ptr, align 4
  %am.ptr = getelementptr inbounds i32, i32* %a, i64 %m.cur
  %am.val = load i32, i32* %am.ptr, align 4
  store i32 %am.val, i32* %a0.ptr, align 4
  store i32 %a0.val, i32* %am.ptr, align 4
  br label %sort.sift.loop

sort.sift.loop:
  %k2.cur = phi i64 [ 0, %sort.body ], [ %k2.next, %sort.sift.swap ]
  %k2shl = shl i64 %k2.cur, 1
  %child2 = add i64 %k2shl, 1
  %child2.ge.m = icmp uge i64 %child2, %m.cur
  br i1 %child2.ge.m, label %sort.after.sift, label %sort.has.child

sort.has.child:
  %child2.ptr = getelementptr inbounds i32, i32* %a, i64 %child2
  %child2.val = load i32, i32* %child2.ptr, align 4
  %right2 = add i64 %child2, 1
  %right2.lt.m = icmp ult i64 %right2, %m.cur
  br i1 %right2.lt.m, label %sort.check.right, label %sort.choose.left

sort.check.right:
  %right2.ptr = getelementptr inbounds i32, i32* %a, i64 %right2
  %right2.val = load i32, i32* %right2.ptr, align 4
  %right2.gt.left = icmp sgt i32 %right2.val, %child2.val
  br i1 %right2.gt.left, label %sort.choose.right, label %sort.choose.left

sort.choose.right:
  %largest2.idx.r = phi i64 [ %right2, %sort.check.right ]
  %largest2.val.r = phi i32 [ %right2.val, %sort.check.right ]
  br label %sort.after.choose

sort.choose.left:
  %largest2.idx.l = phi i64 [ %child2, %sort.has.child ], [ %child2, %sort.check.right ]
  %largest2.val.l = phi i32 [ %child2.val, %sort.has.child ], [ %child2.val, %sort.check.right ]
  br label %sort.after.choose

sort.after.choose:
  %largest2.idx = phi i64 [ %largest2.idx.r, %sort.choose.right ], [ %largest2.idx.l, %sort.choose.left ]
  %largest2.val = phi i32 [ %largest2.val.r, %sort.choose.right ], [ %largest2.val.l, %sort.choose.left ]
  %k2.ptr = getelementptr inbounds i32, i32* %a, i64 %k2.cur
  %k2.val = load i32, i32* %k2.ptr, align 4
  %parent2.ge.child = icmp sge i32 %k2.val, %largest2.val
  br i1 %parent2.ge.child, label %sort.after.sift, label %sort.sift.swap

sort.sift.swap:
  %largest2.ptr = getelementptr inbounds i32, i32* %a, i64 %largest2.idx
  store i32 %largest2.val, i32* %k2.ptr, align 4
  store i32 %k2.val, i32* %largest2.ptr, align 4
  %k2.next = %largest2.idx
  br label %sort.sift.loop

sort.after.sift:
  %m.next = add i64 %m.cur, -1
  br label %sort.loop.check

ret:
  ret void
}