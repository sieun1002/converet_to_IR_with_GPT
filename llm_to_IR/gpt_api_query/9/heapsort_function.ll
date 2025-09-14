; ModuleID = 'heap_sort_module'
source_filename = "heap_sort_module"

define void @heap_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n = icmp ule i64 %n, 1
  br i1 %cmp_n, label %exit, label %build.loop.test.prep

build.loop.test.prep:
  %i0 = lshr i64 %n, 1
  br label %build.loop.test

build.loop.test:                                 ; i.cur is "next i to process + 1"
  %i.cur = phi i64 [ %i0, %build.loop.test.prep ], [ %curr, %inner.exit ]
  %tst = icmp ne i64 %i.cur, 0
  br i1 %tst, label %build.loop.body, label %build.done

build.loop.body:
  %curr = add i64 %i.cur, -1
  br label %sift.loop

sift.loop:
  %k = phi i64 [ %curr, %build.loop.body ], [ %k.next, %do.swap ]
  %k.shl = shl i64 %k, 1
  %left = add i64 %k.shl, 1
  %left.out = icmp uge i64 %left, %n
  br i1 %left.out, label %inner.exit, label %check.right

check.right:
  %right = add i64 %left, 1
  %has.right = icmp ult i64 %right, %n
  %left.ptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %left.val = load i32, i32* %left.ptr, align 4
  br i1 %has.right, label %choose.cmp, label %child.is.left

choose.cmp:
  %right.ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right.val = load i32, i32* %right.ptr, align 4
  %cmp_rl = icmp sgt i32 %right.val, %left.val
  %child.idx.sel = select i1 %cmp_rl, i64 %right, i64 %left
  br label %child.ready

child.is.left:
  br label %child.ready

child.ready:
  %child = phi i64 [ %child.idx.sel, %choose.cmp ], [ %left, %child.is.left ]
  %k.ptr = getelementptr inbounds i32, i32* %arr, i64 %k
  %k.val = load i32, i32* %k.ptr, align 4
  %child.ptr = getelementptr inbounds i32, i32* %arr, i64 %child
  %child.val = load i32, i32* %child.ptr, align 4
  %noLess = icmp sge i32 %k.val, %child.val
  br i1 %noLess, label %inner.exit, label %do.swap

do.swap:
  store i32 %child.val, i32* %k.ptr, align 4
  store i32 %k.val, i32* %child.ptr, align 4
  %k.next = %child
  br label %sift.loop

inner.exit:
  br label %build.loop.test

build.done:
  %end.init = add i64 %n, -1
  br label %sort.test

sort.test:
  %end.cur = phi i64 [ %end.init, %build.done ], [ %end.next, %after.sift2 ]
  %cond = icmp ne i64 %end.cur, 0
  br i1 %cond, label %sort.body, label %exit

sort.body:
  %arr0 = load i32, i32* %arr, align 4
  %end.ptr = getelementptr inbounds i32, i32* %arr, i64 %end.cur
  %arrEnd = load i32, i32* %end.ptr, align 4
  store i32 %arrEnd, i32* %arr, align 4
  store i32 %arr0, i32* %end.ptr, align 4
  br label %sift2.loop

sift2.loop:
  %k2 = phi i64 [ 0, %sort.body ], [ %k2.next, %do.swap2 ]
  %k2.shl = shl i64 %k2, 1
  %left2 = add i64 %k2.shl, 1
  %left2.out = icmp uge i64 %left2, %end.cur
  br i1 %left2.out, label %after.sift2, label %check.right2

check.right2:
  %right2 = add i64 %left2, 1
  %has.right2 = icmp ult i64 %right2, %end.cur
  %left2.ptr = getelementptr inbounds i32, i32* %arr, i64 %left2
  %left2.val = load i32, i32* %left2.ptr, align 4
  br i1 %has.right2, label %cmp.right2, label %child.left2

cmp.right2:
  %right2.ptr = getelementptr inbounds i32, i32* %arr, i64 %right2
  %right2.val = load i32, i32* %right2.ptr, align 4
  %cmp2 = icmp sgt i32 %right2.val, %left2.val
  %child2.idx = select i1 %cmp2, i64 %right2, i64 %left2
  br label %child.ready2

child.left2:
  br label %child.ready2

child.ready2:
  %child2 = phi i64 [ %child2.idx, %cmp.right2 ], [ %left2, %child.left2 ]
  %k2.ptr = getelementptr inbounds i32, i32* %arr, i64 %k2
  %k2.val = load i32, i32* %k2.ptr, align 4
  %child2.ptr = getelementptr inbounds i32, i32* %arr, i64 %child2
  %child2.val = load i32, i32* %child2.ptr, align 4
  %noLess2 = icmp sge i32 %k2.val, %child2.val
  br i1 %noLess2, label %after.sift2, label %do.swap2

do.swap2:
  store i32 %child2.val, i32* %k2.ptr, align 4
  store i32 %k2.val, i32* %child2.ptr, align 4
  %k2.next = %child2
  br label %sift2.loop

after.sift2:
  %end.next = add i64 %end.cur, -1
  br label %sort.test

exit:
  ret void
}