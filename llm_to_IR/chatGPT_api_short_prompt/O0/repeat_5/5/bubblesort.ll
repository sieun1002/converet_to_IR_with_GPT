; ModuleID = 'bubble_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bubble_sort ; Address: 0x1189
; Intent: In-place ascending bubble sort of i32 array with last-swap boundary optimization (confidence=0.98). Evidence: compares adjacent 32-bit elements, signed compare/swap, tracks last swap index to reduce pass bound.
; Preconditions: If n > 0 then arr must point to at least n i32 elements.
; Postconditions: arr[0..n) sorted in nondecreasing (signed) order.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)

define dso_local void @bubble_sort(i32* %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp_n = icmp ule i64 %n, 1
  br i1 %cmp_n, label %exit, label %outer.pre

outer.pre:
  br label %outer.cond

outer.cond:                                          ; preds = %outer.pre, %outer.cont
  %boundary = phi i64 [ %n, %outer.pre ], [ %boundary.next, %outer.cont ]
  %cmp_bound = icmp ugt i64 %boundary, 1
  br i1 %cmp_bound, label %inner.init, label %exit

inner.init:                                          ; preds = %outer.cond
  br label %inner.cond

inner.cond:                                          ; preds = %inner.init, %inner.latch
  %i = phi i64 [ 1, %inner.init ], [ %i.next, %inner.latch ]
  %last = phi i64 [ 0, %inner.init ], [ %last.next, %inner.latch ]
  %cmp_i = icmp ult i64 %i, %boundary
  br i1 %cmp_i, label %inner.body, label %after.inner

inner.body:                                          ; preds = %inner.cond
  %i.minus1 = add i64 %i, -1
  %ptr.prev = getelementptr inbounds i32, i32* %arr, i64 %i.minus1
  %a0 = load i32, i32* %ptr.prev, align 4
  %ptr.cur = getelementptr inbounds i32, i32* %arr, i64 %i
  %a1 = load i32, i32* %ptr.cur, align 4
  %cmp.swap = icmp sgt i32 %a0, %a1
  br i1 %cmp.swap, label %do.swap, label %no.swap

do.swap:                                             ; preds = %inner.body
  store i32 %a1, i32* %ptr.prev, align 4
  store i32 %a0, i32* %ptr.cur, align 4
  br label %inner.latch

no.swap:                                             ; preds = %inner.body
  br label %inner.latch

inner.latch:                                         ; preds = %no.swap, %do.swap
  %last.updated = select i1 %cmp.swap, i64 %i, i64 %last
  %last.next = %last.updated
  %i.next = add i64 %i, 1
  br label %inner.cond

after.inner:                                         ; preds = %inner.cond
  %no_swaps = icmp eq i64 %last, 0
  br i1 %no_swaps, label %exit, label %outer.cont

outer.cont:                                          ; preds = %after.inner
  %boundary.next = add i64 %last, 0
  br label %outer.cond

exit:                                                ; preds = %outer.cond, %after.inner, %entry
  ret void
}