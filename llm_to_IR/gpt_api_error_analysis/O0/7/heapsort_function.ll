; ModuleID = 'heapsort'
source_filename = "heapsort.c"
target triple = "x86_64-pc-linux-gnu"

define void @heap_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %ret, label %build.entry

build.entry:
  %hstart = lshr i64 %n, 1
  br label %build.header

build.header:
  %i.ph = phi i64 [ %hstart, %build.entry ], [ %i.next, %sift.done ]
  %i.nonzero = icmp ne i64 %i.ph, 0
  br i1 %i.nonzero, label %sift.entry, label %extract.init

sift.entry:
  %start.idx = add i64 %i.ph, -1
  br label %sift.loop

sift.loop:
  %i.cur = phi i64 [ %start.idx, %sift.entry ], [ %child.idx.ph, %do.swap ]
  %mul2 = shl i64 %i.cur, 1
  %left = add i64 %mul2, 1
  %left.ge.n = icmp uge i64 %left, %n
  br i1 %left.ge.n, label %sift.done, label %choose.child

choose.child:
  %right = add i64 %left, 1
  %right.in = icmp ult i64 %right, %n
  %left.ptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %left.val = load i32, i32* %left.ptr, align 4
  br i1 %right.in, label %load.right, label %choose.left

load.right:
  %right.ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right.val = load i32, i32* %right.ptr, align 4
  %cmp.rl = icmp sgt i32 %right.val, %left.val
  %child.idx.sel = select i1 %cmp.rl, i64 %right, i64 %left
  br label %child.selected

choose.left:
  br label %child.selected

child.selected:
  %child.idx.ph = phi i64 [ %child.idx.sel, %load.right ], [ %left, %choose.child ]
  %icur.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %icur.val = load i32, i32* %icur.ptr, align 4
  %child.ptr = getelementptr inbounds i32, i32* %arr, i64 %child.idx.ph
  %child.val = load i32, i32* %child.ptr, align 4
  %cmp.ge = icmp sge i32 %icur.val, %child.val
  br i1 %cmp.ge, label %sift.done, label %do.swap

do.swap:
  store i32 %child.val, i32* %icur.ptr, align 4
  store i32 %icur.val, i32* %child.ptr, align 4
  br label %sift.loop

sift.done:
  %i.next = add i64 %i.ph, -1
  br label %build.header

extract.init:
  %last.index = add i64 %n, -1
  br label %extract.header

extract.header:
  %heap.end = phi i64 [ %last.index, %extract.init ], [ %heap.end.next, %post.sift ]
  %cont = icmp ne i64 %heap.end, 0
  br i1 %cont, label %extract.body, label %ret

extract.body:
  %root.ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %root.val = load i32, i32* %root.ptr, align 4
  %end.ptr = getelementptr inbounds i32, i32* %arr, i64 %heap.end
  %end.val = load i32, i32* %end.ptr, align 4
  store i32 %end.val, i32* %root.ptr, align 4
  store i32 %root.val, i32* %end.ptr, align 4
  br label %sift2.loop

sift2.loop:
  %i2.cur = phi i64 [ 0, %extract.body ], [ %child2.idx.ph, %do.swap2 ]
  %left2.mul = shl i64 %i2.cur, 1
  %left2 = add i64 %left2.mul, 1
  %left2.ge.end = icmp uge i64 %left2, %heap.end
  br i1 %left2.ge.end, label %post.sift, label %choose.child2

choose.child2:
  %right2 = add i64 %left2, 1
  %right2.in = icmp ult i64 %right2, %heap.end
  %left2.ptr = getelementptr inbounds i32, i32* %arr, i64 %left2
  %left2.val = load i32, i32* %left2.ptr, align 4
  br i1 %right2.in, label %load.right2, label %choose.left2

load.right2:
  %right2.ptr = getelementptr inbounds i32, i32* %arr, i64 %right2
  %right2.val = load i32, i32* %right2.ptr, align 4
  %cmp.rl2 = icmp sgt i32 %right2.val, %left2.val
  %child2.idx.sel = select i1 %cmp.rl2, i64 %right2, i64 %left2
  br label %child2.selected

choose.left2:
  br label %child2.selected

child2.selected:
  %child2.idx.ph = phi i64 [ %child2.idx.sel, %load.right2 ], [ %left2, %choose.child2 ]
  %icur2.ptr = getelementptr inbounds i32, i32* %arr, i64 %i2.cur
  %icur2.val = load i32, i32* %icur2.ptr, align 4
  %child2.ptr = getelementptr inbounds i32, i32* %arr, i64 %child2.idx.ph
  %child2.val = load i32, i32* %child2.ptr, align 4
  %cmp.ge2 = icmp sge i32 %icur2.val, %child2.val
  br i1 %cmp.ge2, label %post.sift, label %do.swap2

do.swap2:
  store i32 %child2.val, i32* %icur2.ptr, align 4
  store i32 %icur2.val, i32* %child2.ptr, align 4
  br label %sift2.loop

post.sift:
  %heap.end.next = add i64 %heap.end, -1
  br label %extract.header

ret:
  ret void
}