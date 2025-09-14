; ModuleID = 'binary_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: binary_search  ; Address: 0x1169
; Intent: Lower-bound binary search for i32; return index if equal to key else -1 (confidence=0.95). Evidence: loop with mid=(lo+(hi-lo)/2), jle to set hi=mid, final equality check returning -1 if not found
; Preconditions: arr points to at least n contiguous i32 elements; n fits in i64

; Only the needed extern declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare other externs only if they are actually called)

define dso_local i64 @binary_search(i32* %arr, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %entry, %set_hi, %set_lo
  %lo = phi i64 [ 0, %entry ], [ %lo, %set_hi ], [ %lo.next, %set_lo ]
  %hi = phi i64 [ %n, %entry ], [ %mid, %set_hi ], [ %hi, %set_lo ]
  %cmp_lo_hi = icmp ult i64 %lo, %hi
  br i1 %cmp_lo_hi, label %body, label %after_loop

body:                                             ; preds = %loop
  %diff = sub i64 %hi, %lo
  %half = lshr i64 %diff, 1
  %mid = add i64 %lo, %half
  %elem.ptr = getelementptr i32, i32* %arr, i64 %mid
  %elem = load i32, i32* %elem.ptr, align 4
  %le = icmp sle i32 %key, %elem
  br i1 %le, label %set_hi, label %set_lo

set_hi:                                           ; preds = %body
  br label %loop

set_lo:                                           ; preds = %body
  %lo.next = add i64 %mid, 1
  br label %loop

after_loop:                                       ; preds = %loop
  %in_range = icmp ult i64 %lo, %n
  br i1 %in_range, label %check_eq, label %ret_neg1

check_eq:                                         ; preds = %after_loop
  %elem.ptr2 = getelementptr i32, i32* %arr, i64 %lo
  %elem2 = load i32, i32* %elem.ptr2, align 4
  %eq = icmp eq i32 %key, %elem2
  br i1 %eq, label %ret_index, label %ret_neg1

ret_index:                                        ; preds = %check_eq
  ret i64 %lo

ret_neg1:                                         ; preds = %check_eq, %after_loop
  ret i64 -1
}