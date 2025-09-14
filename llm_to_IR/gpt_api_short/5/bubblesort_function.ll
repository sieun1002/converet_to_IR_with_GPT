; ModuleID = 'bubble_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bubble_sort ; Address: 0x1189
; Intent: sort array ascending (bubble sort with last-swap optimization) (confidence=0.98). Evidence: adjacent i32 compare/swap; tracks last swap index to shrink bound.
; Preconditions: arr points to at least n contiguous i32s; n >= 0
; Postconditions: arr sorted in non-decreasing (signed) order

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local void @bubble_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp_n = icmp ule i64 %n, 1
  br i1 %cmp_n, label %ret, label %outer.header

outer.header:                                         ; preds = %outer.latch, %entry
  %limit.phi = phi i64 [ %n, %entry ], [ %limit.next, %outer.latch ]
  %limit_gt1 = icmp ugt i64 %limit.phi, 1
  br i1 %limit_gt1, label %outer.body.init, label %ret

outer.body.init:                                      ; preds = %outer.header
  br label %inner.header

inner.header:                                         ; preds = %inner.latch, %outer.body.init
  %j = phi i64 [ 1, %outer.body.init ], [ %j.next, %inner.latch ]
  %last.cur = phi i64 [ 0, %outer.body.init ], [ %last.next, %inner.latch ]
  %j_lt_limit = icmp ult i64 %j, %limit.phi
  br i1 %j_lt_limit, label %inner.body, label %inner.end

inner.body:                                           ; preds = %inner.header
  %j_minus1 = add i64 %j, -1
  %ptr_a = getelementptr inbounds i32, i32* %arr, i64 %j_minus1
  %a = load i32, i32* %ptr_a, align 4
  %ptr_b = getelementptr inbounds i32, i32* %arr, i64 %j
  %b = load i32, i32* %ptr_b, align 4
  %cmp_ab = icmp sgt i32 %a, %b
  br i1 %cmp_ab, label %do_swap, label %no_swap

do_swap:                                              ; preds = %inner.body
  store i32 %b, i32* %ptr_a, align 4
  store i32 %a, i32* %ptr_b, align 4
  br label %inner.latch

no_swap:                                              ; preds = %inner.body
  br label %inner.latch

inner.latch:                                          ; preds = %no_swap, %do_swap
  %last.sel = phi i64 [ %j, %do_swap ], [ %last.cur, %no_swap ]
  %j.next = add i64 %j, 1
  %last.next = %last.sel
  br label %inner.header

inner.end:                                            ; preds = %inner.header
  %no_swaps = icmp eq i64 %last.cur, 0
  br i1 %no_swaps, label %ret, label %outer.latch

outer.latch:                                          ; preds = %inner.end
  %limit.next = %last.cur
  br label %outer.header

ret:                                                  ; preds = %inner.end, %outer.header, %entry
  ret void
}