; ModuleID = 'bubble_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bubble_sort ; Address: 0x1189
; Intent: In-place bubble sort of 32-bit integers with last-swap optimization (confidence=0.94). Evidence: adjacent comparisons/swaps using 4-byte elements, tracking last swap to reduce next pass.
; Preconditions: arr points to at least n i32 elements.
; Postconditions: arr[0..n-1] sorted in non-decreasing order.

; Only the necessary external declarations:
; (none)

define dso_local void @bubble_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %return, label %outer.preheader

outer.preheader:
  br label %outer

outer:
  %limit = phi i64 [ %n, %outer.preheader ], [ %limit.next, %outer.back ]
  br label %inner.header

inner.header:
  %i = phi i64 [ 1, %outer ], [ %i.next, %inner.latch ]
  %last = phi i64 [ 0, %outer ], [ %last.next, %inner.latch ]
  %cmp.i.limit = icmp ult i64 %i, %limit
  br i1 %cmp.i.limit, label %inner.body, label %inner.exit

inner.body:
  %idx.im1 = add i64 %i, -1
  %p.im1 = getelementptr inbounds i32, i32* %arr, i64 %idx.im1
  %p.i = getelementptr inbounds i32, i32* %arr, i64 %i
  %a = load i32, i32* %p.im1, align 4
  %b = load i32, i32* %p.i, align 4
  %need.swap = icmp sgt i32 %a, %b
  br i1 %need.swap, label %do.swap, label %no.swap

do.swap:
  store i32 %b, i32* %p.im1, align 4
  store i32 %a, i32* %p.i, align 4
  br label %inner.latch

no.swap:
  br label %inner.latch

inner.latch:
  %last.next = phi i64 [ %i, %do.swap ], [ %last, %no.swap ]
  %i.next = add i64 %i, 1
  br label %inner.header

inner.exit:
  %last.out = phi i64 [ %last, %inner.header ]
  %no.swaps = icmp eq i64 %last.out, 0
  br i1 %no.swaps, label %return, label %outer.back

outer.back:
  %limit.next = phi i64 [ %last.out, %inner.exit ]
  %more = icmp ugt i64 %limit.next, 1
  br i1 %more, label %outer, label %return

return:
  ret void
}