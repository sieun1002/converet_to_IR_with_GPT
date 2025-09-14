; ModuleID = 'binary_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: binary_search  ; Address: 0x1169
; Intent: Binary search (lower_bound then equality check) returning index or -1 (confidence=0.98). Evidence: hi=n/lo=0 loop with mid=(lo+(hi-lo)/2), 4-byte scaled loads, final equality check then -1.
; Preconditions: a points to an array of at least n 32-bit signed integers sorted in non-decreasing order; n fits in i64.
; Postconditions: Returns the smallest index i such that a[i]==key, or -1 if no such index exists.

define dso_local i64 @binary_search(i32* %a, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop.cond

loop.cond:                                           ; preds = %entry, %loop.latch
  %lo.cur = phi i64 [ 0, %entry ], [ %lo.next, %loop.latch ]
  %hi.cur = phi i64 [ %n, %entry ], [ %hi.next, %loop.latch ]
  %cmp = icmp ult i64 %lo.cur, %hi.cur
  br i1 %cmp, label %loop.body, label %exit

loop.body:                                           ; preds = %loop.cond
  %delta = sub i64 %hi.cur, %lo.cur
  %half = lshr i64 %delta, 1
  %mid = add i64 %lo.cur, %half
  %elt.ptr = getelementptr inbounds i32, i32* %a, i64 %mid
  %elt = load i32, i32* %elt.ptr, align 4
  %le = icmp sle i32 %key, %elt
  %mid.plus1 = add i64 %mid, 1
  %lo.next = select i1 %le, i64 %lo.cur, i64 %mid.plus1
  %hi.next = select i1 %le, i64 %mid, i64 %hi.cur
  br label %loop.latch

loop.latch:                                          ; preds = %loop.body
  br label %loop.cond

exit:                                                ; preds = %loop.cond
  %lt.n = icmp ult i64 %lo.cur, %n
  br i1 %lt.n, label %check.eq, label %ret.notfound

check.eq:                                            ; preds = %exit
  %ptr.lo = getelementptr inbounds i32, i32* %a, i64 %lo.cur
  %val.lo = load i32, i32* %ptr.lo, align 4
  %eq = icmp eq i32 %val.lo, %key
  br i1 %eq, label %ret.found, label %ret.notfound

ret.found:                                           ; preds = %check.eq
  ret i64 %lo.cur

ret.notfound:                                        ; preds = %check.eq, %exit
  ret i64 -1
}