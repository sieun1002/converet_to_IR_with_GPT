; ModuleID = 'binary_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: binary_search ; Address: 0x1169
; Intent: binary search (lower_bound + equality check) over sorted int array; returns index or -1 (confidence=0.87). Evidence: mid = low + (high-low)>>1 loop with key<=arr[mid] narrowing high, post-loop equality check and -1 on miss.
; Preconditions: arr points to at least n 32-bit integers sorted in non-decreasing order (compared as signed 32-bit).
; Postconditions: returns i64 index in [0,n) where arr[idx]==key, else -1.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)

define dso_local i64 @binary_search(i32* nocapture readonly %arr, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %while

while:                                            ; preds = %entry, %body_cont
  %low.cur = phi i64 [ 0, %entry ], [ %low.next, %body_cont ]
  %high.cur = phi i64 [ %n, %entry ], [ %high.next, %body_cont ]
  %cmp.lt = icmp ult i64 %low.cur, %high.cur
  br i1 %cmp.lt, label %loop, label %after.loop

loop:                                             ; preds = %while
  %diff = sub i64 %high.cur, %low.cur
  %half = lshr i64 %diff, 1
  %mid = add i64 %low.cur, %half
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %le = icmp sle i32 %key, %val
  br i1 %le, label %take.high, label %take.low

take.high:                                        ; preds = %loop
  %high.next.h = %mid
  %low.next.h = %low.cur
  br label %body_cont

take.low:                                         ; preds = %loop
  %low.plus = add i64 %mid, 1
  %low.next.l = %low.plus
  %high.next.l = %high.cur
  br label %body_cont

body_cont:                                        ; preds = %take.low, %take.high
  %low.next = phi i64 [ %low.next.h, %take.high ], [ %low.next.l, %take.low ]
  %high.next = phi i64 [ %high.next.h, %take.high ], [ %high.next.l, %take.low ]
  br label %while

after.loop:                                       ; preds = %while
  %in.range = icmp ult i64 %low.cur, %n
  br i1 %in.range, label %check.eq, label %ret.neg1

check.eq:                                         ; preds = %after.loop
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low.cur
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %ret.idx, label %ret.neg1

ret.idx:                                          ; preds = %check.eq
  ret i64 %low.cur

ret.neg1:                                         ; preds = %check.eq, %after.loop
  ret i64 -1
}