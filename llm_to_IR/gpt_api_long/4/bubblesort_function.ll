; ModuleID = 'bubble_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bubble_sort  ; Address: 0x1189
; Intent: In-place ascending bubble sort with last-swap optimization (confidence=0.98). Evidence: adjacent 32-bit comparisons and swaps; outer loop tightens bound to last swap index.
; Preconditions: a points to at least n 32-bit elements; n is the element count (can be 0 or 1).
; Postconditions: a[0..n-1] sorted in nondecreasing signed 32-bit order.

define dso_local void @bubble_sort(i32* %a, i64 %n) local_unnamed_addr {
entry:
  %cmp.le1 = icmp ule i64 %n, 1
  br i1 %cmp.le1, label %exit, label %outer.entry

outer.entry:
  br label %outer.header

outer.header:
  %upper = phi i64 [ %n, %outer.entry ], [ %upper.next, %outer.cont ]
  %cmp.upper = icmp ugt i64 %upper, 1
  br i1 %cmp.upper, label %outer.body.init, label %exit

outer.body.init:
  br label %inner.header

inner.header:
  %i = phi i64 [ 1, %outer.body.init ], [ %i.next, %inner.inc ]
  %lastSwap = phi i64 [ 0, %outer.body.init ], [ %lastSwap.updated, %inner.inc ]
  %cmp.i = icmp ult i64 %i, %upper
  br i1 %cmp.i, label %inner.body, label %inner.end

inner.body:
  %i.minus1 = add i64 %i, -1
  %p.prev = getelementptr inbounds i32, i32* %a, i64 %i.minus1
  %x = load i32, i32* %p.prev, align 4
  %p.curr = getelementptr inbounds i32, i32* %a, i64 %i
  %y = load i32, i32* %p.curr, align 4
  %gt = icmp sgt i32 %x, %y
  br i1 %gt, label %do.swap, label %no.swap

do.swap:
  store i32 %y, i32* %p.prev, align 4
  store i32 %x, i32* %p.curr, align 4
  br label %inner.inc

no.swap:
  br label %inner.inc

inner.inc:
  %i.next = add i64 %i, 1
  %lastSwap.updated = phi i64 [ %i, %do.swap ], [ %lastSwap, %no.swap ]
  br label %inner.header

inner.end:
  %noSwaps = icmp eq i64 %lastSwap, 0
  br i1 %noSwaps, label %exit, label %outer.cont

outer.cont:
  %upper.next = phi i64 [ %lastSwap, %inner.end ]
  br label %outer.header

exit:
  ret void
}