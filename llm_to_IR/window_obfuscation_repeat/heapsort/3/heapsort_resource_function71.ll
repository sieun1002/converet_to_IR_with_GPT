; ModuleID: sub_140001450_module
source_filename = "sub_140001450_module"
target triple = "x86_64-pc-windows-msvc"

define dso_local void @sub_140001450(i32* %arr, i64 %len) {
entry:
  %cmp_small = icmp ule i64 %len, 1
  br i1 %cmp_small, label %ret, label %build.start

build.start:
  %heapStart = lshr i64 %len, 1
  br label %build.outer.cond

build.outer.cond:
  %hs.cur = phi i64 [ %heapStart, %build.start ], [ %hs.dec, %build.outer.decrement ]
  %hs.iszero = icmp eq i64 %hs.cur, 0
  br i1 %hs.iszero, label %second.phase.entry, label %build.outer.body.entry

build.outer.body.entry:
  br label %build.inner.header

build.inner.header:
  %i.cur = phi i64 [ %hs.cur, %build.outer.body.entry ], [ %i.next, %sift.swap.cont ]
  %mul2 = shl i64 %i.cur, 1
  %left.idx = add i64 %mul2, 1
  %left.oob = icmp uge i64 %left.idx, %len
  br i1 %left.oob, label %build.outer.decrement, label %cmp.right.bound

cmp.right.bound:
  %left.ptr = getelementptr inbounds i32, i32* %arr, i64 %left.idx
  %left.val = load i32, i32* %left.ptr, align 4
  %right.idx = add i64 %left.idx, 1
  %right.in = icmp ult i64 %right.idx, %len
  br i1 %right.in, label %choose.largest.cmp, label %choose.noRight

choose.noRight:
  br label %largest.join

choose.largest.cmp:
  %right.ptr = getelementptr inbounds i32, i32* %arr, i64 %right.idx
  %right.val = load i32, i32* %right.ptr, align 4
  %right.gt.left = icmp sgt i32 %right.val, %left.val
  br i1 %right.gt.left, label %choose.right, label %choose.left2

choose.right:
  br label %largest.join

choose.left2:
  br label %largest.join

largest.join:
  %largest.idx = phi i64 [ %left.idx, %choose.noRight ], [ %right.idx, %choose.right ], [ %left.idx, %choose.left2 ]
  %largest.val = phi i32 [ %left.val, %choose.noRight ], [ %right.val, %choose.right ], [ %left.val, %choose.left2 ]
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %i.val = load i32, i32* %i.ptr, align 4
  %need.swap = icmp slt i32 %i.val, %largest.val
  br i1 %need.swap, label %sift.swap, label %build.outer.decrement

sift.swap:
  store i32 %largest.val, i32* %i.ptr, align 4
  %largest.ptr = getelementptr inbounds i32, i32* %arr, i64 %largest.idx
  store i32 %i.val, i32* %largest.ptr, align 4
  %i.next = add i64 %largest.idx, 0
  br label %sift.swap.cont

sift.swap.cont:
  br label %build.inner.header

build.outer.decrement:
  %hs.dec = add i64 %hs.cur, -1
  br label %build.outer.cond

second.phase.entry:
  %end.init = add i64 %len, -1
  br label %sort.outer.cond

sort.outer.cond:
  %end.cur = phi i64 [ %end.init, %second.phase.entry ], [ %end.dec, %after.heapify.in.sort ]
  %end.iszero = icmp eq i64 %end.cur, 0
  br i1 %end.iszero, label %ret, label %sort.outer.body

sort.outer.body:
  %root.ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %root.val = load i32, i32* %root.ptr, align 4
  %end.ptr = getelementptr inbounds i32, i32* %arr, i64 %end.cur
  %end.val = load i32, i32* %end.ptr, align 4
  store i32 %end.val, i32* %root.ptr, align 4
  store i32 %root.val, i32* %end.ptr, align 4
  br label %sort.inner.header

sort.inner.header:
  %i2.cur = phi i64 [ 0, %sort.outer.body ], [ %i2.next, %sort.sift.swap.cont ]
  %mul2.s = shl i64 %i2.cur, 1
  %left.idx.s = add i64 %mul2.s, 1
  %left.oob.s = icmp uge i64 %left.idx.s, %end.cur
  br i1 %left.oob.s, label %after.heapify.in.sort, label %sort.cmp.right.bound

sort.cmp.right.bound:
  %left.ptr.s = getelementptr inbounds i32, i32* %arr, i64 %left.idx.s
  %left.val.s = load i32, i32* %left.ptr.s, align 4
  %right.idx.s = add i64 %left.idx.s, 1
  %right.in.s = icmp ult i64 %right.idx.s, %end.cur
  br i1 %right.in.s, label %sort.choose.cmp, label %sort.choose.noRight

sort.choose.noRight:
  br label %sort.largest.join

sort.choose.cmp:
  %right.ptr.s = getelementptr inbounds i32, i32* %arr, i64 %right.idx.s
  %right.val.s = load i32, i32* %right.ptr.s, align 4
  %right.gt.left.s = icmp sgt i32 %right.val.s, %left.val.s
  br i1 %right.gt.left.s, label %sort.choose.right, label %sort.choose.left2

sort.choose.right:
  br label %sort.largest.join

sort.choose.left2:
  br label %sort.largest.join

sort.largest.join:
  %largest.idx.s = phi i64 [ %left.idx.s, %sort.choose.noRight ], [ %right.idx.s, %sort.choose.right ], [ %left.idx.s, %sort.choose.left2 ]
  %largest.val.s = phi i32 [ %left.val.s, %sort.choose.noRight ], [ %right.val.s, %sort.choose.right ], [ %left.val.s, %sort.choose.left2 ]
  %i2.ptr = getelementptr inbounds i32, i32* %arr, i64 %i2.cur
  %i2.val = load i32, i32* %i2.ptr, align 4
  %need.swap.s = icmp slt i32 %i2.val, %largest.val.s
  br i1 %need.swap.s, label %sort.sift.swap, label %after.heapify.in.sort

sort.sift.swap:
  store i32 %largest.val.s, i32* %i2.ptr, align 4
  %largest.ptr.s = getelementptr inbounds i32, i32* %arr, i64 %largest.idx.s
  store i32 %i2.val, i32* %largest.ptr.s, align 4
  %i2.next = add i64 %largest.idx.s, 0
  br label %sort.sift.swap.cont

sort.sift.swap.cont:
  br label %sort.inner.header

after.heapify.in.sort:
  %end.dec = add i64 %end.cur, -1
  br label %sort.outer.cond

ret:
  ret void
}