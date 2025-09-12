; ModuleID = 'binary_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: binary_search  ; Address: 0x1169
; Intent: Binary search for a 32-bit key in a sorted ascending int array; return index or -1 (confidence=0.95). Evidence: mid computation with (high-low)>>1 and branch on key <= a[mid]
; Preconditions: %arr points to at least %n 32-bit elements sorted in non-decreasing (ascending) order.
; Postconditions: Returns the lowest index i such that arr[i] == key, or -1 if not found.

define dso_local i64 @binary_search(i32* %arr, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; low/high maintenance loop
  %low.phi = phi i64 [ 0, %entry ], [ %low.next, %after_cmp ]
  %high.phi = phi i64 [ %n, %entry ], [ %high.next, %after_cmp ]
  %cond = icmp ult i64 %low.phi, %high.phi
  br i1 %cond, label %body, label %exit

body:
  %diff = sub i64 %high.phi, %low.phi
  %half = lshr i64 %diff, 1
  %mid = add i64 %low.phi, %half
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %elem = load i32, i32* %elem.ptr, align 4
  %le = icmp sle i32 %key, %elem
  br i1 %le, label %set_high, label %set_low

set_high:
  %high.next.sh = %mid
  %low.next.sh = %low.phi
  br label %after_cmp

set_low:
  %low.plus = add i64 %mid, 1
  br label %after_cmp

after_cmp:
  %low.next = phi i64 [ %low.next.sh, %set_high ], [ %low.plus, %set_low ]
  %high.next = phi i64 [ %high.next.sh, %set_high ], [ %high.phi, %set_low ]
  br label %loop

exit:
  ; if (low < n) and arr[low] == key, return low; else return -1
  %inrange = icmp ult i64 %low.phi, %n
  br i1 %inrange, label %check_eq, label %not_found

check_eq:
  %ptr.low = getelementptr inbounds i32, i32* %arr, i64 %low.phi
  %val.low = load i32, i32* %ptr.low, align 4
  %eq = icmp eq i32 %val.low, %key
  br i1 %eq, label %found, label %not_found

found:
  ret i64 %low.phi

not_found:
  ret i64 -1
}