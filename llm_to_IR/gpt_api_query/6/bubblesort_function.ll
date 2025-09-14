; ModuleID = 'bubble_sort.ll'
source_filename = "bubble_sort"
target triple = "x86_64-pc-linux-gnu"

define dso_local void @bubble_sort(i32* nocapture %arr, i64 %n) #0 {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %exit, label %outer.header

outer.header:                                      ; preds = %entry, %outer.cont
  %limit = phi i64 [ %n, %entry ], [ %newlimit, %outer.cont ]
  %limit_gt1 = icmp ugt i64 %limit, 1
  br i1 %limit_gt1, label %inner.header, label %exit

inner.header:                                      ; preds = %outer.header, %inner.latch
  %i = phi i64 [ 1, %outer.header ], [ %i.next, %inner.latch ]
  %last = phi i64 [ 0, %outer.header ], [ %last.updated, %inner.latch ]
  %i_lt_limit = icmp ult i64 %i, %limit
  br i1 %i_lt_limit, label %inner.body, label %after.inner

inner.body:                                        ; preds = %inner.header
  %i.minus1 = add i64 %i, -1
  %ptr.im1 = getelementptr inbounds i32, i32* %arr, i64 %i.minus1
  %ptr.i = getelementptr inbounds i32, i32* %arr, i64 %i
  %val.im1 = load i32, i32* %ptr.im1, align 4
  %val.i = load i32, i32* %ptr.i, align 4
  %need.swap = icmp sgt i32 %val.im1, %val.i
  br i1 %need.swap, label %do.swap, label %no.swap

do.swap:                                           ; preds = %inner.body
  store i32 %val.i, i32* %ptr.im1, align 4
  store i32 %val.im1, i32* %ptr.i, align 4
  br label %inner.latch

no.swap:                                           ; preds = %inner.body
  br label %inner.latch

inner.latch:                                       ; preds = %no.swap, %do.swap
  %last.updated = phi i64 [ %i, %do.swap ], [ %last, %no.swap ]
  %i.next = add i64 %i, 1
  br label %inner.header

after.inner:                                       ; preds = %inner.header
  %no.swaps = icmp eq i64 %last, 0
  br i1 %no.swaps, label %exit, label %outer.cont

outer.cont:                                        ; preds = %after.inner
  %newlimit = phi i64 [ %last, %after.inner ]
  br label %outer.header

exit:                                              ; preds = %after.inner, %outer.header, %entry
  ret void
}

attributes #0 = { nounwind }