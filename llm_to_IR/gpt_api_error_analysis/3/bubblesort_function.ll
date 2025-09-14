define void @bubble_sort(i32* nocapture %arr, i64 %n) {
entry:
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %exit, label %outer.init

outer.init:
  br label %outer.header

outer.header:
  %upper = phi i64 [ %n, %outer.init ], [ %last, %outer.update ]
  %outer.cond = icmp ugt i64 %upper, 1
  br i1 %outer.cond, label %inner.header, label %exit

inner.header:
  %i = phi i64 [ 1, %outer.header ], [ %i.next, %inner.latch ]
  %last = phi i64 [ 0, %outer.header ], [ %last.sel, %inner.latch ]
  %i.cmp = icmp ult i64 %i, %upper
  br i1 %i.cmp, label %inner.body, label %inner.exit

inner.body:
  %i.minus1 = add i64 %i, -1
  %ptr.prev = getelementptr inbounds i32, i32* %arr, i64 %i.minus1
  %a = load i32, i32* %ptr.prev, align 4
  %ptr.curr = getelementptr inbounds i32, i32* %arr, i64 %i
  %b = load i32, i32* %ptr.curr, align 4
  %need.swap = icmp sgt i32 %a, %b
  br i1 %need.swap, label %do.swap, label %no.swap

do.swap:
  store i32 %b, i32* %ptr.prev, align 4
  store i32 %a, i32* %ptr.curr, align 4
  br label %inner.latch

no.swap:
  br label %inner.latch

inner.latch:
  %last.sel = phi i64 [ %i, %do.swap ], [ %last, %no.swap ]
  %i.next = add i64 %i, 1
  br label %inner.header

inner.exit:
  %no.swaps = icmp eq i64 %last, 0
  br i1 %no.swaps, label %exit, label %outer.update

outer.update:
  br label %outer.header

exit:
  ret void
}