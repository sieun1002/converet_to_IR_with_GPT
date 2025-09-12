; LLVM IR (LLVM 14) for function: heap_sort
; Signature inferred from calling convention and memory access:
;   void heap_sort(int* arr, uint64_t n)

define dso_local void @heap_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %ret, label %build.init

build.init:
  %i0 = lshr i64 %n, 1
  br label %build.outer

; Build max-heap: for (i = n/2; i != 0; --i) siftDown(i)
build.outer:
  %i = phi i64 [ %i0, %build.init ], [ %i.dec, %after.inner ]
  %i.ne0 = icmp ne i64 %i, 0
  br i1 %i.ne0, label %sift.down.build, label %extract.init

sift.down.build:
  %k = phi i64 [ %i, %build.outer ], [ %child, %swap.build ]
  %twok = shl i64 %k, 1
  %left = add i64 %twok, 1
  %left.in = icmp ult i64 %left, %n
  br i1 %left.in, label %choose.child.build, label %after.inner

choose.child.build:
  %right = add i64 %left, 1
  %right.in = icmp ult i64 %right, %n
  %left.ptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %left.val = load i32, i32* %left.ptr, align 4
  br i1 %right.in, label %have.right.build, label %choose.done.build

have.right.build:
  %right.ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right.val = load i32, i32* %right.ptr, align 4
  %right.gt.left = icmp sgt i32 %right.val, %left.val
  %child.sel = select i1 %right.gt.left, i64 %right, i64 %left
  br label %choose.done.build

choose.done.build:
  %child = phi i64 [ %left, %choose.child.build ], [ %child.sel, %have.right.build ]
  %parent.ptr = getelementptr inbounds i32, i32* %arr, i64 %k
  %parent.val = load i32, i32* %parent.ptr, align 4
  %child.ptr = getelementptr inbounds i32, i32* %arr, i64 %child
  %child.val = load i32, i32* %child.ptr, align 4
  %parent.ge.child = icmp sge i32 %parent.val, %child.val
  br i1 %parent.ge.child, label %after.inner, label %swap.build

swap.build:
  store i32 %child.val, i32* %parent.ptr, align 4
  store i32 %parent.val, i32* %child.ptr, align 4
  br label %sift.down.build

after.inner:
  %i.dec = add i64 %i, -1
  br label %build.outer

; Heap sort extraction phase
extract.init:
  %last0 = add i64 %n, -1
  br label %extract.outer

extract.outer:
  %last = phi i64 [ %last0, %extract.init ], [ %last.dec, %after.sift.extract ]
  %cont = icmp ne i64 %last, 0
  br i1 %cont, label %do.extract, label %ret

do.extract:
  ; swap arr[0] and arr[last]
  %root.val = load i32, i32* %arr, align 4
  %last.ptr = getelementptr inbounds i32, i32* %arr, i64 %last
  %last.val = load i32, i32* %last.ptr, align 4
  store i32 %last.val, i32* %arr, align 4
  store i32 %root.val, i32* %last.ptr, align 4
  br label %sift.down.extract

; Sift down with heap size = last (exclusive upper bound)
sift.down.extract:
  %k2 = phi i64 [ 0, %do.extract ], [ %child2, %swap.extract ]
  %twok2 = shl i64 %k2, 1
  %left2 = add i64 %twok2, 1
  %left.in2 = icmp ult i64 %left2, %last
  br i1 %left.in2, label %choose.child.extract, label %after.sift.extract

choose.child.extract:
  %right2 = add i64 %left2, 1
  %right.in2 = icmp ult i64 %right2, %last
  %left.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %left2
  %left.val2 = load i32, i32* %left.ptr2, align 4
  br i1 %right.in2, label %have.right.extract, label %choose.done.extract

have.right.extract:
  %right.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %right.val2 = load i32, i32* %right.ptr2, align 4
  %right.gt.left2 = icmp sgt i32 %right.val2, %left.val2
  %child.sel2 = select i1 %right.gt.left2, i64 %right2, i64 %left2
  br label %choose.done.extract

choose.done.extract:
  %child2 = phi i64 [ %left2, %choose.child.extract ], [ %child.sel2, %have.right.extract ]
  %parent.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %k2
  %parent.val2 = load i32, i32* %parent.ptr2, align 4
  %child.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %child2
  %child.val2 = load i32, i32* %child.ptr2, align 4
  %parent.ge.child2 = icmp sge i32 %parent.val2, %child.val2
  br i1 %parent.ge.child2, label %after.sift.extract, label %swap.extract

swap.extract:
  store i32 %child.val2, i32* %parent.ptr2, align 4
  store i32 %parent.val2, i32* %child.ptr2, align 4
  br label %sift.down.extract

after.sift.extract:
  %last.dec = add i64 %last, -1
  br label %extract.outer

ret:
  ret void
}