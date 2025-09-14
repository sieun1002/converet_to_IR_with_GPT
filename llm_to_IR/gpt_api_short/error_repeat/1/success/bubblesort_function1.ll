; ModuleID = 'bubble_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bubble_sort ; Address: 0x1189
; Intent: in-place bubble sort (last-swap optimization) on 32-bit int array (confidence=0.93). Evidence: adjacent 32-bit compare/swap; outer bound updated to last swap index.
; Preconditions: arr points to at least n 32-bit elements.
; Postconditions: arr is sorted in nondecreasing (signed) order.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local void @bubble_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cond = icmp ule i64 %n, 1
  br i1 %cond, label %return, label %outer.init

outer.init:
  br label %outer.header

outer.header:
  %bound = phi i64 [ %n, %outer.init ], [ %bound.next, %outer.cont ]
  %cmp.bound = icmp ugt i64 %bound, 1
  br i1 %cmp.bound, label %outer.body, label %return

outer.body:
  br label %inner.header

inner.header:
  %i = phi i64 [ 1, %outer.body ], [ %i.next, %inc ]
  %last = phi i64 [ 0, %outer.body ], [ %last.next, %inc ]
  %cmp.inner = icmp ult i64 %i, %bound
  br i1 %cmp.inner, label %inner.body, label %inner.exit

inner.body:
  %idxm1 = add i64 %i, -1
  %p1 = getelementptr inbounds i32, i32* %arr, i64 %idxm1
  %p2 = getelementptr inbounds i32, i32* %arr, i64 %i
  %a = load i32, i32* %p1, align 4
  %b = load i32, i32* %p2, align 4
  %cmpab = icmp sle i32 %a, %b
  br i1 %cmpab, label %noswap, label %doswap

noswap:
  br label %inc

doswap:
  store i32 %b, i32* %p1, align 4
  store i32 %a, i32* %p2, align 4
  br label %inc

inc:
  %last.next = phi i64 [ %last, %noswap ], [ %i, %doswap ]
  %i.next = add i64 %i, 1
  br label %inner.header

inner.exit:
  %last2 = phi i64 [ %last, %inner.header ]
  %no_swaps = icmp eq i64 %last2, 0
  br i1 %no_swaps, label %return, label %outer.cont

outer.cont:
  %bound.next = add i64 %last2, 0
  br label %outer.header

return:
  ret void
}