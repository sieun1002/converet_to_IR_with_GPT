; ModuleID = 'binary_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: binary_search ; Address: 0x1169
; Intent: binary search for exact match in sorted int array, return index or -1 (confidence=0.98). Evidence: mid computation with (hi-lo)>>1 and post-loop equality check returning -1 if not equal.
; Preconditions: arr points to at least n 32-bit ints sorted in nondecreasing order.
; Postconditions: returns index in [0,n) where arr[index] == key, otherwise -1.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local i64 @binary_search(i32* nocapture readonly %arr, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop.header

loop.header:                                         ; preds = %loop.latch, %entry
  %lo = phi i64 [ 0, %entry ], [ %lo.next, %loop.latch ]
  %hi = phi i64 [ %n, %entry ], [ %hi.next, %loop.latch ]
  %cmp = icmp ult i64 %lo, %hi
  br i1 %cmp, label %loop.body, label %after

loop.body:                                           ; preds = %loop.header
  %diff = sub i64 %hi, %lo
  %half = lshr i64 %diff, 1
  %mid = add i64 %lo, %half
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %elem.ptr, align 4
  %gt = icmp sgt i32 %key, %val
  %mid.plus1 = add i64 %mid, 1
  %lo.next = select i1 %gt, i64 %mid.plus1, i64 %lo
  %hi.next = select i1 %gt, i64 %hi, i64 %mid
  br label %loop.latch

loop.latch:                                          ; preds = %loop.body
  br label %loop.header

after:                                               ; preds = %loop.header
  %in.range = icmp ult i64 %lo, %n
  br i1 %in.range, label %check.equal, label %ret.neg

check.equal:                                         ; preds = %after
  %elem.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %lo
  %val2 = load i32, i32* %elem.ptr2, align 4
  %eq = icmp eq i32 %val2, %key
  br i1 %eq, label %ret.idx, label %ret.neg

ret.idx:                                             ; preds = %check.equal
  ret i64 %lo

ret.neg:                                             ; preds = %check.equal, %after
  ret i64 -1
}