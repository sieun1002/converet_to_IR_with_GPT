; ModuleID = 'bubble_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bubble_sort ; Address: 0x1189
; Intent: In-place bubble sort of i32 array with last-swap optimization (confidence=0.96). Evidence: adjacent element compare/swap of 32-bit ints; outer loop shrinks to last swap index.
; Preconditions: arr points to at least n 32-bit elements (non-null if n>0).
; Postconditions: arr[0..n-1] sorted in nondecreasing (signed) order.

; Only the necessary external declarations:

define dso_local void @bubble_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  ; if (n <= 1) return;
  %cmp.n = icmp ule i64 %n, 1
  br i1 %cmp.n, label %exit, label %outer.preheader

outer.preheader:
  br label %outer.header

outer.header:
  ; limit = current upper bound for inner pass
  %limit = phi i64 [ %n, %outer.preheader ], [ %last, %outer.latch ]
  ; while (limit > 1)
  %cmp.limit = icmp ugt i64 %limit, 1
  br i1 %cmp.limit, label %inner.preheader, label %exit

inner.preheader:
  br label %inner.header

inner.header:
  ; i starts at 1; last swap index starts at 0
  %i = phi i64 [ 1, %inner.preheader ], [ %i.next, %inner.latch ]
  %last.phi = phi i64 [ 0, %inner.preheader ], [ %last.upd, %inner.latch ]
  ; for (i < limit)
  %i.cmp = icmp ult i64 %i, %limit
  br i1 %i.cmp, label %inner.body, label %after.inner

inner.body:
  ; a = arr[i-1], b = arr[i]
  %im1 = add i64 %i, -1
  %ptr.im1 = getelementptr inbounds i32, i32* %arr, i64 %im1
  %ptr.i = getelementptr inbounds i32, i32* %arr, i64 %i
  %a = load i32, i32* %ptr.im1, align 4
  %b = load i32, i32* %ptr.i, align 4
  ; if (a > b) swap and record last = i (signed compare as per jle)
  %cmp.ab = icmp sgt i32 %a, %b
  br i1 %cmp.ab, label %swap, label %noswap

swap:
  store i32 %b, i32* %ptr.im1, align 4
  store i32 %a, i32* %ptr.i, align 4
  br label %inner.latch

noswap:
  br label %inner.latch

inner.latch:
  %last.upd = phi i64 [ %i, %swap ], [ %last.phi, %noswap ]
  %i.next = add i64 %i, 1
  br label %inner.header

after.inner:
  ; if no swaps, done
  %last.end = %last.phi
  %no.swaps = icmp eq i64 %last.end, 0
  br i1 %no.swaps, label %exit, label %outer.latch

outer.latch:
  %last = phi i64 [ %last.end, %after.inner ]
  br label %outer.header

exit:
  ret void
}