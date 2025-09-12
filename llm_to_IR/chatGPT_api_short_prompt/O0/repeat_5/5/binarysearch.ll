; ModuleID = 'binary_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: binary_search ; Address: 0x1169
; Intent: Find index of key in sorted int32 array via binary search; returns index or -1 (confidence=0.93). Evidence: lower_bound loop with signed int compare and final equality check; returns 0xFFFFFFFFFFFFFFFF on miss.
; Preconditions: arr points to at least count int32 elements sorted in non-decreasing order.
; Postconditions: Returns i64 index in [0,count) if arr[index] == key, else -1.

; Only the necessary external declarations:
; (none)

define dso_local i64 @binary_search(i32* nocapture readonly %arr, i64 %count, i32 %key) local_unnamed_addr {
entry:
  br label %loop.header

loop.header:                                        ; preds = %loop.update, %entry
  %low = phi i64 [ 0, %entry ], [ %low.next, %loop.update ]
  %high = phi i64 [ %count, %entry ], [ %high.next, %loop.update ]
  %cond = icmp ult i64 %low, %high
  br i1 %cond, label %loop.body, label %post.loop

loop.body:                                          ; preds = %loop.header
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %elt.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %elt = load i32, i32* %elt.ptr, align 4
  %le = icmp sle i32 %key, %elt
  br i1 %le, label %set.high, label %set.low

set.low:                                            ; preds = %loop.body
  %mid.plus = add i64 %mid, 1
  br label %loop.update

set.high:                                           ; preds = %loop.body
  br label %loop.update

loop.update:                                        ; preds = %set.high, %set.low
  %high.next = phi i64 [ %mid, %set.high ], [ %high, %set.low ]
  %low.next = phi i64 [ %low, %set.high ], [ %mid.plus, %set.low ]
  br label %loop.header

post.loop:                                          ; preds = %loop.header
  %inrange = icmp ult i64 %low, %count
  br i1 %inrange, label %check.eq, label %ret.m1

check.eq:                                           ; preds = %post.loop
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low
  %v2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %v2
  br i1 %eq, label %ret.idx, label %ret.m1

ret.idx:                                            ; preds = %check.eq
  ret i64 %low

ret.m1:                                             ; preds = %check.eq, %post.loop
  ret i64 -1
}