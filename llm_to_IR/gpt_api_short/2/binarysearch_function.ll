; ModuleID = 'binary_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: binary_search ; Address: 0x1169
; Intent: binary search for exact match; returns index or -1 (confidence=0.96). Evidence: lower_bound loop (lo<hi, mid=(lo+(hi-lo)/2)) and post-loop equality check with -1 sentinel.
; Preconditions: arr points to at least n sorted 32-bit signed integers (ascending).
; Postconditions: returns the lowest index i in [0,n) such that arr[i]==target, else -1.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)

define dso_local i64 @binary_search(i32* nocapture readonly %arr, i64 %n, i32 %target) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %body, %entry
  %lo = phi i64 [ 0, %entry ], [ %lo.next, %body ]
  %hi = phi i64 [ %n, %entry ], [ %hi.next, %body ]
  %cmp = icmp ult i64 %lo, %hi
  br i1 %cmp, label %body, label %after_loop

body:                                             ; preds = %loop
  %diff = sub i64 %hi, %lo
  %half = lshr i64 %diff, 1
  %mid = add i64 %lo, %half
  %mid.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %mid.val = load i32, i32* %mid.ptr, align 4
  %gt = icmp sgt i32 %target, %mid.val
  %mid.plus1 = add i64 %mid, 1
  %lo.next = select i1 %gt, i64 %mid.plus1, i64 %lo
  %hi.next = select i1 %gt, i64 %hi, i64 %mid
  br label %loop

after_loop:                                       ; preds = %loop
  %inb = icmp ult i64 %lo, %n
  br i1 %inb, label %check, label %notfound

check:                                            ; preds = %after_loop
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %lo
  %val = load i32, i32* %ptr, align 4
  %eq = icmp eq i32 %target, %val
  br i1 %eq, label %found, label %notfound

found:                                            ; preds = %check
  ret i64 %lo

notfound:                                         ; preds = %check, %after_loop
  ret i64 -1
}