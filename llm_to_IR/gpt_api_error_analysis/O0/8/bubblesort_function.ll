; ModuleID = 'bubble_sort.ll'
target triple = "x86_64-pc-linux-gnu"

define void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %ret, label %outer.preheader

outer.preheader:
  br label %outer.header

outer.header:
  %newn = phi i64 [ %n, %outer.preheader ], [ %last.upd, %outer.update ]
  %cmp1 = icmp ugt i64 %newn, 1
  br i1 %cmp1, label %inner.init, label %ret

inner.init:
  br label %inner.header

inner.header:
  %i = phi i64 [ 1, %inner.init ], [ %i.next, %inner.latch ]
  %last.cur = phi i64 [ 0, %inner.init ], [ %last.next, %inner.latch ]
  %cmp2 = icmp ult i64 %i, %newn
  br i1 %cmp2, label %inner.body, label %inner.exit

inner.body:
  %idx.im1 = sub i64 %i, 1
  %ptr.im1 = getelementptr inbounds i32, i32* %arr, i64 %idx.im1
  %val.im1 = load i32, i32* %ptr.im1, align 4
  %ptr.i = getelementptr inbounds i32, i32* %arr, i64 %i
  %val.i = load i32, i32* %ptr.i, align 4
  %cmp3 = icmp sgt i32 %val.im1, %val.i
  br i1 %cmp3, label %swap, label %noswap

swap:
  store i32 %val.i, i32* %ptr.im1, align 4
  store i32 %val.im1, i32* %ptr.i, align 4
  br label %inner.latch

noswap:
  br label %inner.latch

inner.latch:
  %last.next = phi i64 [ %i, %swap ], [ %last.cur, %noswap ]
  %i.next = add i64 %i, 1
  br label %inner.header

inner.exit:
  %iszero = icmp eq i64 %last.cur, 0
  br i1 %iszero, label %ret, label %outer.update

outer.update:
  %last.upd = phi i64 [ %last.cur, %inner.exit ]
  br label %outer.header

ret:
  ret void
}