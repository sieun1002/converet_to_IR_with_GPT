; ModuleID = 'bubble_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bubble_sort ; Address: 0x1189
; Intent: Optimized bubble sort (ascending) on int32 array using last-swap boundary (confidence=0.93). Evidence: 4-byte element accesses; swap when a[i-1] > a[i]; boundary updated to last swap index.
; Preconditions: arr points to at least n 32-bit integers; n is treated as an unsigned size.
; Postconditions: arr[0..n-1] is sorted in non-decreasing order.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)

define dso_local void @bubble_sort(i32* %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp_n = icmp ule i64 %n, 1
  br i1 %cmp_n, label %exit, label %outer.header

outer.header:                                          ; preds = %entry, %outer.next
  %bound = phi i64 [ %n, %entry ], [ %lastswap.end, %outer.next ]
  %cont_outer = icmp ugt i64 %bound, 1
  br i1 %cont_outer, label %inner.cond, label %exit

inner.cond:                                            ; preds = %outer.header, %inner.latch
  %i = phi i64 [ 1, %outer.header ], [ %i.next, %inner.latch ]
  %lastswap = phi i64 [ 0, %outer.header ], [ %lastswap.next, %inner.latch ]
  %cont_inner = icmp ult i64 %i, %bound
  br i1 %cont_inner, label %inner.body, label %after_inner

inner.body:                                            ; preds = %inner.cond
  %idx.prev = add i64 %i, -1
  %ptr.prev = getelementptr inbounds i32, i32* %arr, i64 %idx.prev
  %val.prev = load i32, i32* %ptr.prev, align 4
  %ptr.curr = getelementptr inbounds i32, i32* %arr, i64 %i
  %val.curr = load i32, i32* %ptr.curr, align 4
  %gt = icmp sgt i32 %val.prev, %val.curr
  br i1 %gt, label %do.swap, label %no.swap

do.swap:                                               ; preds = %inner.body
  store i32 %val.curr, i32* %ptr.prev, align 4
  store i32 %val.prev, i32* %ptr.curr, align 4
  br label %inner.latch

no.swap:                                               ; preds = %inner.body
  br label %inner.latch

inner.latch:                                           ; preds = %do.swap, %no.swap
  %lastswap.sel = select i1 %gt, i64 %i, i64 %lastswap
  %i.next = add nuw i64 %i, 1
  %lastswap.next = %lastswap.sel
  br label %inner.cond

after_inner:                                           ; preds = %inner.cond
  %no_swaps = icmp eq i64 %lastswap, 0
  br i1 %no_swaps, label %exit, label %outer.next

outer.next:                                            ; preds = %after_inner
  %lastswap.end = %lastswap
  br label %outer.header

exit:                                                  ; preds = %outer.header, %after_inner, %entry
  ret void
}