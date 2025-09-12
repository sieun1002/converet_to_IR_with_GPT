; ModuleID = 'binary_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: binary_search ; Address: 0x1169
; Intent: Binary search (lower_bound then equality) in a sorted int array; return index or -1 (confidence=0.86). Evidence: mid=(low+((high-low)>>1)), branch on key<=a[mid], final equality check and -1.
; Preconditions: arr points to at least n 32-bit elements sorted in nondecreasing order.
; Postconditions: Returns the first index i in [0,n) with arr[i]==key, or -1 if none.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local i64 @binary_search(i32* %arr, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop.cond

loop.cond:
  %low = phi i64 [ 0, %entry ], [ %low.next, %loop.latch ]
  %high = phi i64 [ %n, %entry ], [ %high.next, %loop.latch ]
  %cmp = icmp ult i64 %low, %high
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %elem = load i32, i32* %elem.ptr, align 4
  %le = icmp sle i32 %key, %elem
  %mid.plus1 = add i64 %mid, 1
  %low.next = select i1 %le, i64 %low, i64 %mid.plus1
  %high.next = select i1 %le, i64 %mid, i64 %high
  br label %loop.latch

loop.latch:
  br label %loop.cond

after.loop:
  %inrange = icmp ult i64 %low, %n
  br i1 %inrange, label %check, label %ret.neg

check:
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %ret.idx, label %ret.neg

ret.idx:
  ret i64 %low

ret.neg:
  ret i64 -1
}