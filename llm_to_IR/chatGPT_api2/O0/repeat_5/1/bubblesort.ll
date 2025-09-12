; ModuleID = 'bubble_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bubble_sort  ; Address: 0x1189
; Intent: In-place bubble sort of i32 array with last-swap boundary optimization (confidence=0.95). Evidence: adjacent i32 compare/swap, tracking last swap to shrink pass range.
; Preconditions: %a points to at least %n contiguous i32 elements.
; Postconditions: Elements [0..n) of %a are sorted in nondecreasing (signed) order.

define dso_local void @bubble_sort(i32* %a, i64 %n) local_unnamed_addr {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %ret, label %outer.preheader

outer.preheader:
  br label %outer.header

outer.header:
  %outer_limit = phi i64 [ %n, %outer.preheader ], [ %outer_limit.next, %outer.check ]
  br label %inner.header

inner.header:
  %i = phi i64 [ 1, %outer.header ], [ %i.next, %swap.merge ]
  %last_swap = phi i64 [ 0, %outer.header ], [ %last_swap.update, %swap.merge ]
  %cond.inner = icmp ult i64 %i, %outer_limit
  br i1 %cond.inner, label %inner.body, label %inner.end

inner.body:
  %i.minus1 = add i64 %i, -1
  %ptr.prev = getelementptr inbounds i32, i32* %a, i64 %i.minus1
  %prev = load i32, i32* %ptr.prev, align 4
  %ptr.curr = getelementptr inbounds i32, i32* %a, i64 %i
  %curr = load i32, i32* %ptr.curr, align 4
  %need.swap = icmp sgt i32 %prev, %curr
  br i1 %need.swap, label %do.swap, label %no.swap

do.swap:
  store i32 %curr, i32* %ptr.prev, align 4
  store i32 %prev, i32* %ptr.curr, align 4
  br label %swap.merge

no.swap:
  br label %swap.merge

swap.merge:
  %last_swap.update = phi i64 [ %i, %do.swap ], [ %last_swap, %no.swap ]
  %i.next = add i64 %i, 1
  br label %inner.header

inner.end:
  %no.swaps = icmp eq i64 %last_swap, 0
  br i1 %no.swaps, label %ret, label %outer.check

outer.check:
  %outer_limit.next = %last_swap
  %cont.outer = icmp ugt i64 %outer_limit.next, 1
  br i1 %cont.outer, label %outer.header, label %ret

ret:
  ret void
}