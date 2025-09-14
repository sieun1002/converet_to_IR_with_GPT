; ModuleID = 'bubble_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bubble_sort ; Address: 0x1189
; Intent: In-place ascending bubble sort (last-swap boundary optimization) on i32 array (confidence=0.92). Evidence: adjacent comparisons/swaps of 32-bit elements; shrinking upper bound to last swap index.
; Preconditions: arr points to at least n i32 elements when n > 0.
; Postconditions: arr[0..n) sorted in nondecreasing (signed) order; stable.

; Only the necessary external declarations:

; Use the IDA symbol here (e.g., @heap_sort or @main)
define dso_local void @bubble_sort(i32* %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %ret, label %init

init:
  br label %outer.cond

outer.cond:                                           ; preds = %after.pass, %init
  %upper = phi i64 [ %n, %init ], [ %newUpper, %after.pass ]
  %cmp.upper.gt1 = icmp ugt i64 %upper, 1
  br i1 %cmp.upper.gt1, label %outer.body, label %ret

outer.body:                                           ; preds = %outer.cond
  br label %inner.cond

inner.cond:                                           ; preds = %inner.iter, %outer.body
  %i = phi i64 [ 1, %outer.body ], [ %i.next, %inner.iter ]
  %last = phi i64 [ 0, %outer.body ], [ %last.updated, %inner.iter ]
  %cmp.i.lt.upper = icmp ult i64 %i, %upper
  br i1 %cmp.i.lt.upper, label %inner.body, label %after.inner

inner.body:                                           ; preds = %inner.cond
  %im1 = add i64 %i, -1
  %p.prev = getelementptr inbounds i32, i32* %arr, i64 %im1
  %p.curr = getelementptr inbounds i32, i32* %arr, i64 %i
  %a = load i32, i32* %p.prev, align 4
  %b = load i32, i32* %p.curr, align 4
  %cmp.a.gt.b = icmp sgt i32 %a, %b
  br i1 %cmp.a.gt.b, label %do.swap, label %no.swap

do.swap:                                              ; preds = %inner.body
  store i32 %b, i32* %p.prev, align 4
  store i32 %a, i32* %p.curr, align 4
  br label %inner.iter

no.swap:                                              ; preds = %inner.body
  br label %inner.iter

inner.iter:                                           ; preds = %no.swap, %do.swap
  %last.updated = phi i64 [ %i, %do.swap ], [ %last, %no.swap ]
  %i.next = add i64 %i, 1
  br label %inner.cond

after.inner:                                          ; preds = %inner.cond
  %noSwaps = icmp eq i64 %last, 0
  br i1 %noSwaps, label %ret, label %after.pass

after.pass:                                           ; preds = %after.inner
  %newUpper = add i64 %last, 0
  br label %outer.cond

ret:                                                  ; preds = %outer.cond, %after.inner, %entry
  ret void
}