; ModuleID = 'binary_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: binary_search ; Address: 0x1169
; Intent: binary search index of key in sorted int32 array (lower_bound then equality check) (confidence=0.96). Evidence: index math with *4 element size; loop low<hi with mid=(low+hi)/2 and key<=a[mid] -> hi=mid, else low=mid+1; final equality check and -1 on miss.
; Preconditions: arr points to at least n int32 elements sorted in nondecreasing order; n >= 0.
; Postconditions: returns i64 index in [0,n) of first occurrence of key if present; otherwise returns -1.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local i64 @binary_search(i32* %arr, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; while (low < hi)
  %low = phi i64 [ 0, %entry ], [ %low.next, %cont ]
  %hi = phi i64 [ %n, %entry ], [ %hi.next, %cont ]
  %cmp = icmp ult i64 %low, %hi
  br i1 %cmp, label %body, label %exit

body:
  %range = sub i64 %hi, %low
  %half = lshr i64 %range, 1
  %mid = add i64 %low, %half
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %elem = load i32, i32* %elem.ptr, align 4
  %le = icmp sle i32 %key, %elem
  br i1 %le, label %set_hi, label %set_low

set_low:
  %midp1 = add i64 %mid, 1
  br label %cont

set_hi:
  br label %cont

cont:
  %hi.next = phi i64 [ %mid, %set_hi ], [ %hi, %set_low ]
  %low.next = phi i64 [ %low, %set_hi ], [ %midp1, %set_low ]
  br label %loop

exit:
  %low.exit = phi i64 [ %low, %loop ]
  %lt_n = icmp ult i64 %low.exit, %n
  br i1 %lt_n, label %check_elem, label %ret_neg1

check_elem:
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low.exit
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %ret_idx, label %ret_neg1

ret_idx:
  ret i64 %low.exit

ret_neg1:
  ret i64 -1
}