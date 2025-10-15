; ModuleID = 'heap_sort.ll'
target triple = "x86_64-pc-linux-gnu"

define void @heap_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp_n = icmp ule i64 %n, 1
  br i1 %cmp_n, label %ret, label %build.init

build.init:
  %half = lshr i64 %n, 1
  br label %build.loop.check

build.loop.check:
  %i.phi = phi i64 [ %half, %build.init ], [ %i.next, %build.loop.body.end ]
  %old_nonzero = icmp ne i64 %i.phi, 0
  br i1 %old_nonzero, label %build.loop.body.start, label %build.done

build.loop.body.start:
  %start = add i64 %i.phi, -1
  br label %sift1.header

sift1.header:
  %root1.phi = phi i64 [ %start, %build.loop.body.start ], [ %root1.next, %sift1.iter.end ]
  %twice1 = shl i64 %root1.phi, 1
  %child1 = add i64 %twice1, 1
  %child_in1 = icmp ult i64 %child1, %n
  br i1 %child_in1, label %sift1.child.check, label %sift1.done

sift1.child.check:
  %right1 = add i64 %child1, 1
  %has_right1 = icmp ult i64 %right1, %n
  br i1 %has_right1, label %sift1.lr, label %sift1.no_right

sift1.lr:
  %ptr_right1 = getelementptr inbounds i32, i32* %arr, i64 %right1
  %val_right1 = load i32, i32* %ptr_right1, align 4
  %ptr_child1 = getelementptr inbounds i32, i32* %arr, i64 %child1
  %val_child1 = load i32, i32* %ptr_child1, align 4
  %right_gt1 = icmp sgt i32 %val_right1, %val_child1
  %maxIdx_lr1 = select i1 %right_gt1, i64 %right1, i64 %child1
  br label %sift1.after.select

sift1.no_right:
  br label %sift1.after.select

sift1.after.select:
  %maxChild1 = phi i64 [ %maxIdx_lr1, %sift1.lr ], [ %child1, %sift1.no_right ]
  %ptr_root1 = getelementptr inbounds i32, i32* %arr, i64 %root1.phi
  %val_root1 = load i32, i32* %ptr_root1, align 4
  %ptr_max1 = getelementptr inbounds i32, i32* %arr, i64 %maxChild1
  %val_max1 = load i32, i32* %ptr_max1, align 4
  %ge1 = icmp sge i32 %val_root1, %val_max1
  br i1 %ge1, label %sift1.done, label %sift1.do.swap

sift1.do.swap:
  store i32 %val_max1, i32* %ptr_root1, align 4
  store i32 %val_root1, i32* %ptr_max1, align 4
  %root1.next = add i64 %maxChild1, 0
  br label %sift1.iter.end

sift1.iter.end:
  br label %sift1.header

sift1.done:
  br label %build.loop.body.end

build.loop.body.end:
  %i.next = add i64 %i.phi, -1
  br label %build.loop.check

build.done:
  %end.init = add i64 %n, -1
  br label %outer.check

outer.check:
  %end.phi = phi i64 [ %end.init, %build.done ], [ %end.next, %after.inner ]
  %cond2 = icmp ne i64 %end.phi, 0
  br i1 %cond2, label %outer.body, label %ret

outer.body:
  %p0 = getelementptr inbounds i32, i32* %arr, i64 0
  %v0 = load i32, i32* %p0, align 4
  %pend = getelementptr inbounds i32, i32* %arr, i64 %end.phi
  %vend = load i32, i32* %pend, align 4
  store i32 %vend, i32* %p0, align 4
  store i32 %v0, i32* %pend, align 4
  br label %sift2.header

sift2.header:
  %root2.phi = phi i64 [ 0, %outer.body ], [ %root2.next, %sift2.iter.end ]
  %twice2 = shl i64 %root2.phi, 1
  %child2 = add i64 %twice2, 1
  %child_in2 = icmp ult i64 %child2, %end.phi
  br i1 %child_in2, label %sift2.child.check, label %after.inner

sift2.child.check:
  %right2 = add i64 %child2, 1
  %has_right2 = icmp ult i64 %right2, %end.phi
  br i1 %has_right2, label %sift2.lr, label %sift2.no_right

sift2.lr:
  %ptr_right2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %val_right2 = load i32, i32* %ptr_right2, align 4
  %ptr_child2 = getelementptr inbounds i32, i32* %arr, i64 %child2
  %val_child2 = load i32, i32* %ptr_child2, align 4
  %right_gt2 = icmp sgt i32 %val_right2, %val_child2
  %maxIdx_lr2 = select i1 %right_gt2, i64 %right2, i64 %child2
  br label %sift2.after.select

sift2.no_right:
  br label %sift2.after.select

sift2.after.select:
  %maxChild2 = phi i64 [ %maxIdx_lr2, %sift2.lr ], [ %child2, %sift2.no_right ]
  %ptr_root2 = getelementptr inbounds i32, i32* %arr, i64 %root2.phi
  %val_root2 = load i32, i32* %ptr_root2, align 4
  %ptr_max2 = getelementptr inbounds i32, i32* %arr, i64 %maxChild2
  %val_max2 = load i32, i32* %ptr_max2, align 4
  %ge2 = icmp sge i32 %val_root2, %val_max2
  br i1 %ge2, label %after.inner, label %sift2.do.swap

sift2.do.swap:
  store i32 %val_max2, i32* %ptr_root2, align 4
  store i32 %val_root2, i32* %ptr_max2, align 4
  %root2.next = add i64 %maxChild2, 0
  br label %sift2.iter.end

sift2.iter.end:
  br label %sift2.header

after.inner:
  %end.next = add i64 %end.phi, -1
  br label %outer.check

ret:
  ret void
}