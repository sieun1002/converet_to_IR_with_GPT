; ModuleID = 'bubble_sort'
source_filename = "bubble_sort.ll"
target triple = "x86_64-pc-linux-gnu"

define dso_local void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %cmp1 = icmp ule i64 %n, 1
  br i1 %cmp1, label %ret, label %outer.cond

outer.cond:                                         ; preds = %outer.cont, %entry
  %bound = phi i64 [ %n, %entry ], [ %bound.next, %outer.cont ]
  %gt1 = icmp ugt i64 %bound, 1
  br i1 %gt1, label %inner.init, label %ret

inner.init:                                         ; preds = %outer.cond
  br label %inner.cond

inner.cond:                                         ; preds = %inner.inc, %inner.init
  %i = phi i64 [ 1, %inner.init ], [ %i.next, %inner.inc ]
  %last = phi i64 [ 0, %inner.init ], [ %last.next, %inner.inc ]
  %cmpi = icmp ult i64 %i, %bound
  br i1 %cmpi, label %inner.body, label %after.inner

inner.body:                                         ; preds = %inner.cond
  %i.minus1 = add i64 %i, -1
  %prev.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.minus1
  %curr.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %prev.val = load i32, i32* %prev.ptr, align 4
  %curr.val = load i32, i32* %curr.ptr, align 4
  %cmpswap = icmp sgt i32 %prev.val, %curr.val
  br i1 %cmpswap, label %do.swap, label %no.swap

do.swap:                                            ; preds = %inner.body
  store i32 %curr.val, i32* %prev.ptr, align 4
  store i32 %prev.val, i32* %curr.ptr, align 4
  br label %inner.inc

no.swap:                                            ; preds = %inner.body
  br label %inner.inc

inner.inc:                                          ; preds = %no.swap, %do.swap
  %last.next = phi i64 [ %i, %do.swap ], [ %last, %no.swap ]
  %i.next = add i64 %i, 1
  br label %inner.cond

after.inner:                                        ; preds = %inner.cond
  %noSwaps = icmp eq i64 %last, 0
  br i1 %noSwaps, label %ret, label %outer.cont

outer.cont:                                         ; preds = %after.inner
  %bound.next = phi i64 [ %last, %after.inner ]
  br label %outer.cond

ret:                                                ; preds = %after.inner, %outer.cond, %entry
  ret void
}