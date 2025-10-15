; ModuleID = 'heapsort_module'
target triple = "x86_64-pc-windows-msvc"

define void @sub_140001450(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %ret, label %build.header

build.header:
  %half = lshr i64 %n, 1
  br label %build.check

build.check:
  %i.cur = phi i64 [ %half, %build.header ], [ %i.next, %build.afterSift ]
  %i.is.zero = icmp eq i64 %i.cur, 0
  br i1 %i.is.zero, label %extract.init, label %sift.entry

sift.entry:
  br label %sift.check

sift.check:
  %j.cur = phi i64 [ %i.cur, %sift.entry ], [ %j.next, %sift.iter.end ]
  %j.shl = shl i64 %j.cur, 1
  %left = add i64 %j.shl, 1
  %left.lt.n = icmp ult i64 %left, %n
  br i1 %left.lt.n, label %sift.have.left, label %build.afterSift

sift.have.left:
  %right = add i64 %left, 1
  %right.lt.n = icmp ult i64 %right, %n
  %ptr.left = getelementptr inbounds i32, i32* %arr, i64 %left
  %val.left = load i32, i32* %ptr.left, align 4
  br i1 %right.lt.n, label %cmp.right, label %choose.largest

cmp.right:
  %ptr.right = getelementptr inbounds i32, i32* %arr, i64 %right
  %val.right = load i32, i32* %ptr.right, align 4
  %right.gt.left = icmp sgt i32 %val.right, %val.left
  %largest.sel = select i1 %right.gt.left, i64 %right, i64 %left
  br label %choose.largest

choose.largest:
  %largest = phi i64 [ %left, %sift.have.left ], [ %largest.sel, %cmp.right ]
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %val.j = load i32, i32* %ptr.j, align 4
  %ptr.largest = getelementptr inbounds i32, i32* %arr, i64 %largest
  %val.largest = load i32, i32* %ptr.largest, align 4
  %j.ge.largest = icmp sge i32 %val.j, %val.largest
  br i1 %j.ge.largest, label %build.afterSift, label %do.swap

do.swap:
  store i32 %val.largest, i32* %ptr.j, align 4
  store i32 %val.j, i32* %ptr.largest, align 4
  br label %sift.iter.end

sift.iter.end:
  %j.next = phi i64 [ %largest, %do.swap ]
  br label %sift.check

build.afterSift:
  %i.cur.phi = phi i64 [ %i.cur, %sift.check ], [ %i.cur, %choose.largest ]
  %i.next = add i64 %i.cur.phi, -1
  br label %build.check

extract.init:
  %end.start = add i64 %n, -1
  br label %extract.loop

extract.loop:
  %end.cur = phi i64 [ %end.start, %extract.init ], [ %end.next, %extract.afterSift ]
  %end.is.zero = icmp eq i64 %end.cur, 0
  br i1 %end.is.zero, label %ret, label %extract.swap

extract.swap:
  %ptr.0 = getelementptr inbounds i32, i32* %arr, i64 0
  %val.0 = load i32, i32* %ptr.0, align 4
  %ptr.end = getelementptr inbounds i32, i32* %arr, i64 %end.cur
  %val.end = load i32, i32* %ptr.end, align 4
  store i32 %val.end, i32* %ptr.0, align 4
  store i32 %val.0, i32* %ptr.end, align 4
  br label %sift2.check

sift2.check:
  %j2.cur = phi i64 [ 0, %extract.swap ], [ %j2.next, %sift2.iter.end ]
  %j2.shl = shl i64 %j2.cur, 1
  %left2 = add i64 %j2.shl, 1
  %left2.lt.end = icmp ult i64 %left2, %end.cur
  br i1 %left2.lt.end, label %sift2.have.left, label %extract.afterSift

sift2.have.left:
  %right2 = add i64 %left2, 1
  %right2.lt.end = icmp ult i64 %right2, %end.cur
  %ptr.left2 = getelementptr inbounds i32, i32* %arr, i64 %left2
  %val.left2 = load i32, i32* %ptr.left2, align 4
  br i1 %right2.lt.end, label %cmp2.right, label %choose2.largest

cmp2.right:
  %ptr.right2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %val.right2 = load i32, i32* %ptr.right2, align 4
  %right2.gt.left2 = icmp sgt i32 %val.right2, %val.left2
  %largest2.sel = select i1 %right2.gt.left2, i64 %right2, i64 %left2
  br label %choose2.largest

choose2.largest:
  %largest2 = phi i64 [ %left2, %sift2.have.left ], [ %largest2.sel, %cmp2.right ]
  %ptr.j2 = getelementptr inbounds i32, i32* %arr, i64 %j2.cur
  %val.j2 = load i32, i32* %ptr.j2, align 4
  %ptr.largest2 = getelementptr inbounds i32, i32* %arr, i64 %largest2
  %val.largest2 = load i32, i32* %ptr.largest2, align 4
  %j2.ge.largest2 = icmp sge i32 %val.j2, %val.largest2
  br i1 %j2.ge.largest2, label %extract.afterSift, label %do2.swap

do2.swap:
  store i32 %val.largest2, i32* %ptr.j2, align 4
  store i32 %val.j2, i32* %ptr.largest2, align 4
  br label %sift2.iter.end

sift2.iter.end:
  %j2.next = phi i64 [ %largest2, %do2.swap ]
  br label %sift2.check

extract.afterSift:
  %end.next = add i64 %end.cur, -1
  br label %extract.loop

ret:
  ret void
}