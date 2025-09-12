; ModuleID = 'binary_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: binary_search ; Address: 0x1169
; Intent: Binary search in a sorted int32 array; returns index or -1 (confidence=0.95). Evidence: mid computed as left + (right-left)/2; loop uses key <= arr[mid] to shrink right; post-loop equality check and -1 on miss.
; Preconditions: arr points to at least n 32-bit signed integers, sorted in nondecreasing (ascending) order.
; Postconditions: Returns i64 index in [0, n) where arr[index] == key if found; otherwise returns -1.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local i64 @binary_search(i32* nocapture readonly %arr, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %while

while:                                            ; loop header: while (left < right)
  %left = phi i64 [ 0, %entry ], [ %left.next, %while.latch ]
  %right = phi i64 [ %n, %entry ], [ %right.next, %while.latch ]
  %cond = icmp ult i64 %left, %right
  br i1 %cond, label %body, label %exit

body:
  %diff = sub i64 %right, %left
  %half = lshr i64 %diff, 1
  %mid = add i64 %left, %half
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %elem.ptr, align 4
  %le = icmp sle i32 %key, %val                          ; signed compare: key <= arr[mid]
  br i1 %le, label %set.right, label %set.left

set.right:                                         ; right = mid
  br label %while.latch

set.left:                                          ; left = mid + 1
  %mid.plus = add i64 %mid, 1
  br label %while.latch

while.latch:
  %left.next = phi i64 [ %left, %set.right ], [ %mid.plus, %set.left ]
  %right.next = phi i64 [ %mid, %set.right ], [ %right, %set.left ]
  br label %while

exit:
  ; if (left < n && arr[left] == key) return left; else return -1
  %inrange = icmp ult i64 %left, %n
  br i1 %inrange, label %check, label %ret.neg

check:
  %p = getelementptr inbounds i32, i32* %arr, i64 %left
  %v = load i32, i32* %p, align 4
  %eq = icmp eq i32 %key, %v
  br i1 %eq, label %ret.idx, label %ret.neg

ret.idx:
  ret i64 %left

ret.neg:
  ret i64 -1
}