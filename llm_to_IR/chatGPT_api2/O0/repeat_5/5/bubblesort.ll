; ModuleID = 'bubble_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bubble_sort  ; Address: 0x1189
; Intent: In-place ascending bubble sort on 32-bit ints with last-swap optimization (confidence=0.95). Evidence: 4-byte element accesses with adjacent compare/swap and shrinking bound.
; Preconditions: a points to at least n contiguous i32 elements.
; Postconditions: a[0..n) sorted in non-decreasing order.

define dso_local void @bubble_sort(i32* %a, i64 %n) local_unnamed_addr {
entry:
  %cmp_le1 = icmp ule i64 %n, 1
  br i1 %cmp_le1, label %return, label %outer.header

outer.header:                                      ; preds = %entry, %setend
  %end = phi i64 [ %n, %entry ], [ %new_end, %setend ]
  %cond = icmp ugt i64 %end, 1
  br i1 %cond, label %outer.body.init, label %return

outer.body.init:                                   ; preds = %outer.header
  br label %inner.header

inner.header:                                      ; preds = %inner.latch, %outer.body.init
  %i = phi i64 [ 1, %outer.body.init ], [ %i.next, %inner.latch ]
  %last_swap = phi i64 [ 0, %outer.body.init ], [ %last_swap.next, %inner.latch ]
  %inner.cond = icmp ult i64 %i, %end
  br i1 %inner.cond, label %inner.body, label %outer.cont

inner.body:                                        ; preds = %inner.header
  %idx.im1 = add i64 %i, -1
  %p.im1 = getelementptr inbounds i32, i32* %a, i64 %idx.im1
  %p.i = getelementptr inbounds i32, i32* %a, i64 %i
  %v.im1 = load i32, i32* %p.im1, align 4
  %v.i = load i32, i32* %p.i, align 4
  %cmp.swap = icmp sgt i32 %v.im1, %v.i
  br i1 %cmp.swap, label %swap, label %noswap

swap:                                              ; preds = %inner.body
  store i32 %v.i, i32* %p.im1, align 4
  store i32 %v.im1, i32* %p.i, align 4
  br label %inner.latch

noswap:                                            ; preds = %inner.body
  br label %inner.latch

inner.latch:                                       ; preds = %noswap, %swap
  %last_swap.next = phi i64 [ %i, %swap ], [ %last_swap, %noswap ]
  %i.next = add i64 %i, 1
  br label %inner.header

outer.cont:                                        ; preds = %inner.header
  %last_swap.exit = phi i64 [ %last_swap, %inner.header ]
  %is_zero = icmp eq i64 %last_swap.exit, 0
  br i1 %is_zero, label %return, label %setend

setend:                                            ; preds = %outer.cont
  %new_end = add i64 %last_swap.exit, 0
  br label %outer.header

return:                                            ; preds = %outer.header, %outer.cont, %entry
  ret void
}