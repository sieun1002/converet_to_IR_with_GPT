define void @bubble_sort(i32* %a, i64 %n) {
entry:
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %ret, label %init

init:
  br label %outer.check

outer.check:
  %last = phi i64 [ %n, %init ], [ %last_swap, %setLast ]
  %cmpLast = icmp ugt i64 %last, 1
  br i1 %cmpLast, label %outer.body, label %ret

outer.body:
  br label %inner.cond

inner.cond:
  %i = phi i64 [ 1, %outer.body ], [ %i.next, %inner.latch ]
  %last_swap = phi i64 [ 0, %outer.body ], [ %ls.update, %inner.latch ]
  %cmpI = icmp ult i64 %i, %last
  br i1 %cmpI, label %inner.body, label %afterInner

inner.body:
  %im1 = add i64 %i, -1
  %ptrPrev = getelementptr inbounds i32, i32* %a, i64 %im1
  %ptrCurr = getelementptr inbounds i32, i32* %a, i64 %i
  %valPrev = load i32, i32* %ptrPrev, align 4
  %valCurr = load i32, i32* %ptrCurr, align 4
  %cmpSwap = icmp sgt i32 %valPrev, %valCurr
  br i1 %cmpSwap, label %do.swap, label %no.swap

do.swap:
  store i32 %valCurr, i32* %ptrPrev, align 4
  store i32 %valPrev, i32* %ptrCurr, align 4
  br label %inner.latch

no.swap:
  br label %inner.latch

inner.latch:
  %ls.update = phi i64 [ %i, %do.swap ], [ %last_swap, %no.swap ]
  %i.next = add i64 %i, 1
  br label %inner.cond

afterInner:
  %isZero = icmp eq i64 %last_swap, 0
  br i1 %isZero, label %ret, label %setLast

setLast:
  br label %outer.check

ret:
  ret void
}