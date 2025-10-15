target triple = "x86_64-pc-windows-msvc"

define dso_local void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %exit, label %outer.cond

outer.cond:                                           ; preds = %entry, %outer.update
  %limit = phi i64 [ %n, %entry ], [ %lastSwap, %outer.update ]
  %gt1 = icmp ugt i64 %limit, 1
  br i1 %gt1, label %outer.body, label %exit

outer.body:                                           ; preds = %outer.cond
  br label %inner.header

inner.header:                                         ; preds = %outer.body, %inner.latch
  %i = phi i64 [ 1, %outer.body ], [ %i.next, %inner.latch ]
  %lastSwap = phi i64 [ 0, %outer.body ], [ %lastSwap.sel, %inner.latch ]
  %cond.inner = icmp ult i64 %i, %limit
  br i1 %cond.inner, label %inner.cmp, label %inner.done

inner.cmp:                                            ; preds = %inner.header
  %i.minus1 = add i64 %i, -1
  %ptr.prev = getelementptr inbounds i32, i32* %arr, i64 %i.minus1
  %val.prev = load i32, i32* %ptr.prev, align 4
  %ptr.cur = getelementptr inbounds i32, i32* %arr, i64 %i
  %val.cur = load i32, i32* %ptr.cur, align 4
  %cmp.swap = icmp sgt i32 %val.prev, %val.cur
  br i1 %cmp.swap, label %inner.swap, label %inner.noswap

inner.swap:                                           ; preds = %inner.cmp
  store i32 %val.cur, i32* %ptr.prev, align 4
  store i32 %val.prev, i32* %ptr.cur, align 4
  br label %inner.latch

inner.noswap:                                         ; preds = %inner.cmp
  br label %inner.latch

inner.latch:                                          ; preds = %inner.swap, %inner.noswap
  %lastSwap.sel = phi i64 [ %i, %inner.swap ], [ %lastSwap, %inner.noswap ]
  %i.next = add i64 %i, 1
  br label %inner.header

inner.done:                                           ; preds = %inner.header
  %isZero = icmp eq i64 %lastSwap, 0
  br i1 %isZero, label %exit, label %outer.update

outer.update:                                         ; preds = %inner.done
  br label %outer.cond

exit:                                                 ; preds = %outer.cond, %inner.done, %entry
  ret void
}