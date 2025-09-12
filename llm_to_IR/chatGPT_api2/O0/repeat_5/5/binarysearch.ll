; ModuleID = 'binary_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: binary_search  ; Address: 0x1169
; Intent: Binary search (lower_bound then equality check) returning index or -1 (confidence=0.95). Evidence: mid=(lo+(hi-lo)/2) loop with jle guiding hi=mid vs lo=mid+1; final equality check and -1 on miss.
; Preconditions: arr points to at least n 32-bit integers sorted in nondecreasing order.
; Postconditions: returns the index of the first element equal to key if present; otherwise returns -1.

define dso_local i64 @binary_search(i32* %arr, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop.cond

loop.cond:
  %lo = phi i64 [ 0, %entry ], [ %lo.next, %loop.update ]
  %hi = phi i64 [ %n, %entry ], [ %hi.next, %loop.update ]
  %cmp = icmp ult i64 %lo, %hi
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:
  %diff = sub i64 %hi, %lo
  %half = lshr i64 %diff, 1
  %mid = add i64 %lo, %half
  %p = getelementptr i32, i32* %arr, i64 %mid
  %v = load i32, i32* %p, align 4
  %le = icmp sle i32 %key, %v
  br i1 %le, label %set.hi, label %set.lo

set.hi:
  br label %loop.update

set.lo:
  %mid.plus1 = add i64 %mid, 1
  br label %loop.update

loop.update:
  %lo.next = phi i64 [ %lo, %set.hi ], [ %mid.plus1, %set.lo ]
  %hi.next = phi i64 [ %mid, %set.hi ], [ %hi, %set.lo ]
  br label %loop.cond

after.loop:
  %inrange = icmp ult i64 %lo, %n
  br i1 %inrange, label %check.eq, label %ret.neg1

check.eq:
  %p2 = getelementptr i32, i32* %arr, i64 %lo
  %v2 = load i32, i32* %p2, align 4
  %eq = icmp eq i32 %v2, %key
  br i1 %eq, label %ret.index, label %ret.neg1

ret.index:
  ret i64 %lo

ret.neg1:
  ret i64 -1
}