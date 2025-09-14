; ModuleID = 'bubble_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bubble_sort ; Address: 0x1189
; Intent: In-place bubble sort (int32, ascending, signed) with last-swap bound and early exit (confidence=0.94). Evidence: 4-byte strides, adjacent compare/swap, n<=1 fast path, last swap index tracking.
; Preconditions: arr points to at least n 32-bit integers.
; Postconditions: arr[0..n-1] is sorted in nondecreasing (signed) order.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local void @bubble_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp_n = icmp ule i64 %n, 1
  br i1 %cmp_n, label %exit, label %outer.header

outer.header:                                            ; preds = %entry, %set_last
  %last = phi i64 [ %n, %entry ], [ %last.next, %set_last ]
  %cmp_last = icmp ugt i64 %last, 1
  br i1 %cmp_last, label %outer.body, label %exit

outer.body:                                              ; preds = %outer.header
  br label %inner.header

inner.header:                                            ; preds = %inner.latch, %outer.body
  %i = phi i64 [ 1, %outer.body ], [ %i.next, %inner.latch ]
  %new_last = phi i64 [ 0, %outer.body ], [ %new_last.next, %inner.latch ]
  %cmp_i = icmp ult i64 %i, %last
  br i1 %cmp_i, label %inner.body, label %inner.end

inner.body:                                              ; preds = %inner.header
  %im1 = add i64 %i, -1
  %p0 = getelementptr inbounds i32, i32* %arr, i64 %im1
  %p1 = getelementptr inbounds i32, i32* %arr, i64 %i
  %a = load i32, i32* %p0, align 4
  %b = load i32, i32* %p1, align 4
  %gt = icmp sgt i32 %a, %b
  br i1 %gt, label %do_swap, label %no_swap

do_swap:                                                 ; preds = %inner.body
  store i32 %b, i32* %p0, align 4
  store i32 %a, i32* %p1, align 4
  br label %inner.latch

no_swap:                                                 ; preds = %inner.body
  br label %inner.latch

inner.latch:                                             ; preds = %no_swap, %do_swap
  %new_last.next = phi i64 [ %i, %do_swap ], [ %new_last, %no_swap ]
  %i.next = add i64 %i, 1
  br label %inner.header

inner.end:                                               ; preds = %inner.header
  %nl.final = phi i64 [ %new_last, %inner.header ]
  %nl_zero = icmp eq i64 %nl.final, 0
  br i1 %nl_zero, label %exit, label %set_last

set_last:                                                ; preds = %inner.end
  %last.next = %nl.final
  br label %outer.header

exit:                                                    ; preds = %inner.end, %outer.header, %entry
  ret void
}