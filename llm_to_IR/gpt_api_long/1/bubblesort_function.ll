; ModuleID = 'bubble_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bubble_sort  ; Address: 0x1189
; Intent: In-place bubble sort (ascending) on i32 array with last-swap optimization (confidence=0.95). Evidence: neighbor comparisons of 4-byte elements with signed jle; tracking last swap to shrink bound.
; Preconditions: %a points to at least %n contiguous i32 elements; %n treated as unsigned length.
; Postconditions: Array %a[0..n) sorted in non-decreasing (signed) order.

; Only the needed extern declarations:

define dso_local void @bubble_sort(i32* %a, i64 %n) local_unnamed_addr {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %ret, label %outer.header

outer.header:
  %high = phi i64 [ %n, %entry ], [ %high.next, %sethigh ]
  %cond.high.gt1 = icmp ugt i64 %high, 1
  br i1 %cond.high.gt1, label %outer.body, label %ret

outer.body:
  br label %inner.header

inner.header:
  %i = phi i64 [ 1, %outer.body ], [ %i.next, %inc ]
  %last = phi i64 [ 0, %outer.body ], [ %last.next, %inc ]
  %cmp.i.lt.high = icmp ult i64 %i, %high
  br i1 %cmp.i.lt.high, label %inner.body, label %after.inner

inner.body:
  %idxm1 = add i64 %i, -1
  %p.prev = getelementptr inbounds i32, i32* %a, i64 %idxm1
  %p.cur = getelementptr inbounds i32, i32* %a, i64 %i
  %v.prev = load i32, i32* %p.prev, align 4
  %v.cur = load i32, i32* %p.cur, align 4
  %need.swap = icmp sgt i32 %v.prev, %v.cur
  br i1 %need.swap, label %swap, label %noswap

swap:
  store i32 %v.cur, i32* %p.prev, align 4
  store i32 %v.prev, i32* %p.cur, align 4
  br label %inc

noswap:
  br label %inc

inc:
  %last.next = phi i64 [ %i, %swap ], [ %last, %noswap ]
  %i.next = add i64 %i, 1
  br label %inner.header

after.inner:
  %nochange = icmp eq i64 %last, 0
  br i1 %nochange, label %ret, label %sethigh

sethigh:
  %high.next = add i64 %last, 0
  br label %outer.header

ret:
  ret void
}