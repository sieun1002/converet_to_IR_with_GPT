; ModuleID = 'binary_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: binary_search  ; Address: 0x1169
; Intent: Binary search (lower_bound) on sorted int32 array; return index if found else -1 (confidence=0.95). Evidence: mid via (high-low)>>1 with 4-byte scaling; branch on key <= a[mid] and final equality check.

define dso_local i64 @binary_search(i32* %a, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop.cond

loop.cond:                                        ; preds = %set.high, %set.low, %entry
  %low = phi i64 [ 0, %entry ], [ %low_next_low, %set.low ], [ %low_next_high, %set.high ]
  %high = phi i64 [ %n, %entry ], [ %high_next_low, %set.low ], [ %high_next_high, %set.high ]
  %cmp = icmp ult i64 %low, %high
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.cond
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %mid.ptr = getelementptr inbounds i32, i32* %a, i64 %mid
  %mid.val = load i32, i32* %mid.ptr, align 4
  %le = icmp sle i32 %key, %mid.val
  br i1 %le, label %set.high, label %set.low

set.low:                                          ; preds = %loop.body
  %mid.plus1 = add i64 %mid, 1
  %low_next_low = %mid.plus1
  %high_next_low = %high
  br label %loop.cond

set.high:                                         ; preds = %loop.body
  %low_next_high = %low
  %high_next_high = %mid
  br label %loop.cond

after.loop:                                       ; preds = %loop.cond
  %inrange = icmp ult i64 %low, %n
  br i1 %inrange, label %check.eq, label %ret.neg1

check.eq:                                         ; preds = %after.loop
  %idx.ptr = getelementptr inbounds i32, i32* %a, i64 %low
  %val = load i32, i32* %idx.ptr, align 4
  %eq = icmp eq i32 %val, %key
  br i1 %eq, label %ret.idx, label %ret.neg1

ret.idx:                                          ; preds = %check.eq
  ret i64 %low

ret.neg1:                                         ; preds = %check.eq, %after.loop
  ret i64 -1
}