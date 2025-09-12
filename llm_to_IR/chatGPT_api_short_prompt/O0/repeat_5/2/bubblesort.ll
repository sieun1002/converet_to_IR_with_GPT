; ModuleID = 'bubble_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bubble_sort ; Address: 0x1189
; Intent: In-place bubble sort (int32), optimized with last-swap bound (confidence=0.98). Evidence: 4-byte indexing with neighbor compares/swaps; outer bound updated to last swap index with early exit when none.
; Preconditions: arr points to at least n 32-bit integers.
; Postconditions: arr is sorted in nondecreasing (ascending) order (stable).

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local void @bubble_sort(i32* %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %exit, label %outer_header

outer_header:                                           ; preds = %entry, %after_inner
  %upper = phi i64 [ %n, %entry ], [ %last, %after_inner ]
  %cmp.upper.gt1 = icmp ugt i64 %upper, 1
  br i1 %cmp.upper.gt1, label %inner_header, label %exit

inner_header:                                           ; preds = %outer_header, %inner_inc
  %i = phi i64 [ 1, %outer_header ], [ %i.next, %inner_inc ]
  %last = phi i64 [ 0, %outer_header ], [ %last.next, %inner_inc ]
  %cmp.i.lt.upper = icmp ult i64 %i, %upper
  br i1 %cmp.i.lt.upper, label %inner_body, label %after_inner

inner_body:                                             ; preds = %inner_header
  %im1 = add i64 %i, -1
  %p_im1 = getelementptr inbounds i32, i32* %arr, i64 %im1
  %p_i = getelementptr inbounds i32, i32* %arr, i64 %i
  %a = load i32, i32* %p_im1, align 4
  %b = load i32, i32* %p_i, align 4
  %cmp.swap = icmp sgt i32 %a, %b
  br i1 %cmp.swap, label %do_swap, label %no_swap

do_swap:                                                ; preds = %inner_body
  store i32 %b, i32* %p_im1, align 4
  store i32 %a, i32* %p_i, align 4
  br label %inner_inc

no_swap:                                                ; preds = %inner_body
  br label %inner_inc

inner_inc:                                              ; preds = %no_swap, %do_swap
  %last.next = phi i64 [ %i, %do_swap ], [ %last, %no_swap ]
  %i.next = add i64 %i, 1
  br label %inner_header

after_inner:                                            ; preds = %inner_header
  %no_swaps = icmp eq i64 %last, 0
  br i1 %no_swaps, label %exit, label %outer_header

exit:                                                   ; preds = %after_inner, %outer_header, %entry
  ret void
}