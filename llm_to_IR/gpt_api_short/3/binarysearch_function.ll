; ModuleID = 'binary_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: binary_search ; Address: 0x1169
; Intent: binary search for a key in a sorted int32 array, return index or -1 (confidence=0.95). Evidence: mid computation with (hi-lo)>>1, signed compare (jle) for key vs value, final equality check and -1 on failure.
; Preconditions: arr points to a non-decreasing sorted array of n 32-bit signed integers; arr valid for n elements.
; Postconditions: returns i64 index in [0,n) where arr[index]==key, else returns -1.

; Only the necessary external declarations:
; (none)

define dso_local i64 @binary_search(i32* nocapture readonly %arr, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; while (lo < hi)
  %lo = phi i64 [ 0, %entry ], [ %lo.next, %loop_latch ]
  %hi = phi i64 [ %n, %entry ], [ %hi.next, %loop_latch ]
  %cond = icmp ult i64 %lo, %hi
  br i1 %cond, label %body, label %after

body:
  %diff = sub i64 %hi, %lo
  %half = lshr i64 %diff, 1
  %mid = add i64 %lo, %half
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %elem = load i32, i32* %elem.ptr, align 4
  ; if (key > elem) lo = mid + 1; else hi = mid; (signed compare)
  %gt = icmp sgt i32 %key, %elem
  %mid.plus1 = add i64 %mid, 1
  %lo.next = select i1 %gt, i64 %mid.plus1, i64 %lo
  %hi.next = select i1 %gt, i64 %hi, i64 %mid
  br label %loop_latch

loop_latch:
  br label %loop

after:
  ; if (lo < n && arr[lo] == key) return lo; else -1
  %inRange = icmp ult i64 %lo, %n
  br i1 %inRange, label %check, label %ret_neg

check:
  %elem2.ptr = getelementptr inbounds i32, i32* %arr, i64 %lo
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %eq = icmp eq i32 %key, %elem2
  br i1 %eq, label %ret_idx, label %ret_neg

ret_idx:
  ret i64 %lo

ret_neg:
  ret i64 -1
}